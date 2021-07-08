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
}
