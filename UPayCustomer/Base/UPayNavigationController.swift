//
//  UPayNavigationController.swift
//  UPay
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

class UPayNavigationController: UINavigationController {

        open var backItem: UIBarButtonItem = {
            let leftButton = UIButton()
            leftButton.frame = CGRect(x: 10, y: 7, width: 30, height: 30)
            leftButton.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
            leftButton.tintColor = JXMainColor
            //leftButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24)
            //leftButton.setTitle("up", for: .normal)
            leftButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
            let item = UIBarButtonItem(customView: leftButton)
            return item
        }()

        override open func viewDidLoad() {
            super.viewDidLoad()

    //        self.navigationBar.isTranslucent = true
    //        self.navigationBar.barStyle = .blackTranslucent //状态栏 白色
    //        //self.navigationBar.barStyle = .default      //状态栏 黑色
    //        self.navigationBar.barTintColor = UIColor.white//导航条颜色
    //        self.navigationBar.tintColor = UIColor.darkText   //item图片文字颜色
    //        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkText,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17)]//标题设置
        }

        override open func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

        /// 重写push方法
        ///
        /// - Parameters:
        ///   - viewController: 将要push的viewController
        ///   - animated: 是否使用动画
        override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: true)
            
            guard viewControllers.count > 0 else { return }
            
            var titleName = ""//"返回"
            if viewControllers.count == 1 {
                titleName = viewControllers.first?.title ?? titleName
            }
            
            if let vc = viewController as? JXBaseViewController {
                vc.hidesBottomBarWhenPushed = true
                vc.customNavigationItem.leftBarButtonItem = self.backItem
            }
        }
        
        /// 自定义导航栏的返回按钮事件
        @objc func pop() {
            popViewController(animated: true)
        }
    
    // 重写这两个方法
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.visibleViewController!.preferredStatusBarStyle
    }
    override var prefersStatusBarHidden: Bool {
        return self.visibleViewController!.prefersStatusBarHidden
    }
}
