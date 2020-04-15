//
//  UPayBuyPlatformDetailViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/28/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import MBProgressHUD
import JXFoundation

class UPayBuyPlatformDetailViewController: UPayBaseViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var mainScrollView: UIScrollView!{
        didSet{
            self.mainScrollView.delegate = self
        }
    }
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!{
        didSet{
            //self.heightConstraint.constant = kNavStatusHeight
        }
    }
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!{
        didSet{
            self.bottomHeightConstraint.constant = 80 + kBottomMaginHeight
        }
    }
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight
        }
    }
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var toAccountLabel: UILabel!
    @IBOutlet weak var toNameLabel: UILabel!
    @IBOutlet weak var toBankLabel: UILabel!
    
    @IBOutlet weak var fromNumTextField: UITextField!
    @IBOutlet weak var fromNameTextField: UITextField!
    @IBOutlet weak var fromBankTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var copy1Button: UIButton!
    @IBOutlet weak var copy2Button: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!{
        didSet{
            self.cancelButton.backgroundColor = JXViewBgColor
            self.cancelButton.setTitleColor(JXMainTextColor, for: .normal)
            self.cancelButton.layer.cornerRadius = 4
            self.cancelButton.layer.borderWidth = 1
            self.cancelButton.layer.borderColor = UIColor.rgbColor(rgbValue: 0xe1e1e1).cgColor
        }
    }
    
    @IBOutlet weak var confirmButton: UIButton!{
        didSet{
            
            self.confirmButton.backgroundColor = JXMainColor
            self.confirmButton.setTitleColor(JXFfffffColor, for: .normal)
            self.confirmButton.layer.cornerRadius = 4
            self.confirmButton.layer.borderWidth = 1
            self.confirmButton.layer.borderColor = UIColor.clear.cgColor
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.fromNumTextField,self.fromNameTextField,self.fromBankTextField])
//        k.showBlock = { (h1, h2, view) in
//            print(h1,h2,view)
//            var height: CGFloat = 0
//            if let v = view as? UITextField {
//                if v == self.fromNumTextField {
//                    height = 80 + kBottomMaginHeight + 74 * 3
//                } else if v == self.fromNameTextField {
//                    height = 80 + kBottomMaginHeight + 74 * 2
//                } else {
//                    height = 80 + kBottomMaginHeight + 74 * 1
//                }
//            }
//            var normalOffset = fabsf(Float(self.mainScrollView.contentSize.height - kScreenHeight))
////            if self.mainScrollView.contentSize.height > kScreenHeight {
////                normalOffset = self.mainScrollView.contentSize.height - kScreenHeight
////            }
//
//            //self.mainScrollView.contentSize.height -
//            if height - (h1 + h2) > 0 {
//                self.showHeight = height - (h1 + h2) + CGFloat(normalOffset)
//            } else {
//                self.showHeight = CGFloat(0 + normalOffset)
//            }
//
//        }
        
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.useTitleNotice = true
        k.textFieldDelegate = self
        return k
    }()
    
    var entity: UPayBuyPlatformDetailEntity? {
        didSet{
        
        }
    }
    
    var vm = UPayBuyPlatformVM()
    
    var imagePicker : UIImagePickerController?
    var isSelected = false
    
    var showHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = JXFfffffColor
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if let entity = entity {
            if entity.recordStatus != 0 {//平台买币
                //平台买币订单状态，1待支付，2已付款，3已完成，5已取消，7待回滚
                switch entity.recordStatus {
                case 1:
                    self.title = "待支付"
                case 2:
                    self.title = "已付款"
                case 3:
                    self.title = "已完成"
                case 5:
                    self.title = "已取消"
                case 7:
                    self.title = "待回滚"
                default:
                    self.title = "未知状态"
                }
            } else { //托管出金
                //托管出金订单状态，1待支付，2已付款，3待仲裁，4已完成，5已取消，6仲裁币商败诉，7待回滚，8已回滚 ，9预约回滚
                switch entity.orderStatus {
                case 1:
                    self.title = "待支付"
                case 2:
                    self.title = "已付款"
                case 3:
                    self.title = "待仲裁"
                case 4:
                    self.title = "已完成"
                case 5:
                    self.title = "已取消"
                case 6:
                    self.title = "仲裁币商败诉"
                case 7:
                    self.title = "待回滚"
                case 8:
                    self.title = "已回滚"
                case 9:
                    self.title = "预约回滚"
                default:
                    self.title = "未知状态"
                }
            }
            
        }
        
        
        self.useLargeTitles = true
        //self.heightConstraint.constant = self.navStatusHeight
        self.customNavigationBar.barTintColor = JXFfffffColor
        let font = UIFont.boldSystemFont(ofSize: 34)
        self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: JXMainColor,NSAttributedString.Key.font:font]//大标题设置
        
        self.view.addSubview(self.keyboard)
        
        self.keyboard.showBlock = { (h1, h2, view) in
            print(h1,h2,view)
            var height: CGFloat = 0
            if let v = view as? UITextField {
                if v == self.fromNumTextField {
                    height = 80 + kBottomMaginHeight + 74 * 3
                } else if v == self.fromNameTextField {
                    height = 80 + kBottomMaginHeight + 74 * 2
                } else {
                    height = 80 + kBottomMaginHeight + 74 * 1
                }
            }
            let normalOffset = fabsf(Float(self.mainScrollView.contentSize.height - kScreenHeight))
            let offset = fabsf(Float(height - (h1 + h2)))
            
            self.showHeight = CGFloat(offset + normalOffset)
//            if height - (h1 + h2) > 0 {
//                self.showHeight = height - (h1 + h2) + CGFloat(normalOffset)
//            } else {
//                self.showHeight = (h1 + h2) - height + CGFloat(normalOffset)
//            }

            UIView.animate(withDuration: 0.25, animations: {
                self.mainScrollView.contentOffset = CGPoint(x: 0, y: self.showHeight)
            }) { (finish) in
                
            }
        }
        self.keyboard.closeBlock = {
            UIView.animate(withDuration: 0.25, animations: {
                self.mainScrollView.contentOffset = CGPoint(x: 0, y: 0)
            }) { (finish) in
                
            }
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        guard let entity = entity else { return }

        self.priceLabel.text = "¥ \(entity.price)"
        self.numLabel.text = "\(entity.coinCount) USDT"
        self.valueLabel.text = "¥ \(entity.totalAmount)"
        self.timeLabel.text = entity.createDate
        
        self.toAccountLabel.text = entity.account
        self.toNameLabel.text = entity.name
        self.toBankLabel.text = entity.bank
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = self.navStatusHeight
        //self.heightConstraint.constant = self.navStatusHeight
        self.bottomHeightConstraint.constant = 80 + kBottomMaginHeight
    }
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    @IBAction func copy1Action(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.toAccountLabel.text
        ViewManager.showNotice("已复制")
    }
    @IBAction func copy2Action(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.toNameLabel.text
        ViewManager.showNotice("已复制")
    }
    @IBAction func selectAction(_ sender: Any) {
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
    @IBAction func cancelAction(_ sender: Any) {
        self.showMBProgressHUD()
        self.vm.buyPlatformCancel(id: self.entity?.id ?? "") { (_, msg, isSuc) in
            if isSuc {
                self.vm.buyPlatformDetail(id: self.entity?.id ?? "") { (_, msg, isSuc) in
                    self.hideMBProgressHUD()
                    ViewManager.showNotice(msg)
                    if isSuc {
                        let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "buyedPlatformDetail") as! UPayBuyPlatformDetailController
                        vc.shouldRefresh = true
                        vc.backBlock = self.backBlock
                        vc.entity = self.vm.buyPlatformDetailEntity
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } else {
                self.hideMBProgressHUD()
                ViewManager.showNotice(msg)
            }
        }
    }
    @IBAction func confirmAction(_ sender: Any) {
        
        guard let entity = self.entity else { return }
        guard let account = self.fromNumTextField.text else { return }
        guard let name = self.fromNameTextField.text else { return }
        guard let bank = self.fromBankTextField.text else { return }
        
        guard let image = self.imageView.image, isSelected == true else {
            ViewManager.showNotice("请添加付款凭证")
            return
        }
        let _ = UIImage.insert(image: image, name: "payImage.jpg")
        
        let _ = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.vm.buyPlatformConfirm(id: entity.id ?? "", transferVoucher: "payImage", buyerName: name, buyerBank: bank, buyerAccount: account) { (_, msg, isSuc) in
            
            let _ = UIImage.delete(name: "payImage.jpg")
            if isSuc {
                
                self.vm.buyPlatformDetail(id: entity.id ?? "") { (_, msg, isSuc) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    ViewManager.showNotice(msg)
                    if isSuc {
                        let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "buyedPlatformDetail") as! UPayBuyPlatformDetailController
                        vc.shouldRefresh = true
                        vc.backBlock = self.backBlock
                        vc.entity = self.vm.buyPlatformDetailEntity
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                ViewManager.showNotice(msg)
            }
        }
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
extension UPayBuyPlatformDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
            self.imageView.image = image
            isSelected = true
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
extension UPayBuyPlatformDetailViewController: JXKeyboardTextFieldDelegate {
    
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fromNumTextField {
            fromNameTextField.becomeFirstResponder()
            return false
        } else if textField == fromNameTextField {
            fromBankTextField.becomeFirstResponder()
            return false
        } else if textField == fromBankTextField {
            return textField.resignFirstResponder()
        }
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        if textField == fromNumTextField {
            if range.location > 5 {
                return false
            }
        }
        return true
    }
    
    @objc func textChange(notify: NSNotification) {
        
        if notify.object is UITextField {
            
        }
        //self.updateButtonStatus()
    }
    //    func updateButtonStatus() {
    //        if
    //            let text = self.textField.text, text.isEmpty == false {
    //
    //            self.confirmButton.isEnabled = true
    //            self.confirmButton.backgroundColor = JXMainColor
    //            self.confirmButton.setTitleColor(JXFfffffColor, for: .normal)
    //            self.confirmButton.layer.borderWidth = 1
    //            self.confirmButton.layer.borderColor = JXMainColor.cgColor
    //
    //        } else {
    //            self.confirmButton.isEnabled = false
    //            self.confirmButton.backgroundColor = JXViewBgColor
    //            self.confirmButton.setTitleColor(JXMainTextColor, for: .normal)
    //            self.confirmButton.layer.borderWidth = 1
    //            self.confirmButton.layer.borderColor = UIColor.rgbColor(rgbValue: 0xe1e1e1).cgColor
    //
    //        }
    //    }
    
//    @objc func keyboardWillShow(notify:Notification) {
//
//        guard
//            let userInfo = notify.userInfo,
//            let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
//            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
//            else {
//                return
//        }
//        self.keyboard.isHidden = false
//
//        UIView.animate(withDuration: animationDuration, animations: {
//            self.mainScrollView.contentOffset = CGPoint(x: 0, y: self.showHeight)
//
//        }) { (finish) in
//            //
//        }
//    }
//    @objc func keyboardWillHide(notify:Notification) {
//        //print("notify = ","notify")
//        guard
//            let userInfo = notify.userInfo,
//            let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
//            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
//            else {
//                return
//        }
//        self.keyboard.isHidden = true
//        UIView.animate(withDuration: animationDuration, animations: {
//            self.mainScrollView.contentOffset = CGPoint(x: 0, y: 0)
//        }) { (finish) in
//
//        }
//    }
}
