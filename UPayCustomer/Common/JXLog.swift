//
//  JXLog.swift
//  UPayCustomer
//
//  Created by 飞亦 on 9/29/19.
//  Copyright © 2019 COB. All rights reserved.
//

import Foundation

struct JXLog: TextOutputStream {

    func write(_ string: String) {
        let fm = FileManager.default
        let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log.txt")
        if let handle = try? FileHandle(forWritingTo: log) {
            handle.seekToEndOfFile()
            handle.write(string.data(using: .utf8)!)
            handle.closeFile()
        } else {
            try? string.data(using: .utf8)?.write(to: log)
        }
    }
    
}

var log = JXLog()

public func printf<T>(_ msg:T, file: String = #file, line: Int = #line, function: String = #function) {
    
    print(Date(), to: &log)
    
//    if JXFoundationHelper.shared.isShowLog {
//        let fileName = (file as NSString).lastPathComponent.components(separatedBy: ".")[0]
//        Swift.print(fileName,msg, separator: " ", terminator: "\n")
//    }
    //print("[\(Date(timeIntervalSinceNow: 0))]",msg, separator: " ", terminator: "\n")
    //print("\(Date(timeIntervalSinceNow: 0)) <\(fileName) \(line) \(function)>\n\(msg)", separator: "", terminator: "\n")
}

