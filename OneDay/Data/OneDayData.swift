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

// MARK: - Model

struct Hitokoto: Convertible {
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

struct OneDayModel: Codable, Identifiable {
    
    struct RefreshOptions: OptionSet {
        var rawValue: Int = 0
        static let text = Self(rawValue: 1 << 1)
        static let image = Self(rawValue: 1 << 2)
        static let gif = Self(rawValue: 1 << 3)
        static let all = Self(rawValue: 1 << 1 + 1 << 2 + 1 << 3)
    }
    
    var id = UUID()
    
    /// 小/中/大杯
    let familyRawValue: Int
    
    /// 文案
    var text: String
    /// 图片文件名
    var imageName: String
    /// GIF文件名
    var gifName: String
    /// 日期
    var date: Date
    
    /// 是否本地文案
    var isLocalText: Bool = false
    /// 是否本地图片
    var isLocalImage: Bool = false
    /// 是否自设日期
    var isLocalDate: Bool = false
    
    /// 刷新类型（Int类型，用于存储）
    var refreshOptionsRawValue: Int = RefreshOptions.all.rawValue
    /// 刷新类型
    var refreshOptions: RefreshOptions {
        set { refreshOptionsRawValue = newValue.rawValue }
        get { RefreshOptions(rawValue: refreshOptionsRawValue) }
    }
    
    enum CodingKeys: String, CodingKey {
        case familyRawValue, text, imageName, gifName, date, isLocalText, isLocalImage, isLocalDate, refreshOptionsRawValue
    }
    
    init(family: WidgetFamily, text: String = "", imageName: String = "", gifName: String = "", date: Date) {
        self.familyRawValue = family.rawValue
        self.text = text
        self.imageName = imageName
        self.gifName = gifName
        self.date = date
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        
        familyRawValue = try c.decode(Int.self, forKey: .familyRawValue)
        
        text = try c.decode(String.self, forKey: .text)
        imageName = try c.decode(String.self, forKey: .imageName)
        gifName = try c.decode(String.self, forKey: .gifName)
        date = try c.decode(Date.self, forKey: .date)
        
        if text != "" {
            isLocalText = try c.decode(Bool.self, forKey: .isLocalText)
        }
        
        if imageName != "" {
            isLocalImage = try c.decode(Bool.self, forKey: .isLocalImage)
        }
        
        isLocalDate = try c.decode(Bool.self, forKey: .isLocalDate)
        
        refreshOptionsRawValue = try c.decode(Int.self, forKey: .refreshOptionsRawValue)
        if refreshOptionsRawValue == 0 {
            refreshOptionsRawValue = RefreshOptions.all.rawValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        
        try c.encode(familyRawValue, forKey: .familyRawValue)
        
        try c.encode(text, forKey: .text)
        try c.encode(imageName, forKey: .imageName)
        try c.encode(gifName, forKey: .gifName)
        try c.encode(date, forKey: .date)
        
        try c.encode(isLocalText, forKey: .isLocalText)
        try c.encode(isLocalImage, forKey: .isLocalImage)
        try c.encode(isLocalDate, forKey: .isLocalDate)
        
        try c.encode(refreshOptionsRawValue, forKey: .refreshOptionsRawValue)
    }
    
}

extension OneDayModel {
    var family: WidgetFamily {
        WidgetFamily(rawValue: familyRawValue) ?? .systemSmall
    }
    
    var showText: String {
        text.count > 0 ? text : DefaultText
    }
    
    var image: UIImage {
        let imagePath = CachePath(imageName)
        if File.manager.fileExists(imagePath), let image = UIImage(contentsOfFile: imagePath) {
            return image
        } else {
            return family.jp.defaultImage
        }
    }
    
    var gif: UIImage.GifResult? {
        guard gifName.count > 0 else { return nil }
        
        let gifPath = CachePath(gifName)
        guard File.manager.fileExists(gifPath), 
              let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath)) 
        else {
            return nil
        }
        
        return UIImage.decodeGIF(gifData)
    }
}

extension OneDayModel {
    func encode() -> Data? {
        try? JSONEncoder().encode(self)
    }
    
    static func decode(_ data: Data?) -> OneDayModel? {
        guard let data = data else { return nil }
        return try? JSONDecoder().decode(OneDayModel.self, from: data)
    }
    
    static func placeholder(_ family: WidgetFamily) -> OneDayModel {
        OneDayModel(family: family, text: DefaultText, date: Date())
    }
    
    static func build(withData data: Data?, family: WidgetFamily) -> OneDayModel {
        .decode(data) ?? .placeholder(family)
    }
}
