//
//  UPayCoinListCell.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/25/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit
import SDWebImage

class UPayCoinListCell: UITableViewCell {
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var coinTitleLabel: UILabel!
    @IBOutlet weak var coinDetailLabel: UILabel!
    
    var entity: UPayCoinCellEntity? {
        didSet {
            coinTitleLabel.text = entity?.symbol
            coinDetailLabel.text = entity?.coinName
            
            if let s = entity?.logo, let url = URL(string: s) {
                coinImageView.sd_setImage(with: url, completed: nil)
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
