//
//  UPayDetailTableController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/27/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import MBProgressHUD
import JXFoundation

class UPayDetailTableController: UITableViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var toAccountLabel: UILabel!
    @IBOutlet weak var toNameLabel: UILabel!
    @IBOutlet weak var toBankLabel: UILabel!
    
    @IBOutlet weak var fromNumLabel: UILabel!
    @IBOutlet weak var fromNameLabel: UILabel!
    @IBOutlet weak var fromBankLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
  
    @IBOutlet weak var copy1Button: UIButton!
    @IBOutlet weak var copy2Button: UIButton!
    
    var entity: UPayBuyPlatformDetailEntity? {
        didSet{

            guard let entity = entity else { return }
            
            self.priceLabel.text = "¥ \(entity.price)"
            self.numLabel.text = "\(entity.coinCount) USDT"
            self.valueLabel.text = "¥ \(entity.totalAmount)"
            self.timeLabel.text = entity.createDate
            
            self.toAccountLabel.text = entity.account
            self.toNameLabel.text = entity.name
            self.toBankLabel.text = entity.bank
            
            self.fromNumLabel.text = entity.buyerAccount
            self.fromNameLabel.text = entity.buyerName
            self.fromBankLabel.text = entity.buyerBank
            
            if let s = entity.transferVoucher {
                self.imageView.sd_setImage(with: URL(string: s), completed: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        self.tableView.separatorStyle = .none
        
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        self.vm.buyPlatformDetail(id: self.id) { (_, msg, isSuc) in
//            MBProgressHUD.hide(for: self.view, animated: true)
//
//            if isSuc {
//
//
//            }
//        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let controllers = self.navigationController?.viewControllers {
            if controllers.count == 4 {
                self.navigationController?.viewControllers.remove(at: 2)
            }
        }
    }
    
    
    @IBAction func copy1Action(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.toAccountLabel.text
        ViewManager.showNotice("已复制")
    }
    @IBAction func copy2Action(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.toNameLabel.text
        ViewManager.showNotice("已复制")
    }
 
}
