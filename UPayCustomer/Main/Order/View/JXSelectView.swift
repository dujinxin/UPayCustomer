//
//  JXSelectView.swift
//  ZPOperator
//
//  Created by feiyi on 2017/6/24.
//  Copyright © 2017年 feiyi. All rights reserved.
//

import UIKit

public enum JXSelectViewPresentModelStyle : Int {
    case none      =  0
    case translucent
}

public enum JXSelectViewStyle : Int {
    case list
    case pick
    case custom
}
public enum JXSelectViewShowPosition {
    case top
    case middle
    case bottom
}

private let reuseIdentifier = "reuseIdentifier"


public class JXSelectView: UIView {
    
    public var topBarHeight : CGFloat = 0
    var pickViewCellHeight : CGFloat = 44
    var tableViewCellHeight : CGFloat = 44
    var pickViewHeight : CGFloat = 216
    //var rect = CGRect.init()
    public var selectViewTop : CGFloat = 0
    public var selectViewHeight : CGFloat = 0
    public var selectViewWidth : CGFloat = UIScreen.main.bounds.width
    
    
    public var selectRow : Int = 0
    public var selectSection : Int = 0
    
    public var presentModelStyle : JXSelectViewPresentModelStyle = .translucent
    public var style : JXSelectViewStyle = .list
    public var position : JXSelectViewShowPosition = .bottom
    public var animateDuration : TimeInterval = 0.25
    public var customView : UIView? {
        didSet{
            self.style = .custom
            self.selectViewHeight = customView?.bounds.height ?? pickViewHeight
            self.selectViewWidth = customView?.bounds.width ?? UIScreen.main.bounds.width
            self.contentView = customView
        }
    }
    private var contentView : UIView?
    public var isUseCustomTopBar : Bool = false {
        didSet{
            if isUseSystemItemBar == true {
                self.topBarHeight = 60
            }
        }
    }
    public var isUseSystemItemBar : Bool = false {
        didSet{
            if isUseSystemItemBar == true {
                self.topBarHeight = 60
                self.topBarView.addSubview(self.cancelButton)
                self.topBarView.addSubview(self.confirmButton)
            }
        }
    }
    
    
    public var delegate : JXSelectViewDelegate?
    public var dataSource : JXSelectViewDataSource?
    
