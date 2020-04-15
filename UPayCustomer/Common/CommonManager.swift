//
//  ViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/24/19.
//  Copyright © 2019 COB. All rights reserved.
//

import Foundation

class ConfigurationEntity: UPayBaseModel {
    
    @objc var bigBuyPrice : Float = 0
    @objc var aliDailyMax : Float = 0
    @objc var platfromSellPrice : Float = 0
    @objc var sellRate : Float = 0
    @objc var buyLimitMax : Int = 0
    @objc var usdtSellPrice : Float = 0
    @objc var buyLimitMin : Int = 0
    @objc var usdtBuyPrice : Float = 0
    @objc var sellLimitMax : Float = 0
    @objc var platfromBuyPrice : Float = 0
    @objc var sellLimitMin : Float = 0
    @objc var buyRate : Float = 0
    
}
//bigBuyPrice    decimal    向平台买币价格
//aliDailyMax    decimal    支付宝单日最大收款额度
//platfromSellPrice    decimal    平台卖价
//sellRate    decimal    卖币手续费
//buyLimitMax    decimal    买币广告单笔最大额度
//usdtSellPrice    decimal    火币usdt卖价
//buyLimitMin    decimal    买币广告单笔最小额度
//usdtBuyPrice    decimal    火币usdt买价
//sellLimitMax    decimal    卖币广告单笔最大额度
//platfromBuyPrice    decimal    平台买价
//sellLimitMin    decimal    卖币广告单笔最小额度
//buyRate    decimal    买币手续费
class CommonVM : NSObject{
    
    var configurationEntity = ConfigurationEntity()
    
    
    func config(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        JXRequest.request(method: .get, url: ApiString.configuration.rawValue, param: [:], success: { (data, message) in
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil,message,false)
                    return
            }
            print(dict)
            self.configurationEntity.setValuesForKeys(dict)
            //let _ = UserManager.manager.saveAccound(dict: dict)
            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
}
