//
//  UPayPromotionModel.swift
//  UPay
//
//  Created by 飞亦 on 6/11/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class UPayPromotionModel: UPayBaseModel {
    
    @objc var invitation_code : String?
    @objc var invent_url : String?
    
    @objc var invent_counts : Double = 0
    @objc var valid_count : Double = 0
    @objc var user_price : Double = 0
    @objc var team_price : Double = 0
}
