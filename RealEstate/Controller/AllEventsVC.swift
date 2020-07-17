//
//  AllEventsVC.swift
//  RealEstate
//
//  Created by Amit Kumar on 07/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

class AllEventsVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!{
        didSet {
            self.tblView.delegate = self
            self.tblView.dataSource = self
        }
    }
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var lblNoDataFound: UILabel!
    private var totalObjectCount : Int = 0
    private var currentPage = 1
    private var arrEvents = [Event]()
    private var selectedSegmentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.register(UINib.init(nibName: EventTCell.identifier, bundle: nil), forCellReuseIdentifier: EventTCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedSegmentIndex = 1
        self.currentPage = 1
        self.totalObjectCount = 0
        self.arrEvents.removeAll()
        self.segmentControl.selectedSegmentIndex = self.selectedSegmentIndex
        self.apiCallGetAllEvents(isPast: self.segmentControl.selectedSegmentIndex == 0)
    }
    
    @IBAction func segmentDidTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex != self.selectedSegmentIndex {
            self.selectedSegmentIndex = sender.selectedSegmentIndex
            self.arrEvents.removeAll()
            self.tblView.reloadData()
            self.apiCallGetAllEvents(isPast: self.segmentControl.selectedSegmentIndex == 0)
        }
    }
    
}

extension AllEventsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTCell.identifier, for: indexPath) as? EventTCell else {
            return UITableViewCell()
        }
        cell.configCellWith(self.arrEvents[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let newIndexPath = indexPath.row + 1
        if newIndexPath == self.arrEvents.count && self.arrEvents.count < self.totalObjectCount && self.totalObjectCount != 0 {
            self.currentPage += 1
            self.apiCallGetAllEvents(isPast: self.segmentControl.selectedSegmentIndex == 0, currentPage: currentPage)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedSegmentIndex == 1 {
            let vc = EventDetailVC.instantiate(from: .home)
            vc.eventObject = self.arrEvents[indexPath.row]
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            
//            let vc = TempVC.instantiate(from: .home)
//            vc.eventObject = self.arrEvents[indexPath.row]
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    private func apiCallGetAllEvents(isPast : Bool, currentPage: Int = 1 , limitPerPage : Int = 10) {
        let dataToAppend = "page=\(currentPage)&limit=\(limitPerPage)"
        AKNetworkManager.sharedManager.request(webService: isPast ? .allPastEvents : .allUpcomingEvents , param: [:], method: .get, urlAppendString: dataToAppend) { (data) in
            print("DATA :\(data)")
            let dictData = AKHelper.getDictionary(from: data)
            let dataFinal = AKHelper.getDictionary(from: dictData?["data"])
            
            let arr = AKHelper.getArrayOfDict(from: dataFinal?["docs"])
            let total = Int(String.getString(dataFinal?["total"])) ?? 0
            self.totalObjectCount = total
            
            if (arr?.count ?? 0) > 0 {
                self.arrEvents.append(contentsOf: arr!.map{Event.init(with: $0)})
                self.tblView.reloadData()
                self.tblView.isHidden = false
                self.lblNoDataFound.isHidden = true
            } else {
                if currentPage == 1 {
                    self.tblView.isHidden = true
                    self.lblNoDataFound.isHidden = false
                }
            }
        }
    }
    
    
}

