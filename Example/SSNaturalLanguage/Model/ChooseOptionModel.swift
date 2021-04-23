//
//  ChooseOptionModel.swift
//  NaturalLanguage
//
//  Created by Abhi Makadiya on 14/03/21.
//

import UIKit
/*
enum NaturalLanguageOptions: Int {
    case tokenization
    case lemmatization
    case languageIdentification
    case spellCheckingAndCorrection
    case partOfSpeechTagging
    case identifyingPeople
    case sentimentAnalysis
    case wordEmbeddings
    case tags
}*/

class ChooseOptionModel: NSObject {

    var title: String?
    
    init(title: String) {
        self.title = title
    }
    
    static func getOptions() -> [ChooseOptionModel] {
        return [ChooseOptionModel(title: "Tokenization"), ChooseOptionModel(title: "Lemmatization"), ChooseOptionModel(title: "Language Identification"), ChooseOptionModel(title: "Spell Checking and Correction"), ChooseOptionModel(title: "Part Of Speech (POS) Tagging"), ChooseOptionModel(title: "Identifying People, Organization, etc"), ChooseOptionModel(title: "Sentiment Analysis"), ChooseOptionModel(title: "Word Embeddings"), ChooseOptionModel(title: "Tags")
        ]
    }
    
}
