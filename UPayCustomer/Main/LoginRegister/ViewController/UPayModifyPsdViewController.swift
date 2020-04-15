//
//  UPayForgetPsdViewController.swift
//  UPay
//
//  Created by 飞亦 on 5/29/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

class UPayModifyPsdViewController: UPayBaseViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            
        }
    }
    @IBOutlet weak var oldPsdTextField: UITextField!{
        didSet{
            //oldPsdTextField.placeholder = LocalizedString(key: "Forget_loginPsdTextField_placeholder")
            oldPsdTextField.rightViewMode = .always
            oldPsdTextField.rightView = {() -> UIView in
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                button.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.setImage(UIImage(named: "open")?.withRenderingMode(.alwaysTemplate), for: .selected)
                button.addTarget(self, action: #selector(switchPsd), for: .touchUpInside)
                button.tintColor = JXMainTextColor
                button.isSelected = false
                button.tag = 1
                return button
            }()
        }
    }
    @IBOutlet weak var psdTextField: UITextField!{
        didSet{
            //psdTextField.placeholder = LocalizedString(key: "Forget_loginPsdTextField_placeholder")
            psdTextField.rightViewMode = .always
            psdTextField.rightView = {() -> UIView in
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                button.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.setImage(UIImage(named: "open")?.withRenderingMode(.alwaysTemplate), for: .selected)
                button.addTarget(self, action: #selector(switchPsd), for: .touchUpInside)
                button.tintColor = JXMainTextColor
                button.isSelected = false
                button.tag = 2
                return button
            }()
        }
    }
    @IBOutlet weak var psdRepeatTextField: UITextField!{
        didSet{
    
            //psdRepeatTextField.placeholder = LocalizedString(key: "Forget_loginPsdTextField_repeat_placeholder")
            psdRepeatTextField.rightViewMode = .always
            psdRepeatTextField.rightView = {() -> UIView in
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                button.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.setImage(UIImage(named: "open")?.withRenderingMode(.alwaysTemplate), for: .selected)
                button.addTarget(self, action: #selector(switchPsd), for: .touchUpInside)
                button.tintColor = JXMainTextColor
                button.isSelected = false
                button.tag = 3
                return button
            }()
        }
    }
    
    @IBOutlet weak var importButton: UIButton!{
        didSet{
            //self.importButton.setTitle(LocalizedString(key: "Import"), for: .normal)
        }
    }

    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.oldPsdTextField,self.psdTextField,self.psdRepeatTextField])
        
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.textFieldDelegate = self
        return k
    }()

    var type : ModifyPsdType = .normalLoginPsd //0第一次
    
    var vm = UPayLoginRegisterVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.title = "修改密码"
        self.useLargeTitles = true
        self.customNavigationBar.barTintColor = JXFfffffColor
        
        self.topConstraint.constant = self.navStatusHeight
        
        self.view.addSubview(self.keyboard)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextView.textDidChangeNotification, object: nil)
        
        self.updateButtonStatus()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let controllers = self.navigationController?.viewControllers {
//            print(controllers)
//            if controllers.count > 1 {
//                self.navigationController?.viewControllers.remove(at: 0)
//            }
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func switchPsd(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.tag == 1 {
            self.oldPsdTextField.isSecureTextEntry = !button.isSelected
        } else if button.tag == 2 {
            self.psdTextField.isSecureTextEntry = !button.isSelected
        } else if button.tag == 3 {
               self.psdRepeatTextField.isSecureTextEntry = !button.isSelected
        }
    }
    
    
    @IBAction func logAction(_ sender: Any) {
        
        guard let oldPassword = self.oldPsdTextField.text, self.validate(oldPassword) == true else {
            ViewManager.showNotice("密码格式错误")
            return
        }
        guard let password = self.psdTextField.text, self.validate(password) == true else {
            ViewManager.showNotice("密码格式错误")
            return
        }
        guard let password_r = self.psdRepeatTextField.text, password == password_r else {
            ViewManager.showNotice("两次输入密码不一致")
            return
        }
        

        self.showMBProgressHUD()

        self.vm.resetPsd(psdType: self.type, oldPassword: oldPassword, newPassword: password, completion: { (_, msg, isSuc) in

            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuc {
//                if let controllers = self.navigationController?.viewControllers {
//                    if controllers.count > 1 {
//                        self.navigationController?.viewControllers.remove(at: 0)
//                    }
//                }
        
                var dict = UserManager.manager.userDict
                dict["resetPsdStatus"] = 2
                let _ = UserManager.manager.saveAccound(dict: dict)
        
                if self.type == .firstLoginPsd {
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let login = storyboard.instantiateViewController(withIdentifier: "setSafePsd") as! UPaySetSafePsdController
                    self.navigationController?.pushViewController(login, animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    
    }
    
    func validate(_ string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,12}$")
        return predicate.evaluate(with: string)
    }
}

extension UPayModifyPsdViewController: JXKeyboardTextFieldDelegate {
    
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == psdTextField {
            psdRepeatTextField.becomeFirstResponder()
            return false
        } else if textField == psdRepeatTextField {
            self.logAction(0)
            return textField.resignFirstResponder()
        }
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == psdTextField || textField == psdRepeatTextField {
            if range.location > 9 {
                return false
            }
        }
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
            let password = self.psdTextField.text, password.isEmpty == false,
            let password_r = self.psdRepeatTextField.text, password_r.isEmpty == false{
            
            self.importButton.isEnabled = true
            self.importButton.backgroundColor = JXMainColor
            
        } else {
            self.importButton.isEnabled = false
            self.importButton.backgroundColor = JXlightBlueColor
            
        }
    }
}
