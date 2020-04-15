//
//  UPayCertResultController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/22/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import JXFoundation

class UPayCertResultController: UPayBaseViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            
        }
    }
  
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var vm = UPayLoginRegisterVM()
    
    var isFront : Bool = true
    var imagePicker : UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.title = "实名认证"
        self.useLargeTitles = true
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-back"), style: .plain, target: self, action: #selector(back))
        
        self.topConstraint.constant = self.navStatusHeight
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        if let controllers = self.navigationController?.viewControllers {
        //            print(controllers)
        //            if controllers.count > 2 {
        //                self.navigationController?.viewControllers.remove(at: 1)
        //            }
        //        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @objc func back() {
        exit(0)
    }
}
