//
//  UPayOrderBuyDetailController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 10/4/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import MBProgressHUD
import JXFoundation

class UPayOrderBuyingDetailController: UPayBaseViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timeCountLabel: UILabel!
    
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var coinImageView: UIImageView!
    
    
    @IBOutlet weak var toAccountLabel: UILabel!
    @IBOutlet weak var toNameLabel: UILabel!
    @IBOutlet weak var toBankLabel: UILabel!
    
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var orderReturnLabel: UILabel!
    @IBOutlet weak var orderFeeLabel: UILabel!
    
    @IBOutlet weak var fromNumTextField: UITextField!
    @IBOutlet weak var fromNameTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var copy1Button: UIButton!
    @IBOutlet weak var copy2Button: UIButton!
    @IBOutlet weak var copy3Button: UIButton!
    
    
    @IBOutlet weak var infoLabel: UILabel!
 
    
    
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
   
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.fromNumTextField,self.fromNameTextField])
        
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.useTitleNotice = true
        k.textFieldDelegate = self
        
        k.showBlock = { (h1, h2, view) in
            print(h1,h2,view)
            var height: CGFloat = 0
            if let v = view as? UITextField {
                if v == self.fromNumTextField {
                    height = 74 * 2
                } else if v == self.fromNameTextField {
                    height = 74 * 1
                }
            }
            let scrollViewHeight = kScreenHeight - 80 - 54 - kBottomMaginHeight - self.navStatusHeight - self.heightConstraint.constant
            let normalOffset = fabsf(Float(self.mainScrollView.contentSize.height - scrollViewHeight))
            let offset = fabsf(Float(height - (h1 + h2 - (80 + 54 + kBottomMaginHeight))))
            
            self.showHeight = CGFloat(offset + normalOffset)

            UIView.animate(withDuration: 0.25, animations: {
                self.mainScrollView.contentOffset = CGPoint(x: 0, y: self.showHeight)
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
    
    var entity: UPayOrderBuyOrSellDetailEntity? {
        didSet{
        
        }
    }
    
    var vm = UPayHomeVM()
    
    var imagePicker : UIImagePickerController?
    var isSelected = false
    
    var shouldRefresh: Bool = false
    var showHeight: CGFloat = 0
    
    var timer : DispatchSourceTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = JXFfffffColor
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        //1待支付，2待确认，3待仲裁，4已完成，5已关闭，7待回滚，9预约回滚
        if let entity = entity {
            switch entity.orderStatus {
            case 1:
                self.title = "待支付"
            case 2:
                self.title = "待确认"
            case 3:
                self.title = "待仲裁"
            case 4:
                self.title = "已完成"
            case 5:
                self.title = "已关闭"
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
        
        self.useLargeTitles = true
//        if #available(iOS 13.0, *) {
//            self.customNavigationBar.standardAppearance.backgroundColor = JXMainColor
//        } else {
//            // Fallback on earlier versions
//            self.customNavigationBar.barTintColor = JXMainColor
//        }
        self.customNavigationBar.backgroundView.backgroundColor = JXMainColor
        let font = UIFont.boldSystemFont(ofSize: 34)
        self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: JXFfffffColor,NSAttributedString.Key.font:font]//大标题设置
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 10, y: 7, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.tintColor = JXFfffffColor
        leftButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        self.view.addSubview(self.keyboard)
        

        guard let entity = entity else { return }

        self.priceLabel.text = "¥ \(entity.buyPrice)"
        self.numLabel.text = "\(entity.buyCoinCount) USDT"
        self.valueLabel.text = "¥ \(entity.totalAmount)"
        //self.coinNameLabel.text = entity.co
        
        self.toAccountLabel.text = entity.account
        self.toNameLabel.text = entity.name
        self.toBankLabel.text = entity.bank
        
        self.orderNumLabel.text = entity.orderNum
        self.orderReturnLabel.text = "\(entity.cmCommision + entity.extraCommision) USDT"
        //self.orderReturnLabel.text = "\(entity.cmCommision + entity.extraCommision) USDT" //补贴 tradeType == 4
        self.orderFeeLabel.text = "\(entity.fee) USDT"
        
        
        if let _ = entity.payerName {
            self.fromNumTextField.text = entity.payerAccount
            self.fromNameTextField.text = entity.payerName
        } else {
            self.fromNumTextField.placeholder = ""
            self.fromNameTextField.placeholder = ""
        }
        
        if let s = entity.transferVoucher {
            self.imageView.sd_setImage(with: URL(string: s), completed: nil)
        }
        
        if entity.orderStatus == 1 {
            self.heightConstraint.constant = 30
            
            self.fromNumTextField.isEnabled = true
            self.fromNameTextField.isEnabled = true
            self.selectButton.isHidden = false
            
            self.infoLabel.text = "请于订单计时结束前转账至指定账户，并“我已付款成功”，否则系统 将自动取消交易"
            self.confirmButton.setTitle("我已成功付款", for: .normal)
            self.cancelButton.setTitle("取消订单", for: .normal)
        } else if entity.orderStatus == 2 {
            self.heightConstraint.constant = 0
            self.timeCountLabel.isHidden = true
            
            self.fromNumTextField.isEnabled = false
            self.fromNameTextField.isEnabled = false
            self.selectButton.isHidden = true
            
           
            self.infoLabel.text = "请根据收款信息核实款项是否收到，如确认未收到款项到账，千万不要点击“我已收款成功”"
            self.confirmButton.setTitle("我已成功收款", for: .normal)
            self.cancelButton.setTitle("未收到款", for: .normal)
        }
        
        var timeInter: Int = 0
                    
        if entity.isBuy {
            if entity.tradeType == 1 {
                timeInter = entity.closeTimes / 1000
            } else {
                timeInter = entity.merSellAutoCloseTimes / 1000
            }
            if timeInter > 0 {
                self.cancelButton.isEnabled = false
                
                self.timer = JXFoundationHelper.shared.countDown(timeOut: timeInter, process: { (process) in
                    let str = self.getCountDownFormatStr(timeInterval: process)
                    self.timeCountLabel.text = self.getCountDownCustomStr1(str: str)
                    print("订单详情",process)
                }) {
                    self.updateOrder()
                    self.timeCountLabel.text = "请尽快完成付款"
                }
            }
        } else {
            timeInter = entity.submitArbitrationTimes / 1000
            if timeInter > 0 {
                self.cancelButton.isEnabled = false
                
                self.timer = JXFoundationHelper.shared.countDown(timeOut: timeInter, process: { (process) in
                    let str = self.getCountDownFormatStr(timeInterval: process)
                    self.cancelButton.setTitle(self.getCountDownCustomStr2(str: str), for: .normal)
                    print("订单详情",process)
                }) {
                    self.cancelButton.isEnabled = true
                    self.cancelButton.setTitle("未收到款", for: .normal)
                }
            }
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let lists = self.navigationController?.viewControllers, lists.count > 2 {
            self.navigationController?.viewControllers.remove(at: lists.count - 2)
        }
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = self.navStatusHeight
        //self.heightConstraint.constant = self.navStatusHeight
        self.bottomConstraint.constant = kBottomMaginHeight
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    deinit {
        self.timer?.cancel()
        self.timer = nil
    }
    @objc func back() {
        if let block = self.backBlock {
            block()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func copyAction1(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.toAccountLabel.text
        ViewManager.showNotice("已复制")
    }
    @IBAction func copyAction2(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.toNameLabel.text
        ViewManager.showNotice("已复制")
    }
    @IBAction func copyAction3(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.entity?.orderNum
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
        guard let entity = self.entity else { return }
        
        self.showMBProgressHUD()
        if entity.isBuy {
            self.vm.orderCancelOrClose(id: entity.id ?? "") { (_, msg, isSuc) in
                if isSuc {
                    self.vm.orderBuyOrSellDetail(id: self.entity?.id ?? "") { (_, message, isSuccess) in
                        self.hideMBProgressHUD()
                        if isSuccess {
                            if self.vm.orderBuyOrSellDetailEntity.isBuy {
                                let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "orderBuyedDetailController") as! UPayOrderBuyedDetailController
                                vc.entity = self.vm.orderBuyOrSellDetailEntity
                                vc.backBlock = self.backBlock
                                
                                vc.hidesBottomBarWhenPushed = true
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "orderBuyedDetailController") as! UPayOrderBuyedDetailController
                                vc.entity = self.vm.orderBuyOrSellDetailEntity
                                vc.backBlock = self.backBlock
                                
                                vc.hidesBottomBarWhenPushed = true
                                self.navigationController?.pushViewController(vc, animated: true)
                            }

                        } else {
                            ViewManager.showNotice(message)
                        }
                    }
                } else {
                    self.hideMBProgressHUD()
                    ViewManager.showNotice(msg)
                }
            }
        } else {
            self.vm.orderConfirmOrNot(id: entity.id ?? "", code: 1) { (_, msg, isSuc) in

                if isSuc {
                    self.vm.orderBuyOrSellDetail(id: self.entity?.id ?? "") { (_, message, isSuccess) in
                        self.hideMBProgressHUD()
                        if isSuccess {
                            let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "orderBuyedDetailController") as! UPayOrderBuyedDetailController
                            vc.entity = self.vm.orderBuyOrSellDetailEntity
                            vc.backBlock = self.backBlock
                            
                            vc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            ViewManager.showNotice(message)
                        }
                    }
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    ViewManager.showNotice(msg)
                }
            }
        }
    }
    @IBAction func confirmAction(_ sender: Any) {
        
        guard let entity = self.entity else { return }
        
        if entity.isBuy {
            
            guard let account = self.fromNumTextField.text else { return }
            guard let name = self.fromNameTextField.text else { return }
            //guard let bank = self.fromBankTextField.text else { return }

            guard let image = self.imageView.image, isSelected == true else {
                ViewManager.showNotice("请添加付款凭证")
                return
            }
            let _ = UIImage.insert(image: image, name: "payImage.jpg")
            
            self.showMBProgressHUD()
            self.vm.orderConfirm(id: entity.id ?? "", transferVoucher: "payImage", payerName: name, payerAccount: account) { (_, msg, isSuc) in

                let _ = UIImage.delete(name: "payImage.jpg")
                if isSuc {
                    self.vm.orderBuyOrSellDetail(id: self.entity?.id ?? "") { (_, message, isSuccess) in
                        self.hideMBProgressHUD()
                        if isSuccess {
                            let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "orderBuyedDetailController") as! UPayOrderBuyedDetailController
                            vc.entity = self.vm.orderBuyOrSellDetailEntity
                            vc.backBlock = self.backBlock
                            
                            vc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            ViewManager.showNotice(message)
                        }
                    }
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    ViewManager.showNotice(msg)
                }
            }
        } else {
            self.showMBProgressHUD()
            self.vm.orderConfirmOrNot(id: entity.id ?? "", code: 2) { (_, msg, isSuc) in

                if isSuc {
                    self.vm.orderBuyOrSellDetail(id: self.entity?.id ?? "") { (_, message, isSuccess) in
                        self.hideMBProgressHUD()
                        if isSuccess {
                            let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "orderBuyedDetailController") as! UPayOrderBuyedDetailController
                            vc.entity = self.vm.orderBuyOrSellDetailEntity
                            vc.backBlock = self.backBlock
                            
                            vc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            ViewManager.showNotice(message)
                        }
                    }
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    ViewManager.showNotice(msg)
                }
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
    func getCountDownFormatStr(timeInterval: Int) -> String {
        if timeInterval <= 0 {
            return ""
        }
        let days = timeInterval / (3600 * 24)
        let hours = (timeInterval - days * 24 * 3600) / 3600
        let minutes = (timeInterval - days * 24 * 3600 - hours * 3600) / 60
        let seconds = timeInterval - days * 24 * 3600 - hours * 3600 - minutes * 60
        
        var timeStr : String = ""
        if days > 0 {
            timeStr = String(format: "%zd天%zd小时%zd分%zd秒", days,hours,minutes,seconds)
        } else {
            if hours > 0 {
                timeStr =  String(format: "%zd小时%zd分%zd秒", hours,minutes,seconds)
            } else {
                if minutes > 0 {
                    timeStr =  String(format: "%zd分%zd秒", minutes,seconds)
                } else {
                    timeStr =  String(format: "%zd秒", seconds)
                }
            }
        }
        return timeStr
    }
    func getCountDownCustomStr2(str: String) -> String {
        if str.isEmpty {
            return ""
        }
        return "未收到款(\(str))"
    }
    func getCountDownCustomStr1(str: String) -> String {
        if str.isEmpty {
            return ""
        }
        return "请在\(str)内完成付款"
    }
    func updateOrder() {
        guard let entity = self.entity else { return }
        
        self.vm.orderBuyOrSellDetail(id: entity.id ?? "") { (_, message, isSuccess) in
            if isSuccess {
                let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "orderBuyedDetailController") as! UPayOrderBuyedDetailController
                vc.entity = self.vm.orderBuyOrSellDetailEntity
                vc.backBlock = self.backBlock
                vc.shouldRefresh = true
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                ViewManager.showNotice(message)
            }
        }
    }
}
extension UPayOrderBuyingDetailController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
extension UPayOrderBuyingDetailController: JXKeyboardTextFieldDelegate {
    
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fromNumTextField {
            fromNameTextField.becomeFirstResponder()
            return false
        } else if textField == fromNameTextField {
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

}
