//
//  SentenceGenerator.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/23/26.
//

import Foundation
import BRWordGeneration

// MARK: Base
struct SentenceGenerator {
    // MARK: Static Variables
    private static var currentTextPool: Set<BRSentence> = fullTextPool
    private static var currentAttributionPool: Set<String> = fullAttributionPool
    
    // MARK: Initializers
    private init() { }
}

// MARK: Public API
extension SentenceGenerator {
    @MainActor static func useItInASentence(_ word: String) -> Sentence {
        let text = getText()
        let attribution = getAttribution()
        return Sentence(text: text.insert(word: word), attribution: attribution)
    }
}

// MARK: Private API - Sentence Building
private extension SentenceGenerator {
    static func getText() -> BRSentence {
        if currentTextPool.isEmpty {
            currentTextPool = fullTextPool
        }
        
        let text = currentTextPool.randomElement() ?? fallbackText
        currentTextPool.remove(text)
        return text
    }
    
    static func getAttribution() -> String {
        if currentAttributionPool.isEmpty {
            currentAttributionPool = fullAttributionPool
        }
        
        let attribution = currentAttributionPool.randomElement() ?? fallbackAttribution
        currentAttributionPool.remove(attribution)
        return attribution
    }
}

// MARK: Private API - Content
private extension SentenceGenerator {
    static var fallbackText: BRSentence {
        BRSentence(format: "Please us %@ in a sentence.",
                   plural: false,
                   properNoun: false,
                   firstWord: false)
    }
    
    static var fallbackAttribution: String { "Jackie Jormp Jomp" }
    
