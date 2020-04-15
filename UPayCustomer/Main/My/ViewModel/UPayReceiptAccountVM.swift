
//
//  ViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/25/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayReceiptAccountVM: NSObject {
    
    //收款账号列表
    var receiptListEntity = UPayReceiptListEntity()
    
    func receiptAccountList(searchTime: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(method: .get, url: ApiString.receiptAccountList.rawValue, param: ["searchTime": searchTime, "pageSize": 10], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion([], msg, true)
                    return
            }
            if searchTime.isEmpty == true {
                self.receiptListEntity.list.removeAll()
            }
            if let count = result["count"] as? Int {
                self.receiptListEntity.count = count
            }
           
            if let arr = result["list"] as? Array<Dictionary<String, Any>> {
                for i in 0..<arr.count {
                    let entity = UPayReceiptCellEntity()
                    entity.setValuesForKeys(arr[i])
                    self.receiptListEntity.list.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
    //添加 编辑 收款账号
    func addOrEditAccount(id: String = "", account: String, name: String, type: Int, bank: String, businessCardQrcode: String, safePassword: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        var param : Dictionary<String, Any> = ["account": account, "name": name, "type": type, "safePassword": safePassword]
        if id.isEmpty == true { //添加
            
        } else { //编辑
            param["id"] = id
        }
        if bank.isEmpty == false { //银行
            param["bank"] = bank
            JXRequest.request(url: ApiString.receiptAccountAddOrEdit.rawValue, param: param, success: { (data, msg) in
                
                completion(data, msg, true)
                
            }) { (msg, code) in
                completion(nil, msg, false)
            }
        } else { //网络支付
            
            let vm = IdentifyVM()
            vm.uploadImage(files: [businessCardQrcode]) { (dataArr1, message1, isSuc1) in
                
                if dataArr1.count != 1 {
                    completion(dataArr1,"图片上传失败",false)
                    return
                }
                param["businessCardQrcode"] = dataArr1[0]
                
                if isSuc1 {
                    JXRequest.request(url: ApiString.receiptAccountAddOrEdit.rawValue, param: param, success: { (data, msg) in
                        
                        completion(data, msg, true)
                        
                    }) { (msg, code) in
                        completion(nil, msg, false)
                    }
                } else {
                    completion(nil,message1,false)
                }
                
            }
        }
        
    }
    //上下架收款账号
    func useOrNotReceiptAccount(id: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(method: .get, url: ApiString.receiptAccountUseOrNot.rawValue, param: ["id": id], success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //删除收款账号
    func deleteReceiptAccount(id: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(method: .get, url: ApiString.receiptAccountDelete.rawValue, param: ["id": id], success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
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
}
