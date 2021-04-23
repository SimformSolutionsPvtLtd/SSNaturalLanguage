//
//  SentimentalAnalysisResultVC.swift
//  NaturalLanguageDemo
//
//  Created by Abhi Makadiya on 22/03/21.
//

import UIKit

class SentimentalAnalysisResultVC: UIViewController {

    var analysisResult: CGFloat = 0.0
    
    @IBOutlet weak var lblResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

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
