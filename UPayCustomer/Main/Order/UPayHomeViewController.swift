//
//  UPayHomeViewController.swift
//  UPay
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

private let headViewHeight : CGFloat = 44

class UPayHomeViewController: UPayBaseViewController {

   
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = 140
        }
    }
    @IBOutlet weak var propertyBgView: UIView!{
        didSet{
            self.propertyBgView.backgroundColor = JXBlueColor
            
//            propertyBgView.layer.cornerRadius = 4
//            propertyBgView.layer.shadowOpacity = 1
//            propertyBgView.layer.shadowRadius = 7
//            propertyBgView.layer.shadowColor = JXBlueShadow.cgColor
//            propertyBgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
   
    @IBOutlet weak var totalPropertyLabel: UILabel!{
        didSet{
            self.totalPropertyLabel.textColor = JXFfffffColor
        }
    }
   
    @IBOutlet weak var manageButton: UIButton!{
        didSet{
            //self.manageButton.backgroundColor = JXFfffffColor
            //self.manageButton.setTitleColor(JXBlueColor, for: .normal)
            //self.manageButton.setTitle(LocalizedString(key: "Finance"), for: .normal)
            
//            manageButton.layer.cornerRadius = 4
//            manageButton.layer.borderColor = JXFfffffColor.cgColor
//            manageButton.layer.borderWidth = 1
            
        }
    }
    @IBOutlet weak var superNodeButton: UIButton!{
        didSet{
            self.superNodeButton.backgroundColor = JXBlueColor
            self.superNodeButton.setTitleColor(JXFfffffColor, for: .normal)
            //self.superNodeButton.setTitle(LocalizedString(key: "SuperNode"), for: .normal)
            
            superNodeButton.layer.cornerRadius = 15
            superNodeButton.layer.borderColor = JXFfffffColor.cgColor
            superNodeButton.layer.borderWidth = 1
            
        }
    }
    
    @IBOutlet weak var noticeBgView: UIView!
    
    
    var financialManagementBlock : (()->())?
    var superNodeBlock : (()->())?
    
    var dropView: JXSelectView?
    var typeArray = Array<UIButton>()
    var statusArray = Array<UIButton>()
    var isDroping: Bool = false
    var keyboard: JXKeyboardToolBar?
    var textField: UITextField?
    
    var tradeType: Int = 0 //交易类型，1商户买，2商户卖，3币商/币商，4商户自行出金
    var orderStatus: Int = -1//订单状态，0进行中，1待支付，2待确认，3待仲裁，4已完成，5已关闭，7待回滚，9预约回滚
    
    @IBAction func financialManagementAction(_ sender: Any) {
        
        if self.isDroping == true, let drop = self.dropView {
            self.isDroping = false
            drop.dismiss()
            return
        }
        
        self.isDroping = true

        let sel = JXSelectView(frame: CGRect(x: 0, y: 140, width: kScreenWidth, height: 400), style: .custom)
        sel.backgroundColor = JXFfffffColor
        sel.position = .top
        sel.selectViewTop = 140
        sel.tapControl.frame = CGRect(x: 0, y: 140, width: kScreenWidth, height: kScreenHeight - 140)
        sel.bgView.frame = CGRect(x: 0, y: 140, width: kScreenWidth, height: kScreenHeight - 140)
        var height: CGFloat = 0
        sel.customView = {
            let v = UIView()
            v.frame = sel.bounds
            v.backgroundColor = JXFfffffColor
            
            let label1 = UILabel()
            label1.frame = CGRect(x: 20, y: 10, width: v.jxWidth - 40, height: 20)
            label1.text = "交易单号"
            label1.textColor = JXMainTextColor
            label1.textAlignment = .left
            label1.font = UIFont.systemFont(ofSize: 14)
            v.addSubview(label1)
            
            let textField = UITextField(frame: CGRect(x: label1.jxLeft, y: label1.jxBottom + 5, width: label1.jxWidth, height: 36))
            textField.placeholder = "输入交易单号"
            textField.font = UIFont.systemFont(ofSize: 12)
            textField.textColor = JXMainTextColor
            textField.textAlignment = .left
            textField.borderStyle = .roundedRect
            textField.clearButtonMode = .whileEditing
            v.addSubview(textField)
            self.textField = textField
            
            let k = JXKeyboardToolBar(frame: CGRect(), views: [textField])
            k.tintColor = JXGrayTextColor
            k.toolBar.barTintColor = JXViewBgColor
            k.backgroundColor = JXViewBgColor
            k.textFieldDelegate = self
            self.keyboard = k
            
            let label2 = UILabel()
            label2.frame = CGRect(x: label1.jxLeft, y: textField.jxBottom + 10, width: label1.jxWidth, height: 20)
            label2.text = "交易类型"
            label2.textColor = JXMainTextColor
            label2.textAlignment = .left
            label2.font = UIFont.systemFont(ofSize: 14)
            v.addSubview(label2)
            
            self.typeArray.removeAll()
            let typeTitle = ["全部","卖币","买币"]
            let space: CGFloat = 30
            let width = (v.jxWidth - 20 * 2 - space * 2) / 3
            for i in 0..<typeTitle.count {
                let button = UIButton()
                button.frame = CGRect(x: label1.jxLeft + (space + width) * CGFloat(i), y: label2.jxBottom + 5, width: width, height: 30)
                button.setTitle(typeTitle[i], for: .normal)
                button.setTitleColor(JXMainTextColor, for: .normal)
                button.setTitleColor(JXMainColor, for: .selected)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                button.layer.cornerRadius = 2
                button.backgroundColor = UIColor.rgbColor(rgbValue: 0xf5f5ff)
                button.tag = i
                button.addTarget(self, action: #selector(selectType(button:)), for: .touchUpInside)
                v.addSubview(button)
                self.typeArray.append(button)
            }
            
            
            let label3 = UILabel()
            label3.frame = CGRect(x: label1.jxLeft, y: label2.jxBottom + 45, width: v.jxWidth - 20, height: 20)
            label3.text = "订单状态"
            label3.textColor = JXMainTextColor
            label3.textAlignment = .left
            label3.font = UIFont.systemFont(ofSize: 14)
            v.addSubview(label3)
            
            self.statusArray.removeAll()
            let statusTitle = ["全部","待支付","待确认","待仲裁","已完成","已关闭","待回滚","待补币回滚"]
            for i in 0..<statusTitle.count {
                let button = UIButton()
                button.frame = CGRect(x: label1.jxLeft + (space + width) * CGFloat(i % 3), y: label3.jxBottom + 5 + (10 + 30) * CGFloat(i / 3), width: width, height: 30)
                button.setTitle(statusTitle[i], for: .normal)
                button.setTitleColor(JXMainTextColor, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                button.layer.cornerRadius = 2
                button.backgroundColor = UIColor.rgbColor(rgbValue: 0xf5f5ff)
                button.tag = i
                button.addTarget(self, action: #selector(selectStatus(button:)), for: .touchUpInside)
                v.addSubview(button)
                self.statusArray.append(button)
            }
            
            let confirmTitle = ["重置","筛选"]
            let button = self.statusArray.last
            let y = button?.jxBottom ?? 0
            for i in 0..<confirmTitle.count {
                let button = UIButton()
                button.frame = CGRect(x: v.jxWidth / 2 * CGFloat(i), y: y + 15, width: v.jxWidth / 2, height: 40)
                button.setTitle(confirmTitle[i], for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                if i == 0 {
                    button.setTitleColor(JXMainTextColor, for: .normal)
                    button.backgroundColor = UIColor.rgbColor(rgbValue: 0xf5f5ff)
                } else {
                    button.setTitleColor(JXFfffffColor, for: .normal)
                    button.backgroundColor = JXMainColor
                }
                button.addTarget(self, action: #selector(selectConfirm(button:)), for: .touchUpInside)
                button.tag = i
                v.addSubview(button)
            }
            height = y + 15 + 40
            v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
            
            return v
        }()

        sel.frame = CGRect(x: 0, y: 140, width: kScreenWidth, height: height)
        sel.dismissBlock = {
            if let keyboard = self.keyboard {
                keyboard.removeFromSuperview()
            }
        }
        self.dropView = sel
        self.dropView?.show(inView: self.view, below: self.propertyBgView, animate: true)
        
        if let keyboard = self.keyboard {
            self.view.addSubview(keyboard)
        }
        
    }
    @IBAction func superNodeAction(_ sender: Any) {
        let vc = UPayOrderBuyListController()
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    lazy var maskView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.rgbColor(rgbValue: 0x000000, alpha: 0.4)
        return v
    }()
    
    var topBar : JXXBarView!
    var horizontalView : JXHorizontalView!
    var vcArray : Array<UPayOrderRecordsController> = []
    
    var vm = UPayHomeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBgView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        //tabBgView.backgroundColor = JXEeeeeeColor
        self.noticeBgView.addSubview(tabBgView)
        
        let topBar = JXXBarView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width , height: 43), titles: ["进行中","已完成","已取消"])
        topBar.delegate = self
      
        let att = JXAttribute()
        att.normalColor = JXMainColor
        att.selectedColor = JXFfffffColor
        att.backgroundColor = JXMainColor
        att.font = UIFont.systemFont(ofSize: 15)
        
        topBar.attribute = att
        topBar.backgroundColor = JXFfffffColor
        
//        topBar.bottomLineSize = CGSize(width: 36, height: 4)
//        topBar.bottomLineView.backgroundColor = JXMainColor
//        topBar.isBottomLineEnabled = true
        
        tabBgView.addSubview(topBar)
        self.topBar = topBar
        
        
        let rect = CGRect(x: 0, y: 140 + headViewHeight, width: kScreenWidth, height: kScreenHeight - 140 - headViewHeight - kTabBarHeight)
        let vc1 = UPayOrderRecordsController()
        vc1.orderStatus = 0
        //vc1.entity = self.entity
        vc1.refreshBlock = { vm in
            //self.updateValues(vm)
        }
        vc1.scrollViewDidScrollBlock = { scroll in
            //self.tableViewDidScroll(scrollView: scroll)
        }
        let vc2 = UPayOrderRecordsController()
        vc2.orderStatus = 4
        //vc2.entity = self.entity
        vc2.refreshBlock = { vm in
            //self.updateValues(vm)
        }
        vc2.scrollViewDidScrollBlock = { scroll in
            //self.tableViewDidScroll(scrollView: scroll)
        }
        let vc3 = UPayOrderRecordsController()
        vc3.orderStatus = 5
        //vc3.entity = self.entity
        vc3.refreshBlock = { vm in
            //self.updateValues(vm)
        }
        vc3.scrollViewDidScrollBlock = { scroll in
            //self.tableViewDidScroll(scrollView: scroll)
        }
        
        let horizontalView = JXHorizontalView.init(frame: rect, containers: [vc1,vc2,vc3], parentViewController: self)
        self.view.insertSubview(horizontalView, belowSubview: self.noticeBgView)
        self.horizontalView = horizontalView
        self.vcArray = [vc1,vc2,vc3]
        
        
        
        
        
//        if UserManager.manager.isLogin {
//            let v = UPayVersionVM()
//            v.version { (_, msg, isSuc) in
//
//                if isSuc && v.versionEntity.ios_version != Bundle.main.version {
//                    let storyboard = UIStoryboard(name: "My", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "versionAlert") as! UPayVersionAlertController
//                    vc.modalPresentationStyle = .overCurrentContext
//                    vc.modalTransitionStyle = .crossDissolve
//                    vc.entity = v.versionEntity
//
//                    let window = UIWindow()
//                    window.frame = UIScreen.main.bounds
//                    window.windowLevel = UIWindow.Level.alert + 1
//                    window.backgroundColor = UIColor.clear
//                    window.isHidden = false
//                    let root = UIViewController()
//                    root.view.backgroundColor = UIColor.clear
//                    window.rootViewController = root
//
//                    vc.callBackBlock = { isDownload in
//                        window.isHidden = true
//                        if let _ = self.maskView.superview {
//                            self.maskView.removeFromSuperview()
//                        }
//                        if isDownload {
//                            guard
//                                let text = v.versionEntity.ios_url,
//                                let url = URL(string: text) else {
//                                    return
//                            }
//                            if UIApplication.shared.canOpenURL(url) {
//                                if #available(iOS 10.0, *) {
//                                    UIApplication.shared.open(url, options: [:]) { (isTrue) in
//
//                                    }
//                                } else {
//                                    UIApplication.shared.openURL(url)
//                                }
//                            }
//                        }
//
//                    }
//
//                    window.rootViewController?.view.addSubview(self.maskView)
//                    window.rootViewController?.present(vc, animated: true, completion:{
//                        //self.maskView.alpha = 1
//                    })
//
//                }
//            }
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        printf("started")
        
        if UserManager.manager.isLogin {
            
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "login") as! UPayLoginViewController
            let loginVC = UPayNavigationController.init(rootViewController: login)
            login.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: false, completion: nil)
        }
        
//        if UserManager.manager.userEntity.resetPsdStatus == 1 {
//            //优先重置登录密码
//            let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "modifyPsd") as! UPayModifyPsdViewController
//            //vc.hidesBottomBarWhenPushed = true
//            vc.type = .firstLoginPsd
//            //self.navigationController?.pushViewController(vc, animated: true)
//            let nvc = UPayNavigationController.init(rootViewController: vc)
//            self.present(nvc, animated: false, completion: nil)
//        } else if UserManager.manager.userEntity.resetSafePsdStatus == 1 {
//            //其次设置安全密码
//            let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "setSafePsd") as! UPaySetSafePsdController
//            //vc.hidesBottomBarWhenPushed = true
//            //self.navigationController?.pushViewController(vc, animated: true)
//            let nvc = UPayNavigationController.init(rootViewController: vc)
//            self.present(nvc, animated: false, completion: nil)
//        } else if UserManager.manager.userEntity.validStatus == 1 {
//            //最后再根据认证状态来跳转不同的显示页面
//
//            //未认证
//            let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "cert") as! UPayCertViewController
//            //vc.hidesBottomBarWhenPushed = true
//            //self.navigationController?.pushViewController(vc, animated: true)
//            let nvc = UPayNavigationController.init(rootViewController: vc)
//            self.present(nvc, animated: false, completion: nil)
//        } else if UserManager.manager.userEntity.validStatus == 2 {
//            //认证中
//        } else if UserManager.manager.userEntity.validStatus == 3 {
//            //已认证
//
//            //已实名
//
//        } else if UserManager.manager.userEntity.validStatus == 4 {
//            //认证失败
//            let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "cert") as! UPayCertViewController
//            //vc.hidesBottomBarWhenPushed = true
//            //self.navigationController?.pushViewController(vc, animated: true)
//            let nvc = UPayNavigationController.init(rootViewController: vc)
//            self.present(nvc, animated: false, completion: nil)
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    override func requestData() {
        
    }

    @objc func selectType(button: UIButton) {
        
        self.typeArray.forEach { (btn) in
            if btn.tag == button.tag {
                btn.isSelected = true
                btn.layer.borderColor = JXMainColor.cgColor
                btn.layer.borderWidth = 1
                btn.backgroundColor = JXFfffffColor
            } else {
                
                btn.isSelected = false
                btn.layer.borderColor = UIColor.rgbColor(rgbValue: 0xf5f5ff).cgColor
                btn.layer.borderWidth = 1
                btn.backgroundColor = UIColor.rgbColor(rgbValue: 0xf5f5ff)
            }
        }
        self.tradeType = button.tag
    }
    @objc func selectStatus(button: UIButton) {
        
        self.statusArray.forEach { (btn) in
            if btn.tag == button.tag {
                btn.isSelected = true
                btn.layer.borderColor = JXMainColor.cgColor
                btn.layer.borderWidth = 1
                btn.backgroundColor = JXFfffffColor
                
            } else {
                btn.isSelected = false
                btn.layer.borderColor = UIColor.rgbColor(rgbValue: 0xf5f5ff).cgColor
                btn.layer.borderWidth = 1
                btn.backgroundColor = UIColor.rgbColor(rgbValue: 0xf5f5ff)
            }
        }
        //订单状态，0进行中，1待支付，2待确认，3待仲裁，4已完成，5已关闭，7待回滚，9预约回滚
        switch button.tag {
        case 0:
            self.orderStatus = -1
        case 1,2,3,4,5:
            self.orderStatus = button.tag
        case 6:
            self.orderStatus = 7
        case 7:
            self.orderStatus = 9
        default:
            self.orderStatus = -1
        }
    }
    @objc func selectConfirm(button: UIButton) {
        self.view.endEditing(true)
        if button.tag == 0 {
            self.tradeType = 0
            self.orderStatus = -1
            
            self.typeArray.forEach { (btn) in
                btn.isSelected = false
                btn.layer.borderColor = UIColor.rgbColor(rgbValue: 0xf5f5ff).cgColor
                btn.layer.borderWidth = 1
                btn.backgroundColor = UIColor.rgbColor(rgbValue: 0xf5f5ff)
            }
            self.statusArray.forEach { (btn) in
                btn.isSelected = false
                btn.layer.borderColor = UIColor.rgbColor(rgbValue: 0xf5f5ff).cgColor
                btn.layer.borderWidth = 1
                btn.backgroundColor = UIColor.rgbColor(rgbValue: 0xf5f5ff)
            }
        } else {
            self.isDroping = false
            self.dropView?.dismiss()
            
            let vc = UPaySelectOrderRecordsController()
            vc.tradeType = self.tradeType
            vc.orderStatus = self.orderStatus
            vc.orderNum = self.textField?.text ?? ""
            
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
//MARK:JXBarViewDelegate
extension UPayHomeViewController : JXXBarViewDelegate {
    
    func jxxBarView(barView: JXXBarView, didClick index: Int) {
        
        let indexPath = IndexPath.init(item: index, section: 0)
        //开启动画会影响topBar的点击移动动画
        self.horizontalView.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: false)
    }
}
//MARK:JXHorizontalViewDelegate
extension UPayHomeViewController : JXHorizontalViewDelegate {
    func horizontalViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        var x : CGFloat
        let count = CGFloat(self.topBar.titles.count)
        
        x = (kScreenWidth / count  - self.topBar.bottomLineSize.width) / 2 + (offset / kScreenWidth ) * ((kScreenWidth / count))
        
        self.topBar.bottomLineView.frame.origin.x = x
        
    }
    func horizontalView(_: JXHorizontalView, to indexPath: IndexPath) {
        if self.topBar.selectedIndex == indexPath.item {
            return
        }
        
        self.topBar.scrollToItem(at: indexPath)
    }
    
}
extension UPayHomeViewController: JXKeyboardTextFieldDelegate {
   
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}
