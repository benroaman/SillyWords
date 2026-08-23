//
//  ShatteringText.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import SwiftUI

//struct ShatteringText: View {
//    let text: String
//    let font: Font = .system(size: 40, weight: .bold)
//
//    @State private var isShattered = false
//    @State private var letters: [LetterPhysics] = []
//    @State private var startTime: Date?
//
//    var body: some View {
//        ZStack {
//            if isShattered {
//                TimelineView(.animation) { timeline in
//                    let elapsed = startTime.map { timeline.date.timeIntervalSince($0) } ?? 0
//                    ZStack {
//                        ForEach(letters) { letter in
//                            Text(String(letter.character))
//                                .font(font)
//                                .foregroundStyle(letter.color)
//                                .offset(x: letter.currentX(at: elapsed),
//                                        y: letter.currentY(at: elapsed))
//                                .rotationEffect(.degrees(letter.currentRotation(at: elapsed)))
//                                .opacity(letter.opacity(at: elapsed))
//                        }
//                    }
//                }
//            } else {
//                Text(text)
//                    .font(font)
//                    .onTapGesture { shatter() }
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//
//    private func shatter() {
//        letters = text.enumerated().map { index, char in
//            LetterPhysics(
//                character: char,
//                index: index,
//                totalCount: text.count
//            )
//        }
//        startTime = Date()
//        isShattered = true
//    }
//}
//
//struct LetterPhysics: Identifiable {
//    let id = UUID()
//    let character: Character
//    let index: Int
//    let totalCount: Int
//
//    // Randomized per-letter physics parameters
//    let horizontalVelocity: Double
//    let initialVerticalVelocity: Double
//    let rotationSpeed: Double
//    let rotationDirection: Double
//    let color: Color
//    let letterSpacingOffset: Double
//
//    private let gravity: Double = 900 // points/sec^2
//
//    init(character: Character, index: Int, totalCount: Int) {
//        self.character = character
//        self.index = index
//        self.totalCount = totalCount
//        self.horizontalVelocity = Double.random(in: -120...120)
//        self.initialVerticalVelocity = Double.random(in: -250...(-50)) // slight upward pop
//        self.rotationSpeed = Double.random(in: 90...360)
//        self.rotationDirection = Bool.random() ? 1 : -1
//        self.color = .primary
//        // approximate original horizontal position in the line of text
//        self.letterSpacingOffset = (Double(index) - Double(totalCount - 1) / 2.0) * 24
//    }
//
//    func currentX(at t: TimeInterval) -> Double {
//        letterSpacingOffset + horizontalVelocity * t
//    }
//
//    func currentY(at t: TimeInterval) -> Double {
//        // projectile motion: y = v0*t + 0.5*g*t^2
//        initialVerticalVelocity * t + 0.5 * gravity * t * t
//    }
//
//    func currentRotation(at t: TimeInterval) -> Double {
//        rotationSpeed * rotationDirection * t
//    }
//
//    func opacity(at t: TimeInterval) -> Double {
//        // fade out over the last second before it's fully offscreen
//        let fadeStart = 1.2
//        let fadeDuration = 0.8
//        if t < fadeStart { return 1.0 }
//        let progress = (t - fadeStart) / fadeDuration
//        return max(0, 1 - progress)
//    }
//}

