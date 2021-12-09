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
    
    var id = UUID()
    
    let familyRawValue: Int
    var text: String
    var imageName: String
    var date: Date
    
    var isRefreshText: Bool = true
    var isRefreshImage: Bool = true
    var isRefreshDate: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case familyRawValue, text, imageName, date, isRefreshText, isRefreshImage, isRefreshDate
    }
    
    static func placeholder(_ family: WidgetFamily) -> OneDayModel {
        OneDayModel(family: family, text: DefaultText, date: Date())
    }
    
    init(family: WidgetFamily, text: String = "", imageName: String = "", date: Date) {
        self.familyRawValue = family.rawValue
        self.text = text
        self.imageName = imageName
        self.date = date
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        familyRawValue = try c.decode(Int.self, forKey: .familyRawValue)
        text = try c.decode(String.self, forKey: .text)
        imageName = try c.decode(String.self, forKey: .imageName)
        date = try c.decode(Date.self, forKey: .date)
        isRefreshText = try c.decode(Bool.self, forKey: .isRefreshText)
        isRefreshImage = try c.decode(Bool.self, forKey: .isRefreshImage)
        isRefreshDate = try c.decode(Bool.self, forKey: .isRefreshDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(familyRawValue, forKey: .familyRawValue)
        try c.encode(text, forKey: .text)
        try c.encode(imageName, forKey: .imageName)
        try c.encode(date, forKey: .date)
        try c.encode(isRefreshText, forKey: .isRefreshText)
        try c.encode(isRefreshImage, forKey: .isRefreshImage)
        try c.encode(isRefreshDate, forKey: .isRefreshDate)
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
        let imagePath = ImageCachePath(imageName)
        if File.manager.fileExists(imagePath), let image = UIImage(contentsOfFile: imagePath) {
            return image
        } else {
            return family.jp.defaultImage
        }
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
}
