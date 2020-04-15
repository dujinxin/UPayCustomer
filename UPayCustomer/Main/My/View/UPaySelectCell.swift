//
//  UPaySelectCell.swift
//  UPay
//
//  Created by 飞亦 on 5/29/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class UPaySelectCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var grayArrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
