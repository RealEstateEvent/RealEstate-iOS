//
//  LiveSteamViewController.swift
//  RealEstate
//
//  Created by Himanshu Goyal on 14/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit
import AgoraRtcKit
import AgoraRtmKit

struct Message {
    var userId: String
    var text: String
    var type: MessageCellType
    var userName: String
    var userImageUrl: String
}

struct OnlineHostModel{
    var userId: String
    var uId: UInt
    var userName: String
    var displayName: String
    var userimageURL: String
    var isVideoMuted: Bool
    var isAudioMuted: Bool
}

enum ChatType {
    case peer(String), group(String)
    
    var description: String {
        switch self {
        case .peer:  return "peer"
        case .group: return "channel"
        }
    }
}

class LiveSteamViewController: UIViewController {
    
    @IBOutlet weak var lblActiveAttendeeCount   : UILabel!
    @IBOutlet weak var collectionView           : UICollectionView!
    @IBOutlet weak var inputContainView         : UIView!
    @IBOutlet weak var tableView                : UITableView!
    @IBOutlet weak var inputTextField           : UITextField!
    @IBOutlet weak var noChatHistory            : UIView!
    @IBOutlet weak var noHostAvailable          : UIView!
    @IBOutlet weak var chatSectionHeight        : NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            self.lblTitle.text = agendaName
        }
    }

    //Button
    @IBOutlet weak var btnLeaveChannel          : UIButton!
    @IBOutlet weak var btnMuteAndUnmute         : UIButton!
    @IBOutlet weak var btnChatShowAndHide       : UIButton!
    @IBOutlet weak var btnScrollToBottom        : UIButton!

    var arrayOfHost                             : [OnlineHostModel] = []
    var userType                                : AgoraClientRole!
    var channelId                               : String = ""
    var userId                                  : String = ""
    var agendaName                              : String = ""
    private var agoraKit                        : AgoraRtcEngineKit = AgoraRtcEngineKit()
    
    lazy var list                               : [Message] = []
    var type                                    : ChatType = .group("")
    var rtmChannel                              : AgoraRtmChannel?
    var eventObject                             : Event?
    private let maxVideoSession                 = 8
    private var canChatScroll                   : Bool = true

    private var isMutedAudio = false {
        didSet {
            agoraKit.muteAllRemoteAudioStreams(isMutedAudio)
            if isMutedAudio{
                btnMuteAndUnmute.setImage(UIImage(named: "ic_Unmute"), for: .normal)
            }else{
                btnMuteAndUnmute.setImage(UIImage(named: "ic_Mute"), for: .normal)
            }
        }
    }

    private var isMutedChat = false {
        didSet {
            // mute local video
            btnChatShowAndHide.isSelected = isMutedChat
            
            if isMutedChat{
                self.chatSectionHeight.constant = 0
                tableView.isHidden = true
                inputContainView.isHidden = true
                btnChatShowAndHide.setImage(UIImage(named: "ic_Chat_Hide"), for: .normal)
            }else{
                self.chatSectionHeight.constant = (self.view.frame.height - 100) * 0.45
                tableView.isHidden = false
                inputContainView.isHidden = false
                btnChatShowAndHide.setImage(UIImage(named: "ic_Chat_Show"), for: .normal)
                
            }
            self.collectionView.reloadData()
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Title \(agendaName)")
        print("ChannelId \(channelId)")
        print("UserId \(userId)")
        
        self.initializeAgoraEngine()

        self.tableView.register(UINib(nibName: "LiveChatTCell", bundle: nil), forCellReuseIdentifier: "LiveChatTCell")
        self.collectionView.register(UINib(nibName: "LiveStreamCCell", bundle: nil), forCellWithReuseIdentifier: "LiveStreamCCell")
        
        self.chatSectionHeight.constant = (self.view.frame.height - 100) * 0.45
        
        if self.list.count > 0{
            noChatHistory.isHidden = true
        }else{
            noChatHistory.isHidden = false
        }
        
        if self.arrayOfHost.count > 0{
            noHostAvailable.isHidden = true
        }else{
            noHostAvailable.isHidden = false
        }
        
        self.setIdleTimerActive(true)
//        self.remoteUserIDs = [1,2,3,4,5,6,7,8,9]
//        self.collectionView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.leaveChannel()
        self.leaveChatChannel()
        self.setIdleTimerActive(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.type = .group(self.channelId)
        updateViews()
        ifLoadOfflineMessages()
        AgoraRtm.updateKit(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        switch type {
        case .peer(let name):     self.title = name
        case .group(let channel): self.title = channel; createChannel(channel)
        }
    }

    func setIdleTimerActive(_ active: Bool) {
        UIApplication.shared.isIdleTimerDisabled = !active
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//    func scrollToTheBottom(isScroll: Bool, animated: Bool, position: UITableView.ScrollPosition)
//    {
//        if isScroll{
//            let end = IndexPath(row: self.list.count - 1, section: 0)
//                self.tableView.reloadData()
//                        self.tableView.scrollToRow(at: end, at: .bottom, animated: true)
//        }
//        let visibleRow = self.tableView.numberOfRows(inSection: 0)
//        print("VISIBLE: \(visibleRow)")
//        var numberOfRows = 1
//        if self.list.count > 0{
//            numberOfRows =  list.count
//            print("TOTAL COUNT: \(numberOfRows)")
//            if numberOfRows > 0 && visibleRow > numberOfRows - 1{
//                let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
//                self.tableView.scrollToRow(at: indexPath as IndexPath, at: position, animated: false)
//
//                self.view.layoutIfNeeded()
//                self.view.layoutSubviews()
//                self.view.setNeedsUpdateConstraints()
//            }
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnScrollToBottomTapped(_ sender: Any) {
        if self.list.count > 0{
            let lastRow = self.list.count - 1
            tableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: true)
        }
    }
    
    @IBAction func btnChatClose(_ sender: Any) {
        isMutedChat.toggle()
        self.view.endEditing(true)
    }
    
    @IBAction func btnSendTapped(_ sender: Any) {
        if self.inputTextField.text!.isEmpty == false{
            send(message: self.inputTextField.text!, type: type)
            self.inputTextField.text = ""
        }
    }

    @IBAction func btnMuteAndUnmuteTapped(_ sender: Any) {
        isMutedAudio.toggle()
    }
    
    @IBAction func btnLeaveTapped(_ sender: Any) {
        self.leaveChannel()
        self.leaveChatChannel()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChatShowAndHideTapped(_ sender: Any) {
        isMutedChat.toggle()
        self.view.endEditing(true)
    }
}


// MARK: - AgoraRtcEngineDelegate
extension LiveSteamViewController: AgoraRtcEngineDelegate {
    func leaveChannel() {
            agoraKit.setupLocalVideo(nil)
            // Leave the channel.
            agoraKit.leaveChannel(nil)
            if userType == .broadcaster {
                agoraKit.stopPreview()
            }
        }
        
        func initializeAgoraEngine() {
            // Initialize the AgoraRtcEngineKit object.
            agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AgoraDetails.id, delegate: self)
            
            // Set the channel profile.
            agoraKit.setChannelProfile(.liveBroadcasting)
            
            // Set the client role.
            agoraKit.setClientRole(self.userType)
            
            // Step 3, Warning: only enable dual stream mode if there will be more than one broadcaster in the channel
            agoraKit.enableDualStreamMode(true)
            
            // Step 4, enable the video module
            agoraKit.enableVideo()
            
            // set video configuration
            agoraKit.setVideoEncoderConfiguration(
                AgoraVideoEncoderConfiguration(
                    size: AgoraVideoDimension640x360,
                    frameRate: .fps15,
                    bitrate: AgoraVideoBitrateStandard,
                    orientationMode: .adaptative
                )
            )

            
            // Step 5, join channel and start group chat
            // If join  channel success, agoraKit triggers it's delegate function
            // 'rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int)'
            
            agoraKit.joinChannel(byUserAccount: self.userId, token: "", channelId: channelId) { [weak self] (sid, uid, elaspsed) in
                if let weakSelf = self{
                    print(uid)
                    print(sid)
                    print(elaspsed)
                }
            }
        
            
            // Step 6, set speaker audio route
            agoraKit.setEnableSpeakerphone(true)
            
        }

    /// Occurs when the first local video frame is displayed/rendered on the local video view.
    ///
    /// Same as [firstLocalVideoFrameBlock]([AgoraRtcEngineKit firstLocalVideoFrameBlock:]).
    /// @param engine  AgoraRtcEngineKit object.
    /// @param size    Size of the first local video frame (width and height).
    /// @param elapsed Time elapsed (ms) from the local user calling the [joinChannelByToken]([AgoraRtcEngineKit joinChannelByToken:channelId:info:uid:joinSuccess:]) method until the SDK calls this callback.
    ///
    /// If the [startPreview]([AgoraRtcEngineKit startPreview]) method is called before the [joinChannelByToken]([AgoraRtcEngineKit joinChannelByToken:channelId:info:uid:joinSuccess:]) method, then `elapsed` is the time elapsed from calling the [startPreview]([AgoraRtcEngineKit startPreview]) method until the SDK triggers this callback.
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        
    }
    
    /// Reports the statistics of the current call. The SDK triggers this callback once every two seconds after the user joins the channel.
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
//        if let selfSession = videoSessions.first {
//            selfSession.updateChannelStats(stats)
//        }
    }
    
    
    /// Occurs when the first remote video frame is received and decoded.
    /// - Parameters:
    ///   - engine: AgoraRtcEngineKit object.
    ///   - uid: User ID of the remote user sending the video stream.
    ///   - size: Size of the video frame (width and height).
    ///   - elapsed: Time elapsed (ms) from the local user calling the joinChannelByToken method until the SDK triggers this callback.
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        if let userInfo = agoraKit.getUserInfo(byUid: uid, withError: nil){
            print(userInfo.userAccount!)
        }
        
        print(uid)

        if let user = self.agoraKit.getUserInfo(byUid: uid, withError: nil){
            let arrayOfId = (user.userAccount ?? "").split(separator: ".")
            let userId = "\(arrayOfId[0])"
            var displayName: String = ""
            
            if let arrayOfSpeaker = self.eventObject?.speakerList{
                let item = arrayOfSpeaker.filter { (obj) -> Bool in
                    if obj.id == userId{
                        return true
                    }else{
                        return false
                    }
                }
                if let firstName = item[0].firstName, firstName.count > 0{
                    displayName.append(firstName.first!)
                }
                if let lastName = item[0].lastName, lastName.count > 0{
                    displayName.append(lastName.first!)
                }
                
                self.arrayOfHost.append(OnlineHostModel(userId: userId, uId: uid, userName: item[0].fullName ?? "", displayName: displayName, userimageURL: item[0].profilePic ?? "", isVideoMuted: false, isAudioMuted: false))
                self.collectionView.reloadData()
            }
        }
        
        
//        self.remoteUserIDs.append(uid)
//        self.collectionView.reloadData()
        
    }
    
    /// Occurs when a remote user (Communication)/host (Live Broadcast) leaves a channel. Same as [userOfflineBlock]([AgoraRtcEngineKit userOfflineBlock:]).
    ///
    /// There are two reasons for users to be offline:
    ///
    /// - Leave a channel: When the user/host leaves a channel, the user/host sends a goodbye message. When the message is received, the SDK assumes that the user/host leaves a channel.
    /// - Drop offline: When no data packet of the user or host is received for a certain period of time (20 seconds for the Communication profile, and more for the Live-broadcast profile), the SDK assumes that the user/host drops offline. Unreliable network connections may lead to false detections, so Agora recommends using a signaling system for more reliable offline detection.
    ///
    ///  @param engine AgoraRtcEngineKit object.
    ///  @param uid    ID of the user or host who leaves a channel or goes offline.
    ///  @param reason Reason why the user goes offline, see AgoraUserOfflineReason.
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        if let index = arrayOfHost.firstIndex(where: { $0.uId == uid }) {
            arrayOfHost.remove(at: index)
            collectionView.reloadData()
        }
    }
    
    /// Reports the statistics of the video stream from each remote user/host.
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStats stats: AgoraRtcRemoteVideoStats) {
//        if let session = getSession(of: stats.uid) {
//            session.updateVideoStats(stats)
//        }
    }
    
    /// Reports the statistics of the audio stream from each remote user/host.
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteAudioStats stats: AgoraRtcRemoteAudioStats) {
//        if let session = getSession(of: stats.uid) {
//            session.updateAudioStats(stats)
//        }
    }
    
    /// Reports a warning during SDK runtime.
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        print("warning code: \(warningCode.rawValue)")
    }
    
    /// Reports an error during SDK runtime.
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("warning code: \(errorCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        if let index = arrayOfHost.firstIndex(where: { $0.uId == uid }) {
            var hostModel = arrayOfHost[index]
            hostModel.isAudioMuted = muted
            arrayOfHost[index] = hostModel
            collectionView.reloadData()
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted: Bool, byUid uid: UInt) {
        if let index = arrayOfHost.firstIndex(where: { $0.uId == uid }) {
            var hostModel = arrayOfHost[index]
            hostModel.isVideoMuted = muted
            arrayOfHost[index] = hostModel
            collectionView.reloadData()
        }
    }
}



