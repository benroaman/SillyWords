//
//  ShatteringText2.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

////////////////////////////////////     V1

//import SwiftUI
//
//// MARK: - Model for a single exploding letter
//
//private struct ExplodingLetter: Identifiable {
//    let id = UUID()
//    let char: Character
//    var offset: CGSize = .zero
//    var rotation: Angle = .zero
//    var opacity: Double = 1
//}
//
//// MARK: - ExplodingTextView
//
///// Renders `text` with `font`. Whenever `text` changes, the *previous* string's
///// letters pop up and fly outward (left half -> up-left, right half -> up-right,
///// middle letter -> straight up), then fall off screen while continuing their
///// horizontal momentum and rotating. The new string cross-fades in underneath.
//struct ExplodingTextView: View {
//
//    /// Every literal that affects the animation's look/feel lives here so it's
//    /// easy to find and tweak without hunting through the animation logic.
//    enum Tuning {
//        // MARK: Pop (phase 1 — quick impulse up and outward)
//
//        /// How long the initial "pop" takes (ease-out).
//        static let popDuration: Double = 0.16
//        /// Range of how high letters pop upward before falling (points, applied as negative/upward).
//        static let popHeightRange: ClosedRange<CGFloat> = 35...65
//        /// Range of horizontal distance letters pop sideways during the pop, before scaling by magnitude.
//        static let popSidewaysRange: ClosedRange<CGFloat> = 8...20
//        /// Fraction of the letter's full rotation that's already applied by the end of the pop.
//        static let popRotationFraction: Double = 0.3
//
//        // MARK: Fall (phase 2 — gravity-like descent)
//
//        /// How long the fall takes (ease-in, so it accelerates like gravity).
//        static let fallDuration: Double = 0.65
//        /// Range of total downward fall distance (points).
//        static let fallDistanceRange: ClosedRange<CGFloat> = 320...480
//        /// Range of additional horizontal drift during the fall, before scaling by magnitude.
//        static let fallSidewaysRange: ClosedRange<CGFloat> = 50...75
//        /// Range of total rotation applied by the end of the fall (degrees; sign follows direction).
//        static let fallRotationDegreesRange: ClosedRange<Double> = 25...55
//
//        // MARK: Momentum scaling
//
//        /// Baseline momentum multiplier applied to every letter, regardless of position.
//        static let baseMomentumMultiplier: Double = 1.0
//        /// How much extra momentum each unit of distance-from-center adds.
//        static let momentumPerDistanceUnit: Double = 0.25
//        /// Distance-from-center is clamped to this many "letter slots" before scaling momentum,
//        /// so letters in very long words don't fly off with absurd force.
//        static let maxMomentumDistance: Double = 3.0
//
//        // MARK: Stagger (letters don't all move in perfect unison)
//
//        /// Fixed delay added per letter index, so the explosion sweeps across the word.
//        static let staggerPerLetterIndex: Double = 0.012
//        /// Range of additional random delay added per letter, for a less mechanical feel.
//        static let staggerRandomJitterRange: ClosedRange<Double> = 0...0.02
//
//        // MARK: New text fade-in
//
//        /// Delay after the explosion starts before the new text begins fading in.
//        static let newTextFadeInDelay: Double = 0.35
//        /// How long the new text takes to fade fully in.
//        static let newTextFadeInDuration: Double = 0.5
//
//        // MARK: Cleanup
//
//        /// Extra buffer time (beyond pop + fall) before removing the exploded letters from memory.
//        static let cleanupBuffer: Double = 0.05
//    }
//
//    let text: String
//    let font: Font
//
//    @State private var displayedText: String
//    @State private var explodingLetters: [ExplodingLetter] = []
//    @State private var newTextOpacity: Double = 1
//
//    init(text: String, font: Font = .largeTitle) {
//        self.text = text
//        self.font = font
//        _displayedText = State(initialValue: text)
//    }
//
//    var body: some View {
//        ZStack {
//            // Incoming text, fades in to replace the old one.
//            Text(displayedText)
//                .font(font)
//                .opacity(newTextOpacity)
//
//            // Outgoing letters, each animated independently.
//            if !explodingLetters.isEmpty {
//                HStack(spacing: 0) {
//                    ForEach(explodingLetters) { letter in
//                        Text(String(letter.char))
//                            .opacity(letter.opacity)
//                            .rotationEffect(letter.rotation)
//                            .offset(letter.offset)
//                    }
//                }
//                .font(font) // Set once on the container instead of per letter.
//                // Prevent the exploding copy from affecting layout of siblings.
//                .fixedSize()
//                // These letters are purely decorative — skip them in hit-testing.
//                .allowsHitTesting(false)
//                // Group the falling letters so their opacity is composited as a
//                // whole rather than blended layer-by-layer as they overlap during
//                // the fall. Unlike .drawingGroup(), this doesn't rasterize into a
//                // fixed-size offscreen buffer, so it can't clip letters as they
//                // move outside the original text's bounds.
//                .compositingGroup()
//            }
//        }
//        .onChange(of: text) { oldValue, newValue in
//            guard oldValue != newValue else { return }
//            explode(from: oldValue, to: newValue)
//        }
//    }
//
//    // MARK: - Animation logic
//
//    private func explode(from oldValue: String, to newValue: String) {
//        let chars = Array(oldValue)
//        let count = chars.count
//        guard count > 0 else {
//            displayedText = newValue
//            return
//        }
//
//        // Build the outgoing letters, hide the incoming text instantly.
//        explodingLetters = chars.map { ExplodingLetter(char: $0) }
//        newTextOpacity = 0
//        displayedText = newValue
//
//        // Index of the exact middle letter, if the count is odd.
//        let hasMiddle = count % 2 == 1
//        let middleIndex = count / 2 // valid only if hasMiddle
//
//        for i in 0..<count {
//            let isMiddle = hasMiddle && i == middleIndex
//            let direction: CGFloat = isMiddle ? 0 : (i < count / 2 ? -1 : 1)
//
//            // Letters further from center get slightly more momentum.
//            let distanceFromCenter = abs(Double(i) - Double(count - 1) / 2.0)
//            let magnitude = Tuning.baseMomentumMultiplier
//                + min(distanceFromCenter, Tuning.maxMomentumDistance) * Tuning.momentumPerDistanceUnit
//
//            let popUpHeight = -CGFloat.random(in: Tuning.popHeightRange)
//            let popSideways = direction * CGFloat.random(in: Tuning.popSidewaysRange) * CGFloat(magnitude)
//
//            let fallDistance = CGFloat.random(in: Tuning.fallDistanceRange)
//            let fallSideways = direction * CGFloat.random(in: Tuning.fallSidewaysRange) * CGFloat(magnitude)
//
//            let rotationTarget = Angle(degrees: Double(direction) * Double.random(in: Tuning.fallRotationDegreesRange))
//
//            // Small stagger so the word doesn't explode as one rigid block.
//            let staggerDelay = Double(i) * Tuning.staggerPerLetterIndex
//                + Double.random(in: Tuning.staggerRandomJitterRange)
//
//            // Each phase is applied as a single write to the array element
//            // (rather than setting .offset then .rotation separately), which
//            // halves the number of copy-on-write array copies during setup.
//            var letter = explodingLetters[i]
//
//            // Phase 1: quick pop up and outward (ease-out, like an impulse).
//            letter.offset = CGSize(width: popSideways, height: popUpHeight)
//            letter.rotation = rotationTarget * Tuning.popRotationFraction
//            withAnimation(.easeOut(duration: Tuning.popDuration).delay(staggerDelay)) {
//                explodingLetters[i] = letter
//            }
//
//            // Phase 2: fall under "gravity" (ease-in), keeping horizontal
//            // momentum, fading out near the end of the fall.
//            letter.offset = CGSize(
//                width: popSideways + fallSideways,
//                height: popUpHeight + fallDistance
//            )
//            letter.rotation = rotationTarget
//            letter.opacity = 0
//            withAnimation(.easeIn(duration: Tuning.fallDuration).delay(staggerDelay + Tuning.popDuration)) {
//                explodingLetters[i] = letter
//            }
//        }
//
//        // New text fades in shortly after the letters start falling.
//        withAnimation(.easeIn(duration: Tuning.newTextFadeInDuration).delay(Tuning.newTextFadeInDelay)) {
//            newTextOpacity = 1
//        }
//
//        // Clean up the exploding letters once fully off screen/faded.
//        let totalDuration = Tuning.popDuration + Tuning.fallDuration + Tuning.cleanupBuffer
//        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
//            explodingLetters.removeAll()
//        }
//    }
//}
//
//// MARK: - Demo
//
//struct ExplodingTextDemo: View {
//    private let words = ["Hello", "Swift", "Exploding", "UI", "Physics", "A"]
//    @State private var currentWord = "Hello"
//
//    var body: some View {
//        VStack(spacing: 60) {
//            ExplodingTextView(text: currentWord, font: .system(size: 48, weight: .bold, design: .rounded))
//
//            Button("Change Word") {
//                if let next = words.filter({ $0 != currentWord }).randomElement() {
//                    currentWord = next
//                }
//            }
//            .buttonStyle(.borderedProminent)
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ExplodingTextDemo()
//}