//import SwiftUI
//
//struct ShatteringText: View {
//    let text: String
//    let font: Font = .system(size: 40, weight: .bold)
//
//    @State private var isShattered = false
//    @State private var animationProgress: CGFloat = 0
//    @State private var letters: [LetterConfig] = []
//
//    private let totalDuration: Double = 1.4
//
//    var body: some View {
//        ZStack {
//            if isShattered {
//                ZStack {
//                    ForEach(letters) { letter in
//                        Text(String(letter.character))
//                            .font(font)
//                            .modifier(LetterFallModifier(progress: animationProgress, config: letter))
//                    }
//                }
//            } else {
//                Text(text)
//                    .font(font)
//                    .onTapGesture { shatter() }
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//
//    private func shatter() {
//        letters = text.enumerated().map { index, char in
//            LetterConfig(character: char, index: index, totalCount: text.count)
//        }
//        animationProgress = 0
//        isShattered = true
//
//        withAnimation(.linear(duration: totalDuration)) {
//            animationProgress = 1
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
//            isShattered = false
//        }
//    }
//}
//
//struct LetterConfig: Identifiable {
//    let id = UUID()
//    let character: Character
//    let baseX: Double
//    let popVelocityX: Double   // pts/sec, horizontal pop
//    let popVelocityY: Double   // pts/sec, negative = slight upward pop
//    let rotationVelocity: Double // deg/sec
//
//    init(character: Character, index: Int, totalCount: Int) {
//        self.character = character
//        self.baseX = (Double(index) - Double(totalCount - 1) / 2.0) * 24
//        self.popVelocityX = Double.random(in: -70...70)
//        self.popVelocityY = Double.random(in: -140...(-60))
//        self.rotationVelocity = Double.random(in: -200...200)
//    }
//}
//
//struct LetterFallModifier: ViewModifier, Animatable {
//    var progress: CGFloat
//    let config: LetterConfig
//
//    private let totalDuration: Double = 1.4
//    private let gravity: Double = 1400        // dominates over time
//    private let horizontalDrag: Double = 4.0  // higher = pop momentum decays faster
//
//    var animatableData: CGFloat {
//        get { progress }
//        set { progress = newValue }
//    }
//
//    func body(content: Content) -> some View {
//        let t = Double(progress) * totalDuration
//
//        // Horizontal velocity decays exponentially (drag), so it "spends" its pop
//        // momentum and settles — it doesn't keep drifting sideways forever.
//        let x = config.baseX + config.popVelocityX * (1 - exp(-horizontalDrag * t)) / horizontalDrag
//
//        // Vertical: single continuous projectile equation. The pop gives a small
//        // upward velocity; gravity's quadratic term overtakes it smoothly with
//        // no discontinuity — this IS the "pop decays into fall" behavior.
//        let y = config.popVelocityY * t + 0.5 * gravity * t * t
//
//        // Rotation decays the same way as horizontal drag, so spin settles too.
//        let rotation = config.rotationVelocity * (1 - exp(-horizontalDrag * t)) / horizontalDrag
//
//        let fadeStart = 0.55
//        let opacity = progress < fadeStart
//            ? 1.0
//            : max(0, 1 - (Double(progress) - fadeStart) / (1 - fadeStart))
//
//        return content
//            .offset(x: x, y: y)
//            .rotationEffect(.degrees(rotation))
//            .opacity(opacity)
//    }
//}

//import SwiftUI
//
//struct ShatteringText: View {
//    let text: String
//    let font: Font = .system(size: 40, weight: .bold)
//
//    @State private var isShattered = false
//    @State private var animationProgress: CGFloat = 0
//    @State private var letters: [LetterConfig] = []
//
//    private let totalDuration: Double = 1.4
//
//    var body: some View {
//        ZStack {
//            if isShattered {
//                ZStack {
//                    ForEach(letters) { letter in
//                        Text(String(letter.character))
//                            .font(font)
//                            .modifier(LetterFallModifier(progress: animationProgress, config: letter))
//                    }
//                }
//            } else {
//                Text(text)
//                    .font(font)
//                    .onTapGesture { shatter() }
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//
//    private func shatter() {
//        letters = text.enumerated().map { index, char in
//            LetterConfig(character: char, index: index, totalCount: text.count)
//        }
//        animationProgress = 0
//        isShattered = true
//
//        withAnimation(.linear(duration: totalDuration)) {
//            animationProgress = 1
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
//            isShattered = false
//        }
//    }
//}
//
//struct LetterConfig: Identifiable {
//    let id = UUID()
//    let character: Character
//    let baseX: Double
//    let popVelocityX: Double
//    let popVelocityY: Double
//    let rotationVelocity: Double
//
//    init(character: Character, index: Int, totalCount: Int) {
//        self.character = character
//        self.baseX = (Double(index) - Double(totalCount - 1) / 2.0) * 24
//
//        // Normalized position: -1 (leftmost) ... 0 (center) ... 1 (rightmost)
//        let normalizedPos = totalCount > 1
//            ? (Double(index) - Double(totalCount - 1) / 2.0) / (Double(totalCount - 1) / 2.0)
//            : 0
//
//        // Bias the pop angle away from center: right letters -> toward 90° (up-right),
//        // left letters -> toward 270° (up-left), center letters -> toward 180° (straight up).
//        // Margin keeps us off the 90/270 boundary so there's always some upward component.
//        let baseAngle = 180 - normalizedPos * 70
//        let jitteredAngle = baseAngle + Double.random(in: -15...15)
//        let angle = min(max(jitteredAngle, 90), 270) // hard clamp: never below 90 or above 270
//
//        let angleRad = angle * .pi / 180
//        let popMagnitude = Double.random(in: 60...110)
//
//        // 0° = straight down, so dx = sin(angle), dy = cos(angle).
//        // Over [90, 270], cos(angle) <= 0 always, guaranteeing an upward (or level) pop.
//        self.popVelocityX = sin(angleRad) * popMagnitude
//        self.popVelocityY = cos(angleRad) * popMagnitude
//
//        self.rotationVelocity = Double.random(in: -90...90)
//    }
//}
//
//struct LetterFallModifier: ViewModifier, Animatable {
//    var progress: CGFloat
//    let config: LetterConfig
//
//    private let totalDuration: Double = 1.4
//    private let gravity: Double = 1400
//    private let horizontalDrag: Double = 4.0
//
//    var animatableData: CGFloat {
//        get { progress }
//        set { progress = newValue }
//    }
//
//    func body(content: Content) -> some View {
//        let t = Double(progress) * totalDuration
//
//        // Momentum decays via drag (exponential), fall grows unbounded via gravity —
//        // pop influence naturally becomes negligible as t grows.
//        let decay = (1 - exp(-horizontalDrag * t)) / horizontalDrag
//        let x = config.baseX + config.popVelocityX * decay
//        let popHump = config.popVelocityY * decay
//        let fall = 0.5 * gravity * t * t
//        let y = popHump + fall
//
//        let rotation = config.rotationVelocity * decay
//
//        let fadeStart = 0.55
//        let opacity = progress < fadeStart
//            ? 1.0
//            : max(0, 1 - (Double(progress) - fadeStart) / (1 - fadeStart))
//
//        return content
//            .offset(x: x, y: y)
//            .rotationEffect(.degrees(rotation))
//            .opacity(opacity)
//    }
//}

