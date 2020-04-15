//
//  UPayBankViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/25/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import JXFoundation

class UPayBankViewController: UPayBaseViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountTextField: UITextField!{
        didSet{
            
        }
    }
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var bankTextField: UITextField!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            self.addButton.layer.cornerRadius = 4
        }
    }
    
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.accountTextField,self.nameTextField,self.bankTextField])
        
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.textViewDelegate = self
        k.textFieldDelegate = self
        return k
    }()
    
    var vm = UPayReceiptAccountVM()
    
    var imagePicker : UIImagePickerController?
    
    var isSelected = false
    var avatar : String?
    
    var type : Int = 4
    var entity : UPayReceiptCellEntity?
    var isEdit : Bool = false
    var psdText : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.view.addSubview(self.keyboard)
        
        
        self.useLargeTitles = true
        self.customNavigationBar.barTintColor = JXFfffffColor
        let font = UIFont(name: "PingFangSC-Semibold", size: 34) ?? UIFont.systemFont(ofSize: 34)
        self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: JXMainColor,NSAttributedString.Key.font:font]//大标题设置
        self.topConstraint.constant = self.navStatusHeight
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        
        
        if isEdit {
            self.title = "编辑银行卡"
            self.accountTextField.text = self.entity?.account
            self.nameTextField.text = self.entity?.name
            self.bankTextField.text = self.entity?.bank
        } else {
            self.title = "添加银行卡"
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
    }
   
    @IBAction func submit() {
        
        guard let account = self.accountTextField.text else { return }
        guard let name = self.nameTextField.text else { return }
        guard let bank = self.bankTextField.text else { return }
        var id = ""
        if isEdit {
            id = entity?.id ?? ""
        }
        
        let alertVC = UIAlertController(title: "安全验证", message: "", preferredStyle: .alert)
        //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
        alertVC.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "请输入安全密码"
            textField.isSecureTextEntry = true
        })
        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            
            guard
                let textField = alertVC.textFields?[0],
                let psd = textField.text,
                psd.isEmpty == false else {
                    return
            }
            
            
            self.showMBProgressHUD()
            self.vm.addOrEditAccount(id: id, account: account, name: name, type: self.type, bank: bank, businessCardQrcode: "codeImage", safePassword: psd, completion: { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                
                if isSuc {
                    if let block = self.backBlock {
                        block()
                    }
                    ViewManager.showNotice("设置成功")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    ViewManager.showNotice(msg)
                }
            })
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
}

extension UPayBankViewController: JXKeyboardTextFieldDelegate,JXKeyboardTextViewDelegate {
    
    func keyboardTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountTextField {
            nameTextField.becomeFirstResponder()
            return false
        } else if textField == nameTextField {
            bankTextField.becomeFirstResponder()
            return false
        } else if textField == bankTextField {
            self.submit()
            return textField.resignFirstResponder()
        }
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textChange(notify: NSNotification) {
        
        if notify.object is UITextField {
            
        }
        self.updateButtonStatus()
    }
    func updateButtonStatus() {
        //登录按钮
        if
            let password = self.nameTextField.text, password.isEmpty == false,
            let password_r = self.accountTextField.text, password_r.isEmpty == false{
            
            self.addButton.isEnabled = true
            self.addButton.backgroundColor = JXMainColor
            self.addButton.setTitleColor(JXFfffffColor, for: .normal)
            self.addButton.layer.borderWidth = 0
            self.addButton.layer.borderColor = UIColor.clear.cgColor
            
        } else {
            self.addButton.isEnabled = false
            self.addButton.backgroundColor = JXViewBgColor
            self.addButton.setTitleColor(JXMainTextColor, for: .normal)
            self.addButton.layer.borderWidth = 1
            self.addButton.layer.borderColor = UIColor.rgbColor(rgbValue: 0xe1e1e1).cgColor
            
        }
    }
}
