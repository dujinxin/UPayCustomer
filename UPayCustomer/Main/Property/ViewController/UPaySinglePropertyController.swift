//
//  UPaySinglePropertyController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 10/10/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import MJRefresh

class UPaySinglePropertyController: UPayTableViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
      didSet{
          topConstraint.constant = 140
      }
    }

    @IBOutlet weak var balanceLabel: UILabel!

    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    @IBOutlet weak var importAdWidth: NSLayoutConstraint!
    @IBOutlet weak var importAdSpace: NSLayoutConstraint!
    
    @IBOutlet weak var importAdButton: UIButton!{
      didSet{
          importAdButton.layer.cornerRadius = 2
          importAdButton.layer.borderColor = JXMainColor.cgColor
          importAdButton.layer.borderWidth = 0.5
      }
    }
    @IBOutlet weak var importButton: UIButton!{
      didSet{
          importButton.layer.cornerRadius = 2
          importButton.layer.borderColor = JXMainColor.cgColor
          importButton.layer.borderWidth = 0.5
      }
    }
    @IBOutlet weak var exportButton: UIButton!{
      didSet{
          exportButton.layer.cornerRadius = 2
          exportButton.layer.borderColor = JXMainColor.cgColor
          exportButton.layer.borderWidth = 0.5
      }
    }

    @IBOutlet weak var selectBackView: UIView!{
        didSet{
            selectBackView.layer.cornerRadius = 20
            
            selectBackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectType)))
        }
    }
    @IBOutlet weak var selectButton: UIButton!{
        didSet{
            self.selectButton.setImage(UIImage(named: "select")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    var vm = UPayWalletVM()
    var propertyEntity: UPayCoinPropertyEntity?
 
    var recordType: Int = -1
    
    let selectLists = [["title":"全部","type":-1],["title":"充币","type":1],["title":"大额买币","type":2],["title":"返佣","type":3],["title":"交易卖币","type":4],["title":"提币","type":5],["title":"交易手续费","type":7],["title":"交易买币","type":8],["title":"提币手续费","type":9],["title":"运营补币","type":10],["title":"其他支出","type":16],["title":"运营出金补币","type":17],["title":"额外返佣","type":18]]
    
    lazy var selectView: JXSelectView = {
        let s = JXSelectView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 216), style: .pick)
        s.backgroundColor = JXFfffffColor
        s.delegate = self
        s.dataSource = self
        s.isUseSystemItemBar = true
        return s
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        self.title = self.propertyEntity?.symbol
        self.useLargeTitles = true
        
        self.topConstraint.constant = 140
        
        self.tableView.frame = CGRect(x: 0, y: self.topConstraint.constant + 164, width: kScreenWidth, height: kScreenHeight - self.topConstraint.constant - 164)
        self.tableView.register(UINib(nibName: "UPayPropertyRecordsCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
        self.tableView.estimatedRowHeight = 54
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none

        self.tableView.removeFromSuperview()
        self.contentView.addSubview(self.tableView)

        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: 1)
        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page += 1
            self.request(page: self.page)
        })
        self.request(page: 0)
        
        self.balanceLabel.text = "\(self.propertyEntity?.balance ?? 0.00)"
        self.blockLabel.text = "\(self.propertyEntity?.block ?? 0.00)"
        self.valueLabel.text = String(format: "%.2f", (self.propertyEntity?.total ?? 0.00) * (self.propertyEntity?.buyPrice ?? 0.00))
        if self.propertyEntity?.coinType != 2 {
            self.importAdSpace.constant = 0
            self.importAdWidth.constant = 0
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func request(page: Int) {
        
        var time: String = ""
        
        if page != 1 {
            time = self.vm.propertyRecordsEntity.list.last?.createDate ?? ""
        }
        
        self.vm.propertyRecords(searchTime: time, coinType: self.propertyEntity?.coinType ?? 0, recordType: self.recordType) { (_, msg, isSuc) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            self.tableView.reloadData()
            
            if isSuc == true && self.vm.propertyRecordsEntity.list.count > 0 {
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.propertyRecordsEntity.list.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCell", for: indexPath) as! UPayPropertyRecordsCell
        cell.entity = self.vm.propertyRecordsEntity.list[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        tableView.deselectRow(at: indexPath, animated: true)
      
        let vc = UPayReceiptAccountListController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func importCoin() {
        let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "import") as! UPayReceiptViewController
        vc.propertyEntity = self.propertyEntity
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func exportCoin() {
      
        self.showMBProgressHUD()
        self.vm.coinEntity(coinType: self.propertyEntity?.coinType ?? 0) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                let vc = UIStoryboard(name: "Property", bundle: nil).instantiateViewController(withIdentifier: "export") as! UPayExportViewController
                vc.propertyEntity = self.propertyEntity
                vc.coinEntity = self.vm.coinEntity
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                ViewManager.showNotice(msg)
            }
        }
        
    }

    @IBAction func importAd() {
        let alertVC = UIAlertController(title: "安全验证", message: "", preferredStyle: .alert)
        //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
        alertVC.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "请输入安全密码"
            textField.isSecureTextEntry = true
        })
        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            
            guard
                let textField = alertVC.textFields?[0],
                let psd = textField.text,
                psd.isEmpty == false else {
                    return
            }
            
            
            self.showMBProgressHUD()
            let vm = UPayAdVM()
            vm.adOtcQuickSell(safePassword: psd) { (_, msg, isSuc) in
                self.hideMBProgressHUD()

                if isSuc {
                    ViewManager.showNotice("导入成功")
                } else {
                    ViewManager.showNotice(msg)
                }
            }
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    @objc func selectType() {
        self.selectView.selectRow = 0
        self.selectView.show()
    }
}
extension UPaySinglePropertyController: JXSelectViewDelegate,JXSelectViewDataSource{
    func jxSelectView(selectView: JXSelectView, didSelectRowAt row: Int, inSection section: Int) {
    
        let dict = self.selectLists[row]
        let type = dict["type"] as? Int
        self.recordType = type ?? -1
        self.tableView.mj_header.beginRefreshing()
    }
    
    func jxSelectView(selectView: JXSelectView, numberOfRowsInSection section: Int) -> Int {
        
        return selectLists.count
    }
    
    func jxSelectView(selectView: JXSelectView, heightForRowAt row: Int) -> CGFloat {
        return 36
    }
    
    func jxSelectView(selectView: JXSelectView, contentForRow row: Int, InSection section: Int) -> String {
        
        let title = selectLists[row]["title"] as? String
        return title ?? ""
    }
}
