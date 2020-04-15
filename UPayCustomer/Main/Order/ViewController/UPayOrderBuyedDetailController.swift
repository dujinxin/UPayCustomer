//
//  UPayOrderBuyedDetailController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 10/4/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import MBProgressHUD
import JXFoundation

class UPayOrderBuyedDetailController: UPayBaseViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
 
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var coinImageView: UIImageView!
    
    
    @IBOutlet weak var toAccountLabel: UILabel!
    @IBOutlet weak var toNameLabel: UILabel!
    @IBOutlet weak var toBankLabel: UILabel!
    
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var orderReturnLabel: UILabel!
    @IBOutlet weak var orderFeeLabel: UILabel!

    
    @IBOutlet weak var fromNumTextField: UITextField!
    @IBOutlet weak var fromNameTextField: UITextField!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var copy1Button: UIButton!
    @IBOutlet weak var copy2Button: UIButton!
    @IBOutlet weak var copy3Button: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!{
        didSet{
            self.cancelButton.backgroundColor = JXViewBgColor
            self.cancelButton.setTitleColor(JXMainTextColor, for: .normal)
            self.cancelButton.layer.cornerRadius = 4
            self.cancelButton.layer.borderWidth = 1
            self.cancelButton.layer.borderColor = UIColor.rgbColor(rgbValue: 0xe1e1e1).cgColor
        }
    }

    var entity: UPayOrderBuyOrSellDetailEntity? {
        didSet{
        
        }
    }
    
    var vm = UPayHomeVM()
    
    var imagePicker : UIImagePickerController?
    var isSelected = false
    
    var shouldRefresh: Bool = false
    var showHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = JXFfffffColor
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if let entity = entity {
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
        
        
        self.useLargeTitles = true
        self.customNavigationBar.backgroundView.backgroundColor = JXMainColor
        let font = UIFont.boldSystemFont(ofSize: 34)
        self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: JXFfffffColor,NSAttributedString.Key.font:font]//大标题设置
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 10, y: 7, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.tintColor = JXFfffffColor
        leftButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        guard let entity = entity else { return }

        self.priceLabel.text = "¥ \(entity.buyPrice)"
        self.numLabel.text = "\(entity.buyCoinCount) USDT"
        self.valueLabel.text = "¥ \(entity.totalAmount)"
        //self.coinNameLabel.text = entity.co
        
        self.toAccountLabel.text = entity.account
        self.toNameLabel.text = entity.name
        self.toBankLabel.text = entity.bank
        
        self.orderNumLabel.text = entity.orderNum
        self.orderReturnLabel.text = "\(entity.cmCommision + entity.extraCommision) USDT"
        //self.orderReturnLabel.text = "\(entity.cmCommision + entity.extraCommision) USDT" //补贴 tradeType == 4
        self.orderFeeLabel.text = "\(entity.fee) USDT"
        
        if let _ = entity.payerName {
            self.fromNumTextField.text = entity.payerAccount
            self.fromNameTextField.text = entity.payerName
        } else {
            self.fromNumTextField.placeholder = ""
            self.fromNameTextField.placeholder = ""
        }
        
        if let s = entity.transferVoucher {
            self.imageView.sd_setImage(with: URL(string: s), completed: nil)
        }
        
        if entity.orderStatus == 5 {
            self.bottomHeightConstraint.constant = 80 + kBottomMaginHeight
        } else {
            self.bottomHeightConstraint.constant = kBottomMaginHeight
            self.cancelButton.isHidden = true
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let lists = self.navigationController?.viewControllers, lists.count > 2 {
            self.navigationController?.viewControllers.remove(at: lists.count - 2)
        }
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = self.navStatusHeight
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    @objc func back() {
        if let block = self.backBlock {
            block()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func copyAction1(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.toAccountLabel.text
        ViewManager.showNotice("已复制")
    }
    @IBAction func copyAction2(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.toNameLabel.text
        ViewManager.showNotice("已复制")
    }
    @IBAction func copyAction3(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.entity?.orderNum
        ViewManager.showNotice("已复制")
    }
   
    @IBAction func cancelAction(_ sender: Any) {
        
        self.showMBProgressHUD()
        self.vm.orderRollBack(id: self.entity?.id ?? "") { (_, msg, isSuc) in
            if isSuc {
                self.vm.orderBuyOrSellDetail(id: self.entity?.id ?? "") { (_, message, isSuccess) in
                    self.hideMBProgressHUD()
                    if isSuccess {
                        if self.vm.orderBuyOrSellDetailEntity.isBuy {
                            let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "orderBuyingDetailController") as! UPayOrderBuyingDetailController
                            vc.entity = self.vm.orderBuyOrSellDetailEntity
                            vc.backBlock = self.backBlock
                            vc.shouldRefresh = true
                            vc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "orderBuyedDetailController") as! UPayOrderBuyedDetailController
                            vc.entity = self.vm.orderBuyOrSellDetailEntity
                            vc.backBlock = self.backBlock
                            vc.shouldRefresh = true
                            vc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }

                    } else {
                        ViewManager.showNotice(message)
                    }
                }
            } else {
                self.hideMBProgressHUD()
                ViewManager.showNotice(msg)
            }
        }
    }
}

