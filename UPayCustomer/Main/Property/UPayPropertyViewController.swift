//
//  UPayPropertyViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/25/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import MJRefresh

class UPayPropertyViewController: UPayTableViewController{
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            topConstraint.constant = kNavStatusHeight + 2.78
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var totalNumLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    

    @IBOutlet weak var useNumLabel: UILabel!
    
    @IBOutlet weak var returnNumLabel: UILabel!
    
    @IBOutlet weak var importButton: UIButton!{
        didSet{
            importButton.layer.cornerRadius = 2
            importButton.layer.borderColor = UIColor.rgbColor(rgbValue: 0xffffff, alpha: 0.6).cgColor
            importButton.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var exportButton: UIButton!{
        didSet{
            exportButton.layer.cornerRadius = 2
            exportButton.layer.borderColor = UIColor.rgbColor(rgbValue: 0xffffff, alpha: 0.6).cgColor
            exportButton.layer.borderWidth = 0.5
        }
    }
    
    @IBOutlet weak var buyButton: UIButton!{
        didSet{
            buyButton.layer.cornerRadius = 2
            buyButton.layer.borderColor = UIColor.rgbColor(rgbValue: 0xffffff, alpha: 0.6).cgColor
            buyButton.layer.borderWidth = 0.5
        }
    }
    
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.layer.cornerRadius = 20
        }
    }
    
    var vm = UPayWalletVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = JXMainColor
        
        self.tableView.frame = CGRect(x: 0, y: 20, width: kScreenWidth, height: kScreenHeight - kTabBarHeight - 303.66 - 20)
        self.tableView.register(UINib(nibName: "UPayPropertyCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
        self.tableView.estimatedRowHeight = 54
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        
        self.tableView.removeFromSuperview()
        self.backView.addSubview(self.tableView)
  
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: 1)
        })
        self.request(page: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    override func request(page: Int) {
        
        self.vm.wallet(coinType: 0) { (_, msg, isSuc) in
            self.tableView.mj_header.endRefreshing()
            if isSuc {
                var totalUSDTValue: Float = 0
                var balanceUSDTValue: Float = 0
                var USDTPrice: Float = 0
                self.vm.walletEntity.list.forEach({ (entity) in
                    totalUSDTValue += entity.total * entity.sellPrice
                    balanceUSDTValue += entity.balance * entity.sellPrice
                    if entity.coinType == 2 {
                        USDTPrice = entity.sellPrice
                        
                        self.returnNumLabel.text = "\(entity.totalCommision)"
                    }
                })
                let totalNum = totalUSDTValue / USDTPrice
            
                let balanceNum = balanceUSDTValue / USDTPrice
                
                self.totalNumLabel.text = "\(totalNum)"
                self.totalValueLabel.text = "≈\(totalUSDTValue) CNY"
                
                self.useNumLabel.text = "\(balanceNum)"
                
                self.tableView.reloadData()
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.walletEntity.list.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCell", for: indexPath) as! UPayPropertyCell
        cell.entity = self.vm.walletEntity.list[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "singleProperty") as! UPaySinglePropertyController
        vc.propertyEntity = self.vm.walletEntity.list[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func importCoin() {
        let vc = UPayCoinListController()
        vc.type = 0
        vc.list = self.vm.walletEntity.list
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func exportCoin() {
        
        let vc = UPayCoinListController()
        vc.type = 1
        vc.list = self.vm.walletEntity.list
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    @IBAction func buyCoin() {
        let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "buyPlatform") as! UPayBuyPlatformViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
