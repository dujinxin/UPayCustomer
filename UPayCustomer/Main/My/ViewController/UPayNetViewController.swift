//
//  UPayNetViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/25/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import JXFoundation

class UPayNetViewController: UPayBaseViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var deleteButton: UIButton!{
        didSet{
            self.deleteButton.backgroundColor = UIColor.clear
            self.deleteButton.setImage(UIImage(named: "icon-delete")?.withRenderingMode(.automatic), for: .normal)
            //self.deleteButton.tintColor = JXMainColor
        }
    }
    @IBOutlet weak var codeImageView: UIImageView!{
        didSet{
            self.codeImageView.isUserInteractionEnabled = true
            self.codeImageView.image = UIImage(named: "img-upload")?.withRenderingMode(.alwaysTemplate)
            self.codeImageView.tintColor = JXMain60TextColor
            self.codeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(select(tap:))))
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            
        }
    }
    @IBOutlet weak var accountTextField: UITextField!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            self.addButton.layer.cornerRadius = 4
        }
    }
    
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.nameTextField,self.accountTextField])
       
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
    
    var type : Int = 1
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
        
        if type == 1 {
            self.title = (self.isEdit == false) ? "添加支付宝" : "编辑支付宝"
            //self.accountTextField.attributedPlaceholder = NSAttributedString(string: "请输入支付宝账号", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:JXPlaceHolerColor])
        } else {

            self.title = (self.isEdit == false) ? "添加微信" : "编辑微信"
            //self.accountTextField.attributedPlaceholder = NSAttributedString(string: "请输入微信账号", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:JXPlaceHolerColor])
        }
        self.useLargeTitles = true
        self.customNavigationBar.barTintColor = JXFfffffColor
        let font = UIFont.boldSystemFont(ofSize: 34)
        self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: JXMainColor,NSAttributedString.Key.font:font]//大标题设置
        self.topConstraint.constant = self.navStatusHeight
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        
        
        if isEdit {
            self.nameTextField.text = self.entity?.name
            self.accountTextField.text = self.entity?.account
            if let str = self.entity?.businessCardQrcode, str.hasPrefix("http") {
                let url = URL(string: str)
                self.codeImageView.sd_setImage(with: url, completed: nil)
                self.deleteButton.isHidden = false
            } else {
                self.deleteButton.isHidden = true
            }
        } else {
            self.deleteButton.isHidden = true
        }
        
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
    
    @objc func select(tap: UITapGestureRecognizer) {
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (action) in
            self.showImagePickerViewController(.camera)
        }))
        alert.addAction(UIAlertAction(title: "相册", style: .default, handler: { (action) in
            self.showImagePickerViewController(.photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func deleteImage(_ sender: Any) {
        self.codeImageView.image = UIImage(named: "img-upload")?.withRenderingMode(.alwaysTemplate)
        self.deleteButton.isHidden = true
    }
    @IBAction func submit() {
        
        guard let account = self.accountTextField.text else { return }
        guard let name = self.nameTextField.text else { return }
        var id = ""
        if isEdit {
            id = entity?.id ?? ""
        }

        guard let image = self.codeImageView.image, isSelected == true else {
            ViewManager.showNotice("请添加收款二维码")
            return
        }
        let _ = UIImage.insert(image: image, name: "codeImage.jpg")
        
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
            self.vm.addOrEditAccount(id: id, account: account, name: name, type: self.type, bank: "", businessCardQrcode: "codeImage", safePassword: psd, completion: { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                let _ = UIImage.delete(name: "codeImage.jpg")
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
    @objc func hideImagePickerViewContorller(){
        self.imagePicker?.dismiss(animated: true, completion: nil)
    }
}
extension UPayNetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
            self.codeImageView.image = image
            isSelected = true
            self.deleteButton.isHidden = false
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
extension UPayNetViewController: JXKeyboardTextFieldDelegate,JXKeyboardTextViewDelegate {
    
    func keyboardTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            accountTextField.becomeFirstResponder()
            return false
        } else if textField == accountTextField {
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
