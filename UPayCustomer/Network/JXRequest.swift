
//
//  JXRequest.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/12.
//  Copyright © 2017年 杜进新. All rights reserved.
//
//  可参考本类实现自己的request，此类不开放，不接受外界使用
//
//

import UIKit

class JXRequest: JXBaseRequest {
    
    override func baseUrl() -> String? {
        return kBaseUrl
    }
    override func customConstruct() ->ConstructingBlock?  {
        return nil
    }
    
    override func requestSuccess(responseData: Any) {
        super.requestSuccess(responseData: responseData)
        
        let isJson = JSONSerialization.isValidJSONObject(responseData)
        print("isJson = ",isJson)
        if responseData is Dictionary<String,Any> {
            print("responseData is Dictionary")
            handleResponseResult(result: responseData)
        } else if responseData is Array<Any>{
            print("responseData is Array")
            handleResponseResult(result: responseData)
        } else if responseData is Data{
            print("responseData is Data")
            guard
                let data = responseData as? Data,
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                else{
                    handleResponseResult(result: nil, message: "数据解析失败", code: JXNetworkError.kResponseUnknow, isSuccess: false)
                    return
            }
            handleResponseResult(result: jsonData)
        } else if responseData is String{
            print("responseData is String")
            handleResponseResult(result: responseData)
        }

//        guard let data = responseData as? Data,
//            let str = String.init(data: data, encoding: .utf8)
//            else{
//                handleResponseResult(result: nil, message: "数据解析失败", code: JXNetworkError.kResponseUnknow, isSuccess: false)
//                return
//        }
        
    }
    override func requestFailure(error: Error) {
        print("请求失败:\(error)")
        handleResponseResult(result: error)
    }
    func handleResponseResult(result:Any?) {
        var msg : String?
        var netCode : JXNetworkError = .kResponseUnknow
        var data : Any? = nil
        var isSuccess : Bool = false
        
        print("requestParam = \(String(describing: param))")
        print("requestUrl = \(String(describing: requestUrl))")
        
        if result is Dictionary<String, Any> {
            
            let jsonDict = result as! Dictionary<String, Any>
            print("responseData = \(jsonDict)")
            
            let message = jsonDict["message"] as? String ?? ""
            msg = message
            
            guard
                let codeStr = jsonDict["code"] as? Int,
                //let codeNum = Int(codeStr),
                let code = JXNetworkError(rawValue: codeStr)
                else {
                    msg = "状态码未知"
                    handleResponseResult(result: nil, message: message, code: .kResponseDataError, isSuccess: isSuccess)
                    return
            }
            
            
            netCode = code
            
            if (code == .kResponseSuccess){
                data = jsonDict["result"]
                isSuccess = true
            } else if code == .kResponseShortTokenDisabled{
                JXNetworkManager.manager.cancelRequests(keepCurrent: nil)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationLoginStatus"), object: false)
                
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let login = storyboard.instantiateViewController(withIdentifier: "login") as! UPayLoginViewController
                let loginVC = UPayNavigationController.init(rootViewController: login)
                login.modalPresentationStyle = .fullScreen
                LanaguageManager.shared.reset(loginVC)
            } else if code == .kResponseLoginFromOtherDevice{
                JXNetworkManager.manager.cancelRequests(keepCurrent: self)
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginFromOtherDevice), object: false)
            } else {
            
            }
        }else if result is Array<Any>{
            print("Array")
        }else if result is String{
            print("String")
        }else if result is Error{
            print("Error")
            guard
                let error = result as? NSError,
                let code = JXNetworkError(rawValue: error.code)
                else {
                    handleResponseResult(result: data, message: "Error", code: .kResponseUnknow, isSuccess: isSuccess)
                    return
            }
            netCode = code
            
            switch code {
            case .kRequestErrorCannotConnectToHost,
                 .kRequestErrorCannotFindHost,
                 .kRequestErrorNotConnectedToInternet,
                 .kRequestErrorNetworkConnectionLost,
                 .kRequestErrorUnknown:
                msg = kRequestNotConnectedDomain;
                break;
            case .kRequestErrorTimedOut:
                msg = kRequestTimeOutDomain;
                break;
            case .kRequestErrorResourceUnavailable:
                msg = kRequestResourceUnavailableDomain;
                break;
            case .kResponseDataError:
                msg = kRequestResourceDataErrorDomain;
                break;
            default:
                msg = error.localizedDescription;
                break;
            }
            
        } else {
            print("未知数据类型")
        }
        handleResponseResult(result: data, message: msg ?? "", code: netCode, isSuccess: isSuccess)
    }
    func handleResponseResult(result: Any?, message: String, code: JXNetworkError, isSuccess: Bool) {
        
        if isSuccess {
            guard let success = self.success else {return}
            
//            if let u = self.requestUrl, (u == ApiString.login.rawValue || u == ApiString.register.rawValue) {
//                if
//                    let cookie = self.responseHeaders()["Set-Cookie"] as? String,
//                    let beegosessionID = cookie.components(separatedBy: "; ").first {
//                    print(beegosessionID)
//
//                    UserDefaults.standard.setValue(cookie, forKey: "Cookie")
//                    UserDefaults.standard.synchronize()
//                }
//            }
            if
                let cookie = self.responseHeaders()["Set-Cookie"] as? String,
                let beegosessionID = cookie.components(separatedBy: "; ").first {
                print(beegosessionID)
                
                UserDefaults.standard.setValue(cookie, forKey: "Cookie")
                UserDefaults.standard.synchronize()
            }
            
            success(result,message)
        } else {
            guard let failure = self.failure else {return}
            failure(message,code)
        }
    }

}
