//
//  UPayBaseViewController.swift
//  UPay
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation
import MBProgressHUD

class UPayBaseViewController: JXBaseViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = JXViewBgColor
        
        self.customNavigationBar.isTranslucent = true
        self.customNavigationBar.barStyle = .default
        self.customNavigationBar.barTintColor = JXFfffffColor
        self.customNavigationBar.tintColor = JXMainColor //item图片文字颜色
        let font1 = UIFont.systemFont(ofSize: 17)
        self.customNavigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: JXMainTextColor,NSAttributedString.Key.font:font1]//标题设置
        let font2 = UIFont.boldSystemFont(ofSize: 34)
        self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: JXMainColor,NSAttributedString.Key.font:font2]//大标题设置
        
        
        
        self.customNavigationBar.useCustomBackgroundView = true
        self.customNavigationBar.useLargeTitles = false
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.clear
        
        
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    open func showMBProgressHUD() {
        let _ = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        hud.backgroundView.color = UIColor.black
        //        hud.contentColor = UIColor.black
        //        hud.bezelView.backgroundColor = UIColor.black
        //        hud.label.text = "加载中..."
        
    }
    open func hideMBProgressHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

}
