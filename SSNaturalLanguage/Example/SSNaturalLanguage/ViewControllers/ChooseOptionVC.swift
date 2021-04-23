//
//  ChooseOptionVC.swift
//  NaturalLanguage
//
//  Created by Abhi Makadiya on 14/03/21.
//

import UIKit
import NaturalLanguage

class ChooseOptionVC: UIViewController {
    
    // MARK: - Variables
    var arrOptions: [ChooseOptionModel] = []
    var text = ""
    
    // MARK: - Outlets
    @IBOutlet weak var tblChooseOptions: UITableView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        arrOptions = ChooseOptionModel.getOptions()
        tblChooseOptions.register(UINib(nibName: "ChooseOptionTVCell", bundle: nil), forCellReuseIdentifier: "ChooseOptionTVCell")
    }
    
    func goToResultVC(data: [ResultModel]) {
        if let resultVC = self.storyboard?.instantiateViewController(identifier: "ResultVC") as? ResultVC {
            resultVC.arrResult = data
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    
    func goToLanguageIndentificationVC(dominant: [ResultModel], predicted: [ResultModel]) {
        if let resultVC = self.storyboard?.instantiateViewController(identifier: "LanguageIdentificationResultVC") as? LanguageIdentificationResultVC {
            resultVC.dominantLanguage = dominant
            resultVC.predictedLanguage = predicted
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    
    func gotoMisspellVC(model: [MisspellModel]) {
        if let misspellVC = self.storyboard?.instantiateViewController(identifier: "MisspellListingVC") as? MisspellListingVC {
            misspellVC.misSpellModel = model
            self.navigationController?.pushViewController(misspellVC, animated: true)
        }
    }
    
    func goToSentimentalAnalysisVC(result: CGFloat) {
        if let sentimentalVC = self.storyboard?.instantiateViewController(identifier: "SentimentalAnalysisResultVC") as? SentimentalAnalysisResultVC {
            sentimentalVC.analysisResult = result
            self.navigationController?.pushViewController(sentimentalVC, animated: true)
        }
    }
    
}

// MARK: - Execution
extension ChooseOptionVC {
    func tokenization() -> [ResultModel] {
        var objOut = [ResultModel]()
        // Initialize the tokenizer with unit of "word"
        let tokenizer = NLTokenizer(unit: .word)
        // Set the string to be processed
        tokenizer.string = text
        // Loop over all the tokens and print them
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
            print(text[tokenRange])
            objOut.append(ResultModel(result: "\(text[tokenRange])"))
            return true
        }
        return objOut
    }
    
    func lemmatization() -> [ResultModel] {
        var objOut = [ResultModel]()
        let tagger = NLTagger(tagSchemes: [.lemma])
        // Set the string to be processed
        tagger.string = text
        // Loop over all the tokens and print their lemma
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lemma) { tag, tokenRange in
          if let tag = tag {
              print("\(text[tokenRange]): \(tag.rawValue)")
            objOut.append(ResultModel(result: "\(text[tokenRange]): \(tag.rawValue)"))
          }
          return true
        }
        return objOut
    }
    
    func findLanguage() -> ([ResultModel], [ResultModel]) {
        let dictLanguage = JsonHelper.getLanguageJson()
        var objDominantLanguage = [ResultModel]()
        var predictedLanguage = [ResultModel]()
        let languageRecog = NLLanguageRecognizer()

        // find the dominant language
        languageRecog.processString(text)
        print("Dominant language is: \(languageRecog.dominantLanguage?.rawValue ?? "")")
        if dictLanguage.keys.contains(languageRecog.dominantLanguage?.rawValue ?? "") {
            objDominantLanguage.append(ResultModel(result: dictLanguage[languageRecog.dominantLanguage?.rawValue ?? ""] ?? ""))
        } else {
            objDominantLanguage.append(ResultModel(result: languageRecog.dominantLanguage?.rawValue ?? ""))
        }
        
        // identify the possible languages
        languageRecog.processString(text)
        //print("Possible languages are:\(languageRecog.languageHypotheses(withMaximum: 2))")
        let dictPredictedLang = languageRecog.languageHypotheses(withMaximum: 5)
        for key in dictPredictedLang.keys {
            if dictLanguage.keys.contains(key.rawValue) {
                predictedLanguage.append(ResultModel(result: "\(dictLanguage[key.rawValue] ?? ""): \(dictPredictedLang[key] ?? 0.0)"))
            } else {
                predictedLanguage.append(ResultModel(result: key.rawValue))
            }
        }
        return (objDominantLanguage, predictedLanguage)
    }
    
    func spellCorrection() -> [MisspellModel] {
        var objOut: [MisspellModel] = []
        // find the dominant language of text
        let dominantLanguage = NLLanguageRecognizer.dominantLanguage(for: text)
        
        // initialize UITextChecker, nsString, stringRange
        let textChecker = UITextChecker()
        let nsString = NSString(string: text)
        let stringRange = NSRange(location: 0, length: nsString.length)
        var offset = 0
        
        repeat {
            // find the range of misspelt word
            let wordRange = textChecker.rangeOfMisspelledWord(in: text, range: stringRange, startingAt: offset, wrap: false, language: dominantLanguage!.rawValue)

            // check if the loop range exceeds the string length
            guard wordRange.location != NSNotFound else {
                break
            }
            let modelOut = MisspellModel()
            modelOut.misspell = nsString.substring(with: wordRange)
            // get the misspelt word
            print(nsString.substring(with: wordRange))

            // get some suggested words for the misspelt word
            
            modelOut.suggestedWord = textChecker.guesses(forWordRange: wordRange, in: text, language: dominantLanguage!.rawValue)?.joined(separator: " ")
            print(textChecker.guesses(forWordRange: wordRange, in: text, language: dominantLanguage!.rawValue) as Any)
            objOut.append(modelOut)
            // update the start index or offset
            offset = wordRange.upperBound
        } while true
        return objOut
    }
    
    func partOfSpeechTagging() -> [ResultModel] {
        var objOut = [ResultModel]()
        
        // Initialize the tagger
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        // Ignore whitespace and punctuation marks
        let options : NLTagger.Options = [.omitWhitespace, .omitPunctuation]
        // Process the text for POS
        tagger.string = text

        // loop through all the tokens and print their POS tags
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            if let tag = tag {
                objOut.append(ResultModel(result: "\(text[tokenRange]): \(tag.rawValue)"))
                print("\(text[tokenRange]): \(tag.rawValue)")
            }
            return true
        }
        return objOut
    }
    
    func identifyPeopleAndOrganization() -> [ResultModel] {
        var objOut = [ResultModel]()
        
        // Initialize NLTagger with ".nameType" scheme for NER
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = text
        // Ignore Punctuation and Whitespace
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        // Tags to extract
        let tags: [NLTag] = [.personalName, .placeName, .organizationName]
        // Loop over the tokens and print the NER of the tokens
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
            if let tag = tag, tags.contains(tag) {
                print("\(text[tokenRange]): \(tag.rawValue)")
                objOut.append(ResultModel(result: "\(text[tokenRange]): \(tag.rawValue)"))
            }
            return true
        }
        return objOut
    }
    
    func calculateSentimental() -> CGFloat {
        // Feed it into the NaturalLanguage framework
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text

        // Ask for the results
        let sentiment = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore).0

        // Read the sentiment back and print it
        let score = Double(sentiment?.rawValue ?? "0") ?? 0
        return CGFloat(score)
    }
    
    func findSimilarWords() -> [ResultModel] {
        var objOut = [ResultModel]()
        // Extract the language type
        let lang = NLLanguageRecognizer.dominantLanguage(for: text)
        // Get the OS embeddings for the given language
        let embedding = NLEmbedding.wordEmbedding(for: lang!)
        
        // Find the 5 words that are nearest to the input word based on the embedding
        if let res = embedding?.neighbors(for: text, maximumCount: 5) {
            for element in res {
                objOut.append(ResultModel(result: "\(element.0) - \(element.1)"))
            }
        }
        return objOut
    }
    
    func findTags() -> [ResultModel] {
        var objOut = [ResultModel]()
        
        // Initialize the tagger
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        // Ignore whitespace and punctuation marks
        let options : NLTagger.Options = [.omitWhitespace, .omitPunctuation]
        // Process the text for POS
        tagger.string = text

        // loop through all the tokens and print their POS tags
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            if let tag = tag {
                if tag.rawValue == "Noun" {
                    objOut.append(ResultModel(result: "\(text[tokenRange])"))
                }
            }
            return true
        }
        return objOut
    }
    
}

extension ChooseOptionVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseOptionTVCell", for: indexPath) as? ChooseOptionTVCell {
            cell.lblTitle.text = arrOptions[indexPath.row].title
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
}

extension ChooseOptionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            goToResultVC(data: tokenization())
        case 1:
            goToResultVC(data: lemmatization())
        case 2:
            let language = findLanguage()
            goToLanguageIndentificationVC(dominant: language.0, predicted: language.1)
        case 3:
            gotoMisspellVC(model: spellCorrection())
        case 4:
            goToResultVC(data: partOfSpeechTagging())
        case 5:
            goToResultVC(data: identifyPeopleAndOrganization())
        case 6:
            goToSentimentalAnalysisVC(result: calculateSentimental())
        case 7:
            goToResultVC(data: findSimilarWords())
        case 8:
            goToResultVC(data: findTags())
        default:
            break
        }
    }
}
