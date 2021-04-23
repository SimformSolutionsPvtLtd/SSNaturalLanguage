//
//  String+Extension.swift
//  SSNaturalLanguage
//
//  Created by Abhi Makadiya on 24/03/21.
//

import UIKit
import NaturalLanguage

extension String {
    
    /// It split a string into chunks of words, sentences, characters or paragraphs.
    /// - Parameter unit: NLTokenUnit
    /// - Returns: Return array of splited string.
    public func splitInto(unit: NLTokenUnit) -> [String] {
        var arrTokens: [String] = []
        let tokenizer = NLTokenizer(unit: unit)
        tokenizer.string = self
        tokenizer.enumerateTokens(in: self.startIndex..<self.endIndex) { tokenRange, _ in
            arrTokens.append("\(self[tokenRange])")
            return true
        }
        return arrTokens
    }
    
    /// It converts word into base form. eg. "assumed" to "assume"
    /// - Returns: Return tuple of word and its base form.
    public func toBaseForm() -> [(word: String, baseForm: String)] {
        var arrLemmatize: [(word: String, baseForm: String)] = []
        let tagger = NLTagger(tagSchemes: [.lemma])
        tagger.string = self
        tagger.enumerateTags(in: self.startIndex..<self.endIndex, unit: .word, scheme: .lemma) { tag, tokenRange in
          if let tag = tag {
            arrLemmatize.append((word: "\(self[tokenRange])", baseForm: "\(tag.rawValue)"))
          }
          return true
        }
        return arrLemmatize
    }
    
    //language Identification
    /// Finds dominant language code from the text content.
    /// - Returns: Return language identity code
    public func identifyLanguage() -> String? {
        let languageRecog = NLLanguageRecognizer()
        languageRecog.processString(self)
        return languageRecog.dominantLanguage?.rawValue
    }
    
    /// Returns array of predicted language with its confidence.
    /// - Parameter maxPredictCount: pass maximum prediction count.
    /// - Returns: Returns array of language code and its confidence
    public func predictedLanguage(maxPredictCount: Int) -> [(languageCode: String, confidence: Double)] {
        var arrLanguages = [(languageCode: String, confidence: Double)]()
        let languageRecog = NLLanguageRecognizer()
        languageRecog.processString(self)
        let dictPredictedLang = languageRecog.languageHypotheses(withMaximum: 5)
        for element in dictPredictedLang {
            arrLanguages.append((languageCode: element.key.rawValue, confidence: element.value))
        }
        return arrLanguages
    }
    
    /// Returns a string with correct spelling.
    /// - Returns: Returns a string with correct spelling.
    public func correctSpell() -> String {
        guard let dominantLanguage = NLLanguageRecognizer.dominantLanguage(for: self) else {
            return self
        }
        var updatedText = self
        let textChecker = UITextChecker()
        let nsString = NSString(string: self)
        let stringRange = NSRange(location: 0, length: nsString.length)
        var offset = 0
        repeat {
            let wordRange = textChecker.rangeOfMisspelledWord(in: self, range: stringRange, startingAt: offset, wrap: false, language: dominantLanguage.rawValue)
            guard wordRange.location != NSNotFound else {
                break
            }
            let misspell = nsString.substring(with: wordRange)
            let suggestedWords = textChecker.guesses(forWordRange: wordRange, in: self, language: dominantLanguage.rawValue)
            updatedText = updatedText.replacingOccurrences(of: misspell, with: suggestedWords?.first ?? misspell)
            offset = wordRange.upperBound
        } while true
        return updatedText
    }
    
    /// It identify words from speech or a sentence as nouns, pronouns, verbs, adjectives, prepositions, idioms, etc.
    /// - Returns: Tuple of word and its tag.
    public func partOfSpeech() -> [(word: String, tag: NLTag)] {
        var arrPartOfSpeech = [(word: String, tag: NLTag)]()
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation]
        tagger.string = self
        tagger.enumerateTags(in: self.startIndex..<self.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            if let tag = tag {
                arrPartOfSpeech.append((word: "\(self[tokenRange])", tag: tag))
            }
            return true
        }
        return arrPartOfSpeech
    }
    
    /// It identify names of people, places, and organizations in similar fashion
    /// - Returns: Tuple of word and its tag.
    public func recognizeNamedEntity() -> [(word: String, tag: NLTag)] {
        var arrNamedEntity = [(word: String, tag: NLTag)]()
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = self
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        let tags: [NLTag] = [.personalName, .placeName, .organizationName]
        tagger.enumerateTags(in: self.startIndex..<self.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
            if let tag = tag, tags.contains(tag) {
                arrNamedEntity.append((word: "\(self[tokenRange])", tag: tag))
            }
            return true
        }
        return arrNamedEntity
    }
    
    /// It analyses the degree of sentiment in the text, and based on that gives a score that ranges from -1 (highly negative) to 1 (very positive).
    /// - Returns: Return sentimental score
    public func sentimentalScore() -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = self
        let sentiment = tagger.tag(at: self.startIndex, unit: .paragraph, scheme: .sentimentScore).0
        let score = Double(sentiment?.rawValue ?? "0") ?? 0
        return score
    }
    
    
    /// It basically maps strings to their vector counterparts. In doing so, strings that have small vector distances are deemed similar.
    /// - Parameter maximumCount: maximum resukt count
    /// - Returns: Return tuple of similar words and its distance
    public func neighboringWords(maximumCount: Int) -> [(String, NLDistance)] {
        guard let lang = NLLanguageRecognizer.dominantLanguage(for: self) else {
            return []
        }
        let embedding = NLEmbedding.wordEmbedding(for: lang)
        if let res = embedding?.neighbors(for: self, maximumCount: maximumCount) {
            return res
        } else {
            return []
        }
    }
    
    /// It finds unique tags from the string
    /// - Parameter defaultTags: An array of default tags. Which help you to get unique tags from string. If it identify same default tag in given string, it will return in this function.
    /// - Returns: An array of tags.
    public func findUniqueTag(with defaultTags: [String] = []) -> [String] {
        let defaultTag = defaultTags.map{ $0.lowercased()}
        var arrTags: [String] = []
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        let options : NLTagger.Options = [.omitWhitespace, .omitPunctuation]
        tagger.string = self
        tagger.enumerateTags(in: self.startIndex..<self.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            if let tag = tag {
                if tag.rawValue == "Noun" || defaultTag.contains("\(self[tokenRange])".lowercased()) {
                    arrTags.append("\(self[tokenRange])")
                }
            }
            return true
        }
        arrTags = arrTags.map{ $0.capitalized}
        return Array(Set(arrTags)).map{ $0.capitalized}
    }
}
