//
//  UPayFindViewController.swift
//  UPay
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation
import MJRefresh

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

private let headViewHeight : CGFloat = 44

class UPayAdViewController: UPayTableViewController {
   
    var vcArray : Array<UPayOrderRecordsController> = []
    
    var vm = UPayAdVM()
    var configVM = CommonVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "广告管理"
        self.useLargeTitles = true
        
        
        let rect = CGRect(x: 0, y: self.navStatusHeight, width: kScreenWidth, height: kScreenHeight - self.navStatusHeight - kTabBarHeight)
        self.tableView.frame = rect
        self.tableView.register(UINib(nibName: "UPayAdListCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
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
        
        self.customNavigationBar.backgroundView.backgroundColor = JXMainColor
        
        self.customNavigationBar.isTranslucent = false
        self.customNavigationBar.barStyle = .blackTranslucent
        self.customNavigationBar.barTintColor = JXMainColor
        self.customNavigationBar.tintColor = JXFfffffColor //item图片文字颜色
        let font1 = UIFont.systemFont(ofSize: 17)
        self.customNavigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: JXFfffffColor,NSAttributedString.Key.font:font1]//标题设置
        let font2 = UIFont.boldSystemFont(ofSize: 34)
        self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: JXFfffffColor,NSAttributedString.Key.font:font2]//大标题设置
       
        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        
        self.requestData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func add() {
        if self.configVM.configurationEntity.platfromSellPrice != 0 {
            let storyboard = UIStoryboard.init(name: "Ad", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "add1") as! UPayAddAd1ViewController
            vc.configurationEntity = self.configVM.configurationEntity
            vc.hidesBottomBarWhenPushed = true
            vc.backBlock = {
                self.tableView.mj_header.beginRefreshing()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.showMBProgressHUD()
            self.configVM.config { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                if isSuc {
                    let storyboard = UIStoryboard.init(name: "Ad", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "add1") as! UPayAddAd1ViewController
                    vc.configurationEntity = self.configVM.configurationEntity
                    vc.hidesBottomBarWhenPushed = true
                    vc.backBlock = {
                        self.tableView.mj_header.beginRefreshing()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    ViewManager.showNotice(msg)
                }
            }
        }
    }
    override func requestData() {
        self.configVM.config { (_, msg, isSuc) in
            if isSuc {
                self.tableView.reloadData()
            }
        }
    }
    override func request(page: Int) {
        
        var time: String = ""
        
        if page != 1 {
            time = self.vm.adListEntity.list.last?.createTime ?? ""
        }
        
        self.vm.adList(searchTime: time, status: -1) { (_, msg, isSuc) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            self.tableView.reloadData()
            
            if isSuc == true && self.vm.adListEntity.list.count > 0 {
                self.tableView.isHidden = false
                self.defaultView.isHidden = true
            } else {
                //self.tableView.isHidden = true
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
    
}

// MARK: - Table view data source
extension UPayAdViewController {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.adListEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UPayAdListCell
        let entity = self.vm.adListEntity.list[indexPath.row]
        cell.entity = entity
        cell.priseLabel.text = "¥ \(self.configVM.configurationEntity.platfromSellPrice)"
        
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
        let entity = self.vm.adListEntity.list[indexPath.row]
        let deleteAction: UITableViewRowAction!
        
        let markAction = UITableViewRowAction(style: .default, title: "编辑") { (action, indexPath) in

            self.showMBProgressHUD()
            self.configVM.config { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                if isSuc {
                    let storyboard = UIStoryboard.init(name: "Ad", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "add3") as! UPayAddAd3ViewController
                    vc.configurationEntity = self.configVM.configurationEntity
                    vc.adEntity = entity
                    //vc.isEdit = true
                    vc.hidesBottomBarWhenPushed = true
                    vc.backBlock = {
                        self.tableView.mj_header.beginRefreshing()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    ViewManager.showNotice(msg)
                }
            }
        }
        markAction.backgroundColor = JXGreenColor
       
        let cancelAction = UITableViewRowAction(style: .normal, title: "取消") { (action, indexPath) in }
        cancelAction.backgroundColor = JXMainColor
       
        if entity.status == 1 { //上架中
            //下架
            //default,destructive默认红色，normal默认灰色，可以通过backgroundColor 修改背景颜色，backgroundEffect 添加模糊效果
            deleteAction = UITableViewRowAction(style: .destructive, title: "下架") { (action, indexPath) in
                self.vm.adOtcUseOrNot(id: entity.id ?? "", type: 2, completion: { (_, msg, isSuc) in
                    ViewManager.showNotice(msg)
                    if isSuc {
                        entity.status = 2
                        tableView.reloadData()
                    }
                })
            }
            deleteAction.backgroundColor = JXRedColor
            return [cancelAction,deleteAction,markAction]
        } else {
            let useAction = UITableViewRowAction(style: .destructive, title: "上架") { (action, indexPath) in
               
                self.vm.adOtcUseOrNot(id: entity.id ?? "", type: 1, completion: { (_, msg, isSuc) in
                    ViewManager.showNotice(msg)
                    if isSuc {
                        entity.status = 1
                        tableView.reloadData()
                    }
                })
            }
            useAction.backgroundColor = JXCyanColor
           
            deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
               
                self.vm.adOtcDelete(id: entity.id ?? "", completion: { (_, msg, isSuc) in
                    ViewManager.showNotice(msg)
                    if isSuc {
                        self.vm.adListEntity.list.remove(at: indexPath.row)
                        tableView.reloadData()
                    }
                })
            }
            deleteAction.backgroundColor = JXRedColor
            return [cancelAction,deleteAction,useAction,markAction]
       }
   }
}
