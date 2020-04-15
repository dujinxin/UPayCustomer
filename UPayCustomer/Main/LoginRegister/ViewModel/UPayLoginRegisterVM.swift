//
//  UPayLoginRegisterVM.swift
//  UPay
//
//  Created by 飞亦 on 6/1/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import AFNetworking

enum ModifyPsdType {
    case firstLoginPsd
    case normalLoginPsd
    case normalSafePsd
}

class UPayLoginRegisterVM: NSObject {

    //登录
    func login(userName: String, password: String, imgCode: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        let request = JXRequest.init(url: ApiString.login.rawValue, param: ["username": userName, "password": password,"method": "login","deviceId": UIDevice.current.uuid,"imgCode": imgCode], success: { (data, message) in
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil,message,false)
                    return
            }
            print(dict)
            

            let _ = UserManager.manager.saveAccound(dict: dict)
            completion(nil,message,true)
        }, failure: { (message, code) in
            completion(nil,message,false)
        }, progress: nil, download: nil, destination: nil)
        
        request.method = .get
        request.startRequest()
        
//        JXRequest.request(url: ApiString.login.rawValue, param: ["username": userName, "password": password,"lang":"zh"], success: { (data, message) in
//            guard
//                let dict = data as? Dictionary<String, Any>
//                else{
//                    completion(nil,message,false)
//                    return
//            }
//            print(dict)
//            let _ = UserManager.manager.saveAccound(dict: dict)
//            completion(nil,message,true)
//        }) { (message, code) in
//            completion(nil,message,false)
//        }
    }
    //注册
    func register(username: String, password: String, pay_password: String, invitation_code: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.register.rawValue, param: ["username": username, "password": password, "pay_password": pay_password ,"invitation_code":invitation_code,"lang":LanaguageManager.shared.languageStr], success: { (data, message) in
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil,message,false)
                    return
            }
          
            let _ = UserManager.manager.saveAccound(dict: dict)
            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    
    //重设密码(包含首次与其他)，重设安全密码
    func resetPsd(psdType: ModifyPsdType, oldPassword: String, newPassword: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        var psd : String = ""
        var param : Dictionary<String, Any> = [:]
        if psdType == .firstLoginPsd {
            psd = ApiString.firstResetLoginPsd.rawValue
            param = ["password": newPassword]
        } else if psdType == .normalLoginPsd {
            psd = ApiString.resetLoginPsd.rawValue
            param = ["oldPassword": oldPassword, "newPassword": newPassword]
        } else {
            psd = ApiString.resetTradePsd.rawValue
            param = ["oldSafePwd": oldPassword, "newSafePwd": newPassword]
        }
        JXRequest.request(url: psd, param: param, success: { (data, message) in

            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //设置安全密码
    func setSafePsd(safePwd: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        JXRequest.request(url: ApiString.firstResetTradePsd.rawValue, param: ["safePwd": safePwd], success: { (data, message) in
            
            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //身份认证
    func certId(id: String, realName: String, cardNum: String, positiveImg: String, backImg: String, completion: @escaping ((_ data: Any?, _ msg: String,_ isSuccess: Bool)->())){
        
        let vm = IdentifyVM()
        vm.uploadImage(files: [positiveImg,backImg]) { (dataArr1, message1, isSuc1) in
            
            if dataArr1.count != 2 {
                completion(dataArr1,"认证失败",false)
                return
            }
            
            if isSuc1 {
                JXRequest.request(url: ApiString.certId.rawValue, param: ["realName": realName, "cardNum": cardNum ,"positiveImg": dataArr1[0],"backImg": dataArr1[1]], success: { (_, message2) in
                    
                    
                    //let _ = UserManager.manager.saveAccound(dict: dict)
                    completion(nil,message2,true)
                }) { (message2, code) in
                    completion(nil,message2,false)
                }
            } else {
                completion(nil,message1,false)
            }
            
        }
       
//        if authStatus == 3 {
//            var d = UserManager.manager.userDict
//            d["authStatus"] = 3
//            let _ = UserManager.manager.saveAccound(dict: dict)
//        }
    }
    //退出
    func logout(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) {
        JXRequest.request(url: ApiString.logout.rawValue, param: ["lang":LanaguageManager.shared.languageStr], success: { (data, message) in
            completion(data,message,true)
            
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
}
class IdentifyVM: JXRequest {
    
    var files : [String] = []
    
    //图片上传
    func uploadImage(files: [String], completion: @escaping ((_ data: [String], _ msg: String,_ isSuccess: Bool)->())){
        self.files = files
        
        self.requestUrl = ApiString.uploadImage.rawValue
        self.method = .post
        self.param = [:]
        self.success = { (data, message) in
            guard
                let array = data as? Array<String>
                else{
                    completion([],message,false)
                    return
            }
            
            completion(array,message,true)
        }
        self.failure = { (message, code) in
            completion([],message,false)
        }
        self.startRequest()
        
    }
    
    override func customConstruct() -> ConstructingBlock? {
        return {(_ formData : AFMultipartFormData) -> () in
            let format = DateFormatter()
            format.dateFormat = "yyyyMMddHHmmss"
            let timeStr = format.string(from: Date.init())
            
            for obj in self.files {
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths[0] + "/\(obj)" + ".jpg"
                let pathUrl = URL.init(fileURLWithPath: path)
                guard let data = try? Data(contentsOf: pathUrl) else{
                    return
                }
                let stream = InputStream.init(data: data)
                formData.appendPart(with: stream, name: obj, fileName: "\(obj)\(timeStr).jpg", length: Int64(data.count), mimeType: "image/jpeg")
                print(data)
            }
            
        }
    }
}
