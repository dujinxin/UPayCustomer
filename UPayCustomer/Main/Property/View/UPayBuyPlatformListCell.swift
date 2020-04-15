//
//  UPayBuyPlatformListCell.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/27/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayBuyPlatformListCell: UITableViewCell {

    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    var entity: UPayBuyPlatformCellEntity? {
        didSet {
            guard let entity = entity else { return }
            self.orderIdLabel.text = entity.orderNum

            self.numLabel.text = "\(entity.coinCount) USDT"
            self.priceLabel.text = "¥ \(entity.price)"
            
            self.valueLabel.text = "¥ \(entity.totalAmount)"
            if entity.recordStatus != 0 {//平台买币
                //平台买币订单状态，1待支付，2已付款，3已完成，5已取消，7待回滚
                switch entity.recordStatus {
                case 1:
                    self.statusLabel.text = "待支付"
                case 2:
                    self.statusLabel.text = "已付款"
                case 3:
                    self.statusLabel.text = "已完成"
                case 5:
                    self.statusLabel.text = "已取消"
                case 7:
                    self.statusLabel.text = "待回滚"
                default:
                    self.statusLabel.text = "未知状态"
                }
            } else { //托管出金
                //托管出金订单状态，1待支付，2已付款，3待仲裁，4已完成，5已取消，6仲裁币商败诉，7待回滚，8已回滚 ，9预约回滚
                switch entity.orderStatus {
                case 1:
                    self.statusLabel.text = "待支付"
                case 2:
                    self.statusLabel.text = "已付款"
                case 3:
                    self.statusLabel.text = "待仲裁"
                case 4:
                    self.statusLabel.text = "已完成"
                case 5:
                    self.statusLabel.text = "已取消"
                case 6:
                    self.statusLabel.text = "仲裁币商败诉"
                case 7:
                    self.statusLabel.text = "待回滚"
                case 8:
                    self.statusLabel.text = "已回滚"
                case 9:
                    self.statusLabel.text = "预约回滚"
                default:
                    self.statusLabel.text = "未知状态"
                }
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
