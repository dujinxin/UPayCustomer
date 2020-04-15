//
//  UPayScanViewController.swift
//  zpStar
//
//  Created by feiyi on 2018/5/4.
//  Copyright © 2018年 feiyi. All rights reserved.
//

import UIKit
import AVFoundation

class UPayScanViewController: UPayBaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var scanImageView: UIImageView!
    
    @IBOutlet weak var leftViewWidthConstraint: NSLayoutConstraint!
    
    var session = AVCaptureSession()
    
    var callBlock : ((_ address: String?)->())?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.session.startRunning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.stopRunning()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButton.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.backButton.tintColor = UIColor.white
        self.scanImageView.tintColor = UIColor.blue
        self.topView.alpha = 0.5
        self.leftView.alpha = 0.5
        self.rightView.alpha = 0.5
        self.bottomView.alpha = 0.5

//        self.controlButton.setImage(#imageLiteral(resourceName: "off"), for: .normal)
//        self.controlButton.setImage(#imageLiteral(resourceName: "on"), for: .selected)


        guard
            let device = AVCaptureDevice.default(for: .video),   //创建摄像设备
            let input = try? AVCaptureDeviceInput(device: device)//创建输入流
            else{
            return
        }

        let output = AVCaptureMetadataOutput()                   //创建输出流

        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)


        let x = self.leftViewWidthConstraint.constant
        let width = view.bounds.width - 2 * self.leftViewWidthConstraint.constant
        let height = width
        let y = (view.bounds.height - height) / 2

        output.rectOfInterest = self.getScanCrop(rect: CGRect(x: x, y: y, width: width, height: height), readerViewBounds: view.bounds)

        session.sessionPreset = .high                           //高质量采集率
        session.addInput(input)
        session.addOutput(output)

        //先添加输出流 才可以设置格式，不然报错
        output.metadataObjectTypes = [.qr,.ean13,.ean8,.code128]//设置扫码支持的编码格式(设置条形码和二维码兼容)

        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = view.layer.bounds
        view.layer.insertSublayer(layer, at: 0)

        session.startRunning()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kStatusBarHeight + 7
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    func getScanCrop(rect: CGRect,readerViewBounds bounds:CGRect) -> CGRect {
        
        let x,y,width,height : CGFloat
        x = rect.origin.y / bounds.height
        y = rect.origin.x / bounds.width
        width = rect.size.height / bounds.height
        height = rect.size.width / bounds.width
        return CGRect(x: x, y: y, width: width, height: height)
    }
    @IBAction func backEvent(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func selectPhoto(_ sender: Any) {
        self.session.stopRunning()
        
        let imagePicker = UIImagePickerController()
        imagePicker.title = LocalizedString(key: "Home_photo")
        //        imagePicker.navigationBar.barTintColor = UIColor.blue
        imagePicker.navigationBar.tintColor = UIColor.black
        //print(self.imagePicker?.navigationItem.rightBarButtonItem!)
        
        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func switchButton(_ sender: UIButton) {
        guard
            let device = AVCaptureDevice.default(for: .video),
            device.hasTorch == true else {
                ViewManager.showNotice(LocalizedString(key: "Home_flashError"))
            return
        }
        sender.isSelected = !sender.isSelected
        if  device.torchMode == .on{
            do {
                try device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
            } catch let error{
                print(error.localizedDescription)
            }
        } else {
            do {
                try device.lockForConfiguration()
                device.torchMode = .on
                device.unlockForConfiguration()
            } catch let error{
                print(error.localizedDescription)
            }
        }
    }
    
}
extension UPayScanViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            guard
                let metadataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
                let codeStr = metadataObject.stringValue
            else {
                return
            }
            session.stopRunning()
            print(codeStr)
            self.handleCode(codeStr)
        }
    }
    func validate(code: String) -> Bool {
//        if code.count != 42 {
//            return false
//        }
//        if code.hasPrefix("0x") == false{
//            return false
//        }
        return true
    }
    
    func handleCode(_ str: String) {
        
        if self.validate(code: str) == false {
            ViewManager.showNotice("无效地址")
        } else {
            if let block = callBlock {
                block(str)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}
extension UPayScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    //        let button = UIButton()
    //        button.frame = CGRect(x: 0, y: 0, width: 44, height: 30)
    //        button.setTitle("取消", for: .normal)
    //        button.setTitleColor(UIColor.darkGray, for: .normal)
    //        let item = UIBarButtonItem.init(customView: button)
    //
    //        viewController.navigationItem.rightBarButtonItem = item//UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(hideImagePickerViewContorller))
    //    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.session.startRunning()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        self.session.stopRunning()
        
        let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as! String
        if mediaType == "public.image" {
            guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage, let ciImage = CIImage(image: image) else {
                return
            }
            //UIImage.image(originalImage: image, to: view.bounds.width)
//            self.userImageView.image = image
//            isSelected = true
            
            // 2.从选中的图片中读取二维码数据
            // 2.1创建一个探测器
            // CIDetectorTypeFace -- 探测器还可以搞人脸识别
            guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow]) else { return }
            // 2.2利用探测器探测数据
            let results = detector.features(in: ciImage)
            // 2.3取出探测到的数据
            for result in results {
                guard
                    let feature = result as? CIQRCodeFeature,
                    let codeStr = feature.messageString
                    else {
                        return
                }
                print(codeStr)
                self.handleCode(codeStr)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