////////////////////////////////////     V2

import SwiftUI

// MARK: - Model for a single exploding letter

private struct ExplodingLetter: Identifiable {
    let id = UUID()
    let char: Character
    var offset: CGSize = .zero
    var rotation: Angle = .zero
    var opacity: Double = 1
}

// MARK: - ExplodingTextView

/// Renders `text` with `font`. Whenever `text` changes, the *previous* string's
/// letters pop up and fly outward (left half -> up-left, right half -> up-right,
/// middle letter -> straight up), then fall off screen while continuing their
/// horizontal momentum and rotating. The new string cross-fades in underneath.
struct ExplodingTextView: View {

    /// Every literal that affects the animation's look/feel lives here so it's
    /// easy to find and tweak without hunting through the animation logic.
    enum Tuning {
        // MARK: Pop (phase 1 — quick impulse up and outward)

        /// How long the initial "pop" takes (ease-out).
        static let popDuration: Double = 0.16
        /// Range of how high letters pop upward before falling (points, applied as negative/upward).
        static let popHeightRange: ClosedRange<CGFloat> = 35...65
        /// Range of horizontal distance letters pop sideways during the pop, before scaling by magnitude.
        static let popSidewaysRange: ClosedRange<CGFloat> = 8...20
        /// Fraction of the letter's full rotation that's already applied by the end of the pop.
        static let popRotationFraction: Double = 0.3

