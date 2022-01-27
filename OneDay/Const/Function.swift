//
//  Function.swift
//  Neves_Example
//
//  Created by 周健平 on 2021/7/14.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

private let JPrintQueue = DispatchQueue(label: "JPrintQueue")
/// 自定义日志
func JPrint(_ msg: Any..., file: NSString = #file, line: Int = #line, fn: String = #function) {
#if DEBUG
    guard msg.count != 0, let lastItem = msg.last else { return }
    
    // 时间+文件位置+行数
    let date = hhmmssSSFormatter.string(from: Date()).utf8
    let fileName = (file.lastPathComponent as NSString).deletingPathExtension
    let prefix = "[\(date)] [\(fileName) \(fn)] [第\(line)行]:"
    
    // 获取【除最后一个】的其他部分
    let items = msg.count > 1 ? msg[..<(msg.count - 1)] : []
    
    JPrintQueue.sync {
        print(prefix, terminator: " ")
        items.forEach { print($0, terminator: " ") }
        print(lastItem)
    }
#endif
}
