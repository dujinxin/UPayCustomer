//
//  UPayHomeModel.swift
//  UPay
//
//  Created by 飞亦 on 6/2/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class UPayHomeModel: UPayBaseModel {
    @objc var total_number : Double = 0
    @objc var today_vit_number : Double = 0
    
    var noticeList = Array<UPayNoticesCellEntity>()
    var contentList = Array<String>()
}
class UPayOrderListEntity: UPayBaseModel {
    
    var list = Array<UPayOrderCellEntity>()
}
class UPayOrderCellEntity: UPayBaseModel {
    
    @objc var isBuy : Bool = false
    @objc var payTime : String?
    @objc var extraCommision : Float = 0
    @objc var fee : Float = 0
    @objc var sellerName : String?
    @objc var orderNum : String?
    @objc var orderStatus : Int = 0
    @objc var cmCommision : Float = 0
    @objc var bank : String?
    @objc var payType : Int = 0
    @objc var payerName : String?
    @objc var id : String?
    @objc var tradeType : Int = 0
    @objc var coinPrice : Float = 0
    @objc var buyerName : String?
    @objc var sellerMobile : String?
    @objc var payerAccount : String?
    @objc var totalAmount : Double = 0
    @objc var createDate : String?
    @objc var coinCounts : Double = 0
    @objc var buyerMobile : String?
    @objc var name : String?
    @objc var account : String?
    @objc var remarks : String?
}
//isBuy    boolean    是否是买家
//extraCommision    decimal    额外返佣
//payTime    string    支付时间
//fee    decimal    手续费
//sellerName    string    卖家姓名
//orderNum    string    订单号
//orderStatus    int    订单状态，1待支付，2待确认，3待仲裁，4已完成，5已关闭，7待回滚，9预约回滚
//cmCommision    decimal    币商返佣
//bank    string    收款银行
//payType    int    支付方式，1支付宝，2微信，4银行卡
//payerName    string    支付姓名
//tradeType    int    交易类型，1商户买，2商户卖，3币商/币商，4商户自行出金
//coinPrice    decimal    币价格
//buyerName    string    买家姓名
//sellerMobile    string    卖家手机号
//payerAccount    string    支付方账户
//totalAmount    decimal    订单金额
//createDate    string    创建时间
//coinCounts    decimal    币数量
//buyerMobile    string    买家手机号
//name    string    收款姓名
//account    string    收款账号


class UPayOrderBuyListEntity: UPayBaseModel {
    
    var list = Array<UPayOrderBuyCellEntity>()
}
class UPayOrderBuyCellEntity: UPayBaseModel {
    
    @objc var id : String?
    @objc var status : Int = 0
    @objc var payType : Int = 0
    @objc var lockCount : Float = 0
    @objc var limitMax : Float = 0
    @objc var limitMin : Float = 0
    @objc var buyCount : Float = 0
    @objc var tradeCount : Float = 0
    @objc var tradePrice : Float = 0
    @objc var sellAmount : Float = 0
    @objc var sellerName : String?
    @objc var createTime : String?
    
    @objc var agentType : Int = 0
    @objc var restCount : Float = 0
    
}
//"lockCount": 200.000000,//锁定数量
//"limitMax": 1386,//单笔最大限额
//"payType": 4,//支付方式，1支付宝，2微信，4银行卡，多选英文逗号分割
//"tradeCount": 0.000000,//    交易数量
//"createTime": "2019-07-18 21:35",//创建时间
//"id": "14f8f0051b9148a2a61c93a0073cf9d9",
//"limitMin": 1386,//单笔最小限额
//"sellAmount":2000,//金额（用于agentType=2）
//"tradePrice":7.00,//交易价格（用于agentType=2）
//"buyCount":333,//买币数量（用于agentType=2）
//"sellerName":"伊丽莎白",//卖家昵称
//"status": 1,
//"agentType":2,//广告类型：2商户用户出金（一口价）4代理商人出金（可拆单）
//"restCount":333//剩余数量（用于agentType=4）


class UPayOrderBuyOrSellDetailEntity: UPayBaseModel {
  
    @objc var id : String?
    @objc var orderNum : String?
    @objc var orderStatus : Int = 0
    @objc var tradeType : Int = 0
    @objc var totalAmount : Float = 0
    @objc var createTime : String?
    @objc var buyCoinCount : Float = 0
    @objc var cmCommision : Float = 0
    @objc var extraCommision : Float = 0
    @objc var fee : Float = 0
    
    @objc var operationStream : String?
    @objc var wdNotPayCount : Int = 0
    @objc var wdPayLeftTime : Int = 0
    
    
    @objc var decimal : Float = 0
    @objc var times : Int = 0
    @objc var closeTimes : Int = 0
    @objc var submitArbitrationTimes : Int = 0
    @objc var merSellAutoCloseTimes : Int = 0
    
    @objc var buyPrice : Float = 0
    @objc var buyerName : String?
    @objc var buyerMobile : String?
    
    @objc var sellerName : String?
    @objc var sellerMobile : String?
    
    @objc var payType : Int = 0
    @objc var payerAccount : String?
    @objc var payerName : String?
    @objc var payTime : String?
    @objc var transferVoucher : String?
    
    
    @objc var name : String?
    @objc var account : String?
    @objc var bank : String?
    
    @objc var expireTime : Int64 = 0
    @objc var webName : String?
    @objc var isBuy : Bool = false
    @objc var rollBackStatus : Int = 0
    @objc var buySubsidyCount : Float = 0
    @objc var abnormalStatus : Int = 0
}

//decimal    补币数目
//operationStream    string    操作记录
//times    long    订单剩余过期时间，毫秒数
//closeTimes    long    待支付剩余时间毫秒数
//submitArbitrationTimes    long    提交仲裁剩余时间毫秒数
//wdNotPayCount    int    配置的取消支付数目
//wdPayLeftTime    int    配置的支付过期时间，单位：分钟
//merSellAutoCloseTimes    long    商户出金订单自动关闭时间毫秒数
//extraCommision    decimal    额外返佣
//payTime    string    支付时间
//fee    decimal    手续费
//sellerName    string    卖家姓名
//orderNum    string    订单号
//orderStatus    int    订单状态，1待支付，2待确认，3待仲裁，4已完成，5已关闭，7待回滚，9预约回滚
//cmCommision    decimal    币商返佣
//bank    string    收款银行
//payType    int    支付方式，1支付宝，2微信，4银行卡
//payerName    string    支付姓名
//tradeType    int    交易类型，1商户买，2商户卖，3币商/币商，4商户自行出金
//buyPrice    decimal    币价格
//buyerName    string    买家姓名
//sellerMobile    string    卖家手机号
//payerAccount    string    支付方账户
//totalAmount    decimal    订单金额
//createTime    string    创建时间
//buyCoinCount    decimal    币数量
//buyerMobile    string    买家手机号
//name    string    收款姓名
//account    string    收款账号

//undefinedKey:id
//undefinedKey:isBuy
//undefinedKey:rollBackStatus
//undefinedKey:expireTime
//undefinedKey:webName
//undefinedKey:buySubsidyCount
//undefinedKey:abnormalStatus
