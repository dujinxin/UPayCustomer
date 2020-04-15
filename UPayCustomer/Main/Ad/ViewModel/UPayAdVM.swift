//
//  UPayFindVM.swift
//  UPay
//
//  Created by 飞亦 on 6/13/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class UPayAdVM: NSObject {
    var adListEntity = UPayAdListEntity()
    
    func adList(searchTime: String, status: Int = -1, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        var param: Dictionary<String, Any> = [:]
        param["searchTime"] = searchTime
        param["pageSize"] = 10
        if status != -1 {
            param["status"] = status
        }
        
        JXRequest.request(method: .get, url: ApiString.adList_otc.rawValue, param: param, success: { (data, msg) in
            
            guard let result = data as? Array<Dictionary<String, Any>>
                else{
                    completion([], msg, true)
                    return
            }
            if searchTime.isEmpty == true {
                self.adListEntity.list.removeAll()
            }
            for i in 0..<result.count {
                let entity = UPayAdCellEntity()
                entity.setValuesForKeys(result[i])
                if let payType = result[i]["payType"] as? String {
                    let arr = payType.components(separatedBy: ",")
                    var i: Int = 0
                    arr.forEach { (e) in
                        guard let num = Int(e) else {
                            return
                        }
                        i += num
                    }
                    entity.payTypeNum = i
                }
                self.adListEntity.list.append(entity)
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
        
    }
    ///发布 广告
    func adOtcPublish(advertType: Int, payType: Int, limitMin: Float, limitMax: Float, totalCount: Float, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        let param: [String : Any] = ["advertType": advertType, "payType": payType, "limitMin": limitMin, "limitMax": limitMax, "totalCount": totalCount]
        
        JXRequest.request(method: .post, url: ApiString.adPublish_otc.rawValue, param: param, success: { (data, msg) in

            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
        
    }
    
    //编辑
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
    //上下架广告 type: 1 上架，2 下架
    func adOtcUseOrNot(id: String, type: Int, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        let url = (type == 1) ? ApiString.adUse_otc.rawValue : ApiString.adNotUse_otc.rawValue
        JXRequest.request(method: .post, url: url, param: ["id": id], success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    ///删除广告
    func adOtcDelete(id: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(method: .post, url: ApiString.adDelete_otc.rawValue, param: ["id": id], success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    ///编辑广告
    func adOtcEdit(id: String, payType: Int, limitMin: Float, limitMax: Float, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        let param: [String : Any] = ["id": id, "payType": payType, "limitMin": limitMin, "limitMax": limitMax]
        
        JXRequest.request(method: .post, url: ApiString.adEdit_otc.rawValue, param: param, success: { (data, msg) in

            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
        
    }
    ///一键导入平台价广告
    func adOtcQuickSell(safePassword: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(method: .post, url: ApiString.adQuickSell_otc.rawValue, param: ["safePassword": safePassword], success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
