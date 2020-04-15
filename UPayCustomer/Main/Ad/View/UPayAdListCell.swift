//
//  UPayAdListCell.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/23/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayAdListCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var priseLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    var entity: UPayAdCellEntity? {
        didSet {
            if self.entity?.advertType == 1 {
                self.typeLabel.text = "出售"
            } else {
                self.typeLabel.text = "购买"
            }
            if self.entity?.status == 1 {
                self.statusLabel.text = "上架中"
            } else {
                self.statusLabel.text = "已下架"
            }
            self.coinLabel.text = "USDT"
            //self.priseLabel.text = "¥ 0"
            self.numberLabel.text = "\(entity?.totalCount ?? 0)"
            self.limitLabel.text = "¥ \(entity?.limitMin ?? 0) - ¥ \(entity?.limitMax ?? 0)"
            self.balanceLabel.text = "\(entity?.restCount ?? 0)"
            
            //1 支付宝,2 支付宝,4 银行卡 ["icon-mini-card","icon-mini-alipay","icon-mini-wechat"]
            if entity?.payTypeNum == 1 {
                self.imageView1.image = UIImage(named: "icon-mini-alipay")
                self.imageView2.image = nil
                self.imageView3.image = nil
            } else if entity?.payTypeNum == 2 {
                self.imageView1.image = UIImage(named: "icon-mini-wechat")
                self.imageView2.image = nil
                self.imageView3.image = nil
            } else if entity?.payTypeNum == 3 {
                self.imageView1.image = UIImage(named: "icon-mini-alipay")
                self.imageView2.image = UIImage(named: "icon-mini-wechat")
                self.imageView3.image = nil
            } else if entity?.payTypeNum == 4 {
                self.imageView1.image = UIImage(named: "icon-mini-card")
                self.imageView2.image = nil
                self.imageView3.image = nil
            } else if entity?.payTypeNum == 5 {
                self.imageView1.image = UIImage(named: "icon-mini-alipay")
                self.imageView2.image = UIImage(named: "icon-mini-card")
                self.imageView3.image = nil
            } else if entity?.payTypeNum == 6 {
                self.imageView1.image = UIImage(named: "icon-mini-wechat")
                self.imageView2.image = UIImage(named: "icon-mini-card")
                self.imageView3.image = nil
            } else if entity?.payTypeNum == 7  {
                self.imageView1.image = UIImage(named: "icon-mini-alipay")
                self.imageView2.image = UIImage(named: "icon-mini-wechat")
                self.imageView3.image = UIImage(named: "icon-mini-card")
            } else {
                self.imageView1.image = nil
                self.imageView2.image = nil
                self.imageView3.image = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
