//
//  MisspellModel.swift
//  NaturalLanguageDemo
//
//  Created by Abhi Makadiya on 22/03/21.
//

import UIKit

class MisspellModel: NSObject {

    var misspell: String?
    var suggestedWord: String?
    
    override init() {
        super.init()
    }
    
    init(misspell: String, suggestedWord: String) {
        self.misspell = misspell
        self.suggestedWord = suggestedWord
    }
    
}
