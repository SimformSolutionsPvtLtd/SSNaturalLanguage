//
//  ResultVC.swift
//  NaturalLanguage
//
//  Created by Abhi Makadiya on 14/03/21.
//

import UIKit

class ResultVC: UIViewController {

    // MARK: - Variables
    var arrResult: [ResultModel] = []
    
    // MARK: - Outlets
    @IBOutlet weak var tblResult: UITableView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Functions
    func setupUI() {
        tblResult.register(UINib(nibName: "ChooseOptionTVCell", bundle: nil), forCellReuseIdentifier: "ChooseOptionTVCell")
    }
}

extension ResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseOptionTVCell", for: indexPath) as? ChooseOptionTVCell {
            cell.lblTitle.text = arrResult[indexPath.row].result
            cell.accessoryType = .none
            return cell
        } else {
            return UITableViewCell()
        }
            
    }
}

extension ResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
