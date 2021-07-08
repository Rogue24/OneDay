//
//  OneDayData.swift
//  OneDay
//
//  Created by aa on 2021/7/7.
//

import UIKit
import WidgetKit
import KakaJSON
import SwiftyJSON

// MARK:- Static Data

let DefaultSmallImage: UIImage = #imageLiteral(resourceName: "train_small")
let DefaultMediumImage: UIImage = #imageLiteral(resourceName: "train_medium")
let DefaultLargeImage: UIImage = #imageLiteral(resourceName: "train_large")

let DefaultContent: String = "人类的悲欢并不相通，我只觉得他们吵闹。"
let FailedContent: String = "很遗憾本次更新失败，请等待下一次更新。"

let Months: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
let ShotMonths: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

let Weekdays: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
let ShotWeekdays: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

let HitokotoURL: String = "https://v1.hitokoto.cn"
let RandomImageURL: (CGSize) -> String = { size in
    "https://picsum.photos/\(Int(size.width))/\(Int(size.height))?random=\(arc4random_uniform(1000))"
}

// MARK:- Extension

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

extension Date: JPCompatible {}
extension JP where Base == Date {
    var weekdayString: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day, .weekday], from: base)
        // 星期几（注意，周日是“1”，周一是“2”。。。。）
        return components.weekday.map { Weekdays[$0 - 1] } ?? ""
    }
}

// MARK:- Model

struct OneDay: Convertible {
    let id: Int = 0
    let uuid: String = ""
    let type: String = ""
    let from: String = ""
    let from_who: String = ""
    let creator: String = ""
    let creator_uid: Int = 0
    let reviewer: Int = 0
    let commit_from: String = ""
    let created_at: String = ""
    let hitokoto: String = ""
    let length: Int = 0
}

struct OneDayModel {
    
    let content: String
    let bgImage: UIImage
    
    init(content: String, bgImage: UIImage) {
        self.content = content
        self.bgImage = bgImage
    }
    
    static func placeholder(_ family: WidgetFamily) -> Self {
        OneDayModel(content: DefaultContent, bgImage: family.jp.defaultImage)
    }
    
    static func fetch(family: WidgetFamily, completion: @escaping (OneDayModel) -> Void) {
        Asyncs.async {
            let group = DispatchGroup()
            
            var oneDay: OneDay? = nil
            var bgImage: UIImage? = nil
            var error: Error? = nil
            
            let hitokotoTask = URLSession.shared.dataTask(with: URL(string: HitokotoURL)!) { (data, _, e) in
                defer { group.leave() }
                error = e
                guard let data = data,
                      let json = JSON(data).dictionary else { return }
                oneDay = json.kj.model(OneDay.self)
            }
            
            let imageTask = URLSession.shared.dataTask(with: URL(string: RandomImageURL(family.jp.imageSize))!) { (data, _, e) in
                defer { group.leave() }
                error = e
                guard let data = data else { return }
                bgImage = UIImage(data: data)
            }
            
            group.enter()
            hitokotoTask.resume()
            
            group.enter()
            imageTask.resume()
            
            group.notify(queue: DispatchQueue.main) {
                if let error = error {
                    JPrint("请求失败 --- \(error)")
                } else if oneDay == nil {
                    JPrint("请求失败 --- 没有数据")
                }
                completion(OneDayModel(content: oneDay.map { $0.hitokoto } ?? FailedContent,
                                       bgImage: bgImage ?? family.jp.defaultImage))
            }
        }
    }
}
