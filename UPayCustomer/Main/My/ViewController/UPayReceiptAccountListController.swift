//
//  UPayReceiptAccountListController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/24/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import MJRefresh

class UPayReceiptAccountListController: UPayTableViewController {
    
    var vm = UPayReceiptAccountVM()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = JXFfffffColor
        self.title = "收款账号"
        self.useLargeTitles = true
        self.customNavigationBar.barTintColor = JXFfffffColor
        let font = UIFont.boldSystemFont(ofSize: 34)
        self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: JXMainColor,NSAttributedString.Key.font:font]//大标题设置
        
        self.tableView.frame = CGRect(x: 0, y: self.navStatusHeight, width: kScreenWidth, height: kScreenHeight - self.navStatusHeight - kTabBarHeight)
        self.tableView.separatorStyle = .none
        //self.tableView.estimatedRowHeight = 88
        self.tableView.register(UINib(nibName: "UPayReceiptCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: 1)
        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page += 1
            self.request(page: self.page)
        })
        
        
        let button = UIButton(type: .custom)
        button.backgroundColor = JXMainColor
        button.frame = CGRect(x: 25, y: kScreenHeight - kTabBarHeight, width: kScreenWidth - 25 * 2, height: 44)
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.setTitle("添加", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(add), for: .touchUpInside)
        button.layer.cornerRadius = 4
        self.view.addSubview(button)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.mj_header.beginRefreshing()
    }
    override func request(page: Int) {
        
        var time: String = ""
        
        if page != 1 {
            time = self.vm.receiptListEntity.list.last?.createTime ?? ""
        }
        
        self.vm.receiptAccountList(searchTime: time) { (_, _, isSuc) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            self.tableView.reloadData()
            
            if isSuc == true && self.vm.receiptListEntity.list.count > 0 {
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
    @objc func add() {
        let vc = UPayReceiptAccountAddController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.vm.receiptListEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! UPayReceiptCell
        
        cell.selectionStyle = .none
        
        cell.entity = self.vm.receiptListEntity.list[indexPath.row]
//        cell.payImageView.image = UIImage(named: dict["image"]!)
//        cell.payNameLabel.text = dict["title"]
//        cell.entity = entity
//        cell.editBlock = {
//            cell.setEditing(true, animated: true)
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除！"
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        let style : UITableViewCell.EditingStyle = .delete
        return style
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let entity = self.vm.receiptListEntity.list[indexPath.row]
        let deleteAction: UITableViewRowAction!
        
        let markAction = UITableViewRowAction(style: .default, title: "编辑") { (action, indexPath) in
            if entity.type == 4 {
                let vc = UIStoryboard(name: "My", bundle: nil).instantiateViewController(withIdentifier: "bank") as! UPayBankViewController
                vc.isEdit = true
                vc.entity = entity
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = UIStoryboard(name: "My", bundle: nil).instantiateViewController(withIdentifier: "net") as! UPayNetViewController
                vc.type = entity.type
                vc.isEdit = true
                vc.entity = entity
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        markAction.backgroundColor = JXGreenColor
        
        let cancelAction = UITableViewRowAction(style: .normal, title: "取消") { (action, indexPath) in }
        cancelAction.backgroundColor = JXMainColor
        
        if entity.useStatus == 1 { //上架中
            //下架
            //default,destructive默认红色，normal默认灰色，可以通过backgroundColor 修改背景颜色，backgroundEffect 添加模糊效果
            deleteAction = UITableViewRowAction(style: .destructive, title: "下架") { (action, indexPath) in
                self.vm.useOrNotReceiptAccount(id: entity.id ?? "", completion: { (_, msg, isSuc) in
                    ViewManager.showNotice(msg)
                    if isSuc {
                        entity.useStatus = 2
                        tableView.reloadData()
                    }
                })
            }
            deleteAction.backgroundColor = JXRedColor
            return [cancelAction,deleteAction,markAction]
        } else {
            let useAction = UITableViewRowAction(style: .destructive, title: "上架") { (action, indexPath) in
                
                self.vm.useOrNotReceiptAccount(id: entity.id ?? "", completion: { (_, msg, isSuc) in
                    ViewManager.showNotice(msg)
                    if isSuc {
                        entity.useStatus = 1
                        tableView.reloadData()
                    }
                })
            }
            useAction.backgroundColor = JXCyanColor
            
            deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
                
                self.vm.deleteReceiptAccount(id: entity.id ?? "", completion: { (_, msg, isSuc) in
                    ViewManager.showNotice(msg)
                    if isSuc {
                        self.vm.receiptListEntity.list.remove(at: indexPath.row)
                        tableView.reloadData()
                    }
                })
            }
            deleteAction.backgroundColor = JXRedColor
            return [cancelAction,deleteAction,useAction,markAction]
        }
    }

}
