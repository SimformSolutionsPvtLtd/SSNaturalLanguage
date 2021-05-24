//
//  SentimentalAnalysisResultVC.swift
//  SSNaturalLanguage
//
//  Created by Abhi Makadiya on 22/03/21.
//

import UIKit

class SentimentalAnalysisResultVC: UIViewController {

    // MARK: - Variables
    var analysisResult: Double = 0.0
    
    // MARK: - Outlets
    @IBOutlet weak var lblResult: UILabel!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Functions
    func setupUI() {
        if analysisResult == 0 {
            lblResult.text = "🙂"
        } else if analysisResult < 0 {
            lblResult.text = "😢"
        } else {
            lblResult.text = "😁"
        }
    }
    
}
