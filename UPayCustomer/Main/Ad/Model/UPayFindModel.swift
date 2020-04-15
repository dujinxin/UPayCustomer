//
//  UPayFindModel.swift
//  UPay
//
//  Created by 飞亦 on 6/13/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class UPayFindModel: UPayBaseModel {

    var list = Array<UPayBannerEntity>()
    var imageList = Array<String>()
}

class UPayBannerEntity: UPayBaseModel {
    @objc var status : Int = 0
    @objc var image : String?
    @objc var click : String?
}

class UPayAdListEntity: UPayBaseModel {
    
    var list = Array<UPayAdCellEntity>()
}

class UPayAdCellEntity: UPayBaseModel {
    @objc var lockCount : Float = 0
    @objc var limitMax : Float = 0
    @objc var payType : String = ""
    @objc var payTypeNum : Int = 0
    @objc var tradeCount : Float = 0
    @objc var createTime : String?
    @objc var restCount : Float = 0
    @objc var id : String?
    @objc var totalCount : Float = 0
    @objc var limitMin : Float = 0
    @objc var advertType : Int = 0
    @objc var status : Int = 0
}
//lockCount    decimal    锁定数量
//limitMax    decimal    单笔最小限额
//payType    string    支付方式，1支付宝，2微信，4银行卡，多选英文逗号分割
//tradeCount    decimal    交易数量
//createTime    string    创建时间
//restCount    decimal    剩余数量
//totalCount    decimal    总数量
//limitMin    decimal    单笔最小限额
//advertType    int    广告类型，1卖，2买
//status    int    上下架状态，1上架，2下架
