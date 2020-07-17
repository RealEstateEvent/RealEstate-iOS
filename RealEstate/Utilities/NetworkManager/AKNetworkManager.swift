//
//  AKNetworkManager.swift
//
//

import Foundation
import Alamofire
import JGProgressHUD
import MobileCoreServices


typealias data = Any?
typealias networkCompletion = (data)->Void

final class AKNetworkManager {
    private var progressHUd : JGProgressHUD!
    
    static let sharedManager = AKNetworkManager.init()
//    private var token : String {
//        guard let token = UserDefaults.standard.value(forKey: "token") as? String else {
//            return ""
//        }
//        return token
//    }
    
    private func getHeader(isForMultipart : Bool = false)->[String:String] {
        guard let authToken = kSharedAuthToken else {return [:]}
        if isForMultipart {
            let headers    = [
                "x-auth":authToken]
            return headers
        } else {
            let headers    = [
                "x-auth":authToken,
                "Content-Type":"application/json"]
            return headers
        }
        
    }
    private init(){}
    
    private func convertToData(_ value:Any) -> Data {
        if let str =  value as? String {
            return String.getString(str).data(using: String.Encoding.utf8)!
            
        } else if let number = value as? NSNumber {
            let strValue = number.stringValue
            return self.convertToData(strValue)
            
        } else if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
            return jsonData
        }  else {
            return Data()
        }
    }
    
    private func getCurrentTimeStamp()->TimeInterval {
        return NSDate().timeIntervalSince1970.rounded();
    }
    
    private func getServiceUrl(serviceName: String)->String {
        let completeURL  = "\(kBaseURL)\(serviceName)"
        return completeURL
    }
    
    
    private func showLoader(){
        self.progressHUd = JGProgressHUD.init(style: .light)
        self.progressHUd.show(in: kSharedAppDelegate?.topMostController?.view ?? UIView())
    }
    
    private func hideLoader() {
        self.progressHUd.dismiss()
    }
    
    func getMessage(from obj: Any?) -> String? {
        let dict = JSONHelper.getDictionary(from: obj)
        guard let msg = dict["ResponseMessage"] as? String else {
            guard let msg = dict["Message"] as? String else {
                guard let msg = dict["message"] as? String else {
                    guard let msg = dict["msg"] as? String else {
                        guard let msg = dict["error"] as? String else {
                            return nil
                        }
                        return msg
                    }
                    return msg
                }
                return msg
            }
            return msg
        }
        return msg
    }
    
    
    
    func request(webService: WebService, param : [String:Any] ,method: HTTPMethod, wantProgress : Bool = true, urlAppendString:String = "", completion : @escaping (Any?)->Void) {
        
        let headers = self.getHeader()
        let completeUrl = self.getServiceUrl(serviceName: webService.rawValue) + urlAppendString
        
        DispatchQueue.main.async {
            if wantProgress {
                self.showLoader()
            }
        }
        
        var encoding : ParameterEncoding     = URLEncoding.default
        switch method {
        case .get,.delete:
            encoding    = URLEncoding.default
        case .post:
            encoding    = JSONEncoding.prettyPrinted
        case .put, .patch:
            encoding    = JSONEncoding.default
        default:
            break;
        }
        
        print("Accessing -> \(completeUrl) param -> \(param) with headers->\(headers)")
        Alamofire.request(completeUrl, method: method, parameters: param, encoding: encoding, headers: headers).responseJSON { (response) in
            self.hideLoader()
            
            let dict = AKHelper.getDictionary(from: response.response?.allHeaderFields)
            
            print("ACCESS TOKEN:\(dict)")
            if let accessToken = dict?["X-Auth"] as? String {
                AppUserDefault.setAuth(token: accessToken)
            }

            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                print("Response :\(data)")

                
                switch statusCode {
                case 200,201:
                    completion(data)
                case 401:
                    print("Call Logout")
                    if kSharedAuthToken != nil {
                        SharedClass.shared.logout()
                    }
                    let msg = self.getMessage(from: data)
                    UIAlertController.showNotificationWith(msg ?? ErrorMessage.kUndefinedError)
                default:
                    let msg = self.getMessage(from: data)
                    UIAlertController.showNotificationWith(msg ?? ErrorMessage.kUndefinedError)
                }
            case .failure(let error):
                
                UIAlertController.showNotificationWith(error.localizedDescription)
            }
        }
    }
    
    
    
    func requestMultiPart(webService: WebService, method: HTTPMethod, attachments:[Attachment], parameters: Dictionary<String, Any>,withProgressHUD showProgress: Bool = true, completion:@escaping((Any?)->())) -> Void {
        
        guard let isNetworkReachable    = NetworkReachabilityManager.init()?.isReachable else {
            return
        }
        if isNetworkReachable {
            if showProgress {
                self.showLoader()
            }
            
//            let headers =         [ "Authorization" : "Bearer " + token]
            let headers = self.getHeader(isForMultipart: true)

            let serviceURL : String = self.getServiceUrl(serviceName: webService.rawValue)
            
            print("Connecting to Host with URL \(serviceURL) with parameters: \(parameters)")
            
            Alamofire.upload(multipartFormData:{ (multipartFormData: MultipartFormData) in
                for (key,value) in parameters {
                    let converted = self.convertToData(value)
                    multipartFormData.append(converted,withName: key)
                }
                
                for obj in attachments {
                    multipartFormData.append(obj.file ?? Data(), withName: obj.fileParam ?? "", fileName:obj.fileName ?? "", mimeType: obj.mime ?? "")
                }
            }, to                   : serviceURL,
               method               : method,
               headers              : headers,
               encodingCompletion   : { (encodingResult: SessionManager.MultipartFormDataEncodingResult) in
                
                switch encodingResult {
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    upload.responseJSON(completionHandler: { (finalResponse) in
                        self.hideLoader()
                        let statusCode = finalResponse.response?.statusCode ?? 0
                        print("Status code :-",statusCode)
                        let result = finalResponse.result.value
                        print("result:\(result ?? "")")
                        
                        switch statusCode {
                        case 200,201,202,203:
                            completion(result)
                          
                        case 400:
                            print("Show Alert for bad request")
                            let msg = self.getMessage(from: result)
                            UIAlertController.showNotificationWith(msg ?? ErrorMessage.kUndefinedError)
                        case 401:
                            print("Call Logout")
                            if kSharedAuthToken != nil {
                                SharedClass.shared.logout()
                            }
                            let msg = self.getMessage(from: result)
                            UIAlertController.showNotificationWith(msg ?? ErrorMessage.kUndefinedError)
                        case 404:
                            UIAlertController.showNotificationWith(ErrorMessage.kNoDataFound)
                        default:
                            let msg = self.getMessage(from: result)
                            UIAlertController.showNotificationWith(msg ?? ErrorMessage.kUndefinedError)
                        }
                    })
                case .failure(let error):
                    self.hideLoader()
                    UIAlertController.showNotificationWith(error.localizedDescription)
                }
            })
        } else {
            UIAlertController.showNotificationWith(ErrorMessage.kInternetError)
        }
    }
    
}
