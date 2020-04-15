//
//  UPayCommunityHeadCell.swift
//  UPay
//
//  Created by 飞亦 on 6/4/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class UPayCommunityHeadCell: UITableViewCell {

    @IBOutlet weak var communityValueLabel: UILabel!
    @IBOutlet weak var availalbeAccountLabel: UILabel!
    @IBOutlet weak var communityRewardLabel: UILabel!
    @IBOutlet weak var normalRewardLabel: UILabel!
    @IBOutlet weak var lineView: UIView!{
        didSet{
            self.lineView.layer.cornerRadius = 1.5
        }
    }
    
    var entity: UPayCommunityMemberEntity? {
        didSet{
            
            self.communityValueLabel.text = "\(entity?.team_market_value ?? 0)"
            self.availalbeAccountLabel.text = "\(entity?.valid_count ?? 0)"
            self.communityRewardLabel.text = "\(entity?.team_price ?? 0)"
            self.normalRewardLabel.text = "\(entity?.level_price ?? 0)"
            
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
