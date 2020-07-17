//  MessageVC.swift
//  RealEstate
//
//  Created by Amit Kumar on 16/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

class RecentChatVC: UIViewController {
    
    @IBOutlet weak var tblView : UITableView! {
        didSet {
            self.tblView.delegate = self
            self.tblView.dataSource = self
        }
    }
    @IBOutlet weak var tfSearch : UITextField! {
        didSet {
            self.tfSearch.addTarget(self, action: #selector(self.textFieldDidEdit(_:)), for: .editingChanged)
        }
    }


    @objc private func textFieldDidEdit(_ sender: UITextField) {
        let text = sender.text
        if (text?.count ?? 0) > 0 {
            //TODO:- call search method
        }
    }
    
}

extension RecentChatVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentChatMsgTCell.identifier, for: indexPath) as? RecentChatMsgTCell else {
            return UITableViewCell()
        }
        
        cell.viewBG.backgroundColor = ((indexPath.row + 1) % 2 == 0) ? .clear : .customTextFieldColor
        return cell
    }
    
    
    
}



