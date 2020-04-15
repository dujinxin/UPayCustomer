//
//  UPayHomeOrdeListrCell.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/29/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayHomeOrdeListrCell: UITableViewCell {
    
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    @IBOutlet weak var userImageView: UIImageView!
 
    
    var entity: UPayOrderCellEntity? {
        didSet {
            //商户买 对应 为 币商卖
            if self.entity?.tradeType == 2 {
                self.typeLabel.text = "买币"
                self.typeLabel.textColor = UIColor.rgbColor(rgbValue: 0xff3100)
                self.coinLabel.textColor = UIColor.rgbColor(rgbValue: 0xff3100)
                
                self.nameLabel.text = self.entity?.sellerName
                
            } else if self.entity?.tradeType == 1{
                self.typeLabel.text = "卖币"
                self.typeLabel.textColor = UIColor.rgbColor(rgbValue: 0x29b35a)
                self.coinLabel.textColor = UIColor.rgbColor(rgbValue: 0x29b35a)
                
                self.nameLabel.text = self.entity?.buyerName
            } else {
                self.typeLabel.text = "买币"
                self.typeLabel.textColor = UIColor.rgbColor(rgbValue: 0xff3100)
                self.coinLabel.textColor = UIColor.rgbColor(rgbValue: 0xff3100)
                
                self.nameLabel.text = self.entity?.sellerName
            }
          
            switch entity?.orderStatus {
            case 1:
                self.statusLabel.text = "待支付"
            case 2:
                self.statusLabel.text = "待确认"
            case 3:
                self.statusLabel.text = "待仲裁"
            case 4:
                self.statusLabel.text = "已完成"
            case 5:
                self.statusLabel.text = "已关闭"
    
            case 7:
                self.statusLabel.text = "待回滚"
            
            case 9:
                self.statusLabel.text = "预约回滚"
            default:
                self.statusLabel.text = "未知状态"
            }
            self.coinLabel.text = "USDT"
            
            self.orderNumberLabel.text = self.entity?.orderNum
            self.valueLabel.text = "¥ \(entity?.totalAmount ?? 0) CNY"
       
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
