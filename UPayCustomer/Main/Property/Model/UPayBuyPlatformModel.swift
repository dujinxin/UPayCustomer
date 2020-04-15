//
//  ViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/26/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayBuyPlatformListEntity: UPayBaseModel {
    var count: Int = 0
    var list = Array<UPayBuyPlatformCellEntity>()
}
class UPayBuyPlatformCellEntity: UPayBaseModel {
    
    @objc var recordType : Int = 0
    @objc var recordStatus : Int = 0
    @objc var orderStatus : Int = 0
   
    @objc var totalAmount : Float = 0
    @objc var price : Float = 0
    @objc var coinCount : Float = 0
    
    @objc var id : String?
    @objc var orderNum : String?
    @objc var createDate : String?
    
}
class UPayBuyPlatformBuyingEntity: UPayBaseModel {
    
    @objc var recordType : Int = 0
    @objc var recordStatus : Int = 0
    @objc var orderStatus : Int = 0
    @objc var closeTime : Int = 0
    
    @objc var totalAmount : Float = 0
    @objc var price : Float = 0
    @objc var coinCount : Float = 0
    
    @objc var id : String?
    @objc var orderNum : String?
    @objc var createDate : String?
    @objc var mobile : String?
    @objc var bank : String?
    @objc var name : String?
    @objc var account : String?
    @objc var remarks : String?
}
class UPayBuyPlatformDetailEntity: UPayBuyPlatformCellEntity {
    
    @objc var closeTime : Int = 0
    
    @objc var mobile : String?
    @objc var bank : String?
    @objc var name : String?
    @objc var account : String?
    @objc var remarks : String?
    
    @objc var buyerBank : String?
    @objc var buyerName : String?
    @objc var buyerAccount : String?
    
    @objc var transferVoucher : String?
    
 
}
//recordType    int    订单类型，1平台买币订单，2托管出金订单
//mobile    string    手机号
//orderNum    string    订单号
//totalAmount    decimal    订单金额
//recordStatus    int    平台买币订单状态，1待支付，2已付款，3已完成，5已取消，7待回滚
//bank    string    收款方银行
//price    decimal    单价
//name    string    收款方姓名
//closeTime    int    关闭时间毫秒数，过期自动关闭
//id    string    id
//remarks    string    备注
//account    string    收款方账户
//coinCount    decimal    币数量
//createDate    string    创建时间
//orderStatus    int    托管出金订单状态，1待支付，2已付款，3待仲裁，4已完成，5已取消，6仲裁币商败诉，7待回滚，8已回滚 ，9预约回滚
//buyerName    string    支付方姓名
//buyerAccount    string    支付方账户
//buyerBank    string    支付方银行