import SwiftUI

struct ShatteringText: View {
    let text: String
    let font: Font = .system(size: 40, weight: .bold)

    @State private var shatteringLetters: [LetterConfig] = []
    @State private var animationProgress: CGFloat = 0
    @State private var isShattering = false

    @State private var displayedText: String
    @State private var newTextOpacity: Double = 1

    private let totalDuration: Double = 1.4
    private let newTextDelay: Double = 0.25   // how long after shatter starts before new text begins fading in
    private let newTextFadeDuration: Double = 0.5

    init(text: String) {
        self.text = text
        _displayedText = State(initialValue: text)
    }

    var body: some View {
        ZStack {
            if isShattering {
                ZStack {
                    ForEach(shatteringLetters) { letter in
                        Text(String(letter.character))
                            .font(font)
                            .modifier(LetterFallModifier(progress: animationProgress, config: letter))
                    }
                }
            }

            Text(displayedText)
                .font(font)
                .opacity(newTextOpacity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: text) { oldValue, newValue in
            transition(from: oldValue, to: newValue)
        }
    }

//    private func transition(from oldValue: String, to newValue: String) {
//        // Build the shattering letters from the OLD text.
//        shatteringLetters = oldValue.enumerated().map { index, char in
//            LetterConfig(character: char, index: index, totalCount: oldValue.count)
//        }
//        animationProgress = 0
//        isShattering = true
//
//        // Hide the "settled" text layer immediately, swap its content to the
//        // new value, and prepare it invisible so it can fade in a moment later.
//        displayedText = newValue
//        newTextOpacity = 0
//
//        // Kick off the shatter animation on the old letters.
//        withAnimation(.linear(duration: totalDuration)) {
//            animationProgress = 1
//        }
//
//        // After a brief pause (while the old text is still visibly falling),
//        // start fading the new text in.
//        DispatchQueue.main.asyncAfter(deadline: .now() + newTextDelay) {
//            withAnimation(.easeIn(duration: newTextFadeDuration)) {
//                newTextOpacity = 1
//            }
//        }
//
//        // Clean up the shattering letters once their animation finishes.
//        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
//            isShattering = false
//        }
//    }
    
    private func transition(from oldValue: String, to newValue: String) {
        shatteringLetters = oldValue.enumerated().map { index, char in
            LetterConfig(character: char, index: index, totalCount: oldValue.count)
        }
        animationProgress = 0
        isShattering = true

        displayedText = newValue
        newTextOpacity = 0

        // Use the completion-based withAnimation API (iOS 17+) so cleanup is tied
        // to the animation actually finishing, not a guessed wall-clock timer.
        withAnimation(.linear(duration: totalDuration)) {
            animationProgress = 1
        } completion: {
            isShattering = false
        }

        // This one is fine to leave as a timer since it's a *softer* effect
        // (fade-in) — being off by a frame or two here is imperceptible.
        DispatchQueue.main.asyncAfter(deadline: .now() + newTextDelay) {
            withAnimation(.easeIn(duration: newTextFadeDuration)) {
                newTextOpacity = 1
            }
        }
    }
}

//struct LetterConfig: Identifiable {
//    let id = UUID()
//    let character: Character
//    let baseX: Double
//    let popVelocityX: Double
//    let popVelocityY: Double
//    let rotationVelocity: Double
//
//    init(character: Character, index: Int, totalCount: Int) {
//        self.character = character
//        self.baseX = (Double(index) - Double(totalCount - 1) / 2.0) * 24
//
//        let normalizedPos = totalCount > 1
//            ? (Double(index) - Double(totalCount - 1) / 2.0) / (Double(totalCount - 1) / 2.0)
//            : 0
//
//        let baseAngle = 180 - normalizedPos * 70
//        let jitteredAngle = baseAngle + Double.random(in: -15...15)
//        let angle = min(max(jitteredAngle, 90), 270)
//
//        let angleRad = angle * .pi / 180
//        let popMagnitude = Double.random(in: 60...110)
//
//        self.popVelocityX = sin(angleRad) * popMagnitude
//        self.popVelocityY = cos(angleRad) * popMagnitude
//
//        self.rotationVelocity = Double.random(in: -90...90)
//    }
//}

struct LetterConfig: Identifiable {
    let id = UUID()
    let character: Character
    let baseX: Double
    let popVelocityX: Double
    let popVelocityY: Double
    let fallDX: Double
    let fallDY: Double
    let rotationVelocity: Double
    let leanDirection: Double // -1 = left, 0 = center, 1 = right — kept for clamping in the modifier

