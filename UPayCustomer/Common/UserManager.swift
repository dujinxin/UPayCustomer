//
//  UserManager.swift
//  ZPSY
//
//  Created by 杜进新 on 2017/9/22.
//  Copyright © 2017年 zhouhao. All rights reserved.
//

import Foundation

private let userPath = NSHomeDirectory() + "/Documents/userAccound.json"

class UserEntity: UPayBaseModel {
    
    @objc var avatar : String?
    @objc var loginName : String = ""
    @objc var name : String?
    @objc var plb_sid : String = ""
    @objc var validId : String? //认证信息id，认证失败时拉取认证信息时使用
    
    @objc var depositStatus : Int = 0 //押金状态，1未押金，2已押金
    @objc var rakeBack : Float = 0 //返佣比例
    @objc var resetPsdStatus : Int = 0 //是否需要重置密码，1需要，2不需要
    @objc var resetSafePsdStatus : Int = 0//是否需要重置安全密码，1需要，2不需要
    @objc var validStatus : Int = 0//认证状态，1未认证，2认证中，3认证通过，4认证失败
}

class UserManager : NSObject{
    
    static let manager = UserManager()
    
    //登录接口获取
    var userEntity = UserEntity()
    //
    var userDict = Dictionary<String, Any>()
    
    var isLogin: Bool {
        get {
            return !userEntity.plb_sid.isEmpty
        }
    }
    
    override init() {
        super.init()
        
        let pathUrl = URL(fileURLWithPath: userPath)
        
        guard
            let data = try? Data(contentsOf: pathUrl),
            let dict = try? JSONSerialization.jsonObject(with: data, options: [])else {
                print("该地址不存在用户信息：\(userPath)")
                return
        }
        self.userDict = dict as! [String : Any]
        self.userEntity.setValuesForKeys(dict as! [String : Any])
        print(dict)
        print("用户地址：\(userPath)")
        
    }
    
    /// 保存用户信息
    ///
    /// - Parameter dict: 用户信息字典
    /// - Returns: 保存结果
    func saveAccound(dict:Dictionary<String, Any>) -> Bool {

        self.userDict = dict
        self.userEntity.setValuesForKeys(dict)

        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
            else {
                return false
        }
        try? data.write(to: URL.init(fileURLWithPath: userPath))
        print("保存地址：\(userPath)")
        
        return true
    }
    /// 删除用户信息
    func removeAccound() {
        self.userEntity = UserEntity()
        
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: userPath)
    }
    
}
extension UserManager {
    func updateNickName(_ nickName: String) {
        var dict = self.userDict
        dict["nickname"] = nickName
        let _ = self.saveAccound(dict: dict)
    }
    func updateAvatar(_ avatar: String) {
        var dict = self.userDict
        dict["headImg"] = avatar
        let _ = self.saveAccound(dict: dict)
    }
}
