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
        case .systemLarge: return DefaultLargeImage
        case .systemMedium: return DefaultMediumImage
        default: return DefaultSmallImage
        }
    }
    
    var familyName: String {
        switch base {
        case .systemLarge: return "大杯"
        case .systemMedium: return "中杯"
        default: return "小杯"
        }
    }
    
    var delay: TimeInterval {
        switch base {
        case .systemLarge: return 2
        case .systemMedium: return 1
        default: return 0
        }
    }
    
    var widgetSize: CGSize {
        switch PortraitScreenWidth {
        case 428: // 428 x 926 - iPhone 12 Pro Max
            switch base {
            case .systemLarge:
                return CGSize(width: 364, height: 382)
            case .systemMedium:
                return CGSize(width: 364, height: 170)
            default:
                return CGSize(width: 170, height: 170)
            }
        
        case 414:
            switch PortraitScreenHeight {
            case 896:  // 414 x 896 - iPhone 11 Pro Max
                switch base {
                case .systemLarge:
                    return CGSize(width: 360, height: 379)
                case .systemMedium:
                    return CGSize(width: 360, height: 169)
                default:
                    return CGSize(width: 169, height: 169)
                }
                
            default: // 414 x 736 - iPhone 8 Plus
                switch base {
                case .systemLarge:
                    return CGSize(width: 348, height: 351)
                case .systemMedium:
                    return CGSize(width: 348, height: 157)
                default:
                    return CGSize(width: 157, height: 157)
                }
            }
            
        case 390: // 390 x 844 - iPhone 12 Pro
            switch base {
            case .systemLarge:
                return CGSize(width: 338, height: 354)
            case .systemMedium:
                return CGSize(width: 338, height: 158)
            default:
                return CGSize(width: 158, height: 158)
            }
            
        case 375:
            switch PortraitScreenHeight {
            case 812: // 375 x 812 - iPhone X & iPhone 12 min
                switch base {
                case .systemLarge:
                    return CGSize(width: 329, height: 345)
                case .systemMedium:
                    return CGSize(width: 329, height: 155)
                default:
                    return CGSize(width: 155, height: 155)
                }
                
            default: // 375 x 667 - iPhone 8
                switch base {
                case .systemLarge:
                    return CGSize(width: 321, height: 324)
                case .systemMedium:
                    return CGSize(width: 321, height: 148)
                default:
                    return CGSize(width: 148, height: 148)
                }
            }
            
        default: // 320 x 568 - iPhone 5s
            switch base {
            case .systemLarge:
                return CGSize(width: 292, height: 311)
            case .systemMedium:
                return CGSize(width: 292, height: 141)
            default:
                return CGSize(width: 141, height: 141)
            }
        }
    }
    
    var imageSize: CGSize {
        var imageSize = widgetSize
        if base == .systemLarge {
            imageSize.height -= 100
        }
        imageSize.width *= ScreenScale
        imageSize.height *= ScreenScale
        return imageSize
    }
}
