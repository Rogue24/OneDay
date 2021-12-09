//
//  OneDayView.swift
//  OneDay
//
//  Created by 周健平 on 2021/7/14.
//

import SwiftUI
import WidgetKit

// MARK: - 自定义Modifier
struct ShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 3)
            .shadow(color: Color.black.opacity(0.3), radius: 1, x: 0, y: 1)
    }
}

// MARK: - Small Widget
struct OneDaySmallView: View {
    var model = OneDayModel.placeholder(.systemSmall)
    
    var body: some View {
        let dateInfo = Date().jp.info// model.date.jp.info
        
        return ZStack {
            Image(uiImage: model.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            Color.black.opacity(0.15)
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(dateInfo.day)
                            .font(.custom("DINAlternate-Bold", size: 28))
                            .foregroundColor(.white)
                        + Text(" / \(dateInfo.month)")
                            .font(.custom("DINAlternate-Bold", size: 14))
                            .foregroundColor(.white)
                        
                        Text("\(dateInfo.year), \(dateInfo.weekday)")
                            .font(.custom("PingFangSC", size: 10))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9020377438)))
                    }
                    Spacer()
                }
                .modifier(ShadowModifier())
                
                Spacer()
                
                Text(model.showText)
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
        .background(Color.white)
        .clipped()
    }
}

// MARK: - Medium Widget
struct OneDayMediumView: View {
    var model = OneDayModel.placeholder(.systemMedium)
    
    var body: some View {
        let dateInfo = Date().jp.info//model.date.jp.info
        
        return ZStack {
            Image(uiImage: model.image)
                .resizable()
                .aspectRatio(contentMode: .fill)

            Color.black.opacity(0.15)

            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(dateInfo.day)
                            .font(.custom("DINAlternate-Bold", size: 36))
                            .foregroundColor(.white)
                        + Text(" / \(dateInfo.month)")
                            .font(.custom("DINAlternate-Bold", size: 18))
                            .foregroundColor(.white)
                        
                        Text("\(dateInfo.year), \(dateInfo.weekday)")
                            .font(.custom("PingFangSC", size: 11))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9020377438)))
                    }
                    Spacer()
                }
                .modifier(ShadowModifier())
                
                Spacer()
                
                Text(model.showText)
                    .font(.custom("PingFangSC", size: 14))
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .lineSpacing(4)
                    .modifier(ShadowModifier())
            }
            .padding(.horizontal, 31)
            .padding(.top, 15)
            .padding(.bottom, 25)
        }
        .frame(minWidth: 0, maxWidth: .infinity,
               minHeight: 0, maxHeight: .infinity)
        .background(Color.white)
        .clipped()
    }

}

// MARK: - Large Widget
struct OneDayLargeView: View {
    static let bottomContentHeight: CGFloat = 100
    @Environment(\.colorScheme) var colorScheme
    
    var model = OneDayModel.placeholder(.systemLarge)
    
    var body: some View {
        let dateInfo = Date().jp.info//model.date.jp.info
        
        return VStack(spacing: 0) {
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
                Image(uiImage: model.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    // minHeight 和 maxHeight 都设置了才能自适应剩余高度，缺一则是以最大宽度按图片宽高比换算后的高度
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .clipped()

                Color.black.opacity(0.15)

                HStack {
                    VStack(alignment: .leading) {
                        Text(dateInfo.day)
                            .font(.custom("DINAlternate-Bold", size: 36))
                            .foregroundColor(.white)
                        + Text(" / \(dateInfo.month)")
                            .font(.custom("DINAlternate-Bold", size: 18))
                            .foregroundColor(.white)
                        
                        Text("\(dateInfo.year), \(dateInfo.weekday)")
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
                    Text(model.showText)
                        .font(.custom("PingFangSC", size: 15))
                        .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9007571473)) : Color(#colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2705882353, alpha: 1)))
                        .lineSpacing(5)
                    Spacer()
                    Text("今日\n语录")
                        .font(.custom("PingFangSC", size: 21))
                        .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) : Color(#colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)))
                }
                .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity)
            .frame(height: Self.bottomContentHeight)
        }
        .frame(minWidth: 0, maxWidth: .infinity,
               minHeight: 0, maxHeight: .infinity)
        .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.1927119253, green: 0.191394761, blue: 0.2468924029, alpha: 1)) : Color.white)
        .clipped()
    }
}

struct OneDayView_Previews: PreviewProvider {
    static var previews: some View {
        let smallSize = WidgetFamily.systemSmall.jp.widgetSize
        let mediumSize = WidgetFamily.systemMedium.jp.widgetSize
        let largeSize = WidgetFamily.systemLarge.jp.widgetSize
        
        return ScrollView {
            OneDaySmallView()
                .frame(width: smallSize.width, height: smallSize.height)
                .cornerRadius(20)
                .padding()
                .modifier(ShadowModifier())
            
            OneDayMediumView()
                .frame(width: mediumSize.width, height: mediumSize.height)
                .cornerRadius(20)
                .padding()
                .modifier(ShadowModifier())

            OneDayLargeView()
                .frame(width: largeSize.width, height: largeSize.height)
                .cornerRadius(20)
                .padding()
                .modifier(ShadowModifier())
        }
    }
}
