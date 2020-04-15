//
//  UPayBuyPlatformViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/26/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import JXFoundation

private let headViewHeight : CGFloat = 74 * 2 + 84 + 64 + 10

class UPayBuyPlatformViewController: UPayBaseViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var coinNumLabel: UILabel!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var confirmButton: UIButton!{
        didSet{
            confirmButton.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var BarBgView: UIView!
    
    
    
    lazy var maskView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.rgbColor(rgbValue: 0x000000, alpha: 0.4)
        return v
    }()
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.textField])
        
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.textFieldDelegate = self
        return k
    }()
    
    var topBar : JXXBarView!
    var horizontalView : JXHorizontalView!
    var vcArray : Array<UPayBuyPlatformRecordsController> = []
    
    var vm = UPayBuyPlatformVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "向平台买币"
        self.useLargeTitles = true
        self.customNavigationBar.barTintColor = JXFfffffColor
        self.topConstraint.constant = self.navStatusHeight
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(self.keyboard)
        
        let tabBgView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        tabBgView.backgroundColor = UIColor.clear
        self.BarBgView.addSubview(tabBgView)
        
        let topBar = JXXBarView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width , height: 44), titles: ["进行中","已完成","已取消"])
        topBar.delegate = self
        
        
        let att = JXAttribute()
        att.normalColor = JXMain60TextColor
        att.selectedColor = JXMainTextColor
        att.font = UIFont.boldSystemFont(ofSize: 14)
        
        topBar.attribute = att
        
        //topBar.backgroundColor = UIColor.clear
        topBar.bottomLineSize = CGSize(width: 60, height: 2)
        topBar.bottomLineView.backgroundColor = JXMainTextColor
        topBar.isBottomLineEnabled = true
        
        tabBgView.addSubview(topBar)
        
        
        
        let rect = CGRect(x: 0, y: self.navStatusHeight + headViewHeight, width: kScreenWidth, height: kScreenHeight - self.navStatusHeight - headViewHeight)
        let vc1 = UPayBuyPlatformRecordsController()
        vc1.orderStatus = 1
        //vc1.entity = self.entity
        vc1.refreshBlock = { vm in
            //self.updateValues(vm)
        }
        vc1.scrollViewDidScrollBlock = { scroll in
            //self.tableViewDidScroll(scrollView: scroll)
        }
        let vc2 = UPayBuyPlatformRecordsController()
        vc2.orderStatus = 4
        //vc2.entity = self.entity
        vc2.refreshBlock = { vm in
            //self.updateValues(vm)
        }
        vc2.scrollViewDidScrollBlock = { scroll in
            //self.tableViewDidScroll(scrollView: scroll)
        }
        let vc3 = UPayBuyPlatformRecordsController()
        vc3.orderStatus = 5
        //vc3.entity = self.entity
        vc3.refreshBlock = { vm in
            //self.updateValues(vm)
        }
        vc3.scrollViewDidScrollBlock = { scroll in
            //self.tableViewDidScroll(scrollView: scroll)
        }
        
        let horizontalView = JXHorizontalView.init(frame: rect, containers: [vc1,vc2,vc3], parentViewController: self)
        self.contentView.addSubview(horizontalView)
        self.horizontalView = horizontalView
        
        self.vcArray = [vc1,vc2,vc3]
       
        self.topBar = topBar
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        
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
    
    @IBAction func confirmAction(_ sender: Any) {
        self.view.endEditing(true)
        
        guard let numStr = self.textField.text, numStr.isEmpty == false, let num = Int(numStr) else { return }

        self.showMBProgressHUD()
        self.vm.buyingPlatform(totalAmount: num) { (_, msg, isSuc) in

            if isSuc {

                self.vm.buyPlatformDetail(id: self.vm.buyPlatformBuyingEntity.id ?? "") { (_, msg, isSuccess) in
                    self.hideMBProgressHUD()
                    if isSuccess {
                        //let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "buyingPlatformDetail") as! UPayBuyPlatformDetailController
                        let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "buyPlatformDetailViewController") as! UPayBuyPlatformDetailViewController
        
                        vc.entity = self.vm.buyPlatformDetailEntity
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        ViewManager.showNotice(msg)
                    }
                }
            } else {
                self.hideMBProgressHUD()
                ViewManager.showNotice(msg)
            }
        }

    }
}
//MARK:JXBarViewDelegate
extension UPayBuyPlatformViewController : JXXBarViewDelegate {
    
    func jxxBarView(barView: JXXBarView, didClick index: Int) {
        
        let indexPath = IndexPath.init(item: index, section: 0)
        //开启动画会影响topBar的点击移动动画
        self.horizontalView.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: false)
    }
}
//MARK:JXHorizontalViewDelegate
extension UPayBuyPlatformViewController : JXHorizontalViewDelegate {
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
extension UPayBuyPlatformViewController: JXKeyboardTextFieldDelegate {
    
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        if
            let text = self.textField.text, text.isEmpty == false {
            
            self.confirmButton.isEnabled = true
            self.confirmButton.backgroundColor = JXMainColor
            self.confirmButton.setTitleColor(JXFfffffColor, for: .normal)
            self.confirmButton.layer.borderWidth = 1
            self.confirmButton.layer.borderColor = JXMainColor.cgColor
            
        } else {
            self.confirmButton.isEnabled = false
            self.confirmButton.backgroundColor = JXViewBgColor
            self.confirmButton.setTitleColor(JXMainTextColor, for: .normal)
            self.confirmButton.layer.borderWidth = 1
            self.confirmButton.layer.borderColor = UIColor.rgbColor(rgbValue: 0xe1e1e1).cgColor
            
        }
    }
}
