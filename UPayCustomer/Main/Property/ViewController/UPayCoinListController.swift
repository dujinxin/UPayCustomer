//
//  UPayCoinListController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/25/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import MJRefresh


class UPayCoinListController: UPayTableViewController {
    
    var sectionTitles = ["银行卡","支付宝","微信"]
    var sectionImages = ["银行卡","支付宝","微信"]
    
    var vm = UPayWalletVM()
    var type: Int = 0 //0充币，1提币
    var list: Array<UPayCoinPropertyEntity>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = JXFfffffColor
        self.title = "币种"
        self.useLargeTitles = true
        self.customNavigationBar.barTintColor = JXFfffffColor
        let font = UIFont.boldSystemFont(ofSize: 34)
        self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: JXMainColor,NSAttributedString.Key.font:font]//大标题设置
        
        self.tableView.frame = CGRect(x: 0, y: self.navStatusHeight, width: kScreenWidth, height: kScreenHeight - self.navStatusHeight - kTabBarHeight)
        self.tableView.separatorStyle = .singleLine
        self.tableView.rowHeight = 68
        self.tableView.register(UINib(nibName: "UPayCoinListCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: 1)
        })
        self.request(page: 0)
    }
    override func request(page: Int) {
        
        let time: String = ""
        
        self.vm.coinList(searchTime: time) { (_, _, isSuc) in
            self.tableView.mj_header.endRefreshing()
            
            self.tableView.reloadData()
            
            if isSuc == true && self.vm.coinListEntity.list.count > 0 {
                self.tableView.isHidden = false
                self.defaultView.isHidden = true
            } else {
                self.tableView.isHidden = true
                self.defaultView.isHidden = false
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
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.vm.coinListEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! UPayCoinListCell
        let entity = self.vm.coinListEntity.list[indexPath.row]
        cell.entity = entity
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let entity = self.vm.coinListEntity.list[indexPath.row]
        
        if self.type == 0 {
            let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "import") as! UPayReceiptViewController
            self.list?.forEach({ (e) in
                if e.coinType == entity.coinType {
                    vc.propertyEntity = e
                }
            })
            vc.coinEntity = entity
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "export") as! UPayExportViewController
            self.list?.forEach({ (e) in
                if e.coinType == entity.coinType {
                    vc.propertyEntity = e
                }
            })
            vc.coinEntity = entity
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
}
