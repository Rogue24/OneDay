//
//  Function.swift
//  Neves_Example
//
//  Created by 周健平 on 2021/7/14.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

func JPrint(_ msg: Any..., file: NSString = #file, line: Int = #line, fn: String = #function) {
#if DEBUG
    guard msg.count != 0, let lastItem = msg.last else { return }
    
    let date = hhmmssSSFormatter.string(from: Date()).utf8
    let fileName = (file.lastPathComponent as NSString).deletingPathExtension
    let prefix = "[\(date)] [\(fileName) \(fn)] [第\(line)行]:"
    print(prefix, terminator: " ")

    let maxIndex = msg.count - 1
    for item in msg[..<maxIndex] {
        print(item, terminator: " ")
    }

    print(lastItem)
#endif
}
