//
//  UPayReceiptViewController.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/25/19.
//  Copyright © 2019 COB. All rights reserved.
//

import UIKit

class UPayReceiptViewController: UPayBaseViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!{
        didSet{
            self.heightConstraint.constant = kNavStatusHeight
        }
    }
    @IBOutlet weak var selectBgView: UIView!{
        didSet{
            //codeBgView.backgroundColor = JXViewBgColor
        }
    }
    @IBOutlet weak var selectView: UIView!{
        didSet{
            selectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectAddress)))
        }
    }
    @IBOutlet weak var addressTypeLabel: UILabel!
    @IBOutlet weak var selectHeightConstraint: NSLayoutConstraint!{
        didSet{
            self.selectHeightConstraint.constant = 64
        }
    }
    @IBOutlet weak var codeBgView: UIView!{
        didSet{
            //codeBgView.backgroundColor = JXViewBgColor
        }
    }
    @IBOutlet weak var codeImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!{
        didSet {
            self.saveButton.backgroundColor = JXCyanColor
            self.saveButton.setTitleColor(JXBlueColor, for: .normal)
        }
    }
    @IBOutlet weak var copyButton: UIButton!
    
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var propertyEntity: UPayCoinPropertyEntity?
    var coinEntity: UPayCoinCellEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.title = "充币"
        self.useLargeTitles = true
        self.heightConstraint.constant = self.navStatusHeight
        self.customNavigationBar.barTintColor = JXFfffffColor
        
