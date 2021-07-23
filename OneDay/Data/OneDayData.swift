//
//  OneDayData.swift
//  OneDay
//
//  Created by 周健平 on 2021/7/14.
//

import UIKit
import WidgetKit
import KakaJSON
import SwiftyJSON

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
    
    static func fetch(context: TimelineProviderContext?, content: String, bgImagePath: String, completion: @escaping (OneDayModel) -> Void) {
        let family = context?.family ?? .systemSmall
        let delay = context == nil ? 0 : family.jp.delay
        
        // 如果同时多种 Widget 一起请求 Hitokoto 接口，很大几率会失败其中一个以上，所以根据类型分别延时请求吧
        Asyncs.asyncDelay(delay) {
            let familyName = family.jp.familyName
            let group = DispatchGroup()
            
            var kContent: String? = nil
            if content.count > 0 {
                JPrint(familyName, "文案有缓存！")
                kContent = content
            } else {
                JPrint(familyName, "文案没缓存，去请求！")
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
                    let oneDay = dict.kj.model(OneDay.self)
                    JPrint(familyName, "请求成功", oneDay.hitokoto)
                    kContent = oneDay.hitokoto
                }
                group.enter()
                hitokotoTask.resume()
            }
            
            var bgImage: UIImage? = nil
            if File.manager.fileExists(bgImagePath),
               let imgData = try? Data(contentsOf: URL(fileURLWithPath: bgImagePath)) {
                JPrint(familyName, "图片有缓存！")
                bgImage = UIImage(data: imgData)
            } else {
                JPrint(familyName, "图片没缓存，去请求！")
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
            }
            
            group.notify(queue: DispatchQueue.main) {
                completion(OneDayModel(content: kContent ?? FailedContent,
                                       bgImage: bgImage ?? family.jp.defaultImage))
            }
        }
    }
}
