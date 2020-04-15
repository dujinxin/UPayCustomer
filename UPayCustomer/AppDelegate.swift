//
//  AppDelegate.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/20/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *documentDirectory = [paths objectAtIndex:0];
//        NSString *fileName = [NSStringstringWithFormat:@"dr.log"];//注意不是NSData!
//        NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
//        //先删除已经存在的文件
//        NSFileManager *defaultManager = [NSFileManagerdefaultManager];
//        [defaultManagerremoveItemAtPath:logFilePath error:nil];
//
//        // 将log输入到文件
//        freopen([logFilePathcStringUsingEncoding:NSASCIIStringEncoding],"a+", stdout);
//        freopen([logFilePathcStringUsingEncoding:NSASCIIStringEncoding],"a+", stderr);

        
        
        
        
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
        
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        
        
        if !UserManager.manager.isLogin {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "login") as! UPayLoginViewController
            let loginVC = UPayNavigationController.init(rootViewController: login)
            login.modalPresentationStyle = .fullScreen
            self.window?.rootViewController = loginVC
        } else {
            if UserManager.manager.userEntity.resetPsdStatus == 1 {
                //优先重置登录密码
                let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "modifyPsd") as! UPayModifyPsdViewController
                //vc.hidesBottomBarWhenPushed = true
                vc.type = .firstLoginPsd
                //self.navigationController?.pushViewController(vc, animated: true)
                let nvc = UPayNavigationController.init(rootViewController: vc)
                self.window?.rootViewController = nvc
            } else if UserManager.manager.userEntity.resetSafePsdStatus == 1 {
                //其次设置安全密码
                let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "setSafePsd") as! UPaySetSafePsdController
                //vc.hidesBottomBarWhenPushed = true
                //self.navigationController?.pushViewController(vc, animated: true)
                let nvc = UPayNavigationController.init(rootViewController: vc)
                self.window?.rootViewController = nvc
            } else if UserManager.manager.userEntity.validStatus == 1 {
                //最后再根据认证状态来跳转不同的显示页面
                
                //未认证
                let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "cert") as! UPayCertViewController
                //vc.hidesBottomBarWhenPushed = true
                //self.navigationController?.pushViewController(vc, animated: true)
                let nvc = UPayNavigationController.init(rootViewController: vc)
                self.window?.rootViewController = nvc
            } else if UserManager.manager.userEntity.validStatus == 2 {
                //认证中 ,还没写
                
                let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "cert") as! UPayCertViewController
                //vc.hidesBottomBarWhenPushed = true
                //self.navigationController?.pushViewController(vc, animated: true)
                let nvc = UPayNavigationController.init(rootViewController: vc)
                self.window?.rootViewController = nvc
            } else if UserManager.manager.userEntity.validStatus == 3 {
                //已认证
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UPayTabBarViewController
                self.window?.rootViewController = vc
            } else if UserManager.manager.userEntity.validStatus == 4 {
                //认证失败
                let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "cert") as! UPayCertViewController
                //vc.hidesBottomBarWhenPushed = true
                //self.navigationController?.pushViewController(vc, animated: true)
                let nvc = UPayNavigationController.init(rootViewController: vc)
                self.window?.rootViewController = nvc
            } else {
                self.window?.rootViewController = UIViewController()
            }
        }
        
        
        
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

