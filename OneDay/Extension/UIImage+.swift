//
//  UIImage+.swift
//  OneDay
//
//  Created by aa on 2024/8/5.
//

import UIKit

extension UIImage {
    static func fromBundle(_ bundle: Bundle? = nil, forName name: String?, ofType ext: String?) -> UIImage? {
        guard let path = (bundle ?? Bundle.main).path(forResource: name, ofType: ext) else {
            return nil
        }
        return UIImage(contentsOfFile: path)
    }
}

extension UIImage {
    struct GifResult {
        let images: [UIImage]
        let duration: TimeInterval
    }
    
    static func decodeBundleGIF(_ bundle: Bundle? = nil, forName name: String) async -> GifResult? {
        guard let path = (bundle ?? Bundle.main).path(forResource: name, ofType: "gif") else {
            return nil
        }
        return await decodeLocalGIF(URL(fileURLWithPath: path))
    }
    
    static func decodeLocalGIF(_  url: URL) async -> GifResult? {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return decodeGIF(data)
    }
    
    static func decodeGIF(_  data: Data) -> GifResult? {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        
        let count = CGImageSourceGetCount(imageSource)
        
        var images: [UIImage] = []
        var duration: TimeInterval = 0
        
        for i in 0 ..< count {
            guard let cgImg = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            
            let img = UIImage(cgImage: cgImg)
            images.append(img)
            
            guard let proertyDic = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) else {
                duration += 0.1
                continue
            }
            
            // CFDictionary的使用：https://www.jianshu.com/p/766acdbbe271
            guard let gifDicValue = CFDictionaryGetValue(proertyDic, Unmanaged.passRetained(kCGImagePropertyGIFDictionary).autorelease().toOpaque()) else {
                duration += 0.1
                continue
            }
            
            let gifDic = Unmanaged<CFDictionary>.fromOpaque(gifDicValue).takeUnretainedValue()
            
            guard let delayValue = CFDictionaryGetValue(gifDic, Unmanaged.passRetained(kCGImagePropertyGIFUnclampedDelayTime).autorelease().toOpaque()) else {
                duration += 0.1
                continue
            }
            
            var delayNum = Unmanaged<NSNumber>.fromOpaque(delayValue).takeUnretainedValue()
            var delay = delayNum.doubleValue
            
            if delay <= Double.ulpOfOne {
                if let delayValue2 = CFDictionaryGetValue(gifDic, Unmanaged.passRetained(kCGImagePropertyGIFDelayTime).autorelease().toOpaque()) {
                    delayNum = Unmanaged<NSNumber>.fromOpaque(delayValue2).takeUnretainedValue()
                    delay = delayNum.doubleValue
                }
            }
            
            if delay < 0.02 {
                delay = 0.1
            }
            
            duration += delay
        }
        
        guard images.count > 0 else {
            return nil
        }
        
        return GifResult(images: images, duration: duration)
    }
}

