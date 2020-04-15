//
//  UPayReceiptCell.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/24/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayReceiptCell: UITableViewCell {

    @IBOutlet weak var payImageView: UIImageView!
    @IBOutlet weak var payNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var bigCircleView: UIView!{
        didSet{
       
            bigCircleView.layer.cornerRadius = 9
            bigCircleView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            bigCircleView.layer.borderWidth = 3
        }
    }
    @IBOutlet weak var smallCircleView: UIView!{
        didSet{
            smallCircleView.backgroundColor = UIColor.clear
            smallCircleView.layer.cornerRadius = 4.5
//            smallCircleView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
//            smallCircleView.layer.borderWidth = 3
        }
    }
    
    @IBOutlet weak var lineView: UIView!{
        didSet{
            //lineView.backgroundColor = JXSeparatorColor
        }
    }
    
    var entity: UPayReceiptCellEntity? {
        didSet{
            if entity?.type == 1 {
                self.payNameLabel.text = "支付宝"
                self.payImageView.image = UIImage(named: "icon-mini-alipay")
            } else if entity?.type == 2 {
                self.payNameLabel.text = "微信"
                self.payImageView.image = UIImage(named: "icon-mini-wechat")
            } else {
                self.payNameLabel.text = "银行卡"
                self.payImageView.image = UIImage(named: "icon-mini-card")
            }
            
            if entity?.useStatus == 1 {
                self.statusLabel.text = "上架中"
                self.smallCircleView.backgroundColor = UIColor.rgbColor(rgbValue: 0x00b454)
            } else {
                self.statusLabel.text = "已下架"
                self.smallCircleView.backgroundColor = UIColor.rgbColor(rgbValue: 0xff2d55)
            }
            self.userNameLabel.text = entity?.name
            self.accountLabel.text = entity?.account
            self.numberLabel.text = "¥ \(entity?.todayTotalAmount ?? 0.00)"
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
