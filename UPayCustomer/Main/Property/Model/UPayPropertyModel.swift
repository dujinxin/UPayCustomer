//
//  ViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/24/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayWalletEntity: UPayBaseModel {
    var list = Array<UPayCoinPropertyEntity>()
}
class UPayCoinPropertyEntity: UPayBaseModel {
    
    @objc var coinType : Int = 0
    
    @objc var total : Float = 0
    @objc var balance : Float = 0
    
    @objc var buyPrice : Float = 0
    @objc var sellPrice : Float = 0
    
    @objc var totalCommision : Float = 0
    @objc var block : Float = 0
    @objc var address : String?
    @objc var ethAddress : String?
    @objc var memo : String?
    @objc var logo : String?
    @objc var symbol : String?
    
}
//coinType    int    币类型,1ptb,2usdt,3btc,5eos,6eusd,7poc
//total    decimal    总数量
//balance    decimal    可用数量
//buyPrice    string    买价
//sellPrice    string    卖价
//totalCommision    decimal    返佣，usdt独有
//block    decimal    冻结数量
//address    string    钱包地址
//ethAddress    string    usdt独有，erc20链钱包地址
//memo    string    eos独有，区别钱包的唯一memo
//logo    string    logo
//symbol    string    简称

class UPayPropertyRecordsEntity: UPayBaseModel {
    var list = Array<UPayPropertyCellEntity>()
}
class UPayPropertyCellEntity: UPayBaseModel {
    
    @objc var coinType : Int = 0
    @objc var recordType : Int = 0
    
    @objc var count : Float = 0
    @objc var bizId : String?
    @objc var createDate : String?
}

class UPayCoinListEntity: UPayBaseModel {
    var list = Array<UPayCoinCellEntity>()
}
class UPayCoinCellEntity: UPayBaseModel {
    
    @objc var otcStatus : Int = 0
    @objc var c2cStatus : Int = 0
    
    @objc var coinType : Int = 0
    
    @objc var outgoMin : Double = 0
    @objc var outgoMax : Double = 0
    @objc var outgoFeeRate : Float = 0
    @objc var outgoFeeMin : Float = 0
    
    @objc var buyBalanceMin : Float = 0
    @objc var sellBalanceMin : Float = 0
    
    @objc var coinName : String?
    @objc var detail : String?
    @objc var logo : String?
    @objc var symbol : String?
    
}
//otcStatus    int    场外交易状态，0不可交易，1可交易
//symbol    string    简称
//logo    string    logo
//c2cStatus    int    币币交易状态，0不可交易，1可交易
//coinName    string    币名称
//detail    string    详情
//outgoMin    decimal    提币最小值
//outgoMax    decimal    提币最大值
//outgoFeeRate    decimal    提币费率
//outgoFeeMin    decimal    提币最小费用
//buyBalanceMin    decimal    买单广告最低余额
//sellBalanceMin    decimal    卖单广告最低余额
//coinType    int    币类型，0表示未匹配上类型

class UPayExportCoinRecordsEntity: UPayBaseModel {
    var list = Array<UPayExportCoinCellEntity>()
}
class UPayExportCoinCellEntity: UPayBaseModel {
    
    @objc var coinType : Int = 0
    
    @objc var fee : Float = 0
    @objc var withdrawCounts : Float = 0
    @objc var realCounts : Float = 0
    
    @objc var transferNum : String?
    @objc var targetAddr : String?
    @objc var createDate : String?
    @objc var symbol : String?
    
    
    @objc var withdrawStatus : Int = 0//1待提币，2已提币，3已拒绝，4 提币中
    //@objc var chainType : Int = 0
    @objc var id : String?
    @objc var remarks : String?
    @objc var name : String?

}
//fee    decimal    手续费
//transferNum    string    订单号
//withdrawCounts    decimal    提币数量
//targetAddr    string    提币地址
//realCounts    decimal    到账数量
//createDate    string    创建时间
//coinType    int    币种
