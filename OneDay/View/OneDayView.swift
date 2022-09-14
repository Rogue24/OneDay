//
//  OneDayView.swift
//  OneDay
//
//  Created by 周健平 on 2021/7/14.
//

import SwiftUI
import WidgetKit

// MARK: - Small Widget
struct OneDaySmallView: View {
    let dateInfo = Date().jp.info
    var model = OneDayModel.placeholder(.systemSmall)
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                Text(dateInfo.day)
                    .font(.custom("DINAlternate-Bold", size: 28))
                    .foregroundColor(.white)
                + Text(" / \(dateInfo.month)")
                    .font(.custom("DINAlternate-Bold", size: 14))
                    .foregroundColor(.white)
                Text("\(dateInfo.year), \(dateInfo.weekday)")
                    .font(.custom("PingFangSC", size: 10))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Spacer()
            
            Text(model.showText)
                .font(.custom("PingFangSC", size: 14))
                .foregroundColor(.white)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .baseShadow()
        .padding(.horizontal, 14)
        .padding(.top, 13)
        .padding(.bottom, 18)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(
            Color.black.opacity(0.15)
        )
        .background(
            Image(uiImage: model.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
    }
}

// MARK: - Medium Widget
struct OneDayMediumView: View {
    let dateInfo = Date().jp.info
    var model = OneDayModel.placeholder(.systemMedium)
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                Text(dateInfo.day)
                    .font(.custom("DINAlternate-Bold", size: 36))
                    .foregroundColor(.white)
                + Text(" / \(dateInfo.month)")
                    .font(.custom("DINAlternate-Bold", size: 18))
                    .foregroundColor(.white)
                Text("\(dateInfo.year), \(dateInfo.weekday)")
                    .font(.custom("PingFangSC", size: 11))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Spacer()
            
            Text(model.showText)
                .font(.custom("PingFangSC", size: 14))
                .foregroundColor(.white)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .baseShadow()
        .padding(.horizontal, 31)
        .padding(.top, 15)
        .padding(.bottom, 25)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(
            Color.black.opacity(0.15)
        )
        .background(
            Image(uiImage: model.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
    }
}

// MARK: - Large Widget
struct OneDayLargeView: View {
    let dateInfo = Date().jp.info
    var model = OneDayModel.placeholder(.systemLarge)
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                Image(uiImage: model.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Color.clear.frame(height: 100)
            }
            
            Color.black.opacity(0.15)
                .frame(maxWidth:. infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                VStack(alignment: .leading) {
                    Text(dateInfo.day)
                        .font(.custom("DINAlternate-Bold", size: 36))
                        .foregroundColor(.white)
                    + Text(" / \(dateInfo.month)")
                        .font(.custom("DINAlternate-Bold", size: 18))
                        .foregroundColor(.white)
                    Text("\(dateInfo.year), \(dateInfo.weekday)")
                        .font(.custom("PingFangSC", size: 11))
                        .foregroundColor(.white.opacity(0.9))
                }
                .baseShadow()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.bottom, 10)
                .padding(.horizontal, 24)

                HStack(alignment: .center, spacing: 10) {
                    Text(model.showText)
                        .font(.custom("PingFangSC", size: 15))
                        .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.9) : Color(red: 0.25, green: 0.25, blue: 0.27))
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Text("今日\n语录")
                        .font(.custom("PingFangSC", size: 21))
                        .foregroundColor(colorScheme == .dark ? Color(red: 0.8, green: 0.8, blue: 0.8) : Color(red: 0.56, green: 0.56, blue: 0.56))
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(colorScheme == .dark ? Color(red: 0.2, green: 0.2, blue: 0.25) : Color.white)
            }
            .frame(maxWidth:. infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(colorScheme == .dark ? Color(red: 0.2, green: 0.2, blue: 0.25) : Color.white)
    }
}

struct OneDayView_Previews: PreviewProvider {
    static let smallSize = WidgetFamily.systemSmall.jp.widgetSize
    static let mediumSize = WidgetFamily.systemMedium.jp.widgetSize
    static let largeSize = WidgetFamily.systemLarge.jp.widgetSize
    
    static var previews: some View {
        ScrollView {
            VStack(spacing: 0) {
                Group {
                    OneDaySmallView()
                        .frame(width: smallSize.width, height: smallSize.height)
                    OneDayMediumView()
                        .frame(width: mediumSize.width, height: mediumSize.height)
                    OneDayLargeView()
                        .frame(width: largeSize.width, height: largeSize.height)
                }
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .baseShadow()
                .padding(8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(.foreground)
    }
}
