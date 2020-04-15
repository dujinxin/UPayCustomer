//
//  UPayIncomeModel.swift
//  UPay
//
//  Created by 飞亦 on 6/11/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class UPayIncomeModel: UPayBaseModel {
    @objc var today_profit_price : Double = 0
    @objc var profit_price : Double = 0
    @objc var today_conduct_price : Double = 0
    @objc var conduct_price : Double = 0
    @objc var today_share_price : Double = 0
    @objc var share_price : Double = 0
    @objc var today_team_price : Double = 0
    @objc var team_price : Double = 0
    @objc var today_level_price : Double = 0
    @objc var level_price : Double = 0
}
class UPayIncomeListEntity: UPayBaseModel {
    
    var list = Array<UPayIncomeCellEntity>()
}
class UPayIncomeCellEntity: UPayBaseModel {
    
    @objc var create_time : String?
    @objc var currency_name : String?
    
    @objc var type : Int = 0 //1:合约收益 2：分享收益 3：分享收益 4社区收益 5：平级收益
    @objc var currency_qty : Double = 0
    @objc var bonus_price : Double = 0
}
