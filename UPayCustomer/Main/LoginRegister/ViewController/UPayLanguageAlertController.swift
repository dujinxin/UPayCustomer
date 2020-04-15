//
//  UPayLanguageAlertController.swift
//  UPay
//
//  Created by 飞亦 on 6/9/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class UPayLanguageAlertController: UPayBaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chineseLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
   
    
    @IBOutlet weak var chineseSelectButton: UIButton!{
        didSet{
            self.chineseSelectButton.setImage(UIImage(named: "accessory"), for: .selected)
            self.chineseSelectButton.setImage(UIImage(named: "unSelected"), for: .normal)
            self.chineseSelectButton.tag = 0
        }
    }
    @IBOutlet weak var englishSelectButton: UIButton!{
        didSet{
            self.englishSelectButton.setImage(UIImage(named: "accessory"), for: .selected)
            self.englishSelectButton.setImage(UIImage(named: "unSelected"), for: .normal)
            self.englishSelectButton.tag = 1
        }
    }
    
    @IBOutlet weak var cancelButton: UIButton!{
        didSet{
            self.cancelButton.backgroundColor = JXCyanColor
            self.cancelButton.tag = 0
        }
    }
    
    @IBOutlet weak var confirmButton: UIButton!{
        didSet{
            self.confirmButton.backgroundColor = JXCyanColor
            self.cancelButton.tag = 1
        }
    }
    
    @IBAction func clickAction(_ sender: UIButton){
        sender.isSelected = true
        selectRow = sender.tag
        if sender.tag == 0 {
            self.englishSelectButton.isSelected = false
        } else {
            self.chineseSelectButton.isSelected = false
        }
    }
    @IBAction func cancelAction(_ sender: UIButton){
        if let block = self.switchBlock {
            block(false)
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmAction(_ sender: UIButton){
        if selectRow != originRow {
            LanaguageManager.shared.changeLanguage(selectRow == 0 ? .chinese : .english)
        }
        if let block = self.switchBlock {
            block(selectRow != originRow)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    var originRow : Int = 0
    var selectRow : Int = 0
    
    var switchBlock: ((_ isChanged: Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        self.customNavigationBar.removeFromSuperview()
        
        if LanaguageManager.shared.type == .chinese {
            self.chineseSelectButton.isSelected = true
            originRow = 0
            selectRow = 0
        } else {
            self.englishSelectButton.isSelected = true
            originRow = 1
            selectRow = 1
        }
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
}