    init(character: Character, index: Int, totalCount: Int) {
        self.character = character
        self.baseX = (Double(index) - Double(totalCount - 1) / 2.0) * 24

        let leanSign = LetterConfig.leanSign(index: index, totalCount: totalCount)
        self.leanDirection = leanSign

        let popHorizontalMagnitude = Double.random(in: 30...80)
        let popUpwardMagnitude = Double.random(in: 40...90)

        self.popVelocityX = popHorizontalMagnitude * leanSign
        self.popVelocityY = -popUpwardMagnitude

        self.fallDX = leanSign * 0.08
        self.fallDY = 1.0

        self.rotationVelocity = Double.random(in: -90...90)
    }

    private static func leanSign(index: Int, totalCount: Int) -> Double {
        if totalCount % 2 == 1 && index == totalCount / 2 {
            return 0
        }
        let midpoint = Double(totalCount - 1) / 2.0
        return Double(index) < midpoint ? -1 : 1
    }
}

//struct LetterFallModifier: ViewModifier, Animatable {
//    var progress: CGFloat
//    let config: LetterConfig
//
//    private let gravity: Double = 1400
//    private let horizontalDrag: Double = 4.0
//    private let totalDuration: Double = 1.4
//
//    var animatableData: CGFloat {
//        get { progress }
//        set { progress = newValue }
//    }
//
//    func body(content: Content) -> some View {
//        let t = Double(progress) * totalDuration
//
//        let decay = (1 - exp(-horizontalDrag * t)) / horizontalDrag
//        let x = config.baseX + config.popVelocityX * decay
//        let popHump = config.popVelocityY * decay
//        let fall = 0.5 * gravity * t * t
//        let y = popHump + fall
//
//        let rotation = config.rotationVelocity * decay
//
//        let fadeStart = 0.55
//        let opacity = progress < fadeStart
//            ? 1.0
//            : max(0, 1 - (Double(progress) - fadeStart) / (1 - fadeStart))
//
//        return content
//            .offset(x: x, y: y)
//            .rotationEffect(.degrees(rotation))
//            .opacity(opacity)
//    }
//}

struct LetterFallModifier: ViewModifier, Animatable {
    var progress: CGFloat
    let config: LetterConfig

    private let gravity: Double = 1400
    private let horizontalDrag: Double = 4.0
    private let totalDuration: Double = 1.4

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        let t = Double(progress) * totalDuration

        let decay = (1 - exp(-horizontalDrag * t)) / horizontalDrag
        let popX = config.popVelocityX * decay
        let popY = config.popVelocityY * decay

        let fallDistance = 0.5 * gravity * t * t
        let fallX = config.fallDX * fallDistance
        let fallY = config.fallDY * fallDistance

        // Clamp horizontal offset so it never crosses back past the letter's
        // original straight-down line (baseX) — i.e. never reverses toward
        // or past center.
        let rawOffsetX = popX + fallX
        let clampedOffsetX: Double
        if config.leanDirection > 0 {
            clampedOffsetX = max(rawOffsetX, 0) // right-leaning: never go negative (back toward/past center)
        } else if config.leanDirection < 0 {
            clampedOffsetX = min(rawOffsetX, 0) // left-leaning: never go positive
        } else {
            clampedOffsetX = 0 // true center letter: always straight down, no horizontal drift at all
        }

        let x = config.baseX + clampedOffsetX
        let y = popY + fallY

        let rotation = config.rotationVelocity * decay

        let fadeStart = 0.55
        let opacity = progress < fadeStart
            ? 1.0
            : max(0, 1 - (Double(progress) - fadeStart) / (1 - fadeStart))

        return content
            .offset(x: x, y: y)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
    }
}

#Preview {
    PreviewWrapper()
}

fileprivate struct PreviewWrapper: View {
    @State private var word = "Hello"

    var body: some View {
        VStack {
            ShatteringText(text: word)
            Button("Change word") {
                word = ["World", "Swift", "Banana", "Brismucect", "Glunde", "Squanch"].randomElement()!
            }
        }
    }
}
