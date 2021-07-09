//
//  Function.swift
//  Neves_Example
//
//  Created by aa on 2020/10/12.
//  Copyright © 2020 CocoaPods. All rights reserved.
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

func swapValues<T>(_ a: inout T, _ b: inout T) {
    (a, b) = (b, a)
}

func HalfDiffValue(_ superValue: CGFloat, _ subValue: CGFloat) -> CGFloat {
    (superValue - subValue) * 0.5
}

/// 获取当前页码
func CurrentPageNumber(_ offsetValue: CGFloat, _ pageSizeValue: CGFloat) -> Int {
    Int((offsetValue + pageSizeValue * 0.5) / pageSizeValue)
}

/// 按页拖动的比例
func PageScrollProgress(WithPageSizeValue pageSizeValue: CGFloat,
                        pageCount: Int,
                        offsetValue: CGFloat,
                        maxOffsetValue: CGFloat,
                        startOffsetValue: inout CGFloat,
                        currentPage: inout Int,
                        sourcePage: inout Int,
                        targetPage: inout Int,
                        progress: inout CGFloat) -> Bool {
    var ov: CGFloat = offsetValue
    if ov < 0 {
        ov = 0
    } else if ov > maxOffsetValue {
        ov = maxOffsetValue
    }
    
    var kStartOffsetValue = startOffsetValue
    
    if ov == kStartOffsetValue {
        return false
    }
    
    var kSourcePage: Int = 0
    var kTargetPage: Int = 0
    var kProgress: CGFloat = 0
    
    // 滑动位置与初始位置的距离
    let offsetDistance = CGFloat(fabs(Double(ov - kStartOffsetValue)))
    
    if ov > kStartOffsetValue {
        // 左/上滑动
        kSourcePage = Int(ov / pageSizeValue)
        kTargetPage = kSourcePage + 1
        kProgress = offsetDistance / pageSizeValue
        if kProgress >= 1 {
            if kTargetPage == pageCount {
                kProgress = 1
                kTargetPage -= 1
                kSourcePage -= 1
            } else {
                kProgress = 0
            }
        }
    } else {
        // 右/下滑动
        kTargetPage = Int(ov / pageSizeValue)
        kSourcePage = kTargetPage + 1
        kProgress = offsetDistance / pageSizeValue
        if kProgress > 1 {
            if kSourcePage == pageCount {
                kProgress = 1
                kTargetPage -= 1
                kSourcePage -= 1
            } else {
                kProgress = 0
            }
        }
    }
    
    if offsetDistance >= pageSizeValue {
        let kCurrentPage = Int((offsetValue + pageSizeValue * 0.5) / pageSizeValue)
        kStartOffsetValue = pageSizeValue * CGFloat(kCurrentPage)
        currentPage = kCurrentPage
        startOffsetValue = kStartOffsetValue
    }
    
    sourcePage = kSourcePage
    targetPage = kTargetPage
    progress = kProgress
    
    return true
}
