//
//  BuyPlatformVM.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/27/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayBuyPlatformVM: NSObject {
    
    //买币订单
    var buyPlatformListEntity = UPayBuyPlatformListEntity()
    
    func buyPlatformList(searchTime: String, orderStatus: Int, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(method: .get, url: ApiString.buyPlatformList.rawValue, param: ["searchTime": searchTime, "orderStatus": orderStatus, "pageSize": 10], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion([], msg, true)
                    return
            }
            if searchTime.isEmpty == true {
                self.buyPlatformListEntity.list.removeAll()
            }
            if let count = result["count"] as? Int {
                self.buyPlatformListEntity.count = count
            }
            
            if let arr = result["list"] as? Array<Dictionary<String, Any>> {
                for i in 0..<arr.count {
                    let entity = UPayBuyPlatformCellEntity()
                    entity.setValuesForKeys(arr[i])
                    self.buyPlatformListEntity.list.append(entity)
                    //entity.set
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //平台买币 下单
    var buyPlatformBuyingEntity = UPayBuyPlatformBuyingEntity()
    
    func buyingPlatform(totalAmount: Int, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(method: .post, url: ApiString.buyingPlatform.rawValue, param: ["totalAmount": totalAmount], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion([], msg, true)
                    return
            }
            self.buyPlatformBuyingEntity.setValuesForKeys(result)
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //平台买币 订单详情
    var buyPlatformDetailEntity = UPayBuyPlatformDetailEntity()
    
    func buyPlatformDetail(id: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(method: .get, url: ApiString.buyPlatformDetail.rawValue, param: ["id": id], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion(nil, msg, false)
                    return
            }
            self.buyPlatformDetailEntity.setValuesForKeys(result)
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //取消
    func buyPlatformCancel(id: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(method: .get, url: ApiString.buyPlatformCancel.rawValue, param: ["id": id], success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //确认支付
    func buyPlatformConfirm(id: String, transferVoucher: String, buyerName: String, buyerBank: String, buyerAccount: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        let vm = IdentifyVM()
        vm.uploadImage(files: [transferVoucher]) { (dataArr1, message1, isSuc1) in
            
            if dataArr1.count != 1 {
                completion(dataArr1,"图片上传失败",false)
                return
            }
            
            if isSuc1 {
                JXRequest.request(method: .post, url: ApiString.buyPlatformConfirm.rawValue, param: ["id": id, "transferVoucher": dataArr1[0], "buyerName": buyerName, "buyerAccount": buyerAccount, "buyerBank": buyerBank], success: { (data, msg) in
                    
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