// MARK: Send Message
private extension LiveSteamViewController {
    func send(message: String, type: ChatType) {
        let sent = { [unowned self] (state: Int) in
            guard let current = AgoraRtm.current else {
                return
            }
            self.appendMessage(user: current, content: message)
        }
        
        let rtmMessage = AgoraRtmMessage(text: message)
        
        switch type {
        case .peer(let name):
            let option = AgoraRtmSendMessageOptions()
    
            option.enableOfflineMessaging = (AgoraRtm.oneToOneMessageType == .offline ? true : false)
                        
            AgoraRtm.kit?.send(rtmMessage, toPeer: name, sendMessageOptions: option, completion: { (error) in
                sent(error.rawValue)
            })
        case .group(_):
            rtmChannel?.send(rtmMessage) { (error) in
                sent(error.rawValue)
            }
        }
    }
}

// MARK: Channel
private extension LiveSteamViewController {
    func createChannel(_ channel: String) {
        let errorHandle = { [weak self] (action: UIAlertAction) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.navigationController?.popViewController(animated: true)
        }
        
        guard let rtmChannel = AgoraRtm.kit?.createChannel(withId: channel, delegate: self) else {
//            showAlert("join channel fail", handler: errorHandle)
            return
        }
        
        rtmChannel.join { [weak self] (error) in
            if error != .channelErrorOk, let strongSelf = self {
//                strongSelf.showAlert("join channel error: \(error.rawValue)", handler: errorHandle)
            }
        }
        
        self.rtmChannel = rtmChannel
    }
    
