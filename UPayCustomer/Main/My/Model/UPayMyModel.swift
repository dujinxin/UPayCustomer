//
//  UPayMyModel.swift
//  UPay
//
//  Created by 飞亦 on 6/12/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class UPayMyModel: UPayBaseModel {
    @objc var icon : String?
    @objc var name : String?
    @objc var invent_url : String?
    @objc var invitation_code : String?
    
    @objc var level : Int = 0
    @objc var status : Int = 0
}