    public var isScrollEnabled : Bool = false {
        didSet{
            if isScrollEnabled == true {
                self.tableView.isScrollEnabled = true
                self.tableView.bounces = true
                self.tableView.showsVerticalScrollIndicator = true
            }else{
                self.tableView.isScrollEnabled = false
                self.tableView.bounces = false
                self.tableView.showsVerticalScrollIndicator = false
            }
        }
    }
    public var isEnabled : Bool = true {
        didSet{
            
        }
    }
    var isShowed : Bool = false
    public var isBackViewUserInteractionEnabled : Bool = true {
        didSet{
            self.tapControl.isEnabled = isBackViewUserInteractionEnabled
        }
    }//背景视图是否响应点击事件
    
    
    public var topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    public lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.tag = 0
        btn.setTitle("取消", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(JXMainColor, for: .normal)
        btn.addTarget(self, action: #selector(tapClick), for: UIControl.Event.touchUpInside)
        return btn
    }()
    public lazy var confirmButton: UIButton = {
        let btn = UIButton()
        btn.tag = 1
        btn.setTitle("确定", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(JXMainColor, for: .normal)
        btn.addTarget(self, action: #selector(confirmClick), for: UIControl.Event.touchUpInside)
        return btn
    }()
   
    lazy var tableView : UITableView = {
        let table = UITableView.init(frame: CGRect.init(), style: .plain)
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        table.bounces = false
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        //table.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return table
    }()
    lazy var pickView: UIPickerView = {
        let pick = UIPickerView.init(frame: CGRect())
        pick.delegate = self
        pick.dataSource = self
        pick.showsSelectionIndicator = true
        
        return pick
    }()

    lazy var bgWindow : UIWindow = {
        let window = UIWindow()
        window.frame = UIScreen.main.bounds
        window.windowLevel = UIWindow.Level.alert + 1
        window.backgroundColor = UIColor.clear
        window.isHidden = false
        return window
    }()
    
    lazy var bgView : UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = UIColor.black
        view.alpha = 0.01
        
        if isBackViewUserInteractionEnabled == true {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
            view.addGestureRecognizer(tap)
        }
        return view
    }()
    lazy var tapControl : UIControl = {
        let control = UIControl()
        control.frame = UIScreen.main.bounds
        control.backgroundColor = UIColor.black
        control.alpha = 0.0
        control.addTarget(self, action: #selector(tapClick), for: .touchUpInside)
        return control
    }()
    var dismissBlock : (()->())?
    public init(frame: CGRect, style: JXSelectViewStyle) {
        super.init(frame: frame)
        
        self.style = style
        
        if style == .list {
            self.contentView = self.tableView
        } else if style == .pick {
            self.contentView = self.pickView
        }
        selectViewHeight = frame.height
        selectViewWidth = frame.width
        self.resetFrame()
    }
    public init(frame: CGRect, customView: UIView) {
        super.init(frame: frame)
        self.style = .custom
        self.contentView = customView
        selectViewHeight = customView.bounds.height
        selectViewWidth = customView.bounds.width
        self.resetFrame()
    }
    public func resetFrame(height: CGFloat = 0.0) {
        var h : CGFloat
        if height > 0 {
            h = height
            selectViewHeight = height
        } else {
            if style == .list {
                let num = self.dataSource?.jxSelectView(selectView:self, numberOfRowsInSection: 0) ?? 0
                h = CGFloat(num > 5 ? 5 : num) * tableViewCellHeight
                if num > 5 {
                    tableView.isScrollEnabled = true
                    tableView.bounces = true
                    tableView.showsVerticalScrollIndicator = true
                }else{
                    tableView.isScrollEnabled = false
                    tableView.bounces = false
                    tableView.showsVerticalScrollIndicator = false
                }
            } else if style == .pick{
                h = pickViewHeight
            } else {
                h = selectViewHeight
            }
        }
        if isUseCustomTopBar || isUseSystemItemBar {
            h += topBarHeight
        }
        if position == .bottom {
            if UIScreen.main.isIphoneX {
                h += kBottomMaginHeight
            }
        }
        self.frame = CGRect(x: 0, y: selectViewTop, width: selectViewWidth, height:h)
        self.layoutSubviews()
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if isUseCustomTopBar {
            topBarView.frame = CGRect(x: 0, y: 0, width: selectViewWidth, height: topBarHeight)
            
        }
        if isUseSystemItemBar {
            topBarView.frame = CGRect(x: 0, y: selectViewTop, width: selectViewWidth, height: topBarHeight)
            cancelButton.frame = CGRect(x: 0, y: 0, width: 60, height: topBarHeight)
            confirmButton.frame = CGRect(x: selectViewWidth - 60, y: 0, width: 60, height: topBarHeight)
        }
        
        if style == .pick {
            self.contentView?.frame = CGRect(x: 0, y: selectViewTop + topBarHeight, width: selectViewWidth, height: pickViewHeight)
            self.pickView.subviews.forEach { (view) in
                if view.frame.size.height < 2 {
                    view.backgroundColor = UIColor.red
                }
            }
        } else if style == .list {
            self.contentView?.frame = CGRect(x: 0, y: selectViewTop + topBarHeight, width: selectViewWidth, height: selectViewHeight)
        } else {
            self.contentView?.frame.size.height = selectViewHeight
            //self.contentView?.frame = CGRect(x: 0, y: selectViewTop, width: selectViewWidth, height: selectViewHeight)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(){
        self.show(inView: self.bgWindow)
    }
    
    public func show(inView view:UIView? ,animate: Bool = true) {
        self.show(inView: view, below: nil, animate: true)
    }
    public func show(inView view:UIView?, below subview: UIView?,animate: Bool = true) {
        if isUseSystemItemBar || isUseCustomTopBar {
            self.addSubview(self.topBarView)
        }
        self.addSubview(self.contentView!)
        self.resetFrame(height: selectViewHeight)
        
        let superView : UIView
        
        if let v = view {
            superView = v
        }else{
            superView = self.bgWindow
        }
        //let center = CGPoint.init(x: contentView.center.x, y: contentView.center.y - 64 / 2)
        let center = superView.center
        
        if position == .top {
            var frame = self.frame
            frame.origin.y = 0.0 - self.frame.height - selectViewTop
            self.frame = frame
        } else if position == .bottom {
            var frame = self.frame
            frame.origin.y = superView.frame.height
            self.frame = frame
        } else {
            self.center = center
        }
        
        if let v = subview {
            superView.insertSubview(self.tapControl, belowSubview: v)
            superView.insertSubview(self, belowSubview: v)
        } else {
            superView.addSubview(self.tapControl)
            superView.addSubview(self)
        }
        superView.isHidden = false
        
        if animate {
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: .curveEaseIn, animations: {
                if self.presentModelStyle == .translucent {
                    self.tapControl.alpha = 0.5
                }
                if self.position == .top{
                    var frame = self.frame
                    frame.origin.y = self.selectViewTop
                    self.frame = frame
                } else if self.position == .bottom {
                    var frame = self.frame
                    frame.origin.y = superView.frame.height - self.frame.height
                    self.frame = frame
                } else {
                    self.center = center
                }
            }, completion: { (finished) in
                self.isShowed = true
                if self.style == .list {
                    self.tableView.reloadData()
                } else if self.style == .pick {
                    self.pickView.reloadComponent(0)
                    if self.selectRow >= 0 {
                        self.pickView.selectRow(self.selectRow, inComponent: 0, animated: true)
                    }
                }
            })
        }
    }
    public func dismiss(animate:Bool = true) {
        guard let superView = self.superview else {
            return
        }
        if animate {
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: .curveEaseOut, animations: {
                self.tapControl.alpha = 0.0
                if self.position == .top {
                    var frame = self.frame
                    frame.origin.y = 0.0 - self.frame.height
                    self.frame = frame
                }else if self.position == .bottom {
                    var frame = self.frame
                    frame.origin.y = superView.frame.height
                    self.frame = frame
                }else{
                    self.center = superView.center
                }
            }, completion: { (finished) in
                if finished {
                    self.clearInfo()
                }
            })
        }else{
            self.clearInfo()
        }
    }
    
    fileprivate func clearInfo() {
        self.isShowed = false
        tapControl.removeFromSuperview()
        bgView.removeFromSuperview()
        self.removeAllSubView()
        self.removeFromSuperview()
        bgWindow.isHidden = true
    }
    @objc private func tapClick() {
        if let delegate = self.delegate {
            delegate.jxSelectView?(selectView: self, clickButtonAtIndex: 0)
        }
        if let block = self.dismissBlock {
            block()
        }
        self.dismiss()
    }
    @objc func confirmClick() {
        if let delegate = self.delegate {
            delegate.jxSelectView?(selectView: self, didSelectRowAt: selectRow, inSection: selectSection)
        }
        self.dismiss()
    }
    fileprivate func viewDisAppear(row:Int, section:Int) {
        if let delegate = self.delegate, row >= 0{
            delegate.jxSelectView?(selectView: self, didSelectRowAt: row, inSection: section)
        }
        self.dismiss()
    }
}

extension JXSelectView : UITableViewDelegate,UITableViewDataSource{
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = self.dataSource {
            return dataSource.jxSelectView(selectView:self, numberOfRowsInSection: section)
        }
        return 0
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let dataSource = self.dataSource {
            return dataSource.jxSelectView(selectView: self, heightForRowAt: indexPath.row)
        }
        return tableViewCellHeight
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        //let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: reuseIdentifier)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.numberOfLines = 1
            if isEnabled == false{
                cell?.selectionStyle = .none
            }
            if let dataSource = self.dataSource {
                if let view = dataSource.jxSelectView?(selectView: self, viewForRow: indexPath.row) {
                    view.tag = 666
                    cell?.contentView.addSubview(view)
                }
            }
        }

        if let view = cell?.contentView.viewWithTag(666){
            view.isHidden = false
        } else {
            if let dataSource = self.dataSource {
                cell?.textLabel?.text = dataSource.jxSelectView(selectView: self, contentForRow: indexPath.row, InSection: indexPath.section)
            }
            
        }
        
        return cell!
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isEnabled {
            tableView.deselectRow(at: indexPath, animated: true)
            if isUseCustomTopBar {
                selectRow = indexPath.row
            }else{
                self.viewDisAppear(row: indexPath.row, section: indexPath.section)
                self.dismiss(animate: true)
            }
        }else{
            
        }
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
extension JXSelectView : UIPickerViewDelegate, UIPickerViewDataSource{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if let dataSource = self.dataSource {
            return dataSource.numberOfComponents?(selectView: self) ?? 1
        }
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let dataSource = self.dataSource {
            return dataSource.jxSelectView(selectView: self, numberOfRowsInSection: component)
        }
        return 0
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let dataSource = self.dataSource {
            return dataSource.jxSelectView(selectView: self, contentForRow: row, InSection: component)
        }
        return nil
    }
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if let dataSource = self.dataSource {
            let string = dataSource.jxSelectView(selectView: self, contentForRow: row, InSection: component)
            let attributeString = NSMutableAttributedString.init(string: string)
            attributeString.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13),NSAttributedString.Key.foregroundColor:JXMainColor], range: NSRange.init(location: 0, length: string.count))
            print(attributeString)
            return attributeString
        }
        
        return nil
    }
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if let dataSource = self.dataSource {
            return dataSource.jxSelectView?(selectView: self, widthForComponent: component) ?? selectViewWidth
        }
        return selectViewWidth
    }
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if let dataSource = self.dataSource {
            return dataSource.jxSelectView(selectView: self, heightForRowAt: component)
        }
        return pickViewCellHeight
    }
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerView.subviews.forEach { (view) in
            if view.frame.size.height < 2{
                view.backgroundColor = JXEeeeeeColor
            }
        }
        var string = ""
        if let dataSource = self.dataSource {
            string = dataSource.jxSelectView(selectView: self, contentForRow: row, InSection: component)
        }
        let label = UILabel()
        label.sizeToFit()
        label.textColor = JXMainColor
        label.textAlignment = .center
        label.text = string
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRow = row
        if isUseSystemItemBar {
            //self.pickView.reloadAllComponents()
        } else if isUseCustomTopBar {
            
        } else {
            self.viewDisAppear(row: row,section: component)
        }
    }
}
@objc public protocol JXSelectViewDataSource: NSObjectProtocol {
    
    func jxSelectView(selectView :JXSelectView, numberOfRowsInSection section:Int) -> Int
    func jxSelectView(selectView :JXSelectView, heightForRowAt row:Int) -> CGFloat
    func jxSelectView(selectView :JXSelectView, contentForRow row:Int, InSection section:Int) -> String
    
    @objc optional func numberOfComponents(selectView: JXSelectView) -> Int
    @objc optional func jxSelectView(selectView: JXSelectView, widthForComponent component: Int) -> CGFloat
    @objc optional func jxSelectView(selectView: JXSelectView, viewForRow row:Int) -> UIView?
    
}
@objc public protocol JXSelectViewDelegate: NSObjectProtocol {
    
    @objc optional func jxSelectView(selectView :JXSelectView, didSelectRowAt row:Int, inSection section:Int)
    @objc optional func jxSelectView(selectView: JXSelectView, clickButtonAtIndex index:Int)
}

