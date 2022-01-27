//
//  Const.swift
//  Neves_Example
//
//  Created by 周健平 on 2020/10/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

let ScreenScale: CGFloat = UIScreen.mainScale

let PortraitScreenWidth: CGFloat = min(UIScreen.mainWidth, UIScreen.mainHeight)
let PortraitScreenHeight: CGFloat = max(UIScreen.mainWidth, UIScreen.mainHeight)
let PortraitScreenSize: CGSize = CGSize(width: PortraitScreenWidth, height: PortraitScreenHeight)
let PortraitScreenBounds: CGRect = CGRect(origin: .zero, size: PortraitScreenSize)

let LandscapeScreenWidth: CGFloat = PortraitScreenHeight
let LandscapeScreenHeight: CGFloat = PortraitScreenWidth
let LandscapeScreenSize: CGSize = CGSize(width: LandscapeScreenWidth, height: LandscapeScreenHeight)
let LandscapeScreenBounds: CGRect = CGRect(origin: .zero, size: LandscapeScreenSize)

let IsBangsScreen: Bool = PortraitScreenHeight > 736.0

let BasisWScale: CGFloat = PortraitScreenWidth / 375.0
let BasisHScale: CGFloat = PortraitScreenHeight / 667.0

let hhmmssSSFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm:ss:SS"
    return formatter
}()

// MARK: - OneDay Data
let AppGroupIdentifier: String = "group.zhoujianping.OneDay"

let SmallDataKey: String = "smallData"
let MediumDataKey: String = "mediumData"
let LargeDataKey: String = "largeData"

let DefaultSmallImage: UIImage = #imageLiteral(resourceName: "train_small")
let DefaultMediumImage: UIImage = #imageLiteral(resourceName: "train_medium")
let DefaultLargeImage: UIImage = #imageLiteral(resourceName: "train_large")

let DefaultText: String = "人类的悲欢并不相通，我只觉得他们吵闹。"
let FailedText: String = "很遗憾本次更新失败，请等待下一次更新。"

let Months: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
let ShotMonths: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

let Weekdays: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
let ShotWeekdays: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

let HitokotoURL: String = "https://v1.hitokoto.cn"
let RandomImageURL: (CGSize) -> String = {
    "https://picsum.photos/\(Int($0.width))/\(Int($0.height))?random=\(arc4random_uniform(10000))"
}