//        let leftButton = UIButton()
//        leftButton.frame = CGRect(x: 10, y: 7, width: 30, height: 30)
//        leftButton.setImage(UIImage(named: "records")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        leftButton.tintColor = JXMainColor
//        leftButton.addTarget(self, action: #selector(record), for: .touchUpInside)
//        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        self.addressLabel.text = self.propertyEntity?.address
        self.codeImageView.image = self.code(self.propertyEntity?.address ?? "")
        
        if self.coinEntity?.coinType == 2 {
            self.addressTypeLabel.text = "OMNI"
            self.infoLabel.text = "充币时请选择相同币种，否则资产将不可找回。 \nUSDT充币仅支持simple send方法，使用其他方法（send all）的充币暂时无法上账，敬请谅解。 \n充值至上述地址后，需整个网络节点确认，1次网络确认后到账，3次网络确认后可提币。 \n您的充值地址不会经常改变，可重复充值，如有更改，我们会公告通知。"
        } else {
            self.selectBgView.removeAllSubView()
            self.selectHeightConstraint.constant = 5
            self.selectView.isUserInteractionEnabled = false
            if self.coinEntity?.coinType == 1 {
                self.infoLabel.text = "充币时请选择相同币种，否则资产将不可找回。 \nUSDT充币仅支持simple send方法，使用其他方法（send all）的充币暂时无法上账，敬请谅解。 \n充值至上述地址后，需整个网络节点确认，1次网络确认后到账，3次网络确认后可提币。 \n您的充值地址不会经常改变，可重复充值，如有更改，我们会公告通知。"
            } else if self.coinEntity?.coinType == 3 {
                self.infoLabel.text = "BTC 地址只能充值 BTC 资产，任何充入 BTC 地址的非 BTC 资产将不可找回。\n使用BTC地址充值需要 1 个网络确认才能到账。\n您的充值地址不会经常改变，可重复充值，如有更改，我们会公告通知。"
            } else if self.coinEntity?.coinType == 5 {
                self.memoLabel.text = "MEMO：\(self.propertyEntity?.memo ?? "")"
                self.infoLabel.text = "EOS 地址只能充值 EOS 资产，任何充入 EOS 地址的非 EOS 资产将不可找回。\n使用EOS地址充值需要 1 个网络确认才能到账。\n充值地址和Memo须同时使用才能充值EOS到平台。\n平台暂不支持EOS智能合约的转入。\n您的充值地址不会经常改变，可重复充值，如有更改，我们会公告通知。"
            } else if self.coinEntity?.coinType == 6 {
                self.infoLabel.text = "ETH 地址只能充值 ETH 资产，任何充入 ETH 地址的非 ETH 资产将不可找回。\n使用ETH地址充值需要 12 个网络确认才能到账。\n您的充值地址不会经常改变，可重复充值，如有更改，我们会公告通知。"
            } else if self.coinEntity?.coinType == 7 {
                self.infoLabel.text = "EUSD 地址只能充值 EUSD资产，任何充入 EUSD 地址的非 EUSD 资产将不可找回。\n使用 EUSD 地址充值需要 12 个网络确认才能到账。\n您的充值地址不会经常改变，可重复充值，如有更改，我们会公告通知。"
            } else if self.coinEntity?.coinType == 8 {
                self.infoLabel.text = "POC 地址只能充值 POC 资产，任何充入 POC 地址的非 POC 资产将不可找回。\n使用POC地址充值需要 1 个网络确认才能到账。\n充值地址和Memo须同时使用才能充值POC到平台。\n平台暂不支持POC智能合约的转入。\n您的充值地址不会经常改变，可重复充值，如有更改，我们会公告通知。"
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func record() {
        
    }
    @objc func selectAddress() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OMNI", style: .default, handler: { (action) in
            
            self.addressTypeLabel.text = "OMNI"
            self.addressLabel.text = self.propertyEntity?.address
            self.codeImageView.image = self.code(self.propertyEntity?.address ?? "")
        }))
        alert.addAction(UIAlertAction(title: "ERC20", style: .default, handler: { (action) in
            
            self.addressTypeLabel.text = "ERC20"
            self.addressLabel.text = self.propertyEntity?.ethAddress
            self.codeImageView.image = self.code(self.propertyEntity?.ethAddress ?? "")
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func copyAddress(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.addressLabel.text
        ViewManager.showNotice("已复制")
    }
    
    @IBAction func saveImage(_ sender: Any) {
        guard let image = self.codeImageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image:UIImage,didFinishSavingWithError error:Error?,contextInfo:AnyObject?) {
        if error != nil {
            ViewManager.showNotice("保存失败")
        } else {
            ViewManager.showNotice("保存成功")
        }
    }
    func code(_ string:String) -> UIImage {
        //二维码滤镜
        let filter = CIFilter.init(name: "CIQRCodeGenerator")
        //设置滤镜默认属性
        filter?.setDefaults()
        
        let data = string.data(using: .utf8)
        
        //设置内容
        filter?.setValue(data, forKey: "inputMessage")
        //设置纠错级别
        filter?.setValue("M", forKey: "inputCorrectionLevel")
        //获取滤镜输出图像
        guard let outImage = filter?.outputImage else{
            return UIImage()
        }
        //转换CIIamge为UIImage,并放大显示
        guard let image = self.createNonInterpolatedUIImage(outImage, size: CGSize(width: kScreenWidth - 50 * 2, height: kScreenWidth - 50 * 2)) else {
            return UIImage()
        }
        return image
    }
    func createNonInterpolatedUIImage(_ ciImage : CIImage,size:CGSize) -> UIImage? {
        let a = size.height
        
        let extent = ciImage.extent.integral
        let scale = min(a / extent.size.width, a / extent.size.height)
        //创建bitmap
        let width = extent.width * scale
        let height = extent.height * scale
        
        let cs = CGColorSpaceCreateDeviceGray()
        guard let bitmapRef = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
            return nil
        }
        let context = CIContext.init()
        guard let bitmapImage = context.createCGImage(ciImage, from: extent) else {
            return nil
        }
        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: extent)
        //保存bitmap到图片
        guard let scaledImage = bitmapRef.makeImage() else {
            return nil
        }
        let image = UIImage.init(cgImage: scaledImage)
        return image
    }
    
}
