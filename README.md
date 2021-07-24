# OneDay

    SwiftUI + WidgetKit 开发实战

## 前言

最近在学习SwiftUI，想起我的设计师小伙伴有一份苹果小组件的设计图，而小组件-WigetKit只能用SwiftUI来开发，正好可以拿来练练手。

## 实用效果

![medium_small_example](https://github.com/Rogue24/JPCover/raw/master/OneDay/medium_small_example.jpg)
![large_example](https://github.com/Rogue24/JPCover/raw/master/OneDay/large_example.jpg)

小组件每隔10分钟左右会刷新一次，并且提供**小杯**、**中杯**、**大杯**三种尺寸。

效果个人感觉还是挺不错的，很适合装饰桌面😆

## 数据源

- 文案由 [Hitokoto](https://hitokoto.cn) 提供，很多不错的段子和毒鸡汤，接口是：https://v1.hitokoto.cn

- 图片则来自于：[LoremPicsum](https://picsum.photos)，这个网站能提供各种精致图片，可以拼接自定义参数获取不同尺寸、滤镜的图片。

## 当前进度

目前只是一个用来装饰桌面的小组件，App的主界面都还没完全弄好，只有小组件功能。

由于刚开始学习SwiftUI没多久，很多语法还在摸索当中，日后会逐渐完善，接下来的计划：

    1.适配iPad尺寸；
    2.可以编辑文案；
    3.自定义文字位置；
    4.可以摆放更多内容。
    
目前已完成：

    ✅ 可以选择照片设置背景图
    
## 疑惑

对小组件的刷新时机不太理解，我是这样设置的：
```swift
func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    // 请求数据
    OneDayModel.fetch(family: context.family) { model in
        // 设置下一步刷新时间：10分钟后
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 10, to: Date())!
        
        // entries提供下次更新的数据
        let entry = OneDayEntry(date: refreshDate, model: model)
        
        // 刷新数据和控制下一步刷新时间
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}
```
代码里是设置了10分钟后刷新的，然而实际上都是15~20分钟左右才刷新一次，也不知道是不是我弄错了，有待解决...

## 最后

感谢设计小哥哥提供的设计图，另外还要感谢公司的设计小姐姐给出的建议和Logo。

如果感觉效果不错，可以下载安装体验一下，喜欢的话不妨给个Star，日后会不断完善其他功能~😊
