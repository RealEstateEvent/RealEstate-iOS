//
//  EventDetailVC.swift
//  RealEstate
//
//  Created by Amit Kumar on 08/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit
import AgoraRtcKit
import AgoraRtmKit

class EventDetailVC: UIViewController {
    @IBOutlet var btnSegmentArray: [UIButton]!
    @IBOutlet var viewSegmentArray: [UIView]!
    @IBOutlet weak var hConstViewParent: NSLayoutConstraint!
    @IBOutlet weak var viewAttendee: UIView!
    @IBOutlet weak var viewAbout: UIView!
    @IBOutlet weak var viewSpeakers: UIView!
    @IBOutlet weak var viewAgenda: UIView!
    @IBOutlet weak var bConstViewAttendee: NSLayoutConstraint!
    @IBOutlet weak var bConstViewSpeakers: NSLayoutConstraint!
    @IBOutlet weak var bConstViewAgenda: NSLayoutConstraint!
    @IBOutlet weak var bConstViewAbout: NSLayoutConstraint!
    @IBOutlet weak var tblViewAgenda: UITableView!
    @IBOutlet weak var tblViewSpeakers: UITableView!
    @IBOutlet weak var tblViewAttendee: UITableView!
    @IBOutlet weak var lblEventPeriod: UILabel!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewSegment: UIView!
    @IBOutlet weak var lblAbout: UILabel!
    
    @IBOutlet weak var viewRSVP: UIView!
    @IBOutlet weak var btnRSVP: UIButton!
    @IBOutlet weak var hConsTblViewSpeaker: NSLayoutConstraint!
    @IBOutlet weak var hConstTblViewAgenda: NSLayoutConstraint!
    @IBOutlet weak var hConstTblViewAttendee: NSLayoutConstraint!
    
    var eventObject : Event?
    private var selectedSegment = 0
    
    @IBOutlet weak var imgViewEvent: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        [self.tblViewAgenda,self.tblViewAttendee,self.tblViewSpeakers].forEach { (tbl) in
            tbl?.delegate = self
            tbl?.dataSource = self
        }
        self.getEventDetail(forEventId: self.eventObject?.event_id ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        [self.tblViewAgenda,self.tblViewAttendee,self.tblViewSpeakers].forEach { (tbl) in
            tbl?.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        [self.tblViewAgenda,self.tblViewAttendee,self.tblViewSpeakers].forEach { (tbl) in
            tbl?.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    private func initialSetup() {
        let arr = [self.viewAbout,self.viewAgenda,self.viewSpeakers,self.viewAttendee]
        for i in 0..<arr.count {
            arr[i]?.tag = i
        }
        let _ = self.btnSegmentArray.compactMap{$0.tintColor = .clear; $0.setTitleColor(UIColor.customGoldenColor, for: .selected)}
        self.heighlightAndShowViewWith(tag:0)
        self.tblViewAttendee.register(UINib.init(nibName: AttendeeTCell.identifier, bundle: nil), forCellReuseIdentifier: AttendeeTCell.identifier)
        self.tblViewAgenda.register(UINib.init(nibName: AgendaTCell.identifier, bundle: nil), forCellReuseIdentifier: AgendaTCell.identifier)
        self.tblViewSpeakers.register(UINib.init(nibName: SpeakerTCell.identifier, bundle: nil), forCellReuseIdentifier: SpeakerTCell.identifier)
        self.updateUI()
    }
    
    private func updateUI() {
        self.imgViewEvent.setImageWith(url: self.eventObject?.coverPhoto)
        self.lblEventPeriod.text = "\(self.eventObject?.startTime?.toStringDate() ?? "") - \(self.eventObject?.endTime?.toStringDate() ?? "")"
        self.lblEventName.text = self.eventObject?.title
        self.lblAbout.text = self.eventObject?.desscription
        self.viewRSVP.isHidden = self.eventObject?.isBooked ?? false
    }
    
    @IBAction func btnSegmentTapped(_ sender: UIButton) {
        self.selectedSegment = sender.tag
        self.heighlightAndShowViewWith(tag: sender.tag)
    }
    
    private func heighlightAndShowViewWith(tag : Int) {
        let _ = self.btnSegmentArray.compactMap{$0.isSelected = false}
        let _ = self.viewSegmentArray.compactMap{$0.isHidden = true}
        let arrView = self.viewSegmentArray.filter{$0.tag == tag}
        let arrBtn = self.btnSegmentArray.filter{$0.tag == tag}
        let _ = arrView.map{$0.isHidden = false}
        let _ = arrBtn.map{$0.isSelected = true}

        let arr : [UIView] = [self.viewAbout,self.viewAgenda,self.viewSpeakers,self.viewAttendee]
        let arrConst : [NSLayoutConstraint] = [self.bConstViewAbout,self.bConstViewAgenda,self.bConstViewSpeakers,self.bConstViewAttendee]
        for i in 0..<arr.count {
            if arr[i].tag == tag {
//                if arr[i] == self.viewSpeakers {
//                    self.hConstViewParent.priority = .defaultHigh
//                } else {
//                    self.hConstViewParent.priority = .defaultLow
//                }
                arr[i].isHidden = false
                arrConst[i].priority = .required
//                arrConst[i].isActive = true
                
            } else {
                arr[i].isHidden = true
                arrConst[i].priority = .defaultLow
//                arrConst[i].isActive = false
            }
            self.tblViewSpeakers.reloadData()
            self.tblViewAgenda.reloadData()
            self.tblViewAttendee.reloadData()
        }
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnRSVPTapped(_ sender: UIButton) {
        self.apiCallRSVPWith(eventId: self.eventObject?.event_id ?? "")
    }
    
    @IBAction func btnBacktapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShareTapped(_ sender: UIButton) {
        
    }
}


extension EventDetailVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tblViewAgenda:
            return self.eventObject?.agendaList.count ?? 0
        case self.tblViewSpeakers:
            return self.eventObject?.speakerList.count ?? 0
        case self.tblViewAttendee:
            return self.eventObject?.attendeeList?.attendees.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.tblViewAgenda:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AgendaTCell.identifier, for: indexPath) as? AgendaTCell else {
                return UITableViewCell()
            }
            
            if let obj  = self.eventObject?.agendaList[indexPath.row] {
                cell.configCellWith(obj,indexPath,tableView)
            }
            
            let arr = self.eventObject?.attendeeList?.attendees.filter{$0.email == SharedClass.shared.user?.email}
            if (arr?.count ?? 0) > 0 {
                cell.btnCheckIn.isHidden = false
            } else {
                cell.btnCheckIn.isHidden = true
            }
            cell.btnCheckIn.tag = indexPath.row
            cell.btnCheckIn.addTarget(self, action: #selector(btnCheckInTapped), for: .touchUpInside)
            cell.layoutIfNeeded()
            cell.selectionStyle = .none
            return cell
        case self.tblViewSpeakers:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SpeakerTCell.identifier, for: indexPath) as? SpeakerTCell else {
                return UITableViewCell()
            }
            if let obj  = self.eventObject?.speakerList[indexPath.row] {
                cell.configCellWith(obj)
            }
            cell.selectionStyle = .none
            return cell
        case self.tblViewAttendee:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttendeeTCell.identifier, for: indexPath) as? AttendeeTCell else {
                return UITableViewCell()
            }
            if let obj  = self.eventObject?.attendeeList?.attendees[indexPath.row] {
                cell.configCellWith(obj)
            }
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
    @objc func btnCheckInTapped(sender: UIButton){
        if let obj  = self.eventObject?.agendaList[sender.tag] {
            let userId = (SharedClass.shared.user?.id ?? "") + ".attendee"
            print(userId)
            self.login(channelId: obj.id ?? "", userId: userId, agendaName: obj.title ?? "")
        }
    }
    
    private func getEventDetail(forEventId evId : String) {
        let dataToAppend = "id=\(evId)"
        AKNetworkManager.sharedManager.request(webService: .eventDetail, param: [:], method: .get, urlAppendString: dataToAppend) { (data) in
            //print("DATA OF EVENT DETAILS IS:\(data)")
            let dict = AKHelper.getDictionary(from: data)
            let eventDict = AKHelper.getDictionary(from: dict?["data"])
            self.eventObject = Event.init(with: eventDict)
            self.updateUI()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                if selectedSegment == 1 {
                    self.hConstTblViewAgenda.constant = newsize.height
                } else if selectedSegment == 2 {
                    self.hConsTblViewSpeaker.constant = newsize.height
                } else if selectedSegment == 3 {
                    self.hConstTblViewAttendee.constant = newsize.height
                }
            }
        }
    }
    
