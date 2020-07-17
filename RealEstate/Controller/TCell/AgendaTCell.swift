//
//  AgendaTCell.swift
//  RealEstate
//
//  Created by Amit Kumar on 09/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

class AgendaTCell: UITableViewCell {
    static var identifier = "AgendaTCell"
    @IBOutlet weak var hConstTblView: NSLayoutConstraint!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTimePeriod: UILabel!
    @IBOutlet weak var lblName: UILabel!
    var speakers : [Speaker]?
    private var indexxPath : IndexPath!
    private var tblViewParent : UITableView!
    
    @IBOutlet weak var btnCheckIn: UIButton!
    
    @IBAction func btnCheckInTapped(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.delegate = self
            self.tblView.dataSource = self
            self.tblView.register(UINib.init(nibName: AttendeeTCell.identifier, bundle: nil), forCellReuseIdentifier: AttendeeTCell.identifier)
        }
    }
    
    
    func configCellWith(_ obj:Agenda, _ indexpath: IndexPath, _ tblView:UITableView) {
        self.tblViewParent = tblView
        self.indexxPath = indexpath
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        self.lblDate.text = obj.startTime?.toStringDate("MMM dd")
        let timeInterval = AKHelper.timeIntervalString(startTimeStamp: obj.startTime ?? "", endTimeStamp: obj.endTime ?? "")
        self.lblTimePeriod.text = "\(obj.startTime?.toStringDate("hh:mm a") ?? "") - \(obj.endTime?.toStringDate("hh:mm a") ?? ""), \(timeInterval ?? "")"
        self.speakers = obj.speakers
        self.lblName.text = obj.title
        self.hConstTblView.constant = CGFloat(90 * (self.speakers?.count ?? 0))
        self.layoutIfNeeded()
        self.tblView.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                self.tblViewParent.reloadRows(at: [self.indexxPath], with: .none)
            }
        }
    }
        
}

extension AgendaTCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.speakers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AttendeeTCell.identifier, for: indexPath) as? AttendeeTCell else {
            return UITableViewCell()
        }
        if let speaker = self.speakers?[indexPath.row] {
            cell.configCellWith(speaker)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}

