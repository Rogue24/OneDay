//
//  WidgetFamily.Extension.swift
//  OneDay
//
//  Created by 周健平 on 2021/7/9.
//

import UIKit
import WidgetKit

extension WidgetFamily: JPCompatible {}
extension JP where Base == WidgetFamily {
    var defaultImage: UIImage {
        switch base {
        case .systemMedium:
            return DefaultMediumImage
        case .systemLarge:
            return DefaultLargeImage
        default:
            return DefaultSmallImage
        }
    }
    
    var imageSize: CGSize {
        var imageSize: CGSize
        switch base {
        case .systemMedium:
            imageSize = CGSize(width: 360, height: 169)
        case .systemLarge:
            imageSize = CGSize(width: 360, height: 275)
        default:
            imageSize = CGSize(width: 169, height: 169)
        }
        imageSize.width *= UIScreen.mainScale
        imageSize.height *= UIScreen.mainScale
        return imageSize
    }
    
    var familyName: String {
        switch base {
        case .systemMedium: return "中杯"
        case .systemLarge: return "大杯"
        default: return "小杯"
        }
    }
    
    var delay: TimeInterval {
        switch base {
        case .systemMedium: return 1
        case .systemLarge: return 2
        default: return 0
        }
    }
}
