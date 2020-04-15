//
//  UPayBuyPlatformRecordsController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/26/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import JXFoundation
import MJRefresh

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class UPayBuyPlatformRecordsController: UPayTableViewController {
    
    
    var vm = UPayBuyPlatformVM()
    
    var orderStatus = 0 //订单状态 1待支付，4已完成，5已关闭
    
    var refreshBlock: ((_ vm: UPayWalletVM) -> ())?
    
    var scrollViewDidScrollBlock: ((_ scrollView: UIScrollView) -> ())?
    var scrollViewDidEndDeceleratingBlock: ((_ scrollView: UIScrollView) -> ())?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.useLargeTitles = true
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let headViewHeight : CGFloat = 74 * 2 + 84 + 64 + 10
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - self.navStatusHeight - headViewHeight)
        self.tableView.frame = rect
        self.tableView.register(UINib(nibName: "UPayBuyPlatformListCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
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
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    override func request(page: Int) {
        
        var time: String = ""
        
        if page != 1 {
            time = self.vm.buyPlatformListEntity.list.last?.createDate ?? ""
        }
        
        self.vm.buyPlatformList(searchTime: time, orderStatus: self.orderStatus) { (_, msg, isSuc) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            self.tableView.reloadData()
            if let block = self.refreshBlock {
                //block(self.vm)
            }
            if isSuc == true && self.vm.buyPlatformListEntity.list.count > 0 {
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
extension UPayBuyPlatformRecordsController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.buyPlatformListEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UPayBuyPlatformListCell
        let entity = self.vm.buyPlatformListEntity.list[indexPath.row]
        cell.entity = entity
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = self.vm.buyPlatformListEntity.list[indexPath.row]
        
        self.showMBProgressHUD()
        self.vm.buyPlatformDetail(id: entity.id ?? "") { (_, msg, isSuc) in
            
            self.hideMBProgressHUD()
            if isSuc {
                
                if entity.recordStatus != 0 {
                    if self.vm.buyPlatformDetailEntity.recordStatus == 1 {
    
                        let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "buyPlatformDetailViewController") as! UPayBuyPlatformDetailViewController
                        vc.entity = self.vm.buyPlatformDetailEntity
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "buyedPlatformDetail") as! UPayBuyPlatformDetailController
                        vc.entity = self.vm.buyPlatformDetailEntity
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    if self.vm.buyPlatformDetailEntity.orderStatus == 1 {
                        
                        let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "buyPlatformDetailViewController") as! UPayBuyPlatformDetailViewController
                        vc.entity = self.vm.buyPlatformDetailEntity
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "buyedPlatformDetail") as! UPayBuyPlatformDetailController
                        vc.entity = self.vm.buyPlatformDetailEntity
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
                
                
                
                
            }
        }
        
    }
}
extension UPayBuyPlatformRecordsController {
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

