//
//  ShatteringText3.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//
//
//
//
//  PopTransitionText.swift
//
//  A single-line, auto-shrinking text view that, whenever its `text` changes,
//  makes the old word pop apart into individual letters and fall off screen
//  while the new word fades in to replace it.
//
//  WHY THIS VERSION IS STRUCTURED THE WAY IT IS
//  ---------------------------------------------
//  An earlier version measured letter positions with `GeometryReader` +
//  `PreferenceKey`. That works, but preference values are delivered
//  *asynchronously* — potentially a frame or more after the layout they
//  describe actually happened on screen. That gap is exactly the kind of
//  thing that produces a "slightly off" position snapshot and inconsistent-
//  looking trajectories.
//
//  This version instead measures text with plain, synchronous
//  `NSString.size(withAttributes:)` calls against a `UIFont`. Every letter's
//  frame is a pure function of (text, font) computed on demand — there is no
//  round trip, so the frame captured the instant an explosion begins is
//  *guaranteed* to be exactly what was on screen, not an approximation of it
//  from one render ago. This is also why the initializer takes a `UIFont`
//  rather than a generic SwiftUI `Font`: only a concrete font object can be
//  measured synchronously. It's still rendered as ordinary SwiftUI `Text`
//  via `Font(uiFont)`.
//
//  BEHAVIOR
//  --------
//  - Letters in the first half of the word pop up-and-left, then fall down
//    while continuing to drift left — the fall's sideways motion is derived
//    directly from the pop's sideways motion (same sign, scaled up), so it
//    reads as one continuous, momentum-preserving arc rather than two
//    unrelated random kicks.
//  - Letters in the second half pop up-and-right, then fall down while
//    continuing to drift right, the same way.
//  - A middle letter (odd-length words) pops straight up and falls straight
//    down (direction == 0, so it never gets a sideways component at all).
//  - Every number that affects the animation's look lives in the `static
//    let` constants on `PopTransitionText` below.
//  - Receiving a new `text` value while a previous explosion is still
//    falling immediately discards the old explosion (and its animation
//    state) and starts a fresh one.
//  - `minimumScaleFactor` is emulated with `scaleEffect`, the same
//    mechanism SwiftUI's real `minimumScaleFactor` uses to visually shrink
//    glyphs. It does not truncate text that's still too wide even at the
//    minimum scale.
//  - Because this view measures its *available width* with a
//    `GeometryReader` (there's no way around that part — available width is
//    inherently something only the parent layout knows), give it an
//    explicit height when you place it, e.g. `.frame(height: 60)`.
//  - Per-character measurement has no cross-letter kerning, so very
//    tightly-kerned custom fonts may look marginally different from a
//    single `Text(word)`. For most fonts this is imperceptible.
//

import SwiftUI
import UIKit

// MARK: - Synchronous text measurement

private struct MeasuredLetter {
    let character: Character
    let frame: CGRect
}

private struct TextLayout {
    let letters: [MeasuredLetter]
    let size: CGSize
}

/// Pure, synchronous measurement: given the same text and font, this always
/// returns the same result — no caching, no async delivery, nothing that can
/// go stale.
private func measureLayout(for text: String, font: UIFont) -> TextLayout {
    let chars = Array(text)
    let height = ceil(font.ascender - font.descender)
    var x: CGFloat = 0
    var letters: [MeasuredLetter] = []
    letters.reserveCapacity(chars.count)
    for ch in chars {
        let width = (String(ch) as NSString).size(withAttributes: [.font: font]).width
        letters.append(MeasuredLetter(character: ch, frame: CGRect(x: x, y: 0, width: width, height: height)))
        x += width
    }
    return TextLayout(letters: letters, size: CGSize(width: x, height: height))
}

// MARK: - Exploding word model

/// A snapshot of a word's letters, captured the instant it starts exploding,
/// so its animation is fully decoupled from whatever happens afterwards.
/// All per-letter randomness is resolved here, once, rather than inside the
/// view — so re-rendering the view hierarchy while the explosion is in
/// flight can never perturb an in-progress trajectory.
private struct ExplodingWord: Identifiable {
    let id = UUID()
    let letters: [SnapshotLetter]
    let rowSize: CGSize
    let scale: CGFloat
}

private struct SnapshotLetter: Identifiable {
    let id: Int                // stable identity within this snapshot
    let character: Character
    let frame: CGRect          // frame within the row's own (unscaled) coordinate space

