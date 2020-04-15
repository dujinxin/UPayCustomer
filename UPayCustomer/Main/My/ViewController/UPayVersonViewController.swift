//
//  UPayVersonViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 10/15/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayVersonViewController: UPayBaseViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!{
        didSet{
            self.contentView.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var backView: UIView!{
        didSet{
            self.backView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!{
        didSet{
            self.logoutButton.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var refreshButton: UIButton!{
        didSet{
            
        }
    }
    lazy var maskView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.rgbColor(rgbValue: 0x000000, alpha: 0.4)
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.title = "版本"
        self.useLargeTitles = true
        
        
        self.titleLabel.text = "当前已是最新版本"
        self.contentLabel.text = "\(Bundle.main.version)"
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        let alertVC = UIAlertController(title: nil, message: "退出登录", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationLoginStatus"), object: false)

        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))

        self.present(alertVC, animated: true, completion: nil)
    }
    @IBAction func refreshAction(_ sender: Any) {
        let v = UPayVersionVM()
        v.version { (_, msg, isSuc) in

            if isSuc && v.versionEntity.ios_version != Bundle.main.version {
                let storyboard = UIStoryboard(name: "My", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "versionAlert") as! UPayVersionAlertController
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                vc.entity = v.versionEntity

                let window = UIWindow()
                window.frame = UIScreen.main.bounds
                window.windowLevel = UIWindow.Level.alert + 1
                window.backgroundColor = UIColor.clear
                window.isHidden = false
                let root = UIViewController()
                root.view.backgroundColor = UIColor.clear
                window.rootViewController = root

                vc.callBackBlock = { isDownload in
                    window.isHidden = true
                    if let _ = self.maskView.superview {
                        self.maskView.removeFromSuperview()
                    }
                    if isDownload {
                        guard
                            let text = v.versionEntity.ios_url,
                            let url = URL(string: text) else {
                                return
                        }
                        if UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:]) { (isTrue) in

                                }
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    }

                }

                window.rootViewController?.view.addSubview(self.maskView)
                window.rootViewController?.present(vc, animated: true, completion:{
                    //self.maskView.alpha = 1
                })

            }
        }
    }
}
