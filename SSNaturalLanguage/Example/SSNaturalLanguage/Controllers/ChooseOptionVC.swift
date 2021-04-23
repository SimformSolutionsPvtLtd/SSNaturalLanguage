//
//  ChooseOptionVC.swift
//  SSNaturalLanguage
//
//  Created by Abhi Makadiya on 14/03/21.
//

import UIKit
import SSNaturalLanguage

enum ChooseOptionType: Int {
    case tokenization = 0
    case lemmatization
    case languageIdentification
    case spellCheckCorrection
    case partOfSpeech
    case identifyingPeople
    case sentimentAnalysis
    case wordEmbedding
    case tags
}

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
}

// MARK: - Navigations
extension ChooseOptionVC {
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
    
    func goToSentimentalAnalysisVC(result: Double) {
        if let sentimentalVC = self.storyboard?.instantiateViewController(identifier: "SentimentalAnalysisResultVC") as? SentimentalAnalysisResultVC {
            sentimentalVC.analysisResult = result
            self.navigationController?.pushViewController(sentimentalVC, animated: true)
        }
    }
}

// MARK: - Tableview DataSource
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

// MARK: - Tableview delegate
extension ChooseOptionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ChooseOptionType(rawValue: indexPath.row) {
        case .tokenization:
            let arrSplitText = text.splitInto(unit: .sentence)
            let arrModel = arrSplitText.map ({ (text) -> ResultModel in
                return ResultModel(result: text)
            })
            goToResultVC(data: arrModel)
        case .lemmatization:
            let arrBaseForm = text.toBaseForm()
            let arrModel = arrBaseForm.map({ (arg) -> ResultModel in
                return ResultModel(result: "\(arg.word) - \(arg.baseForm)")
            })
            goToResultVC(data: arrModel)
        case .languageIdentification:
            var arrDominantLang = [ResultModel]()
            var arrPredictedLang = [ResultModel]()
            let language = text.identifyLanguage()
            arrDominantLang.append(ResultModel(result: Locale.current.localizedString(forIdentifier: language ?? "") ?? ""))
            let predictedLangs = text.predictedLanguage(maxPredictCount: 2)
            for language in predictedLangs {
                arrPredictedLang.append(ResultModel(result: "\(Locale.current.localizedString(forIdentifier: language.languageCode) ?? "") - \(language.confidence)"))
            }
            goToLanguageIndentificationVC(dominant: arrDominantLang, predicted: arrPredictedLang)
        case .spellCheckCorrection:
            let textSpellCorrection = text.correctSpell()
            goToResultVC(data: [ResultModel(result: textSpellCorrection)])
        case .partOfSpeech:
            let arrPartOfSpeech = text.partOfSpeech()
            let arrModel = arrPartOfSpeech.map({ (word) -> ResultModel in
                return ResultModel(result: "\(word.word) - \(word.tag.rawValue)")
            })
            goToResultVC(data: arrModel)
        case .identifyingPeople:
            let arrWords = text.recognizeNamedEntity()
            let arrModel = arrWords.map({ (word) -> ResultModel in
                return ResultModel(result: "\(word.word) - \(word.tag.rawValue)")
            })
            goToResultVC(data: arrModel)
        case .sentimentAnalysis:
            let sentimentalScore = text.sentimentalScore()
            goToSentimentalAnalysisVC(result: sentimentalScore)
        case .wordEmbedding:
            let neighbouringWord = text.neighboringWords(maximumCount: 5)
            let arrModel = neighbouringWord.map ({ (word) -> ResultModel in
                return ResultModel(result: "")
            })
            goToResultVC(data: arrModel)
        case .tags:
            let uniqueTags = text.findUniqueTag()
            let arrModel = uniqueTags.map ({ (word) -> ResultModel in
                return ResultModel(result: word)
            })
            goToResultVC(data: arrModel)
        default:
            break
        }
    }
}
