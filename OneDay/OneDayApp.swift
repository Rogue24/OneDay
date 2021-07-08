//
//  OneDayApp.swift
//  OneDay
//
//  Created by aa on 2021/7/7.
//

import SwiftUI
import WidgetKit

@main
struct OneDayApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification), perform: { _ in
                    // 监听进入后台：刷新所有小组件
                    WidgetCenter.shared.reloadAllTimelines()
                })
        }
    }
}