    static var fullTextPool: Set<BRSentence> {
        [
            BRSentence(format: "I can see your %@.",
                       plural: nil,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "That's the biggest %@ I've ever seen!",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "The %@ is pungent today.",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "He fell and scraped his %@.",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "Have you seen the new %@?",
                       plural: false,
                       properNoun: true,
                       firstWord: false),
            BRSentence(format: "I watch the %@ every night.",
                       plural: nil,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "Where did you get that %@?",
                       plural: nil,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "A good %@ makes any day brigher.",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "Cheryl, that cat left another %@ on the doormat.",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "%@, am I right?",
                       plural: nil,
                       properNoun: false,
                       firstWord: true),
            BRSentence(format: "Does it smell like %@ in here?",
                       plural: nil,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "The %@ really is beautiful in autumn.",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "You know I heard she got a %@ job.",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "What's the deal with %@?",
                       plural: nil,
                       properNoun: nil,
                       firstWord: false),
            BRSentence(format: "Ach! I keep tripping over that %@!",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "I was climbing a fence and snagged my %@.",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "That darn %@ is always underfoot!",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "Why does that %@ look so shiny?",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "Is the %@ supposed to get wet?",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "They have %@ now?!",
                       plural: true,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "All your %@ are belong to us.",
                       plural: true,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "Mr. %@ is my favorite teacher.",
                       plural: false,
                       properNoun: true,
                       firstWord: false),
            BRSentence(format: "I hear %@ is beautiful this time of year.",
                       plural: false,
                       properNoun: true,
                       firstWord: false),
            BRSentence(format: "That's my pet snake %@, she's my best friend.",
                       plural: false,
                       properNoun: true,
                       firstWord: false),
            BRSentence(format: "Why do they have so many %@?",
                       plural: true,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "Look up! The trees are full of %@!",
                       plural: nil,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "Put. Down. The %@.",
                       plural: nil,
                       properNoun: nil,
                       firstWord: false),
            BRSentence(format: "Is the %@ supposed quiver like that?",
                       plural: false,
                       properNoun: nil,
                       firstWord: false),
            BRSentence(format: "And now I'm covered in %@.",
                       plural: nil,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "You can't handle the %@!",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "It's like %@ on your wedding day.",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "How many %@ are you going to eat?",
                       plural: true,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "Ooh I get to lick the %@!",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "%@ make my skin crawl.",
                       plural: true,
                       properNoun: false,
                       firstWord: true),
            BRSentence(format: "It is the east, and Juliet is the %@",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "To err is human; to %@, divine",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "So many %@, so little time.",
                       plural: true,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "%@ like there's nobody watching",
                       plural: false,
                       properNoun: false,
                       firstWord: true),
            BRSentence(format: "Be the %@ that you wish to see in the world.",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "Live, laugh, %@.",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "Keep calm and %@ on.",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "You have to kiss a lot of %@ to find your prince.",
                       plural: true,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "When life gives you lemons, make %@.",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "You miss 100% of the %@ you don't take.",
                       plural: true,
                       properNoun: false,
                       firstWord: false),
            BRSentence(format: "You only %@ once.",
                       plural: false,
                       properNoun: false,
                       firstWord: false),
//            BRSentence(format: <#T##String#>,
//                       plural: <#T##Bool?#>,
//                       properNoun: <#T##Bool?#>,
//                       firstWord: <#T##Bool#>),
//            BRSentence(format: <#T##String#>,
//                       plural: <#T##Bool?#>,
//                       properNoun: <#T##Bool?#>,
//                       firstWord: <#T##Bool#>),
//            BRSentence(format: <#T##String#>,
//                       plural: <#T##Bool?#>,
//                       properNoun: <#T##Bool?#>,
//                       firstWord: <#T##Bool#>),
//            BRSentence(format: <#T##String#>,
//                       plural: <#T##Bool?#>,
//                       properNoun: <#T##Bool?#>,
//                       firstWord: <#T##Bool#>),
//            BRSentence(format: <#T##String#>,
//                       plural: <#T##Bool?#>,
//                       properNoun: <#T##Bool?#>,
//                       firstWord: <#T##Bool#>),
//            BRSentence(format: <#T##String#>,
//                       plural: <#T##Bool?#>,
//                       properNoun: <#T##Bool?#>,
//                       firstWord: <#T##Bool#>),
//            BRSentence(format: <#T##String#>,
//                       plural: <#T##Bool?#>,
//                       properNoun: <#T##Bool?#>,
//                       firstWord: <#T##Bool#>),
//            BRSentence(format: <#T##String#>,
//                       plural: <#T##Bool?#>,
//                       properNoun: <#T##Bool?#>,
//                       firstWord: <#T##Bool#>),
//            BRSentence(format: <#T##String#>,
//                       plural: <#T##Bool?#>,
//                       properNoun: <#T##Bool?#>,
//                       firstWord: <#T##Bool#>),
//            BRSentence(format: <#T##String#>,
//                       plural: <#T##Bool?#>,
//                       properNoun: <#T##Bool?#>,
//                       firstWord: <#T##Bool#>),
//            BRSentence(format: <#T##String#>,
//                       plural: <#T##Bool?#>,
//                       properNoun: <#T##Bool?#>,
//                       firstWord: <#T##Bool#>),
            
        ]
    }
    
    static var fullAttributionPool: Set<String> {
        [
            "Benjamin Franklin",
            "Pliny the Elder",
            "Phineas Gage",
            "Homer",
            "William Shakespeare",
            "Aristophanes",
            "Plato",
            "Socrates",
            "Aristotle",
            "Thomas Jefferson",
            "George Washington",
            "John Adams",
            "Alexander Hamilton",
            "James Madison",
            "Fyodor Dostoevsky",
            "Leo Tolstoy",
            "Marie Curie",
            "Albert Eistein",
            "Ada Lovelace",
            "Margaret Thatcher",
            "Mary Shelley",
            "Cleopatra",
            "Virginia Woolf",
            "Jane Austen",
            "Eleanor Roosevelt",
            "Tokugawa Ieyasu",
        ]
    }
}

// MARK: Support Types
extension SentenceGenerator {
    struct Sentence: Hashable, Identifiable {
        let text: String
        let attribution: String
        let id = UUID()
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
