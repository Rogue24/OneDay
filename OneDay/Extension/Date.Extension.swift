//
//  Date.Extension.swift
//  OneDay
//
//  Created by 周健平 on 2021/7/9.
//

import Foundation

extension Date: JPCompatible {}
extension JP where Base == Date {
    
    typealias DateInfo = (year: String, month: String, day: String, weekday: String)
    var info: DateInfo {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: base)
    
        let year = "\(components.year!)"
        let month = Months[components.month! - 1]
        let day = "\(components.day!)"
        let weekday = ShotWeekdays[components.weekday! - 1] // 星期几（注意，周日是“1”，周一是“2”。。。。）
        return (year, month, day, weekday)
    }
    
}
