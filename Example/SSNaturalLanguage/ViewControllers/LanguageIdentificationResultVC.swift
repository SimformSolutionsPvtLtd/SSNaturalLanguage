//
//  LanguageIdentificationResultVC.swift
//  NaturalLanguageDemo
//
//  Created by Abhi Makadiya on 21/03/21.
//

import UIKit

class LanguageIdentificationResultVC: UIViewController {
    
    // MARK: - Variables
    var dominantLanguage: [ResultModel] = []
    var predictedLanguage: [ResultModel] = []
    
    // MARK: - Outlets
    @IBOutlet weak var tblLanguageList: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Functions
    func setupUI() {
        tblLanguageList.register(UINib(nibName: "ChooseOptionTVCell", bundle: nil), forCellReuseIdentifier: "ChooseOptionTVCell")
    }
    
}

extension LanguageIdentificationResultVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dominantLanguage.count
        } else if section == 1 {
            return predictedLanguage.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseOptionTVCell", for: indexPath) as? ChooseOptionTVCell {
                cell.lblTitle.text = dominantLanguage[indexPath.row].result
                cell.accessoryType = .none
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseOptionTVCell", for: indexPath) as? ChooseOptionTVCell {
                cell.lblTitle.text = predictedLanguage[indexPath.row].result
                cell.accessoryType = .none
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Dominant Language"
        } else if section == 1 {
            return "Predicted Language"
        } else {
            return ""
        }
    }
}