    func leaveChatChannel() {
        rtmChannel?.leave { (error) in
            print("leave channel error: \(error.rawValue)")
        }
    }
}

// MARK: AgoraRtmDelegate
extension LiveSteamViewController: AgoraRtmDelegate {
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
//        showAlert("connection state changed: \(state.rawValue)") { [weak self] (_) in
//            if reason == .remoteLogin, let strongSelf = self {
//                strongSelf.navigationController?.popToRootViewController(animated: true)
//            }
//        }
    }
    
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        appendMessage(user: peerId, content: message.text)
    }
}

// MARK: AgoraRtmChannelDelegate
extension LiveSteamViewController: AgoraRtmChannelDelegate {
    func channel(_ channel: AgoraRtmChannel, memberCount count: Int32) {
        self.lblActiveAttendeeCount.text = "\(count)"
    }
    
    func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
//        DispatchQueue.main.async { [unowned self] in
//            self.showAlert("\(member.userId) join")
//        }
    }
    
    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
//        DispatchQueue.main.async { [unowned self] in
//            self.showAlert("\(member.userId) left")
//        }
    }
    
    func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
        appendMessage(user: member.userId, content: message.text)
    }
}

private extension LiveSteamViewController {
    func updateViews() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 55
    }
    
    func ifLoadOfflineMessages() {
        switch type {
        case .peer(let name):
            guard let messages = AgoraRtm.getOfflineMessages(from: name) else {
                return
            }
            
            for item in messages {
                appendMessage(user: name, content: item.text)
            }
            
            AgoraRtm.removeOfflineMessages(from: name)
        default:
            break
        }
        
        self.tableView.reloadData()
    }
    
    func pressedReturnToSendText(_ text: String?) -> Bool {
        guard let text = text, text.count > 0 else {
            return false
        }
        send(message: text, type: type)
        return true
    }
    
    func appendMessage(user: String, content: String) {
        DispatchQueue.main.async { [unowned self] in
            let msg = Message(userId: user, text: content, type: .attendee, userName: "", userImageUrl: "")
            self.list.append(msg)
            if self.canChatScroll{
                let end = IndexPath(row: self.list.count - 1, section: 0)
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: end, at: .bottom, animated: true)
            }else{
                self.tableView.reloadData()
            }
        }
    }
}