        // MARK: Fall (phase 2 — gravity-like descent)

        /// How long the fall takes (ease-in, so it accelerates like gravity).
        static let fallDuration: Double = 0.65
        /// Range of total downward fall distance (points).
        static let fallDistanceRange: ClosedRange<CGFloat> = 320...480
        /// Range of additional horizontal drift during the fall, before scaling by magnitude.
        static let fallSidewaysRange: ClosedRange<CGFloat> = 50...75
        /// Range of total rotation applied by the end of the fall (degrees; sign follows direction).
        static let fallRotationDegreesRange: ClosedRange<Double> = 25...55

        // MARK: Momentum scaling

        /// Baseline momentum multiplier applied to every letter, regardless of position.
        static let baseMomentumMultiplier: Double = 1.0
        /// How much extra momentum each unit of distance-from-center adds.
        static let momentumPerDistanceUnit: Double = 0.25
        /// Distance-from-center is clamped to this many "letter slots" before scaling momentum,
        /// so letters in very long words don't fly off with absurd force.
        static let maxMomentumDistance: Double = 3.0

        // MARK: Stagger (letters don't all move in perfect unison)

        /// Fixed delay added per letter index, so the explosion sweeps across the word.
        static let staggerPerLetterIndex: Double = 0.012
        /// Range of additional random delay added per letter, for a less mechanical feel.
        static let staggerRandomJitterRange: ClosedRange<Double> = 0...0.02

        // MARK: New text fade-in

        /// Delay after the explosion starts before the new text begins fading in.
        static let newTextFadeInDelay: Double = 0.35
        /// How long the new text takes to fade fully in.
        static let newTextFadeInDuration: Double = 0.5

        // MARK: Cleanup

        /// Extra buffer time (beyond pop + fall) before removing the exploded letters from memory.
        static let cleanupBuffer: Double = 0.05
    }
    
    let text: String
    let font: Font

    @State private var displayedText: String
    @State private var explodingLetters: [ExplodingLetter] = []
    @State private var newTextOpacity: Double = 1

    /// True while an explosion is currently animating. Used to avoid starting
    /// a second explosion on top of one that's still in flight — overlapping
    /// explosions would stomp on each other's state and cut both off early.
    @State private var isExploding = false
    /// The most recently requested text that arrived while an explosion was
    /// already in progress. Once the current explosion finishes, we jump
    /// straight to this value instead of playing every intermediate word.
    @State private var pendingText: String?

    init(text: String, font: Font = .largeTitle) {
        self.text = text
        self.font = font
        _displayedText = State(initialValue: text)
    }

    var body: some View {
        ZStack {
            // Incoming text, fades in to replace the old one.
            Text(displayedText)
                .font(font)
                .opacity(newTextOpacity)

            // Outgoing letters, each animated independently.
            if !explodingLetters.isEmpty {
                HStack(spacing: 0) {
                    ForEach(explodingLetters) { letter in
                        Text(String(letter.char))
                            .opacity(letter.opacity)
                            .rotationEffect(letter.rotation)
                            .offset(letter.offset)
                    }
                }
                .font(font) // Set once on the container instead of per letter.
                // Prevent the exploding copy from affecting layout of siblings.
                .fixedSize()
                // These letters are purely decorative — skip them in hit-testing.
                .allowsHitTesting(false)
                // Group the falling letters so their opacity is composited as a
                // whole rather than blended layer-by-layer as they overlap during
                // the fall. Unlike .drawingGroup(), this doesn't rasterize into a
                // fixed-size offscreen buffer, so it can't clip letters as they
                // move outside the original text's bounds.
                .compositingGroup()
            }
        }
        .onChange(of: text) { oldValue, newValue in
            guard oldValue != newValue else { return }
            if isExploding {
                // An explosion is already playing — let it finish untouched.
                // Just remember where we ultimately need to end up.
                pendingText = newValue
            } else {
                explode(from: oldValue, to: newValue)
            }
        }
    }

