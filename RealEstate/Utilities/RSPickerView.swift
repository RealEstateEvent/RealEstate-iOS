//
//  RSPickerView.swift
//  Evango
//
//  Created by Office on 22/06/16.
//  Copyright © 2016 Collabroo. All rights reserved.
//

import UIKit

let kGetScreenWidth                 = UIScreen.main.bounds.size.width
let kGetScreenHeight                = UIScreen.main.bounds.size.height
let pickerTopMargin: CGFloat        = 0

class RSPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource
{
    
  // MARK:- ----------Closures----------
  private var callBack = {(index: Int, response: Any?) -> () in
  }
  
  // MARK:- ----------Public Methods----------
  var arrData       : [Any]             = []
  var strKey        : String?
  var pickerView    : UIPickerView!
  var viewContainer : UIView!
  
  // MARK:- ----------Initializer Methods----------
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  convenience init(_ target: UIView, arrayList list: [Any], keyValue key: String?, handler completionBlock: @escaping (_ index: Int, _ response: Any?) -> ())
  {
    
    kSharedAppDelegate?.window!.endEditing(true)
    let rect    = target.bounds
    self.init(frame: rect)
    
    
    //let screenHeight = kScreenHeight
    self.arrData = list
    self.strKey  = key
    
    let targetHeight = rect.size.height
    let pickerHeight = 201
    let pickerMinY   = targetHeight - CGFloat(pickerHeight) - pickerTopMargin
    self.viewContainer = UIView(frame: CGRect(x: 0, y: targetHeight, width: kGetScreenWidth, height: CGFloat(pickerHeight)))
    
    self.pickerView = UIPickerView(frame: CGRect(x: 2, y: 35, width: kGetScreenWidth, height: 162))
    self.pickerView.delegate = self
    self.pickerView.dataSource = self
    self.pickerView.backgroundColor = UIColor.clear
    self.pickerView.tintColor = .customTextFieldColor
   // pickerView.reloadAllComponents()
   
    self.viewContainer.addSubview(pickerView)
    self.viewContainer.backgroundColor = .lightGray
    
    let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: kGetScreenWidth, height: 35))
    viewHeader.backgroundColor = .darkGray
    
    
    let btnCancel = getButton(xValue: 1.0, buttonTitle: "Cancel")
    viewHeader.addSubview(btnCancel)
    
    let btnDone = getButton(xValue: kGetScreenWidth - 71.0, buttonTitle: "Done")
    viewHeader.addSubview(btnDone)
        
    self.viewContainer.addSubview(viewHeader)
    self.addSubview(viewContainer)
    
    target.addSubview(self)
    self.callBack = completionBlock
    
    UIView.animateKeyframes(withDuration    : 0.25,
                            delay           : 0.0,
                            options         : .beginFromCurrentState,
                            animations      :   {
                                                  var frame                 = self.viewContainer.frame
                                                  frame.origin.y            = pickerMinY
                                                  self.viewContainer.frame  = frame
                                                },
                            completion      : nil)
  }
  
  
    
  // MARK:- ----------Private Methods----------
  private func getButton(xValue: CGFloat, buttonTitle title: String) -> UIButton {
    let button      = UIButton(type: .custom)
    
    button.frame    = CGRect(x: xValue, y: 1, width: 70, height: 35)
    
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
    
    let selector    =  title == "Cancel" ? #selector(tapCancel(sender:)) : #selector(tapDone(sender:))
    button.addTarget(self, action: selector, for: .touchUpInside)
//    button.backgroundColor = .customGoldenColor
//    button.layer.cornerRadius = 17.5
    
    return button
  }
  
  // MARK:- ----------IBAction Methods----------
    @objc func tapCancel(sender: UIButton) {
        kSharedAppDelegate?.window!.endEditing(true)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState, animations: {
              var frame                 = self.viewContainer.frame
              frame.origin.y            = self.frame.size.height
              self.viewContainer.frame  = frame
        }) { (finished) in
          self.removeFromSuperview()
        }
  }
  
    @objc func tapDone(sender: UIButton) {
        kSharedAppDelegate?.window!.endEditing(true)
        UIView.animateKeyframes(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState,
                                animations  :   {
                                                  var frame = self.viewContainer.frame
                                                  frame.origin.y = self.frame.size.height
                                                  self.viewContainer.frame = frame
                                                })
            { (finished) in
              if finished {
                if self.arrData.count > 0 {
                    guard let key = self.strKey else {
                        self.callBack(self.pickerView.selectedRow(inComponent: 0),
                                      String(describing: self.arrData[self.pickerView.selectedRow(inComponent: 0)]).capitalized)
                        self.removeFromSuperview()
                        return
                    }
                    self.callBack(self.pickerView.selectedRow(inComponent: 0), String.getString(JSONHelper.getDictionary(from: self.arrData[self.pickerView.selectedRow(inComponent: 0)])[key]).capitalized)
                    
                } else {
                  self.callBack(-1, nil)
                }
                self.removeFromSuperview()
              }
            }
  }
  
  
  // MARK:- ----------Picker View Delegate Methods----------
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return arrData.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if strKey == nil {
        return String(describing: arrData[row])
    } else {
        let dictData = JSONHelper.getDictionary(from: arrData[row])
      return String.getString(dictData[strKey!])
    }
  }
    
}