extension LiveSteamViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if list.count > 0{
            noChatHistory.isHidden = true
        }else{
            noChatHistory.isHidden = false
        }
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var msg = list[indexPath.row]
        let arrayOfId = msg.userId.split(separator: ".")
        let msgUserId = "\(arrayOfId[0])"
        let userType = "\(arrayOfId[1])"
        if userType.lowercased() == "host"{
            if let arrayOfSpeaker = self.eventObject?.speakerList{
                let item = arrayOfSpeaker.filter { (obj) -> Bool in
                    if obj.id == msgUserId{
                        return true
                    }else{
                        return false
                    }
                }
                msg.type = .host
                msg.userName = item[0].fullName ?? ""
                msg.userId = msgUserId
                msg.userImageUrl = item[0].profilePic ?? ""
            }
        }else{
            if let arrayOfAttendees = self.eventObject?.attendeeList?.attendees{
                let item = arrayOfAttendees.filter { (obj) -> Bool in
                    if obj.id == msgUserId{
                        return true
                    }else{
                        return false
                    }
                }
                msg.type = .attendee
                msg.userName = item[0].fullName ?? ""
                msg.userId = msgUserId
                msg.userImageUrl = item[0].profilePic ?? ""
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveChatTCell", for: indexPath) as! LiveChatTCell
        cell.update(message: msg)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let lastCellRowIndex = self.tableView.indexPathsForVisibleRows?.last?.row {
            print("LastCellRow \(lastCellRowIndex + 1)")
            print("List Count \(self.list.count - 1)")
            if self.list.count - 1 > lastCellRowIndex + 1 {
                self.canChatScroll = false
                self.btnScrollToBottom.isHidden = false
            } else {
                self.canChatScroll = true
                self.btnScrollToBottom.isHidden = true
            }
        }
    }

}

