//
//  UPayOrderBuyListController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 10/3/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import JXFoundation
import MJRefresh

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class UPayOrderBuyListController: UPayTableViewController {
    
    var vm = UPayHomeVM()
    
    var selectView: UIView?
    
    var price: Double = 7.00
    var currentEntity: UPayOrderBuyCellEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我要买入"
        self.useLargeTitles = true
        self.customNavigationBar.backgroundView.backgroundColor = JXMainColor
        let font = UIFont.boldSystemFont(ofSize: 34)
        self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: JXFfffffColor,NSAttributedString.Key.font:font]//大标题设置
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 10, y: 7, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.tintColor = JXFfffffColor
        leftButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        
        
        let rect = CGRect(x: 0, y: self.navStatusHeight, width: kScreenWidth, height: kScreenHeight - self.navStatusHeight)
        self.tableView.frame = rect
        self.tableView.register(UINib(nibName: "UPayBuyListCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        //self.tableView.rowHeight = 135
        self.tableView.showsVerticalScrollIndicator = false
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: 1)
        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page += 1
            self.request(page: self.page)
        })
        self.tableView.mj_header.beginRefreshing()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let t = self.textField, t.isFirstResponder == true {
            t.resignFirstResponder()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    @objc func back() {
        if let block = self.backBlock {
            block()
        }
        self.navigationController?.popViewController(animated: true)
    }
    override func request(page: Int) {
        var time: String = ""
        
        if page != 1 {
            time = self.vm.orderBuyListEntity.list.last?.createTime ?? ""
        }
        self.vm.orderBuyList(searchTime: time) { (_, msg, isSuc) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            self.tableView.reloadData()
            
            if isSuc == true && self.vm.orderBuyListEntity.list.count > 0 {
                self.tableView.isHidden = false
            } else {
                self.tableView.isHidden = true
                self.defaultView.backgroundColor = UIColor.clear
                self.defaultView.subviews.forEach({ (v) in
                    v.backgroundColor = UIColor.clear
                    if let l = v as? UILabel {
                        l.textColor = JXGrayTextColor
                    }
                })
                self.defaultInfo = ["imageName":"empty-state","content":"暂无记录"]
                self.setUpDefaultView()
                self.defaultView.frame = self.tableView.frame
            }
        }
    }
    var textField: UITextField?
    var numberLabel: UILabel?
    
    func customView(entity: UPayOrderBuyCellEntity) -> UIView {
        
        self.currentEntity = entity
        let space: CGFloat = 10
        let itemWidth = (kScreenWidth - space * 3) / 2
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60 + 20 + 5 + 44 + 5 + 20 + 10)
        
        let rightContentView = UIView()
        rightContentView.frame = CGRect(x: 0, y: 0, width: contentView.jxWidth, height: contentView.jxHeight + kBottomMaginHeight)
        rightContentView.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(rightContentView)
        
        let topBarView = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 35)
            //label.center = view.center
            label.text = "购买\("USDT")"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = JXMainColor
            view.addSubview(label)
            //label.sizeToFit()
            
            let detailLabel = UILabel()
            detailLabel.frame = CGRect(x: 0, y: label.jxBottom, width: kScreenWidth, height: 12)
            //label.center = view.center
            detailLabel.text = ""
            detailLabel.textAlignment = .center
            detailLabel.font = UIFont.systemFont(ofSize: 11)
            detailLabel.textColor = JXMain60TextColor
            view.addSubview(detailLabel)
            
            let button = UIButton()
            button.frame = CGRect(x: 15, y: 10, width: 30, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            button.setTitle("取消", for: .normal)
            button.tintColor = JXMainTextColor
            //button.setImage(UIImage(named: "Close")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.setTitleColor(JXMainTextColor, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
            view.addSubview(button)
            
            
            let button1 = UIButton()
            button1.frame = CGRect(x: kScreenWidth - 30 - 15, y: 10, width: 30, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            button1.setTitle("确定", for: .normal)
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button1.setTitleColor(JXMainColor, for: .normal)
            button1.contentVerticalAlignment = .center
            button1.contentHorizontalAlignment = .center
            button1.addTarget(self, action: #selector(confirm), for: .touchUpInside)
            contentView.addSubview(button1)
            
            return view
        }()
        rightContentView.addSubview(topBarView)
        
        
        let priceLabel = UILabel()
        priceLabel.frame = CGRect(x: 15, y: topBarView.jxBottom, width: (contentView.jxWidth - 45) / 2 , height: 20)
        //label.center = view.center
        priceLabel.text = "单价：¥ \(entity.tradePrice)"
        priceLabel.textAlignment = .left
        priceLabel.font = UIFont.systemFont(ofSize: 13)
        priceLabel.textColor = JXMainTextColor
        rightContentView.addSubview(priceLabel)
        
        let numLabel = UILabel()
        numLabel.frame = CGRect(x: priceLabel.jxRight + 15, y: priceLabel.jxTop, width: (contentView.jxWidth - 45) / 2, height: 20)
        //label.center = view.center
        numLabel.text = "剩余数量：\(entity.restCount) USDT"
        numLabel.textAlignment = .right
        numLabel.font = UIFont.systemFont(ofSize: 13)
        numLabel.textColor = JXMainTextColor
        rightContentView.addSubview(numLabel)
        
        self.textField = {
            let textField = UITextField(frame: CGRect(x: 15, y: priceLabel.jxBottom + 5, width: contentView.jxWidth - 30 , height: 44))
            textField.backgroundColor = JXTextViewBgColor
            textField.layer.cornerRadius = 2
            textField.delegate = self
            textField.placeholder = "请输入购买金额"
            //textField.text = number
            textField.keyboardType = .numberPad
            textField.font = UIFont.systemFont(ofSize: 14)
            textField.textColor = JXMainTextColor
            //textField.attributedPlaceholder = NSAttributedString(string: "输入购买金额", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:JXPlaceHolerColor])
            
            
            textField.leftViewMode = .always
            textField.leftView = {
                let nameLabel = UILabel()
                nameLabel.frame = CGRect(x: 0, y: 20, width: 10, height: 30)
                nameLabel.text = "   "
                return nameLabel
            }()
            
            textField.rightViewMode = .always
            textField.rightView = {
                let nameLabel = UILabel()
                nameLabel.frame = CGRect(x: 0, y: 20, width: 40, height: 30)
                nameLabel.text = "CNY   "
                nameLabel.textColor = JXMainTextColor
                nameLabel.font = UIFont.systemFont(ofSize: 14)
                return nameLabel
            }()
            
            return textField
        }()
        rightContentView.addSubview(self.textField!)
    
        let limitLabel = UILabel()
        limitLabel.frame = CGRect(x: 15, y: self.textField!.jxBottom + 5, width: (contentView.jxWidth - 45) / 2 , height: 20)
        //label.center = view.center
        limitLabel.text = "限额：¥ \(entity.limitMin) - ¥ \(entity.limitMax)"
        limitLabel.textAlignment = .left
        limitLabel.font = UIFont.systemFont(ofSize: 13)
        limitLabel.textColor = JXMainTextColor
        rightContentView.addSubview(limitLabel)
    
        self.numberLabel = {
            let label = UILabel()
            label.frame = CGRect(x: limitLabel.jxRight + 15, y: limitLabel.jxTop, width: (contentView.jxWidth - 45) / 2, height: 20)
            //label.center = view.center
            label.text = "≈ 0 USDT"
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = JXMainTextColor
            
            return label
        }()
        rightContentView.addSubview(self.numberLabel!)
        
        return contentView
    }
    @objc func showKeyboard() {
        self.textField?.becomeFirstResponder()
    }
    @objc func hideKeyboard() {
        self.textField?.resignFirstResponder()
    }
    @objc func cancel() {
        self.textField?.resignFirstResponder()
    }
    @objc func confirm() {
        
        guard let entity = self.currentEntity else { return }
        guard let numStr = self.textField?.text, let num = Float(numStr), num > 0 else {
            ViewManager.showNotice("请输入购买数量")
            return
        }
        self.textField?.resignFirstResponder()
        self.showMBProgressHUD()
        self.vm.orderBuyOrSell(id: entity.id ?? "", code: 1, amount: num) { (result, msg, isSuc) in
            if isSuc == true, let id = result as? String {
                self.vm.orderBuyOrSellDetail(id: id) { (_, message, isSuccess) in
                    self.hideMBProgressHUD()
                    if isSuccess {
                        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "orderBuyingDetailController") as! UPayOrderBuyingDetailController
                        vc.entity = self.vm.orderBuyOrSellDetailEntity
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        ViewManager.showNotice(message)
                    }
                }
            } else {
                self.hideMBProgressHUD()
                ViewManager.showNotice(msg)
            }
        }
    }
}

