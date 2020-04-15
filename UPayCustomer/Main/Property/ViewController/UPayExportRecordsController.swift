//
//  UPayExportRecordsController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/26/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import MJRefresh

class UPayExportRecordsController: UPayTableViewController {
    
    var vm = UPayWalletVM()
    var coinType: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = JXFfffffColor
        self.title = "提币记录"
        self.useLargeTitles = true
        self.customNavigationBar.barTintColor = JXFfffffColor
        let font = UIFont.boldSystemFont(ofSize: 34)
        self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: JXMainColor,NSAttributedString.Key.font:font]//大标题设置
        
        self.tableView.frame = CGRect(x: 0, y: self.navStatusHeight, width: kScreenWidth, height: kScreenHeight - self.navStatusHeight)
        self.tableView.separatorStyle = .none
        //self.tableView.estimatedRowHeight = 88
        self.tableView.register(UINib(nibName: "UPayExportRecordsCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: 1)
        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page += 1
            self.request(page: self.page)
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.mj_header.beginRefreshing()
    }
    override func request(page: Int) {
        
        var time: String = ""
        
        if page != 1 {
            time = self.vm.exportCoinRecordsEntity.list.last?.createDate ?? ""
        }
        
        self.vm.exportCoinRecordsList(searchTime: time, coinType: self.coinType, withdrawStatus: 1){ (_, _, isSuc) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            self.tableView.reloadData()
            
            if isSuc == true && self.vm.exportCoinRecordsEntity.list.count > 0 {
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
        return self.vm.exportCoinRecordsEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! UPayExportRecordsCell
        
        cell.selectionStyle = .none
        cell.entity = self.vm.exportCoinRecordsEntity.list[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
