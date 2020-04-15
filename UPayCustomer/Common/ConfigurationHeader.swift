//
//  ConfigurationHeader.swift
//  UPay
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import Foundation
import JXFoundation


//MARK:设备
let deviceModel = UIScreen.main.model

//MARK:尺寸类
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let kScreenBounds = UIScreen.main.bounds

let kStatusBarHeight = (UIScreen.main.isIphoneX == true) ? CGFloat(44) : CGFloat(20)
let kNavBarHeight = CGFloat(44)
let kNavStatusHeight = kStatusBarHeight + kNavBarHeight
let kBottomMaginHeight : CGFloat = (UIScreen.main.isIphoneX == true) ? 34 : 0
let kTabBarHeight : CGFloat = kBottomMaginHeight + 49

let kHWPercent = (kScreenHeight / kScreenWidth)//高宽比例
let kPercent = kScreenWidth / 375.0

//MARK:颜色

let JX333333Color = UIColor.rgbColor(rgbValue: 0x333333)
let JX666666Color = UIColor.rgbColor(rgbValue: 0x666666)
let JX999999Color = UIColor.rgbColor(rgbValue: 0x999999)
let JXEeeeeeColor = UIColor.rgbColor(rgbValue: 0xeeeeee)
let JXFfffffColor = UIColor.rgbColor(rgbValue: 0xffffff)
let JXF1f1f1Color = UIColor.rgbColor(rgbValue: 0xf1f1f1)



//2蓝色系
let JXBlueColor = UIColor.rgbColor(rgbValue: 0x0052cc)
let JXlightBlueColor = UIColor.rgbColor(rgbValue: 0xb1c1d2)
let JXBlueShadow = UIColor.rgbColor(rgbValue: 0x0C559C, alpha: 1)

let JXMainColor = JXBlueColor
let JXMainTextColor = UIColor.rgbColor(rgbValue: 0x56657E)
let JXMain60TextColor = UIColor.rgbColor(rgbValue: 0x56657E, alpha: 0.6)

let JXBlackTextColor = UIColor.rgbColor(rgbValue: 0x05223E)
let JX092641Color = UIColor.rgbColor(rgbValue: 0x092641)
let JX809FBCColor = UIColor.rgbColor(rgbValue: 0x809FBC)
let JX7999B8Color = UIColor.rgbColor(rgbValue: 0x7999B8)
let JXGrayTextColor = UIColor.rgbColor(rgbValue: 0x7395B5)



let JXGreenColor = UIColor.rgbColor(rgbValue: 0x2AB586)  //绿
let JXYellowColor = UIColor.rgbColor(rgbValue: 0xEDC00B) //黄（黄金）
let JXPurpleColor = UIColor.rgbColor(rgbValue: 0x7876F4) //紫（白金）
let JXRedColor = UIColor.rgbColor(rgbValue: 0xD33333)    //红
let JXCyanColor = UIColor.rgbColor(rgbValue: 0xCFE7FF)   //青




let JXViewBgColor = UIColor.rgbColor(rgbValue: 0xF5F5F5)

let JXTextViewBgColor = UIColor.rgbColor(rgbValue: 0xe8e8e8)
let JXTextViewBg1Color = JXTextViewBgColor
let JXTextViewBg2Color = UIColor.rgbColor(rgbValue: 0xb7b7b7, alpha: 0.44)
let JXUIBarBgColor = JXFfffffColor
let JXMerchantIconBgColor = JXMainColor
let JXMerchantIconTextColor = JXFfffffColor

let JXLargeTitleColor = JXBlueColor

let JXOrderDetailBgColor = JXFfffffColor

let JXSeparatorColor = UIColor.rgbColor(rgbValue: 0xd3dfef)
