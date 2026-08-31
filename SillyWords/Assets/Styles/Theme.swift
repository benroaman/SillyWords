//
//  Theme.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/31/26.
//

import Foundation
import SwiftUI

struct Theme {
    private init() { }
}

extension Theme {
    struct App {
        private init() { }
        static let color: Color = .indigo
    }
}

extension Theme {
    struct WordGen {
        private init() { }
        static let color: Color = .green
        static let icon: SFSymbol = .pencilAndScribble
    }
}

extension Theme {
    struct SentenceGen {
        private init() { }
        static let color: Color = .green
        static let icon: SFSymbol = .quoteBubble
        static let refreshIcon: SFSymbol = .arrowTrianglehead2Clockwise
    }
}

extension Theme {
    struct Report {
        private init() { }
        static let color: Color = .orange
        static let icon: SFSymbol = .exclamationmarkBubble
    }
}

extension Theme {
    struct Offensive {
        private init() { }
        static let color: Color = .red
    }
}

extension Theme {
    struct PoorQuality {
        private init() { }
        static let color: Color = .orange
    }
}

extension Theme {
    struct Feedback {
        private init() { }
        static let color: Color = Theme.App.color
        static let icon: SFSymbol = .envelope
    }
}

extension Theme {
    struct Delete {
        private init() { }
        static let color: Color = .red
        static let icon: SFSymbol = .trash
    }
}

extension Theme {
    struct Favorite {
        private init() { }
        static let color: Color = .purple
        static let icon: SFSymbol = .heart
        static let iconOn: SFSymbol = .heartFill
        static let iconOff: SFSymbol = .heart
    }
}

extension Theme {
    struct ZeroItem {
        private init() { }
        static let color: Color = .secondary
    }
}

extension Theme {
    struct History {
        private init() { }
        static let color: Color = .teal
        static let icon: SFSymbol = .clock
    }
}

extension Theme {
    struct UserInterface {
        private init() { }
        static let color: Color = Theme.App.color
        static let icon: SFSymbol = .candybarphone
    }
}

extension Theme {
    struct Selected {
        private init() { }
        static let color: Color = .green
        static let icon: SFSymbol = .checkmark
    }
}

extension Theme {
    struct Settings {
        private init() { }
        static let color: Color = Theme.App.color
        static let icon: SFSymbol = .gearshape
    }
}

extension Theme {
    struct Presets {
        private init() { }
        static let icon: SFSymbol = .documentBadgeGearshape
    }
}

extension Theme {
    struct Syllables {
        private init() { }
        static let icon: SFSymbol = .ruler
    }
}

extension Theme {
    struct Consonants {
        private init() { }
        static let icon: SFSymbol = .bCircle
    }
}

extension Theme {
    struct Vowels {
        private init() { }
        static let icon: SFSymbol = .aCircle
    }
}

extension Theme {
    struct Contact {
        private init() { }
        static let icon: SFSymbol = .envelopeFill
    }
}

extension Theme {
    struct Transition {
        private init() { }
        static let icon: SFSymbol = .rectangle2Swap
    }
}

extension Theme {
    struct Sort {
        private init() { }
        static let iconByDate: SFSymbol = .calendar
        static let iconByAlpha: SFSymbol = .charactersLowercase
    }
}
