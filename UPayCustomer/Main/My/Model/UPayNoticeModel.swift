//
//  UPayNoticeModel.swift
//  UPay
//
//  Created by 飞亦 on 6/2/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class UPayNoticeModel: UPayBaseModel {
    var list = Array<UPayNoticesCellEntity>()
}

class UPayNoticesCellEntity: UPayBaseModel {
    
    @objc var content : String?
    @objc var title : String?
    @objc var link : String?
    @objc var notice_icon : String?
    @objc var remarks : String?
    @objc var update_time : String?
    @objc var create_time : String?
    
    
    @objc var content_type : Int = 0 //1:文本内容,2:外链接内容
    @objc var id : Int = 0
    @objc var status : Int = 0
    @objc var stick : Double = 0
}
