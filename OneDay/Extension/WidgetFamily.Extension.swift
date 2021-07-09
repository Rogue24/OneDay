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
    
    var widgetSize: CGSize {
        switch PortraitScreenWidth {
        case 414...:
            switch PortraitScreenHeight {
            case 896...:
                switch base {
                case .systemMedium:
                    return CGSize(width: 360, height: 169)
                case .systemLarge:
                    return CGSize(width: 360, height: 379)
                default:
                    return CGSize(width: 169, height: 169)
                }
                
            default: // 736
                switch base {
                case .systemMedium:
                    return CGSize(width: 348, height: 159)
                case .systemLarge:
                    return CGSize(width: 348, height: 357)
                default:
                    return CGSize(width: 159, height: 159)
                }
            }
            
        case 375:
            switch PortraitScreenHeight {
            case 812...:
                switch base {
                case .systemMedium:
                    return CGSize(width: 329, height: 155)
                case .systemLarge:
                    return CGSize(width: 329, height: 345)
                default:
                    return CGSize(width: 155, height: 155)
                }
                
            default: // 667
                switch base {
                case .systemMedium:
                    return CGSize(width: 321, height: 148)
                case .systemLarge:
                    return CGSize(width: 321, height: 324)
                default:
                    return CGSize(width: 148, height: 148)
                }
            }
            
        default: // 320x568
            switch base {
            case .systemMedium:
                return CGSize(width: 292, height: 141)
            case .systemLarge:
                return CGSize(width: 292, height: 311)
            default:
                return CGSize(width: 141, height: 141)
            }
        }
    }
    
    var imageSize: CGSize {
        var imageSize: CGSize
        switch base {
        case .systemLarge:
            imageSize = widgetSize
            imageSize.height -= 100
        default:
            imageSize = widgetSize
        }
        imageSize.width *= UIScreen.mainScale
        imageSize.height *= UIScreen.mainScale
        return imageSize
    }
}
