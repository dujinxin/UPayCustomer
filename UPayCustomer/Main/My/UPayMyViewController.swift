//
//  UPayMyViewController.swift
//  UPay
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import MJRefresh

class UPayMyViewController: UPayTableViewController{
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            topConstraint.constant = kNavStatusHeight
        }
    }
    
    @IBOutlet weak var topConstraint_item: NSLayoutConstraint!{
        didSet{
            topConstraint_item.constant = kStatusBarHeight + 7
        }
    }
    
    @IBOutlet weak var rightButton: UIButton!{
        didSet{
            self.rightButton.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
            self.rightButton.setImage(UIImage(named: "setting")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.rightButton.addTarget(self, action: #selector(setting(button:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            //imageView.backgroundColor = JXMainTextColor
        }
    }
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.layer.cornerRadius = 20
        }
    }
    
    var actionArray = [
        [
            ["title":"实名认证"]
        ],
        [
            ["title":"收款账号管理"]
        ],
        [
            ["title":"资金密码"],
            ["title":"登录密码"]
        ]
    ]
    var sectionTitles = ["认证","交易设置","安全中心"]
  
    var vm = UPayMyVM()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 230 - kTabBarHeight)
        self.tableView.register(UINib(nibName: "UPayMyListCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
        self.tableView.estimatedRowHeight = 54
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.isScrollEnabled = false
        self.tableView.separatorStyle = .none
        
        self.tableView.removeFromSuperview()
        self.backView.addSubview(self.tableView)
        
        
        self.nickNameLabel.text = UserManager.manager.userEntity.name
        self.accountLabel.text = UserManager.manager.userEntity.loginName
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    override func requestData() {
//        self.vm.my { (data, msg, isSuccess) in
//            if isSuccess == true {
//                self.tableView.reloadData()
//            } else {
//                ViewManager.showNotice(msg)
//            }
//        }
    }
    @IBAction func edit(_ sender: UIButton) {
        
        //        let alertVC = UIAlertController(title: "修改昵称", message: nil, preferredStyle: .alert)
        //        //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
        //        alertVC.addTextField(configurationHandler: { (textField) in
        //            textField.text = self.vm.profileInfoEntity?.nickname
        //            textField.delegate = self
        //            //textField.addTarget(self, action: #selector(self.valueChanged(textField:)), for: .editingChanged)
        //        })
        //        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
        //
        //            if
        //                let textField = alertVC.textFields?[0],
        //                let text = textField.text,
        //                text.isEmpty == false,
        //                text != self.vm.profileInfoEntity?.nickname{
        //
        //                self.showMBProgressHUD()
        //                self.vm.modify(nickName: text, completion: { (_, msg, isSuccess) in
        //                    self.hideMBProgressHUD()
        //                    if isSuccess == false {
        //                        ViewManager.showNotice(msg)
        //                    } else {
        //                        self.vm.profileInfoEntity?.nickname = text
        //                        UserManager.manager.updateNickName(text)
        //                        self.tableView.reloadData()
        //                    }
        //                })
        //            }
        //        }))
        //        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        //        }))
        //        self.present(alertVC, animated: true, completion: nil)
    }
    @objc func setting(button: UIButton) {

        let vc = UIStoryboard(name: "My", bundle: nil).instantiateViewController(withIdentifier: "version") as! UPayVersonViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 50)
        
        //v.backgroundColor = JXEeeeeeColor//JXViewBgColor
        let label = UILabel(frame: CGRect(x: 15, y: 20, width: kScreenWidth, height: 30))
        label.text = sectionTitles[section]
        label.textAlignment = .left
        label.textColor = JXMain60TextColor
        label.font = UIFont.systemFont(ofSize: 14)
        v.addSubview(label)
        
        let line = UIView()
        line.frame = CGRect(x: 0, y: 49.5, width: kScreenWidth, height: 0.5)
        line.backgroundColor = UIColor.rgbColor(rgbValue: 0xefeff4)
        v.addSubview(line)
        return v
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return actionArray.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (actionArray[section] as AnyObject).count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCell", for: indexPath) as! UPayMyListCell
        let dict = actionArray[indexPath.section][indexPath.row]
        
        cell.titleView.text = LocalizedString(key: dict["title"] ?? "")
        if indexPath.section == 0 {
            cell.detailView.text = "已认证"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let vc = UPayReceiptAccountListController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "modifyPsd") as! UPayModifyPsdViewController
            vc.hidesBottomBarWhenPushed = true
    
            if indexPath.row == 0 {
                vc.type = .normalSafePsd
            } else {
                vc.type = .normalLoginPsd
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

