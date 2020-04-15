//
//  UPayAddAd3ViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 10/9/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import JXFoundation

class UPayAddAd3ViewController: UPayBaseViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            
        }
    }
    @IBOutlet weak var priseView: UIView!{
        didSet{
            priseView.tag = 0
            priseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
        }
    }
    @IBOutlet weak var numberView: UIView!{
        didSet{
            numberView.tag = 1
            numberView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
        }
    }
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var minLimitTextField: UITextField!{
        didSet{
            minLimitTextField.rightViewMode = .always
            minLimitTextField.rightView = {() -> UIView in
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
                button.isEnabled = false
                button.setTitleColor(JXMainColor, for: .normal)
                button.setTitle("CNY   ", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                return button
            }()
        }
    }
    @IBOutlet weak var maxLimitTextField: UITextField!{
        didSet{
            maxLimitTextField.rightViewMode = .always
            maxLimitTextField.rightView = {() -> UIView in
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
                button.isEnabled = false
                button.setTitleColor(JXMainColor, for: .normal)
                button.setTitle("CNY   ", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                return button
            }()
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
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.numberTextField,self.minLimitTextField,self.maxLimitTextField])
        
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.textFieldDelegate = self
        return k
    }()
    
    var selectView: JXSelectView?
    
    var vm = UPayAdVM()
    var configurationEntity: ConfigurationEntity?
    var walletEntity: UPayWalletEntity?
    var adEntity: UPayAdCellEntity?
    
    var payType: Int = 0 //支付方式，取和值（1支付宝，2微信，4银行卡）
    var advertType: Int = 1//广告类型，1卖，2买
    var totalCount: Float = 0//挂币数量
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "编辑广告"
        self.useLargeTitles = true
        
        self.topConstraint.constant = self.navStatusHeight
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        self.view.addSubview(self.keyboard)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        self.minLimitTextField.text = "\(self.configurationEntity?.sellLimitMin ?? 0)"
//        self.maxLimitTextField.text = "\(self.configurationEntity?.sellLimitMax ?? 0)"
//        self.priceLabel.text = "\(self.configurationEntity?.platfromSellPrice ?? 0) CNY"
//
//
//        self.walletEntity?.list.forEach({ (entity) in
//            if entity.coinType == 2 {
//
//                self.numberLabel.text = "\(entity.balance)"
//                self.feeLabel.text = "\(entity.balance * (self.configurationEntity?.sellRate ?? 0)) USDT"
//                self.valueLabel.text = "数量设定(市场参考价：\(entity.balance * (self.configurationEntity?.platfromSellPrice ?? 0)) CNY)"
//
//                self.totalCount = entity.balance
//            }
//        })
        
        guard let entity = self.adEntity else { return }
        
        self.minLimitTextField.text = "\(entity.limitMin)"
        self.maxLimitTextField.text = "\(entity.limitMax)"
        self.priceLabel.text = "\(self.configurationEntity?.platfromSellPrice ?? 0) CNY"
        
        self.numberLabel.text = "数量"
        self.numberTextField.text = "\(entity.totalCount)"
        
        
        self.totalCount = entity.totalCount
        
        self.payType = entity.payTypeNum
        
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
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        
        guard let minText = self.minLimitTextField.text, minText.isEmpty == false, let min = Float(minText) else { return }
        guard let maxText = self.maxLimitTextField.text, maxText.isEmpty == false, let max = Float(maxText) else { return }
        
        if self.payType > 0 {
            self.showMBProgressHUD()
            self.vm.adOtcEdit(id: self.adEntity?.id ?? "", payType: self.payType, limitMin: min, limitMax: max) { (_, msg, isS) in
                self.hideMBProgressHUD()
                ViewManager.showNotice(msg)
                if isS == true {
                    if let block = self.backBlock {
                        block()
                    }
                    self.navigationController?.popToRootViewController(animated: true)
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
extension UPayAddAd3ViewController: UITextFieldDelegate,JXKeyboardTextFieldDelegate {
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == minLimitTextField {
            maxLimitTextField.becomeFirstResponder()
            return false
        } else if textField == maxLimitTextField {
            textField.resignFirstResponder()
            return true
        }
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let max = self.configurationEntity?.sellLimitMax else { return true }
        if range.location > "\(max)".count - 1 {
            return false
        }
        return true
    }
    @objc func textChange(notify: NSNotification) {
        
        if notify.object is UITextField {
            
        }
    }
    @objc func keyboardWillShow(notify:Notification) {
        
        guard
            let userInfo = notify.userInfo,
            let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        
        //print(rect)//226
        UIView.animate(withDuration: animationDuration, animations: {
            self.mainScrollView.contentOffset = CGPoint(x: 0, y: 60)
            
        }) { (finish) in
            //
        }
    }
    @objc func keyboardWillHide(notify:Notification) {
        print("notify = ","notify")
        guard
            let userInfo = notify.userInfo,
            let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        UIView.animate(withDuration: animationDuration, animations: {
            self.mainScrollView.contentOffset = CGPoint(x: 0, y: 0)
        }) { (finish) in
            
        }
    }
}
