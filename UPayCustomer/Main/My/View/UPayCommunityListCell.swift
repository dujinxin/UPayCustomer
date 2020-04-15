//
//  UPayCommunityListCell.swift
//  UPay
//
//  Created by 飞亦 on 6/4/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class UPayCommunityListCell: UITableViewCell {
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var availalbeAccountLabel: UILabel!
    @IBOutlet weak var communityValueLabel: UILabel!
    
    @IBOutlet weak var title1Label: UILabel!
    @IBOutlet weak var title2Label: UILabel!
    
    
    @IBOutlet weak var topBgView: UIView!{
        didSet{
            self.topBgView.backgroundColor = JXCyanColor
            self.topBgView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var bgView: UIView!{
        didSet{
            self.bgView.backgroundColor = JXFfffffColor
            self.bgView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var bottomBgView: UIView!{
        didSet{
            
        }
    }
    
    
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    
    var entity: UPayCommunityMemberEntity? {
        didSet{
            
            self.nickNameLabel.text = entity?.name
            self.communityValueLabel.text = "\(entity?.team_market_value ?? 0)"
            self.availalbeAccountLabel.text = "\(entity?.valid_count ?? 0)"
            if LanaguageManager.shared.type == .chinese {
                if entity?.status == 0 {
                    self.statusImageView.image = UIImage(named: "unavailable_c")
                } else if entity?.status == 1 {
                    self.statusImageView.image = UIImage(named: "available_c")
                } else if entity?.status == 2 {
                    self.statusImageView.image = UIImage(named: "qualified_c")
                }
            } else {
                if entity?.status == 0 {
                    self.statusImageView.image = UIImage(named: "unavailable_e")
                } else if entity?.status == 1 {
                    self.statusImageView.image = UIImage(named: "available_e")
                } else if entity?.status == 2 {
                    self.statusImageView.image = UIImage(named: "qualified_e")
                }
            }
            switch entity?.level {
            case 1:
                self.star1ImageView.isHidden = false
                self.star2ImageView.isHidden = true
                self.star3ImageView.isHidden = true
                self.star4ImageView.isHidden = true
                self.star5ImageView.isHidden = true
            case 2:
                self.star1ImageView.isHidden = false
                self.star2ImageView.isHidden = false
                self.star3ImageView.isHidden = true
                self.star4ImageView.isHidden = true
                self.star5ImageView.isHidden = true
            case 3:
                self.star1ImageView.isHidden = false
                self.star2ImageView.isHidden = false
                self.star3ImageView.isHidden = false
                self.star4ImageView.isHidden = true
                self.star5ImageView.isHidden = true
            case 4:
                self.star1ImageView.isHidden = false
                self.star2ImageView.isHidden = false
                self.star3ImageView.isHidden = false
                self.star4ImageView.isHidden = false
                self.star5ImageView.isHidden = true
            case 5:
                self.star1ImageView.isHidden = false
                self.star2ImageView.isHidden = false
                self.star3ImageView.isHidden = false
                self.star4ImageView.isHidden = false
                self.star5ImageView.isHidden = false
            default:
                self.star1ImageView.isHidden = true
                self.star2ImageView.isHidden = true
                self.star3ImageView.isHidden = true
                self.star4ImageView.isHidden = true
                self.star5ImageView.isHidden = true
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
