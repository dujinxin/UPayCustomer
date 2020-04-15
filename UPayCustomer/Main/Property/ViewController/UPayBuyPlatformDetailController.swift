//
//  UPayBuyPlatformDetailController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/27/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayBuyPlatformDetailController: UPayBaseViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    var entity: UPayBuyPlatformDetailEntity?
    var shouldRefresh: Bool = false
    
    var childVC: UPayDetailTableController {
        guard let vc = children.first as? UPayDetailTableController else {
            let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "detailTabel") as! UPayDetailTableController
           
            return vc
        }
        return vc
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let entity = entity {
            if entity.recordStatus != 0 {//平台买币
                //平台买币订单状态，1待支付，2已付款，3已完成，5已取消，7待回滚
                switch entity.recordStatus {
                case 1:
                    self.title = "待支付"
                case 2:
                    self.title = "已付款"
                case 3:
                    self.title = "已完成"
                case 5:
                    self.title = "已取消"
                case 7:
                    self.title = "待回滚"
                default:
                    self.title = "未知状态"
                }
            } else { //托管出金
                //托管出金订单状态，1待支付，2已付款，3待仲裁，4已完成，5已取消，6仲裁币商败诉，7待回滚，8已回滚 ，9预约回滚
                switch entity.orderStatus {
                case 1:
                    self.title = "待支付"
                case 2:
                    self.title = "已付款"
                case 3:
                    self.title = "待仲裁"
                case 4:
                    self.title = "已完成"
                case 5:
                    self.title = "已取消"
                case 6:
                    self.title = "仲裁币商败诉"
                case 7:
                    self.title = "待回滚"
                case 8:
                    self.title = "已回滚"
                case 9:
                    self.title = "预约回滚"
                default:
                    self.title = "未知状态"
                }
            }
        }
        
        self.useLargeTitles = true
        self.topConstraint.constant = self.navStatusHeight
        self.customNavigationBar.barTintColor = JXFfffffColor
        let font = UIFont.boldSystemFont(ofSize: 34)
        self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: JXMainColor,NSAttributedString.Key.font:font]//大标题设置
        
        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(back))
            

        self.childVC.entity = self.entity
        
    }

    @objc func back() {
        if self.shouldRefresh == true, let block = self.backBlock {
            block()
        }
        self.navigationController?.popViewController(animated: true)
    }
}
