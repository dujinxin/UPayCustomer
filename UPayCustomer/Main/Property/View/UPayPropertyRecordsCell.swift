//
//  UPayPropertyRecordsCell.swift
//  UPayCustomer
//
//  Created by 飞亦 on 10/10/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayPropertyRecordsCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var entity: UPayPropertyCellEntity? {
        didSet {
            guard let entity = entity else { return }
            
            //记录类型，1,”充币”，2,”大额买币”，3,”返佣”，4,”交易卖币”，5,”提币”，7,”交易手续费”，8,”交易买币”，9,”提币手续费”，10,”运营补币”，16其他支出，17运营出金补币，18额外返佣
            switch entity.recordType {
            case 1:
                self.typeLabel.text = "充币"
            case 2:
                self.typeLabel.text = "大额买币"
            case 3:
                self.typeLabel.text = "返佣"
            case 4:
                self.typeLabel.text = "交易卖币"
            case 5:
                self.typeLabel.text = "提币"
            case 7:
                self.typeLabel.text = "交易手续费"
            case 8:
                self.typeLabel.text = "交易买币"
            case 9:
                self.typeLabel.text = "提币手续费"
            case 10:
                self.typeLabel.text = "运营补币"
            case 16:
                self.typeLabel.text = "其他支出"
            case 17:
                self.typeLabel.text = "运营出金补币"
            case 18:
                self.typeLabel.text = "额外返佣"
            default:
                self.typeLabel.text = "未知状态"
            }
            
            
            self.numberLabel.text = "\(entity.count)"

            self.timeLabel.text = entity.createDate
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