extension LiveSteamViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if pressedReturnToSendText(textField.text) {
            textField.text = nil
        } else {
        }
        view.endEditing(true)
        return true
    }
}

extension LiveSteamViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arrayOfHost.count > 0{
            noHostAvailable.isHidden = true
        }else{
            noHostAvailable.isHidden = false
        }
        return arrayOfHost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveStreamCCell", for: indexPath)
        let hostModel = arrayOfHost[indexPath.row]
        if let videoCell = cell as? LiveStreamCCell {
            let videoCanvas = AgoraRtcVideoCanvas()
            videoCanvas.uid = hostModel.uId
            videoCanvas.view = videoCell.videoView
            videoCanvas.renderMode = .fit
            agoraKit.setupRemoteVideo(videoCanvas)
            
            videoCell.update(model: hostModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.arrayOfHost.count > 0{
            
            let screenHeight = Int(self.collectionView.frame.height)
            let screenWidth = Int(UIScreen.main.bounds.width)

            if self.arrayOfHost.count == 1{
                return CGSize(width: screenWidth, height: screenHeight)
            }else if self.arrayOfHost.count == 2{
                return CGSize(width: screenWidth, height: screenHeight/2)
            }else{

                var numberOfSection: Int = 0
                var widht: Int = 0
                var height: Int = 0

                if self.arrayOfHost.count % 2 == 0{
                    numberOfSection = self.arrayOfHost.count/2
                    widht = screenWidth/2
                    height = screenHeight/numberOfSection
                }else{
                    numberOfSection = self.arrayOfHost.count/2 + 1
                    if indexPath.item == self.arrayOfHost.count - 1{
                        widht = screenWidth
                        height = screenHeight/numberOfSection
                    }else{
                        widht = screenWidth/2
                        height = screenHeight/numberOfSection
                    }
                }

                print(height, widht)
                
                return CGSize(width: widht, height: height)
            }
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
}
