//
//  UPayVersionVM.swift
//  UPay
//
//  Created by 飞亦 on 6/18/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class UPayVersionVM: NSObject {
    var versionEntity = UPayVersionModel()
    
    func version(completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.version.rawValue, param: ["os": 1], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion(nil, msg, false)
                    return
            }
            
            self.versionEntity.setValuesForKeys(result)
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
