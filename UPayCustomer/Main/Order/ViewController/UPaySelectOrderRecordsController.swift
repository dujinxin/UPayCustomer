//
//  UPaySelectOrderRecordsController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/30/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import JXFoundation
import MJRefresh

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class UPaySelectOrderRecordsController: UPayTableViewController {
    
    
    var vm = UPayHomeVM()
    
    var orderNum = ""
    var orderStatus = -1 //订单状态，0进行中，1待支付，2待确认，3待仲裁，4已完成，5已关闭，7待回滚，9预约回滚
    var tradeType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "订单筛选"
        self.useLargeTitles = true
        self.customNavigationBar.barTintColor = JXFfffffColor
        let font = UIFont.boldSystemFont(ofSize: 34)
        self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: JXMainColor,NSAttributedString.Key.font:font]//大标题设置
        
        
        let rect = CGRect(x: 0, y: self.navStatusHeight, width: kScreenWidth, height: kScreenHeight - self.navStatusHeight)
        self.tableView.frame = rect
        self.tableView.register(UINib(nibName: "UPayHomeOrdeListrCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
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
        
    }
    
    override func request(page: Int) {
        var time: String = ""
        
        if page != 1 {
            time = self.vm.orderListEntity.list.last?.createDate ?? ""
        }
        self.vm.orderList(searchTime: time, tradeType: self.tradeType, orderNum: self.orderNum, orderStatus: self.orderStatus) { (_, msg, isSuc) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            self.tableView.reloadData()
            
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
extension UPaySelectOrderRecordsController {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.orderListEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UPayHomeOrdeListrCell
        let entity = self.vm.orderListEntity.list[indexPath.row]
        cell.entity = entity
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let entity = self.vm.orderListEntity.list[indexPath.row]
        self.showMBProgressHUD()
        self.vm.orderBuyOrSellDetail(id: entity.id ?? "") { (_, message, isSuccess) in
            self.hideMBProgressHUD()
            if isSuccess {
                if entity.isBuy {
                    if entity.orderStatus == 1 {
                        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "orderBuyingDetailController") as! UPayOrderBuyingDetailController
                        vc.entity = self.vm.orderBuyOrSellDetailEntity
                        vc.backBlock = {
                            self.tableView.mj_header.beginRefreshing()
                        }
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "orderBuyedDetailController") as! UPayOrderBuyedDetailController
                        vc.entity = self.vm.orderBuyOrSellDetailEntity
                        vc.backBlock = {
                            self.tableView.mj_header.beginRefreshing()
                        }
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    if entity.orderStatus == 2 {
                        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "orderBuyingDetailController") as! UPayOrderBuyingDetailController
                        vc.entity = self.vm.orderBuyOrSellDetailEntity
                        vc.backBlock = {
                            self.tableView.mj_header.beginRefreshing()
                        }
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "orderBuyedDetailController") as! UPayOrderBuyedDetailController
                        vc.entity = self.vm.orderBuyOrSellDetailEntity
                        vc.backBlock = {
                            self.tableView.mj_header.beginRefreshing()
                        }
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
            } else {
                ViewManager.showNotice(message)
            }
        }
    }
}
