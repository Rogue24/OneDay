//
//  OneDayWidget.swift
//  OneDayWidget
//
//  Created by 周健平 on 2021/7/14.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> OneDayEntry {
        OneDayEntry(date: Date(), model: OneDayStore.fetchModel(context.family))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (OneDayEntry) -> ()) {
        completion(placeholder(in: context))
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        OneDayStore.fetchData(context.family) {
            let model = OneDayStore.fetchModel(context.family)
            
            /// policy提供下次更新的时间，可填：
            /// .never：永不更新(可通过WidgetCenter更新)
            /// .after(Date)：指定多久之后更新
            /// .atEnd：指定Widget通过你提供的entries的Date更新。
            let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
            
            /// entries提供下次更新的数据
            let entry = OneDayEntry(date: refreshDate, model: model)
            
            /// 刷新数据和控制下一步刷新时间
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
    
}

struct OneDayEntry: TimelineEntry {
    let date: Date
    let model: OneDayModel
}

struct OneDayWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        Group {
            switch family {
            case .systemMedium:
                OneDayMediumView(model: entry.model)
            case .systemLarge:
                OneDayLargeView(model: entry.model)
            default:
                OneDaySmallView(model: entry.model)
            }
        }
        // 小组件间距：Preview上为0，模拟器或真机才可获取到实际的间距
        // PS: 最新系统版本貌似默认为0了，无须再手动挪回去。
//        .disableWidgetContentMargins()
        // 小组件背景
        .widgetBackground(Color.white)
    }
}

@main
struct OneDayWidget: Widget {
    let kind: String = "OneDayWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            OneDayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("One Day")
        .description("用心去感受每一天的心境，生命就在每天的生活里。")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .disableWidgetContentMargins()
    }
}

struct OneDayWidget_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date()

        let smallFamily = WidgetFamily.systemSmall
        let smallEntry = OneDayEntry(date: date, model: OneDayModel.placeholder(smallFamily))
        OneDayWidgetEntryView(entry: smallEntry)
            .previewContext(WidgetPreviewContext(family: smallFamily))

        let mediumFamily = WidgetFamily.systemMedium
        let mediumEntry = OneDayEntry(date: date, model: OneDayModel.placeholder(mediumFamily))
        OneDayWidgetEntryView(entry: mediumEntry)
            .previewContext(WidgetPreviewContext(family: mediumFamily))

        let largeFamily = WidgetFamily.systemLarge
        let largeEntry = OneDayEntry(date: date, model: OneDayModel.placeholder(largeFamily))
        OneDayWidgetEntryView(entry: largeEntry)
            .previewContext(WidgetPreviewContext(family: largeFamily))
    }
}
