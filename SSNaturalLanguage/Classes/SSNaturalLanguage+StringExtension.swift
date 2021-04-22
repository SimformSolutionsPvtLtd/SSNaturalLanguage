//
//  String+Extension.swift
//  SSNaturalLanguage
//
//  Created by Abhi Makadiya on 24/03/21.
//

import UIKit
import NaturalLanguage

extension String {

    private struct CustomTagsStruct {
        static var customTags: [String] = []
        var customTagProperty: [String] {
            get {
                return CustomTagsStruct.customTags
            }
            set(newValue) {
                CustomTagsStruct.customTags = newValue.map{ $0.lowercased()}
            }
        }
    }
    
    //Tokenisation
    func tokenize(unit: NLTokenUnit) -> [String] {
        var arrTokens: [String] = []
        let tokenizer = NLTokenizer(unit: unit)
        tokenizer.string = self
        tokenizer.enumerateTokens(in: self.startIndex..<self.endIndex) { tokenRange, _ in
            arrTokens.append("\(self[tokenRange])")
            return true
        }
        return arrTokens
    }
    
    //Lemmatization
    func lemmatize() -> [String] {
        var arrLemmatize: [String] = []
        let tagger = NLTagger(tagSchemes: [.lemma])
        tagger.string = self
        tagger.enumerateTags(in: self.startIndex..<self.endIndex, unit: .word, scheme: .lemma) { tag, tokenRange in
          if let tag = tag {
            arrLemmatize.append(tag.rawValue)
          }
          return true
        }
        return arrLemmatize
    }
    
    //language Identification
    func languageIdentity() -> String? {
        let languageRecog = NLLanguageRecognizer()
        languageRecog.processString(self)
        return languageRecog.dominantLanguage?.rawValue
    }
    
    //possible language
    func possibleLanguages(maximumResult: Int) -> [NLLanguage: Double] {
        let languageRecog = NLLanguageRecognizer()
        languageRecog.processString(self)
        let dictPossibleLanguages = languageRecog.languageHypotheses(withMaximum: maximumResult)
        return dictPossibleLanguages
    }
    
    func correctSpell() -> String {
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
    
    func partOfSpeechTags() -> [[String: NLTag]] {
        var arrPartOfSpeech = [[String: NLTag]]()
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation]
        tagger.string = self
        tagger.enumerateTags(in: self.startIndex..<self.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            if let tag = tag{
                var dictToken: [String: NLTag] = [:]
                dictToken["\(self[tokenRange])"] = tag
                arrPartOfSpeech.append(dictToken)
            }
            return true
        }
        return arrPartOfSpeech
    }
    
    func recognizeNamedEntity() -> [[String: String]] {
        var arrNamedEntity = [[String: String]]()
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = self
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        let tags: [NLTag] = [.personalName, .placeName, .organizationName]
        tagger.enumerateTags(in: self.startIndex..<self.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
            if let tag = tag, tags.contains(tag) {
                var dictToken: [String: String] = [:]
                dictToken["\(self[tokenRange])"] = "\(tag.rawValue)"
                arrNamedEntity.append(dictToken)
            }
            return true
        }
        return arrNamedEntity
    }
    
    func sentimentalScore() -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = self
        let sentiment = tagger.tag(at: self.startIndex, unit: .paragraph, scheme: .sentimentScore).0
        let score = Double(sentiment?.rawValue ?? "0") ?? 0
        return score
    }
    
    func neighboringWords() -> [(String, NLDistance)]? {
        guard let lang = NLLanguageRecognizer.dominantLanguage(for: self) else {
            return []
        }
        let embedding = NLEmbedding.wordEmbedding(for: lang)
        if let res = embedding?.neighbors(for: self, maximumCount: 5) {
            return res
        } else {
            return nil
        }
    }
    
    static func addCustomTags(tags: [String]) {
        CustomTagsStruct.customTags = tags
    }
    
    static func getCustomTags() -> [String] {
        return CustomTagsStruct.customTags
    }
    
    func findUniqueTag() -> [String] {
        var arrTags: [String] = []
        let customTags = String.getCustomTags()
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        let options : NLTagger.Options = [.omitWhitespace, .omitPunctuation]
        tagger.string = self
        tagger.enumerateTags(in: self.startIndex..<self.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            if let tag = tag {
                if tag.rawValue == "Noun" || customTags.contains("\(self[tokenRange])".lowercased()) {
                    arrTags.append("\(self[tokenRange])")
                }
            }
            return true
        }
        return Array(Set(arrTags))
    }
}