    // MARK: - Animation logic

    private func explode(from oldValue: String, to newValue: String) {
        isExploding = true

        let chars = Array(oldValue)
        let count = chars.count
        guard count > 0 else {
            displayedText = newValue
            finishExploding()
            return
        }

        // Build the outgoing letters, hide the incoming text instantly.
        explodingLetters = chars.map { ExplodingLetter(char: $0) }
        newTextOpacity = 0
        displayedText = newValue

        // Index of the exact middle letter, if the count is odd.
        let hasMiddle = count % 2 == 1
        let middleIndex = count / 2 // valid only if hasMiddle

        for i in 0..<count {
            let isMiddle = hasMiddle && i == middleIndex
            let direction: CGFloat = isMiddle ? 0 : (i < count / 2 ? -1 : 1)

            // Letters further from center get slightly more momentum.
            let distanceFromCenter = abs(Double(i) - Double(count - 1) / 2.0)
            let magnitude = Tuning.baseMomentumMultiplier
                + min(distanceFromCenter, Tuning.maxMomentumDistance) * Tuning.momentumPerDistanceUnit

            let popUpHeight = -CGFloat.random(in: Tuning.popHeightRange)
            let popSideways = direction * CGFloat.random(in: Tuning.popSidewaysRange) * CGFloat(magnitude)

            let fallDistance = CGFloat.random(in: Tuning.fallDistanceRange)
            let fallSideways = direction * CGFloat.random(in: Tuning.fallSidewaysRange) * CGFloat(magnitude)

            let rotationTarget = Angle(degrees: Double(direction) * Double.random(in: Tuning.fallRotationDegreesRange))

            // Small stagger so the word doesn't explode as one rigid block.
            let staggerDelay = Double(i) * Tuning.staggerPerLetterIndex
                + Double.random(in: Tuning.staggerRandomJitterRange)

            // Each phase is applied as a single write to the array element
            // (rather than setting .offset then .rotation separately), which
            // halves the number of copy-on-write array copies during setup.
            var letter = explodingLetters[i]

            // Phase 1: quick pop up and outward (ease-out, like an impulse).
            letter.offset = CGSize(width: popSideways, height: popUpHeight)
            letter.rotation = rotationTarget * Tuning.popRotationFraction
            withAnimation(.easeOut(duration: Tuning.popDuration).delay(staggerDelay)) {
                explodingLetters[i] = letter
            }

            // Phase 2: fall under "gravity" (ease-in), keeping horizontal
            // momentum, fading out near the end of the fall.
            letter.offset = CGSize(
                width: popSideways + fallSideways,
                height: popUpHeight + fallDistance
            )
            letter.rotation = rotationTarget
            letter.opacity = 0
            withAnimation(.easeIn(duration: Tuning.fallDuration).delay(staggerDelay + Tuning.popDuration)) {
                explodingLetters[i] = letter
            }
        }

        // New text fades in shortly after the letters start falling.
        withAnimation(.easeIn(duration: Tuning.newTextFadeInDuration).delay(Tuning.newTextFadeInDelay)) {
            newTextOpacity = 1
        }

        // Clean up the exploding letters once fully off screen/faded, then
        // either settle into "idle" or immediately start the next explosion
        // if another text change arrived while this one was playing.
        let totalDuration = Tuning.popDuration + Tuning.fallDuration + Tuning.cleanupBuffer
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
            explodingLetters.removeAll()
            finishExploding()
        }
    }

    /// Marks the current explosion as finished and, if another text change
    /// was requested in the meantime, immediately starts the next explosion
    /// from the word currently on screen to the latest requested word.
    private func finishExploding() {
        isExploding = false
        guard let next = pendingText else { return }
        pendingText = nil
        explode(from: displayedText, to: next)
    }
}

// MARK: - Demo

import OSLog

struct ExplodingTextDemo: View {
    private let words = ["Hello", "Swift", "Exploding", "UI", "Physics", "A"/*, "Lorem Ipsum Dolor Something"*/]
    @State private var currentWord = "Hello"

    var body: some View {
        VStack(spacing: 60) {
            ExplodingTextView(text: currentWord, font: .system(size: 48, weight: .bold, design: .rounded))

            Button("Change Word") {
                if let next = words.filter({ $0 != currentWord }).randomElement() {
                    currentWord = next
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ExplodingTextDemo()
}
