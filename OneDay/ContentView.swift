//
//  ContentView.swift
//  OneDay
//
//  Created by 周健平 on 2021/7/14.
//

import SwiftUI
import WidgetKit
import UIKit

struct ContentView: View {
    
    @State var family: WidgetFamily = .systemSmall
    
    @State var showImagePicker = false
    @State var showImageCroper = false
    @State var photo: UIImage? = nil
    @State var isCroped: Bool = false
    @State var cacheImgPath: String = ""
    
    @State var editText: String = ""
    
    @AppStorage(SmallDataKey, store: UserDefaults(suiteName: AppGroupIdentifier))
    private var smallStorage: Data?
    
    @AppStorage(MediumDataKey, store: UserDefaults(suiteName: AppGroupIdentifier))
    private var mediumStorage: Data?
    
    @AppStorage(LargeDataKey, store: UserDefaults(suiteName: AppGroupIdentifier))
    private var largeStorage: Data?
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Have a nice day!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .padding(.top, 50)
                
                HStack {
                    Button(action: {
                        family = .systemSmall
                    }, label: {
                        Text("小杯")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white.opacity(0.85))
                            .padding(.all, 8)
                            .background(family == .systemSmall ? Color(#colorLiteral(red: 0.08090337366, green: 0.6359872222, blue: 0.9755890965, alpha: 1)) : nil)
                            .cornerRadius(8)
                    })
                    Button(action: {
                        family = .systemMedium
                    }, label: {
                        Text("中杯")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white.opacity(0.85))
                            .padding(.all, 8)
                            .background(family == .systemMedium ? Color(#colorLiteral(red: 0.08090337366, green: 0.6359872222, blue: 0.9755890965, alpha: 1)) : nil)
                            .cornerRadius(8)
                    })
                    Button(action: {
                        family = .systemLarge
                    }, label: {
                        Text("大杯")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white.opacity(0.85))
                            .padding(.all, 8)
                            .background(family == .systemLarge ? Color(#colorLiteral(red: 0.08090337366, green: 0.6359872222, blue: 0.9755890965, alpha: 1)) : nil)
                            .cornerRadius(8)
                    })
                }
                .padding()
                
                Button(action: reloadWidget, label: {
                    Text("刷新当前小组件")
                        .font(.system(size: 15))
                        .foregroundColor(Color.white.opacity(0.85))
                        .padding()
                })
                
                HStack(spacing: 0) {
                    Button(action: {
                        setupWidgetContent()
                    }, label: {
                        Text("自定义\(family.jp.familyName)文案")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white.opacity(0.85))
                            .padding()
                    })
                    Spacer()
                    Button(action: {
                        saveCacheModel(for: \.text, "")
                    }, label: {
                        Text("\(family.jp.familyName)使用Hitokoto文案")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white.opacity(0.85))
                            .padding()
                    })
                }
                .padding(.horizontal, 16)
                
                HStack(spacing: 0) {
                    Button(action: {
                        showImagePicker.toggle()
                    }, label: {
                        Text("自定义\(family.jp.familyName)背景 - 相册")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white.opacity(0.85))
                            .padding()
                    })
                    .sheet(isPresented: $showImagePicker, onDismiss: imagePickDismiss) {
                        ImagePickerView(selectedImage: $photo)
                    }
                    Spacer()
                    Button(action: {
                        saveCacheModel(for: \.imageName, "")
                    }, label: {
                        Text("\(family.jp.familyName)背景使用网络图片")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white.opacity(0.85))
                            .padding()
                    })
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                VStack {
                    /// 必须得在`ViewBuilder的{}`内用到`AppStorage`的变量，不能封装在另一个函数内获取，否则就不能实时刷新！！！
                    switch family {
                    case .systemLarge:
                        let model = OneDayModel.build(withData: largeStorage, family: .systemLarge)
                        OneDayPreviewView(model: model)
                            .padding()
                            .padding(.bottom, 30)
                        
                    case .systemMedium:
                        let model = OneDayModel.build(withData: mediumStorage, family: .systemMedium)
                        OneDayPreviewView(model: model)
                            .padding()
                            .padding(.bottom, 30)
                        
                    default:
                        let model = OneDayModel.build(withData: smallStorage, family: .systemSmall)
                        OneDayPreviewView(model: model)
                            .padding()
                            .padding(.bottom, 30)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .fullScreenCover(isPresented: $showImageCroper, onDismiss: imageCropDismiss) {
            ImageCroperView(family: family,
                            cropImage: $photo,
                            cachePath: $cacheImgPath,
                            isCroped: $isCroped)
        }
    }
    
}

// MARK: - 缓存+刷新
extension ContentView {
    func saveCacheModel(for keyPath: WritableKeyPath<OneDayModel, String>, _ newValue: String) {
        var model = OneDayStore.fetchModel(family)
        
        let oldValue = model[keyPath: keyPath]
        guard oldValue != newValue else { return }
//        model[keyPath: keyPath] = newValue
        
        switch keyPath {
        case \.text:
            model.text = newValue
            model.isLocalText = newValue != ""
            model.refreshOptions = .text
            
        case \.imageName:
            model.imageName = newValue
            model.isLocalImage = newValue != ""
            model.refreshOptions = .image
            
            let oldCachePath = ImageCachePath(oldValue)
            if File.manager.fileExists(oldCachePath) {
                File.manager.deleteFile(oldCachePath)
                JPrint("旧图片删除成功")
            } else {
                JPrint("没有旧图片")
            }
            
        default:
            break
        }
        
        OneDayStore.cacheModel(model)
        reloadWidget()
    }
    