    // Fully-resolved trajectory, computed once at snapshot time.
    let popDelay: Double
    let popUp: CGFloat
    let popSideways: CGFloat
    let popRotation: Double
    let fallSideways: CGFloat      // total extra sideways offset added during the fall phase
    let fallRotationDelta: Double  // rotation added on top of popRotation during the fall phase

    init(index: Int, character: Character, frame: CGRect, direction: CGFloat, distanceFromCenter: CGFloat) {
        self.id = index
        self.character = character
        self.frame = frame

        func varied(_ base: Double) -> Double {
            base * Double.random(
                in: (1 - PopTransitionText.trajectoryVariance)...(1 + PopTransitionText.trajectoryVariance)
            )
        }

        // `sign` is the ONLY thing that determines left/right: -1 for the
        // first half of the word, 0 for a middle letter, +1 for the second
        // half. Every sideways distance below is computed as a strictly
        // non-negative magnitude and multiplied by `sign` exactly once, so
        // there's no way for a left letter's math to end up positive (or
        // vice versa) partway through.
        let sign = Double(direction)
        let dist = Double(distanceFromCenter)

        popDelay = Double.random(in: 0...PopTransitionText.maxStaggerDelay)
        popUp = CGFloat(varied(Double(PopTransitionText.popHeight)))

        // --- Horizontal travel: magnitude first, sign applied once. ---
        let popSidewaysMagnitude = varied(
            Double(PopTransitionText.popSidewaysDistanceBase) + Double(PopTransitionText.popSidewaysPerIndexDistance) * dist
        )
        let fallSidewaysMagnitude = popSidewaysMagnitude * Double(PopTransitionText.fallMomentumMultiplier)
        popSideways = CGFloat(popSidewaysMagnitude * sign)
        fallSideways = CGFloat(fallSidewaysMagnitude * sign)

        // --- Rotation: intentionally NOT tied to `sign`. A letter tumbling
        // one way while also translating sideways can visually read as
        // moving the *other* way for part of the motion, which is exactly
        // the "wrong direction" look. Keeping rotation as a small, direction-
        // independent wobble means it can never fight the sideways reading. ---
        let jitter = Double.random(in: -PopTransitionText.rotationJitterDegrees...PopTransitionText.rotationJitterDegrees)
        popRotation = jitter
        let fallRotationTarget = jitter * PopTransitionText.fallRotationMultiplier
        let cap = PopTransitionText.maxTotalRotationDegrees
        fallRotationDelta = max(-cap, min(cap, fallRotationTarget)) - popRotation
    }
}

// MARK: - Static (non-exploding) letters
// Renders the current word using the same absolute per-letter positioning
// technique as the exploding letters (rather than a flowing HStack), driven
// by the exact same synchronous `measureLayout` function. Using one
// technique for both states means there's no hand-off between "flow layout"
// and "captured-frame layout" for the explosion to possibly disagree with.

private struct StaticLettersView: View {
    let layout: TextLayout
    let font: UIFont

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(Array(layout.letters.enumerated()), id: \.offset) { _, letter in
                Text(String(letter.character))
                    .font(Font(font))
                    .frame(width: letter.frame.width, height: letter.frame.height)
                    .position(x: letter.frame.midX, y: letter.frame.midY)
            }
        }
        .frame(width: layout.size.width, height: layout.size.height)
    }
}

// MARK: - Exploding letters

private struct ExplodingLettersView: View {
    let word: ExplodingWord
    let font: UIFont

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(word.letters) { letter in
                ExplodingLetterView(letter: letter, font: font)
            }
        }
        .frame(width: word.rowSize.width, height: word.rowSize.height)
        .scaleEffect(word.scale, anchor: .center)
    }
}

private struct ExplodingLetterView: View {
    let letter: SnapshotLetter
    let font: UIFont

    @State private var offset: CGSize = .zero
    @State private var rotationDegrees: Double = 0
    @State private var opacity: Double = 1

    var body: some View {
        Text(String(letter.character))
            .font(Font(font))
            .frame(width: letter.frame.width, height: letter.frame.height)
            .position(x: letter.frame.midX, y: letter.frame.midY)
            .offset(offset)
            .rotationEffect(.degrees(rotationDegrees), anchor: .center)
            .opacity(opacity)
            .onAppear(perform: animate)
    }

