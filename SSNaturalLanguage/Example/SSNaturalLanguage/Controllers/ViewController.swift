//
//  ViewController.swift
//  SSNaturalLanguage
//
//  Created by Abhi Makadiya on 21/03/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var tvEnterText: TextViewWithPlaceholder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvEnterText.layer.cornerRadius = 10
        tvEnterText.clipsToBounds = true
        tvEnterText.layer.borderWidth = 1.0
        tvEnterText.layer.borderColor = UIColor(red: 83/225, green: 105/255, blue: 235/255, alpha: 1.0).cgColor
    }

    // MARK: - IB Action
    @IBAction func btnSubmitAction(_ sender: ThemeSubmitButton) {
        if tvEnterText.text != tvEnterText.placeholderText || !tvEnterText.text.isEmpty {
            if let chooseOptionVC = self.storyboard?.instantiateViewController(identifier: "ChooseOptionVC") as? ChooseOptionVC {
                chooseOptionVC.text = tvEnterText.text
                self.navigationController?.pushViewController(chooseOptionVC, animated: true)
            }
        }
    }

}

