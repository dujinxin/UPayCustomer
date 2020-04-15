//
//  UPayTabBarViewController.swift
//
//  Created by feiyi on 2018/5/8.
//  Copyright © 2018年 feiyi. All rights reserved.
//

import UIKit
import JXFoundation

class UPayTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let document = paths[0]
//        let fileName = "dr.log"
//        let path = document + fileName
//
//        let fileManager = FileManager.default
//        if fileManager.fileExists(atPath: path) {
//            try? fileManager.removeItem(atPath: path)
//
//        }
//        freopen(path.cString(using: .ascii), "a+", stdout)
//        freopen(path.cString(using: .ascii), "a+", stderr)

        // Do any additional setup after loading the view.

        //UITabBar.appearance()
        tabBar.barTintColor = JXUIBarBgColor
        tabBar.isTranslucent = false
        tabBar.tintColor = JXMainColor
        
        
        let normalTitleList = ["订单管理","广告管理","资产管理","我的"]
        let normalImageList = ["order","ellipses.bubble.fill","creditcard.fill","person.fill"]
        let selectedImageList = ["home_selected","find_selected","quotes_selected","my_selected"]
        
        let normalAttributed = [NSAttributedString.Key.foregroundColor:JXGrayTextColor]
        let selectedAttributed = [NSAttributedString.Key.foregroundColor:JXMainColor]
//        tabBar.items?.forEach({ (item) in
//            item.setTitleTextAttributes(normalAttributed, for: .normal)
//            item.setTitleTextAttributes(selectedAttributed, for: .selected)
//            item.image?.renderingMode = .alwaysOriginal
//        })
        
        if let items = tabBar.items {
            for i in 0..<items.count {
                let item = items[i]
                item.title = normalTitleList[i]
                item.setTitleTextAttributes(normalAttributed, for: .normal)
                item.setTitleTextAttributes(selectedAttributed, for: .selected)
                item.image = UIImage(named: normalImageList[i])?.withRenderingMode(.alwaysOriginal)
                item.selectedImage = UIImage(named: normalImageList[i])?.withRenderingMode(.alwaysTemplate)
            }
        }
        
        tabBar.tintColor = JXMainColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        tabBar.layer.shadowColor = UIColor.rgbColor(rgbValue: 0x5c6677, alpha: 0.2).cgColor
        tabBar.layer.shadowOpacity = 1
        tabBar.addObserver(self, forKeyPath: "frame", options: [.old, .new], context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: "NotificationLoginStatus"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(tabBarStatus(notify:)), name: NSNotification.Name(rawValue: NotificationTabBarHiddenStatus), object: nil)
//
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tabBar = object as? UITabBar, keyPath == "frame" {
            if let oldFrame = change?[.oldKey] as? CGRect, let newFrame = change?[.newKey] as? CGRect {
                if oldFrame.size != newFrame.size {
                    if oldFrame.height > newFrame.height {
                        tabBar.frame = oldFrame
                    } else {
                        tabBar.frame = newFrame
                    }
                }
            }
        }
    }
    func imageWithColor(_ color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        tabBar.removeObserver(self, forKeyPath: "frame")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "NotificationLocatedStatus"), object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationTabBarHiddenStatus), object: nil)
    }

    @objc func buttonClick() {

        //self.tabBarController?.selectedIndex = 1
        
        self.selectedIndex = 1
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let scan = storyboard.instantiateViewController(withIdentifier: "ScanVC") as! ScanViewController
//        let scanVC = UINavigationController.init(rootViewController: scan)
//
//        self.present(scanVC, animated: false, completion: nil)
    }
    
    @objc func tabBarStatus(notify: Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            self.tabBar.isHidden = true
        }else{
            self.tabBar.isHidden = false
        }
    }

}

//MARK: loginStatus
extension UPayTabBarViewController {
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            
            let mainSb = UIStoryboard(name: "Main", bundle: nil)
            let rootViewC = mainSb.instantiateInitialViewController() as! UPayTabBarViewController
            LanaguageManager.shared.reset(rootViewC)
        } else {
            UserManager.manager.removeAccound()
            
            UserDefaults.standard.setValue("", forKey: "Cookie")
            UserDefaults.standard.synchronize()
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "login") as! UPayLoginViewController
            let loginVC = UPayNavigationController.init(rootViewController: login)
            if self.selectedViewController is UINavigationController {
                let selectVC = self.selectedViewController as! UINavigationController
                let topVC = selectVC.topViewController
                if let modelVC = topVC?.navigationController?.visibleViewController {
                    modelVC.dismiss(animated: false, completion: nil)
                }
                topVC?.navigationController?.popToRootViewController(animated: false)
                topVC!.navigationController?.present(loginVC, animated: true, completion: nil)
            } else {
                self.selectedViewController?.navigationController?.present(loginVC, animated: true, completion: nil)
            }
        
        }
    }
}
