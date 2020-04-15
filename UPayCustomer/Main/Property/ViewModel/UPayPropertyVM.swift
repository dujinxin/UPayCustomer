//
//  ViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/24/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayWalletVM: NSObject {
    
    //钱包
    var walletEntity = UPayWalletEntity()
    
    //币类型,1ptb,2usdt,3btc,5eos,6eusd,7poc
    func wallet(coinType: Int, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(method: .get, url: ApiString.wallet.rawValue, param: ["coinType": coinType], success: { (data, msg) in
            
            self.walletEntity.list.removeAll()
            if let result = data as? Array<Dictionary<String, Any>> {
                
                for i in 0..<result.count {
                    let entity = UPayCoinPropertyEntity()
                    entity.setValuesForKeys(result[i])
                    self.walletEntity.list.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //资产记录
    var propertyRecordsEntity = UPayPropertyRecordsEntity()
    
    //币类型,1ptb,2usdt,3btc,5eos,6eusd,7poc
    func propertyRecords(searchTime: String, coinType: Int, recordType: Int = -1, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        var param: [String : Any] = ["coinType": coinType, "searchTime": searchTime, "pageSize": 20]
        if recordType != -1 {
            param["recordType"] = recordType
        }
        JXRequest.request(method: .get, url: ApiString.propertyRecords.rawValue, param: param, success: { (data, msg) in
            
            if searchTime.isEmpty == true {
                self.propertyRecordsEntity.list.removeAll()
            }
            if let result = data as? Array<Dictionary<String, Any>> {
                
                for i in 0..<result.count {
                    let entity = UPayPropertyCellEntity()
                    entity.setValuesForKeys(result[i])
                    self.propertyRecordsEntity.list.append(entity)
                }
            }
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
    //币种列表
    
    var coinListEntity = UPayCoinListEntity()
    
    func coinList(searchTime: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(method: .get, url: ApiString.coinList.rawValue, param: ["searchTime": searchTime, "pageSize": 20], success: { (data, msg) in
            
            guard let result = data as? Array<Dictionary<String, Any>>
                else{
                    completion([], msg, true)
                    return
            }
            if searchTime.isEmpty == true {
                self.coinListEntity.list.removeAll()
            }
            
            for i in 0..<result.count {
                let entity = UPayCoinCellEntity()
                entity.setValuesForKeys(result[i])
                self.coinListEntity.list.append(entity)
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //申请提币
    //币类型,1ptb,2usdt,3btc,5eos,6eusd,7poc
    func export(coinType: Int, withdrawCounts: Float, targetAddr: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(method: .post, url: ApiString.coinExport.rawValue, param: ["coinType": coinType, "withdrawCounts": withdrawCounts, "targetAddr": targetAddr], success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //提币记录
    
    var exportCoinRecordsEntity = UPayExportCoinRecordsEntity()
    
    func exportCoinRecordsList(searchTime: String, coinType: Int, withdrawStatus: Int, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(method: .get, url: ApiString.coinExportList.rawValue, param: ["searchTime": searchTime, "coinType": coinType, "withdrawStatus": withdrawStatus, "pageSize": 20], success: { (data, msg) in
            
            guard let result = data as? Array<Dictionary<String, Any>>
                else{
                    completion([], msg, true)
                    return
            }
            if searchTime.isEmpty == true {
                self.exportCoinRecordsEntity.list.removeAll()
            }
            
            for i in 0..<result.count {
                let entity = UPayExportCoinCellEntity()
                entity.setValuesForKeys(result[i])
                self.exportCoinRecordsEntity.list.append(entity)
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
    var coinEntity = UPayCoinCellEntity()
    
    func coinEntity(coinType: Int, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(method: .get, url: ApiString.coinEntity.rawValue, param: ["coinType": coinType], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion([], msg, true)
                    return
            }
            
            self.coinEntity.setValuesForKeys(result)
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
