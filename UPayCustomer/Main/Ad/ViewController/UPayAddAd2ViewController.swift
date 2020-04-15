//
//  UPayAddAd2ViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/24/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import JXFoundation

class UPayAddAd2ViewController: UPayBaseViewController {

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
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    
   
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
    
    var vm = UPayAdVM()
    var configurationEntity: ConfigurationEntity?
    var walletEntity: UPayWalletEntity?
    
    var payType: Int = 0 //支付方式，取和值（1支付宝，2微信，4银行卡）
    var advertType: Int = 1//广告类型，1卖，2买
    var totalCount: Float = 0//挂币数量
    
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
        
        
        self.view.addSubview(self.keyboard)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.minLimitTextField.text = "\(self.configurationEntity?.sellLimitMin ?? 0)"
        self.maxLimitTextField.text = "\(self.configurationEntity?.sellLimitMax ?? 0)"
        self.priceLabel.text = "\(self.configurationEntity?.platfromSellPrice ?? 0) CNY"
        
        
        self.walletEntity?.list.forEach({ (entity) in
            if entity.coinType == 2 {
                
                self.numberTextField.text = "\(entity.balance)"
                self.feeLabel.text = "\(entity.balance * (self.configurationEntity?.sellRate ?? 0)) USDT"
                self.valueLabel.text = "数量设定(市场参考价：\(entity.balance * (self.configurationEntity?.platfromSellPrice ?? 0)) CNY)"
                
                self.totalCount = entity.balance
            }
        })
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
        }
        
    }
    @IBAction func next(_ sender: Any) {
        
        guard let minText = self.minLimitTextField.text, minText.isEmpty == false, let min = Float(minText) else { return }
        guard let maxText = self.maxLimitTextField.text, maxText.isEmpty == false, let max = Float(maxText) else { return }
        guard let numText = self.numberTextField.text, numText.isEmpty == false, let num = Float(numText) else { return }
        
        self.showMBProgressHUD()
        self.vm.adOtcPublish(advertType: self.advertType, payType: self.payType, limitMin: min, limitMax: max, totalCount: num * (1 - (self.configurationEntity?.sellRate ?? 0))) { (_, msg, isS) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isS == true {
                if let block = self.backBlock {
                    block()
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
}
extension UPayAddAd2ViewController: UITextFieldDelegate,JXKeyboardTextFieldDelegate {
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
        if string == "" {
            return true
        }

        if
            let num = textField.text,
            let numDouble = Float(num + string), numDouble > self.configurationEntity!.sellLimitMax {
            
            textField.text = "\(self.configurationEntity!.sellLimitMax)"
            return false

        } else {
            return true
        }
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
