//
//  UPayHomeVM.swift
//  UPay
//
//  Created by 飞亦 on 6/1/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class UPayHomeVM: NSObject {

    ///首页订单列表
    var orderListEntity = UPayOrderListEntity()
  
    func orderList(searchTime: String, tradeType: Int = 0, orderNum: String = "", orderStatus: Int = -1, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        var param: Dictionary<String, Any> = [:]
        param["searchTime"] = searchTime
        param["pageSize"] = 10
        if tradeType != 0 {
            param["tradeType"] = tradeType
        }
        if orderNum.isEmpty == false {
            param["orderNum"] = orderNum
        }
        if orderStatus != -1 {
            param["orderStatus"] = orderStatus
        }
        
        JXRequest.request(method: .get, url: ApiString.orderList_otc.rawValue, param: param, success: { (data, msg) in
            
            guard let result = data as? Array<Dictionary<String, Any>>
                else{
                    completion([], msg, true)
                    return
            }
            if searchTime.isEmpty == true {
                self.orderListEntity.list.removeAll()
            }
            for i in 0..<result.count {
                let entity = UPayOrderCellEntity()
                entity.setValuesForKeys(result[i])
                self.orderListEntity.list.append(entity)
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    ///首页，买单列表
    var orderBuyListEntity = UPayOrderBuyListEntity()
    
    func orderBuyList(searchTime: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        var param: Dictionary<String, Any> = [:]
        param["searchTime"] = searchTime
        param["pageSize"] = 10
        
        JXRequest.request(method: .get, url: ApiString.orderBuyList_otc.rawValue, param: param, success: { (data, msg) in
            
            guard let result = data as? Array<Dictionary<String, Any>>
                else{
                    completion([], msg, true)
                    return
            }
            if searchTime.isEmpty == true {
                self.orderBuyListEntity.list.removeAll()
            }
            for i in 0..<result.count {
                let entity = UPayOrderBuyCellEntity()
                entity.setValuesForKeys(result[i])
                self.orderBuyListEntity.list.append(entity)
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    ///首页，下单
    func orderBuyOrSell(id: String, code: Int = 1, amount: Float = 0, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        var param: Dictionary<String, Any> = [:]
        param["id"] = id
        param["code"] = code
        param["amount"] = amount
        
        JXRequest.request(method: .get, url: ApiString.orderBuyOrSell_otc.rawValue, param: param, success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    ///首页，订单详情
    var orderBuyOrSellDetailEntity = UPayOrderBuyOrSellDetailEntity()
    func orderBuyOrSellDetail(id: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        var param: Dictionary<String, Any> = [:]
        param["id"] = id
        
        JXRequest.request(method: .get, url: ApiString.orderBuyOrSellDetail_otc.rawValue, param: param, success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion(nil, msg, true)
                    return
            }
            self.orderBuyOrSellDetailEntity.setValuesForKeys(result)
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    ///首页，取消（买单）
    func orderCancelOrClose(id: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        var param: Dictionary<String, Any> = [:]
        param["id"] = id
        
        JXRequest.request(method: .get, url: ApiString.orderCancelOrClose_otc.rawValue, param: param, success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    ///首页，回滚（已关闭，已取消订单）
    func orderRollBack(id: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        var param: Dictionary<String, Any> = [:]
        param["id"] = id
        
        JXRequest.request(method: .post, url: ApiString.orderRollBack_otc.rawValue, param: param, success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    ///首页，确认支付（买单）
    func orderConfirm(id: String, transferVoucher: String, payerName: String, buyerBank: String =  "", payerAccount: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        let vm = IdentifyVM()
        vm.uploadImage(files: [transferVoucher]) { (dataArr1, message1, isSuc1) in
            
            if dataArr1.count != 1 {
                completion(dataArr1,"图片上传失败",false)
                return
            }
            
            if isSuc1 {
                JXRequest.request(method: .post, url: ApiString.orderConfirmPay_otc.rawValue, param: ["id": id, "transferVoucher": dataArr1[0], "payerName": payerName, "payerAccount": payerAccount], success: { (data, msg) in
                    
                    completion(data, msg, true)
                    
                }) { (msg, code) in
                    completion(nil, msg, false)
                }
            } else {
                completion(nil,message1,false)
            }
            
        }
     
    }
    ///首页，确认（已收款或未收款）
    func orderConfirmOrNot(id: String, code: Int = 1, remarks: String = "", completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        var param: Dictionary<String, Any> = [:]
        param["id"] = id
        param["code"] = code
        if remarks.isEmpty == false {
            param["remarks"] = remarks
        }
        JXRequest.request(method: .get, url: ApiString.orderConfirmOrNot_otc.rawValue, param: param, success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
