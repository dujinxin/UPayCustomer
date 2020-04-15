//
//  UPayPropertyCell.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/25/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import SDWebImage

class UPayPropertyCell: UITableViewCell {

    @IBOutlet weak var coinImageView: UIImageView!
    
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var useLabel: UILabel!
    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var entity: UPayCoinPropertyEntity? {
        didSet {
            self.coinLabel.text = entity?.symbol
            if let s = entity?.logo,let url = URL(string: s) {
                self.coinImageView.sd_setImage(with: url, completed: nil)
            }
            self.useLabel.text = "\(entity?.balance ?? 0.00)"
            self.blockLabel.text = "\(entity?.block ?? 0.00)"
            self.valueLabel.text = String(format: "%.2f", (entity?.total ?? 0) * (entity?.sellPrice ?? 0))
           
  
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