    private func apiCallRSVPWith(eventId : String) {
        let dataToAppend = "id=\(eventId)"
        AKNetworkManager.sharedManager.request(webService: .bookEvent, param: [:], method: .post, urlAppendString: dataToAppend) { (data) in
            let dict = AKHelper.getDictionary(from: data)
            let msg = AKNetworkManager.sharedManager.getMessage(from: dict)
            UIAlertController.showNotificationWith(msg ?? "")
            self.viewRSVP.isHidden = true
        }
    }
    
    func shareText() {

        // text to share
        let text = "This is some text that I want to share."

        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)

    }

    // share image
     func shareImage() {

        // image to share
        let image = UIImage(named: "Image")

        // set up activity view controller
        let imageToShare = [image!]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}


private extension EventDetailVC {
    func login(channelId: String, userId: String, agendaName: String) {
        AgoraRtm.updateKit(delegate: self)
        AgoraRtm.current = userId
        AgoraRtm.oneToOneMessageType = .normal

        AgoraRtm.kit?.login(byToken: nil, user: userId) { [unowned self] (errorCode) in
//            guard errorCode == .ok else {
//                print(errorCode)
////                self.showAlert("login error: \(errorCode.rawValue)")
//                return
//            }
//
            AgoraRtm.status = .offline
            
            DispatchQueue.main.async {
                self.view.endEditing(true)
                let vc = LiveSteamViewController.instantiate(from: .home)
                vc.userType = .audience
                vc.channelId = channelId
                vc.userId = userId
                vc.eventObject = self.eventObject
                vc.agendaName = agendaName
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func logout() {
        guard AgoraRtm.status == .online else {
            return
        }
        
        AgoraRtm.kit?.logout(completion: { (error) in
            guard error == .ok else {
                return
            }
            
            AgoraRtm.status = .offline
        })
    }
}

extension EventDetailVC: AgoraRtmDelegate {
    // Receive one to one offline messages
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        AgoraRtm.add(offlineMessage: message, from: peerId)
    }
}
