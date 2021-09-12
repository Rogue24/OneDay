//
//  OneDayStore.swift
//  OneDay
//
//  Created by aa on 2021/7/26.
//

import UIKit
import WidgetKit
import KakaJSON
import SwiftyJSON
import SwiftUI
import Combine

func ImageCacheName(_ family: WidgetFamily, date: Date = Date()) -> String {
    let dateStr = String(format: "%.0lf", date.timeIntervalSince1970)
    switch family {
    case .systemLarge:
        return "large_\(dateStr).jpeg"
    case .systemMedium:
        return "medium_\(dateStr).jpeg"
    default:
        return "small_\(dateStr).jpeg"
    }
}

func ImageCachePath(_ name: String) -> String {
    var cachePath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppGroupIdentifier)!.path
    cachePath += "/"
    cachePath += name
    return cachePath
}

@propertyWrapper struct UserDefault<T> {
    let key: String
    
    var wrappedValue: T? {
        set {
            UserDefaults(suiteName: AppGroupIdentifier)?.set(newValue, forKey: key)
            UserDefaults(suiteName: AppGroupIdentifier)?.synchronize()
        }
        get {
            UserDefaults(suiteName: AppGroupIdentifier)?.object(forKey: key) as? T
        }
    }
}

class OneDayStore: ObservableObject {
    
    /**
     * 目前疑问：
     * 为何要同时使用`UserDefault`和`AppStorage`？
     * 真正存值的是`UserDefault`，而`AppStorage`则是SwiftUI的状态，用于刷新`桌面Widget`和`App内`的UI（只要`AppStorage`发生改变SwiftUI则会立马刷新视图）
     * 虽然`AppStorage`也是能用于存取的，但是存值后`桌面Widget`和`App内`的数据并不是最新的！会有延迟（至少目前的现象就是如此）
     * 目前想到方案就是使用`UserDefault`存取，而`AppStorage`用于UI刷新的一种奇怪组合。
     */
    
    @UserDefault<Data>(key: SmallDataKey)
    private static var smallData
    @AppStorage(SmallDataKey, store: UserDefaults(suiteName: AppGroupIdentifier))
    private static var smallStorage: Data?
    
    @UserDefault<Data>(key: MediumDataKey)
    private static var mediumData
    @AppStorage(MediumDataKey, store: UserDefaults(suiteName: AppGroupIdentifier))
    private static var mediumStorage: Data?
    
    @UserDefault<Data>(key: LargeDataKey)
    private static var largeData
    @AppStorage(LargeDataKey, store: UserDefaults(suiteName: AppGroupIdentifier))
    private static var largeStorage: Data?
    
    static func cacheModel(_ model: OneDayModel) {
        let data = model.encode()
        let family = model.family
        switch family {
        case .systemLarge:
            largeData = data
            largeStorage = data
        case .systemMedium:
            mediumData = data
            mediumStorage = data
        default:
            smallData = data
            smallStorage = data
        }
    }
    
    static func fetchModel(_ family: WidgetFamily) -> OneDayModel {
        switch family {
        case .systemLarge:
            return .decode(largeData) ?? .placeholder(.systemLarge)
        case .systemMedium:
            return .decode(mediumData) ?? .placeholder(.systemMedium)
        default:
            return .decode(smallData) ?? .placeholder(.systemSmall)
        }
    }
    
    static func fetchData(_ family: WidgetFamily, completion: @escaping () -> ()) {
        Asyncs.asyncDelay(family.jp.delay) {
            let cacheModel = fetchModel(family)
            
            var text = cacheModel.text
            var imageName = cacheModel.imageName
            let date = cacheModel.date
            
            let isRefreshText = cacheModel.isRefreshText || text == ""
            let isRefreshImage = cacheModel.isRefreshImage || imageName == ""
            let isRefreshDate = cacheModel.isRefreshDate
            
            let refreshDone: (_ text: String, _ imageName: String) -> () = {
                var model = OneDayModel(family: family,
                                        text: $0,
                                        imageName: $1,
                                        date: isRefreshDate ? Date() : date)
                model.isRefreshText = isRefreshText
                model.isRefreshImage = isRefreshImage
                model.isRefreshDate = isRefreshDate
                
                Asyncs.main {
                    self.cacheModel(model)
                    completion()
                }
            }
            
            if !isRefreshText && !isRefreshImage {
                refreshDone(text, imageName)
                return
            }
            
            let group = DispatchGroup()
            let printMsg: (_ msg: String) -> () = {
                let familyName = family.jp.familyName
                JPrint(familyName, $0)
            }
            
            if isRefreshText {
                text = FailedText
                let hitokotoTask = URLSession.shared.dataTask(with: URL(string: HitokotoURL)!) { (data, _, error) in
                    defer { group.leave() }
                    if let error = error {
                        printMsg(String(format: "文案请求失败: %@", error as CVarArg))
                        return
                    }
                    guard let data = data, data.count > 0 else {
                        printMsg("文案请求失败: 没有数据")
                        return
                    }
                    guard let dict = JSON(data).dictionary else {
                        printMsg("文案请求失败: 数据解析失败")
                        return
                    }
                    let hitokoto = dict.kj.model(Hitokoto.self)
                    printMsg(String(format: "文案请求成功: %@", hitokoto.hitokoto))
                    text = hitokoto.hitokoto
                }
                group.enter()
                hitokotoTask.resume()
            } else {
                printMsg("不用请求文案")
            }
            
            if isRefreshImage {
                File.manager.deleteFile(ImageCachePath(imageName))
                imageName = ""
                let imageTask = URLSession.shared.dataTask(with: URL(string: RandomImageURL(family.jp.imageSize))!) { (data, _, _) in
                    defer { group.leave() }
                    guard let data = data else {
                        printMsg("图片请求失败")
                        return
                    }
                    let cacheName = ImageCacheName(family)
                    let cachePath = ImageCachePath(cacheName)
                    do {
                        try data.write(to: URL(fileURLWithPath: cachePath))
                        imageName = cacheName
                        printMsg("\(cachePath) --- 图片缓存成功")
                    } catch {
                        printMsg(String(format: "%@ --- 图片缓存失败: %@", cachePath, error as CVarArg))
                    }
                }
                group.enter()
                imageTask.resume()
            } else {
                printMsg("不用请求图片")
            }
            
            group.notify(queue: DispatchQueue.global()) {
                refreshDone(text, imageName)
            }
        }
    }
    
}
