//
//  OneDayWidget+.swift
//  OneDayWidgetExtension
//
//  Created by aa on 2024/3/18.
//
//  WWDC：https://developer.apple.com/videos/play/wwdc2023/10027
//  酷我音乐iOS小组件适配开发实践：https://cloud.tencent.com/developer/article/2371312
//  iOS17小组件简单适配：https://blog.csdn.net/qq_33608748/article/details/132394041

import SwiftUI

// MARK: Modifier

@available(iOSApplicationExtension 17.0, *)
struct DisableWidgetContentMargins: ViewModifier {
    @Environment(\.widgetContentMargins) var margins
    
    func body(content: Content) -> some View {
        content.padding(-margins)
//            .overlay {
//                Text("""
//                top: \(String(format: "%.2lf", margins.top))
//                leading: \(String(format: "%.2lf", margins.leading))
//                bottom: \(String(format: "%.2lf", margins.bottom))
//                trailing: \(String(format: "%.2lf", margins.trailing))
//                """)
//                    .font(.system(size: 20))
//                    .background(Color.yellow)
//                    .foregroundColor(Color.red)
//            }
    }
}

// MARK: Extension

extension View {
    /// 小组件背景
    func widgetBackground(_ backgroundView: @autoclosure () -> some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView()
            }
        } else {
            return background(backgroundView())
        }
    }
    
    /// 忽略小组件间距
    func disableWidgetContentMargins() -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return modifier(DisableWidgetContentMargins())
        } else {
            return self
        }
    }
}

extension WidgetConfiguration {
    /// 忽略小组件间距
    func disableWidgetContentMargins() -> some WidgetConfiguration {
        if #available(iOSApplicationExtension 17.0, *) {
            return self.contentMarginsDisabled()
        } else {
            return self
        }
    }
}
