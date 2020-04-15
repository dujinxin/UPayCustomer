//
//  UPayAdListViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/23/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import JXFoundation
import MJRefresh

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class UPayAdListViewController: UPayTableViewController {
    
    
    var vm = UPayHomeVM()
    
    
    var orderStatus = 0 //订单状态，0进行中，1待支付，2待确认，3待仲裁，4已完成，5已关闭，7待回滚，9预约回滚
    
    var refreshBlock: ((_ vm: UPayWalletVM) -> ())?
    
    var scrollViewDidScrollBlock: ((_ scrollView: UIScrollView) -> ())?
    var scrollViewDidEndDeceleratingBlock: ((_ scrollView: UIScrollView) -> ())?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let headViewHeight : CGFloat = 162 + 20 + 50 + 24 + 40 + 30 + 10 + 44
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - headViewHeight)
        self.tableView.frame = rect
        self.tableView.register(UINib(nibName: "UPayPropertyCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        self.tableView.rowHeight = 135
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
        
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    override func request(page: Int) {
        
        self.vm.orderList(searchTime: "", tradeType: -1, orderNum: "", orderStatus: self.orderStatus) { (_, msg, isSuc) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            self.tableView.reloadData()
            if let block = self.refreshBlock {
                //block(self.vm)
            }
            if isSuc == true && self.vm.orderListEntity.list.count > 0 {
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
    
}

// MARK: - Table view data source
extension UPayAdListViewController {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.orderListEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UITableViewCell
        let entity = self.vm.orderListEntity.list[indexPath.row]
        //cell.tradeRecords = entity
        
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
extension UPayAdListViewController {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let block = self.scrollViewDidScrollBlock {
            block(scrollView)
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let block = self.scrollViewDidEndDeceleratingBlock {
            block(scrollView)
        }
    }
}