    private func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + letter.popDelay) {
            withAnimation(.easeOut(duration: PopTransitionText.popDuration), {
                offset = CGSize(width: letter.popSideways, height: -letter.popUp)
                rotationDegrees = letter.popRotation
            }, completion: {
                withAnimation(.easeIn(duration: PopTransitionText.fallDuration)) {
                    offset = CGSize(
                        width: letter.popSideways + letter.fallSideways,
                        height: PopTransitionText.fallDistance
                    )
                    rotationDegrees = letter.popRotation + letter.fallRotationDelta
                    opacity = 0
                }
            })
            
            
//            withAnimation(.easeOut(duration: PopTransitionText.popDuration)) {
//                offset = CGSize(width: letter.popSideways, height: -letter.popUp)
//                rotationDegrees = letter.popRotation
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + PopTransitionText.popDuration) {
//                withAnimation(.easeIn(duration: PopTransitionText.fallDuration)) {
//                    offset = CGSize(
//                        width: letter.popSideways + letter.fallSideways,
//                        height: PopTransitionText.fallDistance
//                    )
//                    rotationDegrees = letter.popRotation + letter.fallRotationDelta
//                    opacity = 0
//                }
//            }
        }
    }
}

// MARK: - PopTransitionText

struct PopTransitionText: View {

    // MARK: Tunable constants
    // Every numeric value that affects the animation's appearance lives here.

    /// How long each letter spends popping upward before it starts to fall.
    static let popDuration: TimeInterval = 0.28
    /// How long each letter spends falling once the pop is complete.
    static let fallDuration: TimeInterval = 0.55

    /// Base upward distance letters travel during the pop phase.
    static let popHeight: CGFloat = 20
    /// Base sideways distance letters travel during the pop phase. This is
    /// deliberately fairly large relative to rotation, so the left/right
    /// direction reads unambiguously even while a letter is tumbling.
    static let popSidewaysDistanceBase: CGFloat = 26
    /// Extra sideways pop distance per letter, scaled by distance from the
    /// word's center (creates a "fan out" look where outer letters move further).
    static let popSidewaysPerIndexDistance: CGFloat = 8

    /// How much the fall's sideways travel scales up from the pop's sideways
    /// travel (always the same sign as the pop — this is "momentum carrying
    /// forward"). 1.0 = no extra drift during the fall, 3.0 = the fall
    /// drifts 3x as far sideways as the pop did.
    static let fallMomentumMultiplier: CGFloat = 2.5
    /// How far down letters fall — make this larger than your view's height
    /// so letters clear the screen.
    static let fallDistance: CGFloat = 320

    /// Small rotational wobble applied to every letter. This is
    /// deliberately independent of left/right travel direction (see
    /// `SnapshotLetter.init`) so it can never visually compete with the
    /// sideways motion.
    static let rotationJitterDegrees: Double = 10
    /// How much that wobble grows by the end of the fall, relative to what
    /// it was during the pop.
    static let fallRotationMultiplier: Double = 1.8
    /// Hard cap on total rotation (degrees, either direction) any single
    /// letter can accumulate. Keeps the motion reading as "falling", not
    /// "spinning wildly".
    static let maxTotalRotationDegrees: Double = 40
    /// Fractional random variance (+/-) applied to pop magnitudes, so no two
    /// letters — or two runs of the animation — move identically. (The fall
    /// phase inherits this variance automatically, since it's derived from
    /// the pop phase's already-randomized values.)
    static let trajectoryVariance: Double = 0.25
    /// Maximum random delay before an individual letter begins its pop,
    /// staggering the burst instead of firing every letter in lockstep.
    static let maxStaggerDelay: TimeInterval = 0.06

    /// Delay after the old word starts exploding before the new word begins
    /// fading in.
    static let newTextFadeInDelay: TimeInterval = 0.10
    /// Duration of the new word's fade-in.
    static let newTextFadeInDuration: TimeInterval = 0.35
    /// Extra time kept alive after the fall finishes before the exploded
    /// letters are torn down (purely internal bookkeeping/cleanup).
    static let cleanupBuffer: TimeInterval = 0.2

    // MARK: Public API

    let text: String
    let font: UIFont
    let minimumScaleFactor: CGFloat

    init(text: String, font: UIFont, minimumScaleFactor: CGFloat = 0.5) {
        self.text = text
        self.font = font
        self.minimumScaleFactor = minimumScaleFactor
        _displayedText = State(initialValue: text)
    }

    // MARK: State

    @State private var displayedText: String
    @State private var stableTextOpacity: Double = 1
    @State private var explodingWord: ExplodingWord?
    @State private var containerWidth: CGFloat = 0
    @State private var pendingCleanupID: UUID?

    /// Always a fresh, synchronous measurement of whatever is currently
    /// displayed — never stale, never a frame behind.
    private var currentLayout: TextLayout {
        measureLayout(for: displayedText, font: font)
    }

