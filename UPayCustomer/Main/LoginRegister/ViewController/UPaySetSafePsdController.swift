//
//  UPaySetSafePsdController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/21/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import JXFoundation

class UPaySetSafePsdController: UPayBaseViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            
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
                button.tag = 1
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
                button.tag = 2
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
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.psdTextField,self.psdRepeatTextField])
        
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.textViewDelegate = self
        k.textFieldDelegate = self
        return k
    }()
    
    var vm = UPayLoginRegisterVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.title = "设置密码"
        self.useLargeTitles = true
        
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
//            if controllers.count > 2 {
//                self.navigationController?.viewControllers.remove(at: 1)
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
            self.psdTextField.isSecureTextEntry = !button.isSelected
        } else if button.tag == 2 {
            self.psdRepeatTextField.isSecureTextEntry = !button.isSelected
        }
    }
    
    
    @IBAction func logAction(_ sender: Any) {
        
        guard let password = self.psdTextField.text, self.validate(password) == true else {
            ViewManager.showNotice("密码格式错误")
            return
        }
        guard let password_r = self.psdRepeatTextField.text, password == password_r else {
            ViewManager.showNotice("两次输入密码不一致")
            return
        }

        self.showMBProgressHUD()

        self.vm.setSafePsd(safePwd: password) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuc {
        
                var dict = UserManager.manager.userDict
                dict["resetSafePsdStatus"] = 2
                let _ = UserManager.manager.saveAccound(dict: dict)
        
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let login = storyboard.instantiateViewController(withIdentifier: "cert") as! UPayCertViewController
                self.navigationController?.pushViewController(login, animated: true)
                
            }
        }
        
    }
    
    func validate(_ string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,12}$")
        return predicate.evaluate(with: string)
    }
}

extension UPaySetSafePsdController: JXKeyboardTextFieldDelegate,JXKeyboardTextViewDelegate {
    
    func keyboardTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
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
