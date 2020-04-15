//
//  UPayAddAd1ViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/23/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayAddAd1ViewController: UPayBaseViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var imageView1: UIImageView!{
        didSet{
            self.imageView1.image = UIImage(named: "square.grid")?.withRenderingMode(.alwaysTemplate)
        }
    }
    @IBOutlet weak var imageView2: UIImageView!{
        didSet{
            self.imageView2.image = UIImage(named: "yuan")?.withRenderingMode(.alwaysTemplate)
        }
    }
    @IBOutlet weak var imageView3: UIImageView!{
        didSet{
            self.imageView3.image = UIImage(named: "paperplane")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    
    @IBOutlet weak var otcButton: UIButton!{
        didSet{
            
            otcButton.setTitleColor(JXMainColor, for: .normal)
            otcButton.layer.cornerRadius = 3
            otcButton.layer.borderColor = JXMainColor.cgColor
            otcButton.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var customButton: UIButton!{
        didSet{
            customButton.setTitle("", for: .normal)
            customButton.isEnabled = false
        }
    }
    @IBOutlet weak var sellButton: UIButton!{
        didSet{
            sellButton.setTitleColor(JXMainColor, for: .normal)
            sellButton.layer.cornerRadius = 3
            sellButton.layer.borderColor = JXMainColor.cgColor
            sellButton.layer.borderWidth = 1
            
        }
    }
    @IBOutlet weak var buyButton: UIButton!{
        didSet{
            buyButton.setTitle("", for: .normal)
            buyButton.isEnabled = false
        }
    }
    
    
    @IBOutlet weak var cointView: UIView!{
        didSet{
            cointView.tag = 0
            cointView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
        }
    }
    @IBOutlet weak var moneyView: UIView!{
        didSet{
            moneyView.tag = 1
            moneyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
        }
    }
    @IBOutlet weak var payView: UIView!{
        didSet{
            payView.tag = 2
            payView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
        }
    }
    
    @IBOutlet weak var pay1ImageView: UIImageView!
    @IBOutlet weak var pay2ImageView: UIImageView!
    @IBOutlet weak var pay3ImageView: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
            nextButton.backgroundColor = JXMainColor
            nextButton.setTitleColor(JXFfffffColor, for: .normal)
            nextButton.layer.cornerRadius = 3
        }
    }
    var selectView: JXSelectView?
    
    var walletVM = UPayWalletVM()
    var configurationEntity: ConfigurationEntity?
    var payType: Int = 0
    var isEdit: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "发布广告"
        self.useLargeTitles = true
        
        self.topConstraint.constant = self.navStatusHeight
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    @objc func tap(tap: UITapGestureRecognizer) {
        guard let v = tap.view else {
            return
        }
        
        if v.tag == 0 {
            
        } else if v.tag == 1 {
            
        } else if v.tag == 2 {
            //选择支付方式
            selectView = JXSelectView(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), style: JXSelectViewStyle.custom)
            selectView?.backgroundColor = JXFfffffColor
            selectView?.isBackViewUserInteractionEnabled = false
            selectView?.customView = self.customView()
            selectView?.show(inView: self.view)
            
        }
    }
    @IBAction func next(_ sender: Any) {
        print(self.payType)
        if self.payType > 0 {
            self.showMBProgressHUD()
            self.walletVM.wallet(coinType: 0) { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                if isSuc {
                    let storyboard = UIStoryboard.init(name: "Ad", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "add2") as! UPayAddAd2ViewController
                    vc.payType = self.payType
                    vc.configurationEntity = self.configurationEntity
                    vc.walletEntity = self.walletVM.walletEntity
                    vc.hidesBottomBarWhenPushed = true
                    vc.backBlock = self.backBlock
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    ViewManager.showNotice(msg)
                }
            }
            
        } else {
            ViewManager.showNotice("请至少选择一种支付方式")
        }
    }
    
    @objc func cancel() {
//        self.payType = 0
//        self.pay1ImageView.image = nil
//        self.pay2ImageView.image = nil
//        self.pay3ImageView.image = nil
        
        self.selectView?.dismiss()
    }
    @objc func confirm() {
        
        if self.payType == 0 {
            self.pay1ImageView.image = nil
            self.pay2ImageView.image = nil
            self.pay3ImageView.image = nil
        } else if self.payType == 1 {
            self.pay1ImageView.image = UIImage(named: "icon-mini-alipay")
            self.pay2ImageView.image = nil
            self.pay3ImageView.image = nil
        } else if self.payType == 2 {
            self.pay1ImageView.image = UIImage(named: "icon-mini-wechat")
            self.pay2ImageView.image = nil
            self.pay3ImageView.image = nil
        } else if self.payType == 3 {
            self.pay1ImageView.image = UIImage(named: "icon-mini-alipay")
            self.pay2ImageView.image = UIImage(named: "icon-mini-wechat")
            self.pay3ImageView.image = nil
        } else if self.payType == 4 {
            self.pay1ImageView.image = UIImage(named: "icon-mini-card")
            self.pay2ImageView.image = nil
            self.pay3ImageView.image = nil
        } else if self.payType == 5 {
            self.pay1ImageView.image = UIImage(named: "icon-mini-alipay")
            self.pay2ImageView.image = UIImage(named: "icon-mini-card")
            self.pay3ImageView.image = nil
        } else if self.payType == 6 {
            self.pay1ImageView.image = UIImage(named: "icon-mini-wechat")
            self.pay2ImageView.image = UIImage(named: "icon-mini-card")
            self.pay3ImageView.image = nil
        } else {
            self.pay1ImageView.image = UIImage(named: "icon-mini-alipay")
            self.pay2ImageView.image = UIImage(named: "icon-mini-wechat")
            self.pay3ImageView.image = UIImage(named: "icon-mini-card")
        }
        self.selectView?.dismiss()
    }
    @objc func selectPay(button: UIButton) {
        button.isSelected = !button.isSelected
        
        if button.isSelected == true {
            button.layer.borderColor = JXMainColor.cgColor
            if button.tag == 0 {
                self.payType += 4
            } else if button.tag == 1 {
                self.payType += 1
            } else {
                self.payType += 2
            }
        } else {
            button.layer.borderColor = UIColor.clear.cgColor
            if button.tag == 0 {
                self.payType -= 4
            } else if button.tag == 1 {
                self.payType -= 1
            } else {
                self.payType -= 2
            }
        }
    }
    func customView() -> UIView {
        
        let list = ["银行转帐","支付宝"/*,"微信转帐"*/]
        let space: CGFloat = 10
        let itemWidth = (kScreenWidth - space * 3) / 2
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60 + 44 * 1 + space * 1)
        
        let rightContentView = UIView()
        rightContentView.frame = CGRect(x: 0, y: 0, width: contentView.jxWidth, height: contentView.jxHeight + kBottomMaginHeight)
        rightContentView.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(rightContentView)
        
        let topBarView = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 35)
            //label.center = view.center
            label.text = "选择支付方式"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = JXMainColor
            view.addSubview(label)
            //label.sizeToFit()
            
            let detailLabel = UILabel()
            detailLabel.frame = CGRect(x: 0, y: label.jxBottom, width: kScreenWidth, height: 12)
            //label.center = view.center
            detailLabel.text = "至少选择一种"
            detailLabel.textAlignment = .center
            detailLabel.font = UIFont.systemFont(ofSize: 11)
            detailLabel.textColor = JXMain60TextColor
            view.addSubview(detailLabel)
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            button.setTitle("取消", for: .normal)
            button.tintColor = JXMainTextColor
            //button.setImage(UIImage(named: "Close")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.setTitleColor(JXMainTextColor, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
            view.addSubview(button)
            
            
            let button1 = UIButton()
            button1.frame = CGRect(x: kScreenWidth - 40 - 24, y: 10, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            button1.setTitle("确定", for: .normal)
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button1.setTitleColor(JXMainColor, for: .normal)
            button1.contentVerticalAlignment = .center
            button1.contentHorizontalAlignment = .center
            button1.addTarget(self, action: #selector(confirm), for: .touchUpInside)
            contentView.addSubview(button1)
            
            return view
        }()
        rightContentView.addSubview(topBarView)
        
        
        
        for i in 0..<list.count{
            let view = UIView(frame: CGRect(x: space + (itemWidth + space) * CGFloat(i % list.count), y: topBarView.jxBottom + 0 + CGFloat(44 * (i / list.count)), width: itemWidth, height: 44))
            view.backgroundColor = JXFfffffColor
            view.layer.cornerRadius = 4
            
            let icon = UIImageView(frame: CGRect(x: 10, y: 12, width: 20, height: 20))
            //icon.backgroundColor = JXMainColor
            view.addSubview(icon)
            
            let label = UILabel()
            label.frame = CGRect(x: icon.jxRight + 5, y: 0, width: 80, height: 44)
            //label.center = view.center
            label.text = list[i]
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = JXMainTextColor
            view.addSubview(label)
            
            let button = UIButton()
            button.frame = CGRect(x: 0, y: 0, width: itemWidth, height: 44)
            button.layer.cornerRadius = 4
            button.isSelected = false
            button.tag = i
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.clear.cgColor
            
            button.addTarget(self, action: #selector(selectPay(button:)), for: .touchUpInside)
            view.addSubview(button)
            
            if i == 1 {
                icon.image = UIImage(named: "icon-mini-alipay")
            } else if i == 2 {
                icon.image = UIImage(named: "icon-mini-wechat")
            } else {
                icon.image = UIImage(named: "icon-mini-card")
            }
            if self.payType == 0 {
                button.isSelected = false
                button.layer.borderColor = UIColor.clear.cgColor
            } else if self.payType == 1 {
                if i == 1 {
                    button.isSelected = true
                    button.layer.borderColor = JXMainColor.cgColor
                }
            } else if self.payType == 2 {
                if i == 2 {
                    button.isSelected = true
                    button.layer.borderColor = JXMainColor.cgColor
                }
            } else if self.payType == 3 {
                if i == 1 || i == 2 {
                    button.isSelected = true
                    button.layer.borderColor = JXMainColor.cgColor
                }
            } else if self.payType == 4 {
                if i == 0 {
                    button.isSelected = true
                    button.layer.borderColor = JXMainColor.cgColor
                }
            } else if self.payType == 5 {
                if i == 1 || i == 0{
                    button.isSelected = true
                    button.layer.borderColor = JXMainColor.cgColor
                }
            } else if self.payType == 6 {
                if i == 2 || i == 0 {
                    button.isSelected = true
                    button.layer.borderColor = JXMainColor.cgColor
                }
            } else {
                button.isSelected = true
                button.layer.borderColor = JXMainColor.cgColor
            }
            rightContentView.addSubview(view)
        }
        
        
        return contentView
    }
    
}
