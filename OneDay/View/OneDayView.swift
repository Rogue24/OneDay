//
//  OneDayView.swift
//  OneDay
//
//  Created by aa on 2021/7/7.
//

import SwiftUI

// MARK:- 自定义Modifier
struct ShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 3)
            .shadow(color: Color.black.opacity(0.3), radius: 1, x: 0, y: 1)
    }
}

// MARK:- Small Widget
struct OneDaySmallView: View {
    var model = OneDayModel.placeholder(.systemSmall)
    
    var body: some View {
        let date = Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
        
        let year = "\(components.year!)"
        let month = Months[components.month! - 1]
        let day = "\(components.day!)"
        let weekday = ShotWeekdays[components.weekday! - 1] // 星期几（注意，周日是“1”，周一是“2”。。。。）
        
        return ZStack {
            Image(uiImage: model.bgImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            Color.black.opacity(0.15)
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(day)
                            .font(.custom("DINAlternate-Bold", size: 28))
                            .foregroundColor(.white)
                        + Text(" / \(month)")
                            .font(.custom("DINAlternate-Bold", size: 14))
                            .foregroundColor(.white)
                        
                        Text("\(year), \(weekday)")
                            .font(.custom("PingFangSC", size: 10))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9020377438)))
                    }
                    Spacer()
                }
                .modifier(ShadowModifier())
                
                Spacer()
                
                Text(model.content)
                    .font(.custom("PingFangSC", size: 14))
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .lineSpacing(4)
                    .modifier(ShadowModifier())
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
        .frame(minWidth: 0, maxWidth: .infinity,
               minHeight: 0, maxHeight: .infinity)
        .clipped()
    }
}

// MARK:- Medium Widget
struct OneDayMediumView: View {
    var model = OneDayModel.placeholder(.systemMedium)
    
    var body: some View {
        let date = Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
        
        let year = "\(components.year!)"
        let month = Months[components.month! - 1]
        let day = "\(components.day!)"
        let weekday = ShotWeekdays[components.weekday! - 1] // 星期几（注意，周日是“1”，周一是“2”。。。。）
        
        return ZStack {
            Image(uiImage: model.bgImage)
                .resizable()
                .aspectRatio(contentMode: .fill)

            Color.black.opacity(0.15)

            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(day)
                            .font(.custom("DINAlternate-Bold", size: 36))
                            .foregroundColor(.white)
                        + Text(" / \(month)")
                            .font(.custom("DINAlternate-Bold", size: 18))
                            .foregroundColor(.white)
                        
                        Text("\(year), \(weekday)")
                            .font(.custom("PingFangSC", size: 11))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9020377438)))
                    }
                    Spacer()
                }
                .modifier(ShadowModifier())
                
                Spacer()
                
                Text(model.content)
                    .font(.custom("PingFangSC", size: 14))
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .lineSpacing(4)
                    .modifier(ShadowModifier())
            }
            .padding(.horizontal, 31)
            .padding(.top, 15)
            .padding(.bottom, 27)
        }
        .frame(minWidth: 0, maxWidth: .infinity,
               minHeight: 0, maxHeight: .infinity)
        .clipped()
    }

}

// MARK:- Large Widget
struct OneDayLargeView: View {
    var model = OneDayModel.placeholder(.systemLarge)
    
    var body: some View {
        let date = Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
        
        let year = "\(components.year!)"
        let month = Months[components.month! - 1]
        let day = "\(components.day!)"
        let weekday = ShotWeekdays[components.weekday! - 1] // 星期几（注意，周日是“1”，周一是“2”。。。。）
        
        return VStack(spacing: 0) {
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
                Image(uiImage: model.bgImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    // minHeight 和 maxHeight 都设置了才能自适应剩余高度，缺一则是以最大宽度按图片宽高比换算后的高度
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .clipped()

                Color.black.opacity(0.15)

                HStack {
                    VStack(alignment: .leading) {
                        Text(day)
                            .font(.custom("DINAlternate-Bold", size: 36))
                            .foregroundColor(.white)
                        + Text(" / \(month)")
                            .font(.custom("DINAlternate-Bold", size: 18))
                            .foregroundColor(.white)
                        
                        Text("\(year), \(weekday)")
                            .font(.custom("PingFangSC", size: 11))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9020377438)))
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 24)
                .modifier(ShadowModifier())
            }

            ZStack {
                HStack(alignment: .center, spacing: 10) {
                    Text(model.content)
                        .font(.custom("PingFangSC", size: 15))
                        .foregroundColor(Color(#colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2705882353, alpha: 1)))
                        .lineSpacing(5)
                    Spacer()
                    Text("今日\n语录")
                        .font(.custom("PingFangSC", size: 21))
                        .foregroundColor(Color(#colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)))
                }
                .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
        }
        .frame(minWidth: 0, maxWidth: .infinity,
               minHeight: 0, maxHeight: .infinity)
        .background(Color.white)
        .clipped()
    }
}

struct OneDayView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            OneDaySmallView()
                .frame(width: 169, height: 169)
                .cornerRadius(20)
                .padding()
                .modifier(ShadowModifier())
            
            OneDayMediumView()
                .frame(width: 360, height: 169)
                .cornerRadius(20)
                .padding()
                .modifier(ShadowModifier())

            OneDayLargeView()
                .frame(width: 360, height: 376)
                .cornerRadius(20)
                .padding()
                .modifier(ShadowModifier())
        }
    }
}