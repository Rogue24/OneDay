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
    
    @AppStorage("largeImgPath", store: UserDefaults(suiteName: "group.zhoujianping.OneDay"))
    var largeImgPath: String = ""
    @AppStorage("largeText", store: UserDefaults(suiteName: "group.zhoujianping.OneDay"))
    var largeText: String = ""
    
    @AppStorage("mediumImgPath", store: UserDefaults(suiteName: "group.zhoujianping.OneDay"))
    var mediumImgPath: String = ""
    @AppStorage("mediumText", store: UserDefaults(suiteName: "group.zhoujianping.OneDay"))
    var mediumText: String = ""
    
    @AppStorage("smallImgPath", store: UserDefaults(suiteName: "group.zhoujianping.OneDay"))
    var smallImgPath: String = ""
    @AppStorage("smallText", store: UserDefaults(suiteName: "group.zhoujianping.OneDay"))
    var smallText: String = ""
    
    @State var showImagePicker = false
    @State var showImageCroper = false
    
    @State var photo: UIImage? = nil
    @State var model: OneDayModel? = nil
    @State var family: WidgetFamily = WidgetFamily.systemSmall {
        didSet {
            guard family != oldValue else { return }
            updateModel()
        }
    }
    
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
                
                Button(action: {
                    // 刷新所有小组件
                    WidgetCenter.shared.reloadAllTimelines()
                }, label: {
                    Text("刷新小组件")
                        .font(.system(size: 15))
                        .foregroundColor(Color.white.opacity(0.85))
                        .padding()
                })
                
                Button(action: checkAPI, label: {
                    Text("检测接口")
                        .font(.system(size: 15))
                        .foregroundColor(Color.white.opacity(0.85))
                        .padding()
                })
                
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
                
                HStack {
                    Button(action: {
                        showImagePicker.toggle()
                    }, label: {
                        Text("打开相册设置\(family.jp.familyName)背景")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white.opacity(0.85))
                            .padding()
                    })
                    .sheet(isPresented: $showImagePicker, onDismiss: imagePickDismiss) {
                        ImagePickerView(selectedImage: $photo)
                    }
                    
                    Button(action: {
                        guard saveBgImageCache("") else { return }
                        updateModel()
                        WidgetCenter.shared.reloadAllTimelines()
                    }, label: {
                        Text("\(family.jp.familyName)背景使用网络图片")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white.opacity(0.85))
                            .padding()
                    })
                }
                
                Spacer()
                if let model = self.model {
                    VStack {
                        OneDayPreviewView(family: $family, model: model)
                            .padding(.bottom, 30)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
        .onAppear() {
            updateModel()
        }
        .fullScreenCover(isPresented: $showImageCroper, onDismiss: imageCropDismiss) {
            ImageCroperView(cropImage: $photo, family: $family)
        }
    }
    
    func imagePickDismiss() {
        guard photo != nil else { return }
        showImageCroper.toggle()
    }
    
    func imageCropDismiss() {
        let bgImagePath = photo == nil ? "" : family.jp.imageCachePath
        guard saveBgImageCache(bgImagePath) else { return }
        updateModel()
        photo = nil
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @discardableResult
    func saveBgImageCache(_ imgPath: String) -> Bool {
        let oldPath: String
        switch family {
        case .systemLarge:
//            largeText = ""
            oldPath = largeImgPath
            largeImgPath = imgPath
        case .systemMedium:
//            mediumText = ""
            oldPath = mediumImgPath
            mediumImgPath = imgPath
        default:
//            smallText = ""
            oldPath = smallImgPath
            smallImgPath = imgPath
        }
        
        if imgPath.count > 0 {
            if File.manager.fileExists(imgPath) {
                JPrint("图片缓存成功！")
            } else {
                JPrint("图片缓存失败！")
            }
        } else {
            JPrint("移除图片缓存！")
        }
        
        return !(imgPath == "" && oldPath == imgPath)
    }
    
    func updateModel() {
        let imgPath: String
        switch family {
        case .systemLarge:
            imgPath = largeImgPath
        case .systemMedium:
            imgPath = mediumImgPath
        default:
            imgPath = smallImgPath
        }
        let bgImage: UIImage
        if imgPath.count > 0 {
            if File.manager.fileExists(imgPath),
               let image = UIImage(contentsOfFile: imgPath) {
                bgImage = image
            } else {
                bgImage = family.jp.defaultImage
            }
        } else {
            bgImage = family.jp.defaultImage
        }
        model = OneDayModel(content: DefaultContent,
                            bgImage: bgImage)
    }
    
    func checkAPI() {
        let content: String
        let bgImagePath: String
        switch family {
        case .systemLarge:
            content = largeText
            bgImagePath = largeImgPath
        case .systemMedium:
            content = mediumText
            bgImagePath = mediumImgPath
        default:
            content = smallText
            bgImagePath = smallImgPath
        }
        OneDayModel.fetch(context: nil, content: content, bgImagePath: bgImagePath) { model in
            JPrint(model)
        }
    }
}

struct OneDayPreviewView: View {
    @Binding var family: WidgetFamily
    var model: OneDayModel
    
    var body: some View {
        switch family {
        case .systemLarge:
            OneDayLargeView(model: model)
                .frame(width: family.jp.widgetSize.width, height: family.jp.widgetSize.height)
                .cornerRadius(20)
                .padding()
                .modifier(ShadowModifier())
            
        case .systemMedium:
            OneDayMediumView(model: model)
                .frame(width: family.jp.widgetSize.width, height: family.jp.widgetSize.height)
                .cornerRadius(20)
                .padding()
                .modifier(ShadowModifier())
            
        default:
            OneDaySmallView(model: model)
                .frame(width: family.jp.widgetSize.width, height: family.jp.widgetSize.height)
                .cornerRadius(20)
                .padding()
                .modifier(ShadowModifier())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