    func reloadWidget() {
        // TODO: 当前什么杯，就刷新哪个杯
        
        // 这里只刷新名为“OneDayWidget”的小组件，包括该小组件的大、中、小杯（目前也就这一种小组件）
        WidgetCenter.shared.getCurrentConfigurations { result in
            guard case let .success(widgets) = result else { return }
            guard let widget = widgets.first(where: { $0.family == family }) else { return }
            WidgetCenter.shared.reloadTimelines(ofKind: widget.kind)
        }
        
        // 刷新全部
        // WidgetCenter.shared.reloadAllTimelines()
    }
}

// MARK: - 自定义文案
extension ContentView {
    func setupWidgetContent() {
        let model = OneDayStore.fetchModel(family)
        editText = model.isLocalText ? model.text : ""
        
        AlertWithTextField(title: "自定义文案",
                           message: family.jp.familyName,
                           placeholder: "空文本则使用Hitokoto文案",
                           text: $editText,
                           confirmText: confirmText)
    }
    
    func confirmText() {
        let text = editText
        saveCacheModel(for: \.text, text)
    }
}

// MARK: - 自定义背景
extension ContentView {
    func imagePickDismiss() {
        guard photo != nil else { return }
        
        let cacheName = ImageCacheName(family)
        cacheImgPath = ImageCachePath(cacheName)
        showImageCroper = true
    }
    
    func imageCropDismiss() {
        photo = nil
        guard isCroped else { return }
        
        let imagePath = cacheImgPath
        var imageName = (imagePath as NSString).lastPathComponent as String
        
        if File.manager.fileExists(imagePath) {
            JPrint("图片缓存成功：", imagePath)
        } else {
            JPrint("图片缓存失败：", imagePath)
            imageName = ""
        }
        
        saveCacheModel(for: \.imageName, imageName)
    }
}

struct OneDayPreviewView: View {
    var model: OneDayModel
    var body: some View {
        let widgetSize = model.family.jp.widgetSize
        OneDayView(model: model)
            .frame(width: widgetSize.width, height: widgetSize.height)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .modifier(ShadowModifier())
    }
}

// MARK: - OneDayView
struct OneDayView: View {
    var model: OneDayModel
    var body: some View {
        switch model.family {
        case .systemLarge: OneDayLargeView(model: model)
        case .systemMedium: OneDayMediumView(model: model)
        default: OneDaySmallView(model: model)
        }
    }
}

// MARK: - ContentView_Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