    /// Emulates `minimumScaleFactor` by shrinking (never growing) to fit
    /// `containerWidth`, clamped at the provided minimum.
    private var scale: CGFloat {
        let width = currentLayout.size.width
        guard containerWidth > 0, width > 0 else { return 1 }
        let fitted = min(1, containerWidth / width)
        return max(minimumScaleFactor, fitted)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                StaticLettersView(layout: currentLayout, font: font)
                    .scaleEffect(scale, anchor: .center)
                    .opacity(stableTextOpacity)

                if let explodingWord {
                    ExplodingLettersView(word: explodingWord, font: font)
                        .id(explodingWord.id)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .onAppear { containerWidth = geo.size.width }
            .onChange(of: geo.size.width) { newValue in
                containerWidth = newValue
            }
        }
        .onChange(of: text) { newValue in
            beginTransition(to: newValue)
        }
    }

    // MARK: - Transition

    private func beginTransition(to newValue: String) {
        guard newValue != displayedText else { return }

        // Measured fresh, right now, from the text that's actually on
        // screen this instant — guaranteed to match pixel-for-pixel.
        let oldLayout = currentLayout
        let oldScale = scale
        let count = oldLayout.letters.count

        let letters: [SnapshotLetter] = oldLayout.letters.enumerated().map { index, measured in
            SnapshotLetter(
                index: index,
                character: measured.character,
                frame: measured.frame,
                direction: Self.direction(forIndex: index, count: count),
                distanceFromCenter: Self.distanceFromCenter(forIndex: index, count: count)
            )
        }

        let newExplosion = ExplodingWord(letters: letters, rowSize: oldLayout.size, scale: oldScale)

        // Replacing `explodingWord` — and giving the overlay a fresh `.id` —
        // immediately tears down any in-flight explosion and its per-letter
        // animation state. That's what makes a mid-animation new string cut
        // off the old animation instead of blending with it.
        explodingWord = newExplosion

        // Swap in the new text right away, invisibly, then fade it in.
        stableTextOpacity = 0
        displayedText = newValue

        withAnimation(.easeIn(duration: Self.newTextFadeInDuration).delay(Self.newTextFadeInDelay)) {
            stableTextOpacity = 1
        }

        // Clean up the exploded letters once they've fully fallen away, but
        // only if nothing newer has replaced them in the meantime.
        let totalLifetime = Self.maxStaggerDelay + Self.popDuration + Self.fallDuration + Self.cleanupBuffer
        let thisID = newExplosion.id
        pendingCleanupID = thisID
        DispatchQueue.main.asyncAfter(deadline: .now() + totalLifetime) {
            if pendingCleanupID == thisID {
                explodingWord = nil
            }
        }
    }

    fileprivate static func direction(forIndex index: Int, count: Int) -> CGFloat {
        guard count > 0 else { return 0 }
        if count % 2 == 1 {
            let mid = count / 2
            if index == mid { return 0 }       // middle letter: straight up/down
            return index < mid ? -1 : 1
        } else {
            return index < count / 2 ? -1 : 1
        }
    }

    fileprivate static func distanceFromCenter(forIndex index: Int, count: Int) -> CGFloat {
        guard count > 1 else { return 0 }
        let center = CGFloat(count - 1) / 2
        return abs(CGFloat(index) - center)
    }
}

// MARK: - Demo

struct PopTransitionTextDemo: View {
    private let words = [
        "Hello", "World", "SwiftUI", "Animation", "Popcorn",
        "A", "Sw", "Delightful", "Gravity", "Bye"
    ]
    @State private var currentWord = "Hello"

    private var demoFont: UIFont {
        let base = UIFont.systemFont(ofSize: 48, weight: .bold)
        if let rounded = base.fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: rounded, size: 48)
        }
        return base
    }

    var body: some View {
        VStack(spacing: 40) {
            PopTransitionText(
                text: currentWord,
                font: demoFont,
                minimumScaleFactor: 0.4
            )
            .frame(height: 70)
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
            .padding(.horizontal)

            VStack(spacing: 16) {
                Button("Next Word") {
                    currentWord = words.filter { $0 != currentWord }.randomElement() ?? currentWord
                }
                .buttonStyle(.borderedProminent)

                Button("Rapid Fire (tests interruption)") {
                    Task {
                        for word in words {
                            currentWord = word
                            try? await Task.sleep(nanoseconds: 150_000_000)
                        }
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}

#Preview {
    PopTransitionTextDemo()
}
