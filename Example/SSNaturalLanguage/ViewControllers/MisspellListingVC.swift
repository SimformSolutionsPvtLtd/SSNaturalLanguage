//
//  MisspellListingVC.swift
//  NaturalLanguageDemo
//
//  Created by Abhi Makadiya on 22/03/21.
//

import UIKit

class MisspellListingVC: UIViewController {

    // MARK: - Variables
    var misSpellModel: [MisspellModel] = []
    
    // MARK: - Outlets
    @IBOutlet weak var tblSpellList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        tblSpellList.register(UINib(nibName: "SpellCheckingTVCell", bundle: nil), forCellReuseIdentifier: "SpellCheckingTVCell")
    }
}

extension MisspellListingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return misSpellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SpellCheckingTVCell", for: indexPath) as? SpellCheckingTVCell {
            cell.lblMisspell.text = misSpellModel[indexPath.row].misspell
            cell.lblCorrection.text = misSpellModel[indexPath.row].suggestedWord
            return cell
        } else {
            return UITableViewCell()
        }
            
    }
}

extension MisspellListingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