// MARK: - Table view data source
extension UPayOrderBuyListController {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.orderBuyListEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UPayBuyListCell
        let entity = self.vm.orderBuyListEntity.list[indexPath.row]
        cell.entity = entity
        cell.buyBlock = {
            
            if entity.agentType == 2 {
                self.showMBProgressHUD()
                self.vm.orderBuyOrSell(id: entity.id ?? "", code: 1, amount: entity.sellAmount) { (result, msg, isSuc) in
                    if isSuc == true, let id = result as? String {
                        self.vm.orderBuyOrSellDetail(id: id) { (_, message, isSuccess) in
                            self.hideMBProgressHUD()
                            if isSuccess {
                                let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "orderBuyingDetailController") as! UPayOrderBuyingDetailController
                                vc.entity = self.vm.orderBuyOrSellDetailEntity
                                self.navigationController?.pushViewController(vc, animated: true)
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
                print(1234567)
                
                if let sele = self.selectView, let _ = sele.superview {
                    sele.removeFromSuperview()
                }
        
                //选择支付方式
                self.selectView = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 164))
                self.selectView?.backgroundColor = JXFfffffColor
                self.selectView?.addSubview(self.customView(entity: entity))
                self.view.addSubview(self.selectView!)
                //self.selectView?.show(inView: self.view)
                //self.perform(#selector(self.showKeyboard), with: nil, afterDelay: 0.25)

                self.showKeyboard()
            }
        }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "propertyDetail") as! UPayProDetailViewController
        //        let entity = self.vm.orderListEntity.list[indexPath.row]
        //        vc.entity = entity
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
//MARK:UITextFieldDelegate
extension UPayOrderBuyListController: UITextFieldDelegate{
    @objc func keyboardWillShow(notify:Notification) {
           
           guard
               let userInfo = notify.userInfo,
               let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
               let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
               else {
                   return
           }
           UIView.animate(withDuration: animationDuration, animations: {
            self.selectView?.frame.origin.y = kScreenHeight - (self.selectView?.frame.size.height ?? 0) - rect.height
           }) { (finish) in
               //
           }
       }
       @objc func keyboardWillHide(notify:Notification) {
           print("notify = ","notify")
           guard
               let userInfo = notify.userInfo,
               let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
               let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
               else {
                   return
           }
           UIView.animate(withDuration: animationDuration, animations: {
               self.selectView?.frame.origin.y = kScreenHeight
           }) { (finish) in
               
           }
       }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc func textChange(notify: NSNotification) {
        
        if
            notify.object is UITextField,
            let textField = notify.object as? UITextField {

            if
                let num = textField.text,
                let numDouble = Double(num) {

                self.numberLabel?.text = String(format: "%.2f USDT", numDouble / price)
                
            } else {
                self.numberLabel?.text = "0 USDT"
            }
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //删除键
        if string == "" {
            return true
        }

        if
            let num = textField.text,
            let numDouble = Float(num + string), numDouble > self.currentEntity!.limitMax {
            
            textField.text = "\(self.currentEntity?.limitMax ?? 0)"
            return false

        } else {
            return true
        }
    }
    
}
