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

// MARK:- Model

struct OneDay: Convertible {
    let id: Int = 0
    let uuid: String = ""
    let type: String = ""
    let from: String = ""
    let from_who: String? = nil
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
        // 如果同时多种 Widget 一起请求 Hitokoto 接口，很大几率会失败其中一个以上，所以根据类型分别延时请求吧
        Asyncs.asyncDelay(family.jp.delay) {
            let group = DispatchGroup()
            
            let familyName = family.jp.familyName
            JPrint(familyName, "开始请求")
            
            var oneDay: OneDay? = nil
            let hitokotoTask = URLSession.shared.dataTask(with: URL(string: HitokotoURL)!) { (data, _, error) in
                defer { group.leave() }
                if let error = error {
                    JPrint(familyName, "请求失败", error)
                    return
                }
                guard let data = data, data.count > 0 else {
                    JPrint(familyName, "请求失败 没有数据")
                    return
                }
                guard let dict = JSON(data).dictionary else {
                    JPrint(familyName, "请求失败 数据解析失败")
                    return
                }
                oneDay = dict.kj.model(OneDay.self)
            }
            group.enter()
            hitokotoTask.resume()
            
            var bgImage: UIImage? = nil
            let imageTask = URLSession.shared.dataTask(with: URL(string: RandomImageURL(family.jp.imageSize))!) { (data, _, _) in
                defer { group.leave() }
                guard let data = data else {
                    JPrint(familyName, "请求图片失败")
                    return
                }
                bgImage = UIImage(data: data)
            }
            group.enter()
            imageTask.resume()
            
            group.notify(queue: DispatchQueue.main) {
                if let oneDay = oneDay {
                    JPrint(familyName, "请求成功", oneDay.hitokoto)
                }
                completion(OneDayModel(content: oneDay.map { $0.hitokoto } ?? FailedContent,
                                       bgImage: bgImage ?? family.jp.defaultImage))
            }
        }
    }
}
