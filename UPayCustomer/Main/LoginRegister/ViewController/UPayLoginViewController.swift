//
//  UPayLoginViewController.swift
//  UPay
//
//  Created by 飞亦 on 5/29/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation
import SDWebImage

class UPayLoginViewController: UPayBaseViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = 64
        }
    }
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!{
        didSet{
            self.bottomConstraint.constant = kBottomMaginHeight + 25
        }
    }
    @IBOutlet weak var phoneView: UIView!{
        didSet{
            phoneView.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var psdView: UIView!{
        didSet{
            psdView.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var codeView: UIView!{
        didSet{
            codeView.layer.cornerRadius = 4
        }
    }
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var loginPsdTextField: UITextField!{
        didSet{
            
            loginPsdTextField.rightViewMode = .always
            loginPsdTextField.rightView = {() -> UIView in
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                button.setImage(UIImage(named: "close"), for: .normal)
                button.setImage(UIImage(named: "open"), for: .selected)
                button.addTarget(self, action: #selector(switchPsd), for: .touchUpInside)
                button.isSelected = false
                button.tag = 1
                return button
            }()
        }
    }
    @IBOutlet weak var loginCodeTextField: UITextField!{
        didSet{
        
        }
    }
   
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.layer.cornerRadius = 4
        }
    }

    @IBOutlet weak var coderButton: UIButton!{
        didSet{
            let url = URL.init(string: String(format: "%@%@?deviceId=%@&method=login&time=%d", kBaseUrl,ApiString.getImageCode.rawValue,UIDevice.current.uuid,arc4random_uniform(1000000)))
            coderButton.sd_setImage(with: url, for: .normal, completed: nil)
        }
    }
   
    
    var vm = UPayLoginRegisterVM()
 
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.phoneTextField,self.loginPsdTextField,loginCodeTextField])
       
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.textFieldDelegate = self
        k.showBlock = { (h1, h2, view) in
            print(h1,h2,view)
            var height: CGFloat = 0
            if let v = view as? UITextField {
                if v == self.phoneTextField {
                    height = 44 * 4 + 25 * 5 + kBottomMaginHeight
                } else if v == self.loginPsdTextField {
                    height = 44 * 3 + 25 * 4 + kBottomMaginHeight
                } else {
                    height = 44 * 2 + 25 * 3 + kBottomMaginHeight
                }
            }
            let scrollViewHeight = kScreenHeight
            let normalOffset = fabsf(Float(self.mainScrollView.contentSize.height - scrollViewHeight))
            let offset = fabsf(Float(height - (h1 + h2)))
            
            let showHeight = CGFloat(offset + normalOffset) + 44

            UIView.animate(withDuration: 0.25, animations: {
                self.mainScrollView.contentOffset = CGPoint(x: 0, y: showHeight)
            }) { (finish) in
                
            }
        }
        k.closeBlock = {
            UIView.animate(withDuration: 0.25, animations: {
                self.mainScrollView.contentOffset = CGPoint(x: 0, y: 0)
            }) { (finish) in
                
            }
        }
        return k
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.customNavigationBar.removeFromSuperview()
        self.view.addSubview(self.keyboard)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        
//        self.phoneTextField.text = "13812345678"
//        self.loginPsdTextField.text = "qweasd123"//asdqwe123
        
        self.phoneTextField.text = "13800010004"
        self.loginPsdTextField.text = "qweasd123"//asdqwe123
    
        self.updateButtonStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let controllers = self.navigationController?.viewControllers {
            if controllers.count > 1 {
                self.navigationController?.viewControllers.remove(at: 0)
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    lazy var maskView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.rgbColor(rgbValue: 0x000000, alpha: 0.4)
        return v
    }()
    @objc func switchPsd(button: UIButton) {
        
        button.isSelected = !button.isSelected
        if button.isSelected {
            self.loginPsdTextField.isSecureTextEntry = false
        }else{
            self.loginPsdTextField.isSecureTextEntry = true
        }
        
    }
    @IBAction func switchCode(_ sender: Any) {
        let url = URL.init(string: String(format: "%@%@?deviceId=%@&method=login&time=%d", kBaseUrl,ApiString.getImageCode.rawValue,UIDevice.current.uuid,arc4random_uniform(1000000)))
        coderButton.sd_setImage(with: url, for: .normal, completed: nil)
    }

    @IBAction func logAction(_ sender: Any) {
    
        guard let user = self.phoneTextField.text, user.count >= 5  else {
            ViewManager.showNotice(LocalizedString(key: "Notice_nameError"))
            return
        }
        guard let password = self.loginPsdTextField.text, password.count >= 6 else {
            ViewManager.showNotice(LocalizedString(key: "Notice_passwordError"))
            return
        }
        guard let code = self.loginCodeTextField.text, code.isEmpty == false else {
            ViewManager.showNotice(LocalizedString(key: "Notice_passwordError"))
            return
        }

//        if self.validate(password) == false {
//            ViewManager.showNotice("密码格式错误")
//            return
//        }
        self.showMBProgressHUD()

        self.vm.login(userName: user, password: password, imgCode: code) { (_, msg, isSuccess) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuccess {
                
                
                if UserManager.manager.userEntity.resetPsdStatus == 1 {
                    //优先重置登录密码
                    let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "modifyPsd") as! UPayModifyPsdViewController
                    vc.hidesBottomBarWhenPushed = true
                    vc.type = .firstLoginPsd
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if UserManager.manager.userEntity.resetSafePsdStatus == 1 {
                    //其次设置安全密码
                    let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "setSafePsd") as! UPaySetSafePsdController
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if UserManager.manager.userEntity.validStatus == 1 {
                    //最后再根据认证状态来跳转不同的显示页面
                    
                    //未认证
                    let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "cert") as! UPayCertViewController
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if UserManager.manager.userEntity.validStatus == 2 {
                    //认证中
                    let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "certResult") as! UPayCertResultController
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if UserManager.manager.userEntity.validStatus == 3 {
                    //已认证
                    
                    if let root = UIViewController.rootViewController, root == self.navigationController {
                        let mainSb = UIStoryboard(name: "Main", bundle: nil)
                        let rootViewC = mainSb.instantiateViewController(withIdentifier: "tabbar") as! UPayTabBarViewController
                        LanaguageManager.shared.reset(rootViewC)
                    } else {
//                        self.dismiss(animated: true, completion: {
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationLoginStatus"), object: true)
//                        })
                    }
//                    self.dismiss(animated: true, completion: {
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationLoginStatus"), object: true)
//                    })
                } else if UserManager.manager.userEntity.validStatus == 4 {
                    //认证失败
                    let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "cert") as! UPayCertViewController
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
            }
        }
    }
    
    func validate(_ string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$")
        return predicate.evaluate(with: string)
    }
}

extension UPayLoginViewController: UITextFieldDelegate,JXKeyboardTextFieldDelegate {
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTextField {
            loginPsdTextField.becomeFirstResponder()
            return false
        } else if textField == loginPsdTextField {
            self.logAction(0)
            textField.resignFirstResponder()
            return true
        }
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField || textField == loginPsdTextField  {
//            if range.location > 9 {
//                return false
//            }
        }
        return true
    }
    @objc func textChange(notify: NSNotification) {
        
        if notify.object is UITextField {
            self.updateButtonStatus()
        }
    }
    func updateButtonStatus() {
        //登录按钮
        if
            let name = self.phoneTextField.text, name.isEmpty == false,
            let password = self.loginPsdTextField.text, password.isEmpty == false,
            let code = self.loginCodeTextField.text, code.isEmpty == false{
            
            self.loginButton.isEnabled = true
            self.loginButton.backgroundColor = JXFfffffColor
            
        } else {
            self.loginButton.isEnabled = false
            self.loginButton.backgroundColor = JXlightBlueColor
            
        }
    }
}

