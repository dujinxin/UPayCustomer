//
//  UPayExportViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/25/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import JXFoundation

class UPayExportViewController: UPayBaseViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            
        }
    }
    @IBOutlet weak var selectHeightConstraint: NSLayoutConstraint!{
        didSet{
            self.selectHeightConstraint.constant = 40
        }
    }
    @IBOutlet weak var selectView: UIView!{
        didSet{
            selectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectAddress)))
        }
    }
    
    @IBOutlet weak var addressTypeLabel: UILabel!
    
    @IBOutlet weak var addressTextField: UITextField!{
        didSet{
            
        }
    }
    @IBOutlet weak var numTextField: UITextField!{
        didSet{
            
        }
    }
    @IBOutlet weak var scanButton: UIButton!{
        didSet{
            //self.importButton.setTitle(LocalizedString(key: "Import"), for: .normal)
        }
    }
    @IBOutlet weak var allButton: UIButton!{
        didSet{
            //self.importButton.setTitle(LocalizedString(key: "Import"), for: .normal)
        }
    }
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var toNumLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    
    @IBOutlet weak var exportButton: UIButton!{
        didSet{
            exportButton.layer.cornerRadius = 4
        }
    }
    
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.addressTextField,self.numTextField])
        
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.textViewDelegate = self
        k.textFieldDelegate = self
        return k
    }()
    
    var propertyEntity: UPayCoinPropertyEntity?
    var coinEntity: UPayCoinCellEntity?
    
    var vm = UPayWalletVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.title = "提币"
        self.useLargeTitles = true
        self.customNavigationBar.barTintColor = JXFfffffColor
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 10, y: 7, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "records")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.tintColor = JXMainColor
        leftButton.addTarget(self, action: #selector(record), for: .touchUpInside)
        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        self.topConstraint.constant = self.navStatusHeight
        
        self.view.addSubview(self.keyboard)
        
        self.balanceLabel.text = "数量 可用\(self.propertyEntity?.balance ?? 0) \(self.propertyEntity?.symbol ?? "")"
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        self.addObserver(self, forKeyPath: "text", options: [.old,.new], context: nil)
        
        if self.coinEntity?.coinType == 2 {
            self.addressTypeLabel.text = "OMNI"
        } else {
            self.selectView.removeAllSubView()
            self.selectHeightConstraint.constant = 0
            self.selectView.isUserInteractionEnabled = false
        }
        self.updateButtonStatus()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.removeObserver(self, forKeyPath: "text")
    }
    @objc func record() {
        let vc = UPayExportRecordsController()
        vc.coinType = self.propertyEntity?.coinType ?? 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func selectAddress() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OMNI", style: .default, handler: { (action) in
            
            self.addressTypeLabel.text = "OMNI"
//            self.addressLabel.text = self.propertyEntity?.address
//            self.codeImageView.image = self.code(self.propertyEntity?.address ?? "")
        }))
        alert.addAction(UIAlertAction(title: "ERC20", style: .default, handler: { (action) in
            
            self.addressTypeLabel.text = "ERC20"
//            self.addressLabel.text = self.propertyEntity?.ethAddress
//            self.codeImageView.image = self.code(self.propertyEntity?.ethAddress ?? "")
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func scanAction(_ sender: Any) {
        
    }
    
    @IBAction func allAction(_ sender: Any) {
        guard let e = self.propertyEntity else { return }
        guard let coin = self.coinEntity else { return }
        self.numTextField.text = "\(e.balance)"
        
        let fee = coin.outgoFeeRate * e.balance
        if coin.outgoFeeMin > fee {

            self.feeLabel.text = "\(coin.outgoFeeMin) \(coin.symbol ?? "")"
            if e.balance > coin.outgoFeeMin {
                self.toNumLabel.text = "\(e.balance - coin.outgoFeeMin) \(coin.symbol ?? "")"
            } else {
                self.toNumLabel.text = "\(0) \(coin.symbol ?? "")"
            }
        } else {
            self.toNumLabel.text = "\(e.balance - fee) \(coin.symbol ?? "")"
            self.feeLabel.text = "\(fee) \(coin.symbol ?? "")"
            
            if e.balance > coin.outgoFeeRate {
                self.toNumLabel.text = "\(e.balance - fee) \(coin.symbol ?? "")"
            } else {
                self.toNumLabel.text = "\(0) \(coin.symbol ?? "")"
            }
        }
        self.updateButtonStatus()
        
    }
    
    @IBAction func exportAction(_ sender: Any) {
        
        guard let address = self.addressTextField.text, address.isEmpty == false else {
            ViewManager.showNotice("请填写地址")
            return
        }
        guard let numStr = self.numTextField.text, numStr.isEmpty == false, let num = Float(numStr) else {
            ViewManager.showNotice("请输入数量")
            return
        }
        
        guard let e = self.propertyEntity else { return }
        
        self.showMBProgressHUD()
        
        self.vm.export(coinType: e.coinType, withdrawCounts: num, targetAddr: address) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuc {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
extension UPayExportViewController: JXKeyboardTextFieldDelegate,JXKeyboardTextViewDelegate {
    
    func keyboardTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == addressTextField {
            numTextField.becomeFirstResponder()
            return false
        } else if textField == numTextField {
            self.exportAction(0)
            return textField.resignFirstResponder()
        }
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        if
            textField == numTextField,
            let e = self.propertyEntity,
            let text = textField.text,
            let num = Float(text + string),
            num >= e.balance {
            
            textField.text = "\(e.balance)"
            return false
        }
        return true
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath,keyPath == "text",let change = change,let newText = change[.newKey] as? String else { return }
        print(newText)
        
        guard let e = self.propertyEntity else { return }
        guard let coin = self.coinEntity else { return }
        //self.numTextField.text = "\(e.balance)"
        guard let number = Float(newText) else { return}
        let fee = coin.outgoFeeRate * number
        if coin.outgoFeeMin > fee {

            self.feeLabel.text = "\(coin.outgoFeeMin) \(coin.symbol ?? "")"
            if e.balance > coin.outgoFeeMin {
                self.toNumLabel.text = "\(number - coin.outgoFeeMin) \(coin.symbol ?? "")"
            } else {
                self.toNumLabel.text = "\(0) \(coin.symbol ?? "")"
            }
        } else {
            self.toNumLabel.text = "\(number - fee) \(coin.symbol ?? "")"
            self.feeLabel.text = "\(fee) \(coin.symbol ?? "")"
            
            if e.balance > coin.outgoFeeRate {
                self.toNumLabel.text = "\(number - fee) \(coin.symbol ?? "")"
            } else {
                self.toNumLabel.text = "\(0) \(coin.symbol ?? "")"
            }
        }
        self.updateButtonStatus()
    }
    @objc func textChange(notify: NSNotification) {
        
        if
            let textField = notify.object as? UITextField,
            textField == numTextField,
            let text = numTextField.text,
            text.isEmpty == false,
            let num = Float(text),
            let coin = self.coinEntity,
            let e = self.propertyEntity {
            
            let fee = coin.outgoFeeRate * num
            
            if coin.outgoFeeMin > fee {
                
                self.feeLabel.text = "\(coin.outgoFeeMin) \(coin.symbol ?? "")"
                if e.balance > coin.outgoFeeMin {
                    if num + coin.outgoFeeMin > e.balance {
                        self.toNumLabel.text = "\(e.balance - coin.outgoFeeMin) \(coin.symbol ?? "")"
                    } else {
                        self.toNumLabel.text = "\(text) \(coin.symbol ?? "")"
                    }
                } else {
                    self.toNumLabel.text = "\(0) \(coin.symbol ?? "")"
                }
                
            } else {
            
                self.feeLabel.text = "\(fee) \(coin.symbol ?? "")"
               
                if e.balance > coin.outgoFeeRate {
                    if num + fee > e.balance {
                        self.toNumLabel.text = "\(e.balance - fee) \(coin.symbol ?? "")"
                    } else {
                        self.toNumLabel.text = "\(text) \(coin.symbol ?? "")"
                    }
                } else {
                    self.toNumLabel.text = "\(0) \(coin.symbol ?? "")"
                }
            }
        }
        self.updateButtonStatus()
    }
    func updateButtonStatus() {
        //登录按钮
        if
            let address = self.addressTextField.text, address.isEmpty == false,
            let numStr = self.numTextField.text, numStr.isEmpty == false, let num = Float(numStr), num > 0 {
            
            self.exportButton.isEnabled = true
            self.exportButton.backgroundColor = JXMainColor
            self.exportButton.setTitleColor(JXFfffffColor, for: .normal)
            self.exportButton.layer.borderWidth = 0
            self.exportButton.layer.borderColor = UIColor.clear.cgColor
            
        } else {
            self.exportButton.isEnabled = false
            self.exportButton.backgroundColor = JXViewBgColor
            self.exportButton.setTitleColor(JXMainTextColor, for: .normal)
            self.exportButton.layer.borderWidth = 1
            self.exportButton.layer.borderColor = UIColor.rgbColor(rgbValue: 0xe1e1e1).cgColor
            
        }
    }
}
