//
//  UPayExportRecordsCell.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/26/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayExportRecordsCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var entity: UPayExportCoinCellEntity? {
        didSet {
            
            self.numberLabel.text = "\(entity?.withdrawCounts ?? 0.00)"
            self.timeLabel.text = entity?.createDate
            //1待提币，2已提币，3已拒绝，4 提币中
            guard let e = entity else { return }
            if e.withdrawStatus == 1 {
                self.statusLabel.text = "待提币"
            } else if e.withdrawStatus == 2 {
                self.statusLabel.text = "已提币"
            } else if e.withdrawStatus == 3 {
                self.statusLabel.text = "已拒绝"
            } else {
                self.statusLabel.text = "提币中"
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
