//
//  UPayReceiptAccountAddController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/24/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayReceiptAccountAddController: UPayTableViewController {
    
    var sectionTitles = ["银行卡","支付宝","微信"]
    var sectionImages = ["icon-mini-card","icon-mini-alipay","icon-mini-wechat"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = JXFfffffColor
        self.title = "添加"
        self.useLargeTitles = true
        self.customNavigationBar.barTintColor = JXFfffffColor
        let font = UIFont(name: "PingFangSC-Semibold", size: 34) ?? UIFont.systemFont(ofSize: 34)
        self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: JXMainColor,NSAttributedString.Key.font:font]//大标题设置
        
        self.tableView.frame = CGRect(x: 0, y: self.navStatusHeight, width: kScreenWidth, height: kScreenHeight - self.navStatusHeight - kTabBarHeight)
        self.tableView.separatorStyle = .singleLine
        self.tableView.rowHeight = 54
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
        
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: sectionImages[indexPath.row])
        cell.textLabel?.text = sectionTitles[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = JXMainTextColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let vc = UIStoryboard(name: "My", bundle: nil).instantiateViewController(withIdentifier: "bank") as! UPayBankViewController
            //vc.type = 4
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = UIStoryboard(name: "My", bundle: nil).instantiateViewController(withIdentifier: "net") as! UPayNetViewController
            vc.type = 1
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard(name: "My", bundle: nil).instantiateViewController(withIdentifier: "net") as! UPayNetViewController
            vc.type = 2
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
