//
//  ViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/25/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayReceiptListEntity: UPayBaseModel {
    
    var count: Int = 0
    var list = Array<UPayReceiptCellEntity>()
}

class UPayReceiptCellEntity: UPayBaseModel {
    @objc var bank : String?
    @objc var createTime : String?
    @objc var name : String?
    @objc var account : String?
    @objc var businessCardQrcode : String?
    @objc var id : String?
    @objc var type : Int = 0
    @objc var useStatus : Int = 0
    @objc var todayTotalAmount : Float = 0
}
//bank    string    银行
//createTime    string    创建时间
//name    string    姓名
//todayTotalAmount    decimal    今日收款额
//id    string    id
//type    int    账号类型，1支付宝，2微信，4银行卡
//account    string    账户
//useStatus    int    上下架状态，1上架，2下架
