//
//  UPayCertViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/21/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import JXFoundation

class UPayCertViewController: UPayBaseViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var idForwardButton: UIButton!{
        didSet{
            //self.importButton.setTitle(LocalizedString(key: "Import"), for: .normal)
        }
    }
    @IBOutlet weak var idBackButton: UIButton!{
        didSet{
            //self.importButton.setTitle(LocalizedString(key: "Import"), for: .normal)
        }
    }
    @IBOutlet weak var idForwardImageView: UIImageView!{
        didSet{
            //self.importButton.setTitle(LocalizedString(key: "Import"), for: .normal)
        }
    }
    @IBOutlet weak var idBackImageView: UIImageView!{
        didSet{
            //self.importButton.setTitle(LocalizedString(key: "Import"), for: .normal)
        }
    }
    
    @IBOutlet weak var psdTextField: UITextField!{
        didSet{
            
        }
    }
    @IBOutlet weak var psdRepeatTextField: UITextField!{
        didSet{
           
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
    
    var isFront : Bool = true
    var imagePicker : UIImagePickerController?
    
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
    
    @IBAction func idFrontAction(button: UIButton) {
        self.selectShow(true)
    }
    @IBAction func idBackAction(button: UIButton) {
        self.selectShow(false)
    }
    
    func selectShow(_ isFront: Bool) {
        self.isFront = isFront
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (action) in
            self.showImagePickerViewController(.camera)
        }))
        alert.addAction(UIAlertAction(title: "相册", style: .default, handler: { (action) in
            self.showImagePickerViewController(.photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            //self.dismiss(animated: true, completion: nil)
            self.imagePicker?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func showImagePickerViewController(_ sourceType:UIImagePickerController.SourceType) {
        self.imagePicker = UIImagePickerController()
        imagePicker?.title = "选择照片"
        //        imagePicker.navigationBar.barTintColor = UIColor.blue
        imagePicker?.navigationBar.tintColor = JXMainColor
        //print(self.imagePicker?.navigationItem.rightBarButtonItem!)
        
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = true
        imagePicker?.sourceType = sourceType
        self.present(imagePicker!, animated: true, completion: nil)
    }
    
    @IBAction func logAction(_ sender: Any) {
        
        guard let name = self.psdTextField.text, name.isEmpty == false else {
            ViewManager.showNotice("请输入姓名")
            return
        }
        guard let idCode = self.psdRepeatTextField.text, idCode.count == 18 else {
            ViewManager.showNotice("身份证号输入有误，请重新输入")
            return
        }
        
        self.showMBProgressHUD()
        
        self.vm.certId(id: "", realName: name, cardNum: idCode, positiveImg: "idCardFront", backImg: "idCardBack") { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuc {
                let _ = UIImage.delete(name: "idCardFront.jpg")
                let _ = UIImage.delete(name: "idCardBack.jpg")
                
                //                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                //                let login = storyboard.instantiateViewController(withIdentifier: "login") as! UPayLoginViewController
                //                self.navigationController?.pushViewController(login, animated: true)
                
            }
        }
        
    }
    
    func validate(_ string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$")
        return predicate.evaluate(with: string)
    }
}
extension UPayCertViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    //        let button = UIButton()
    //        button.frame = CGRect(x: 0, y: 0, width: 44, height: 30)
    //        button.setTitle("取消", for: .normal)
    //        button.setTitleColor(UIColor.darkGray, for: .normal)
    //        let item = UIBarButtonItem.init(customView: button)
    //
    //        viewController.navigationItem.rightBarButtonItem = item//UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(hideImagePickerViewContorller))
    //    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as! String
        if mediaType == "public.image",let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
        
            //UIImage.image(originalImage: image, to: view.bounds.width)
            
            if self.isFront == true {
                self.idForwardImageView.image = image
                let _ = UIImage.insert(image: image, name: "idCardFront.jpg")
                
            } else {
                //identifyVM.backImage = cardImage
                self.idBackImageView.image = image
                let _  = UIImage.insert(image: image, name: "idCardBack.jpg")
            }
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
}
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
extension UPayCertViewController: JXKeyboardTextFieldDelegate,JXKeyboardTextViewDelegate {
    
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
        if textField == psdRepeatTextField {
            if range.location > 17 {
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
