//
//  UPayBuyListCell.swift
//  UPayCustomer
//
//  Created by 飞亦 on 10/3/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayBuyListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priseLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
   
    @IBOutlet weak var payImageView: UIImageView!
    @IBOutlet weak var buyButton: UIButton!{
        didSet{
            self.buyButton.layer.cornerRadius = 3
        }
    }
    
    var buyBlock: (()->())?
    
    var entity: UPayOrderBuyCellEntity? {
        didSet {
            guard let entity = entity else { return }
            
            self.nameLabel.text = entity.sellerName

            self.priseLabel.text = "¥ \(entity.tradePrice)"
            
            if entity.agentType == 2 {
                self.numberLabel.text = "\(entity.buyCount) USDT"
            } else {
                self.numberLabel.text = "\(entity.restCount) USDT"
            }
            self.limitLabel.text = "¥ \(entity.limitMin) - ¥ \(entity.limitMax)"
            
            if entity.payType == 4 {
                imageView?.backgroundColor = UIColor.red
            }
            self.payImageView.image = UIImage(named: "icon-mini-card")
            
        }
    }
    
    @IBAction func buy(_ sender: Any) {
        if let block = buyBlock {
            block()
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
