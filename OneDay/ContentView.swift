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
    
    @State var family: WidgetFamily = WidgetFamily.systemSmall
    @State var photo: UIImage? = nil
    @State var model: OneDayModel? = nil
    
    @State var showImagePicker = false
    @State var showImageCroper = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Have a nice day!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                
                Button(action: {
                    // 刷新所有小组件
                    WidgetCenter.shared.reloadAllTimelines()
                }, label: {
                    Text("刷新小组件")
                        .font(.system(size: 15))
                        .foregroundColor(Color.white.opacity(0.75))
                        .padding()
                })
                
                Button(action: checkAPI, label: {
                    Text("检测接口")
                        .font(.system(size: 15))
                        .foregroundColor(Color.white.opacity(0.75))
                        .padding()
                })
                
                Button(action: {
                    showImagePicker.toggle()
                }, label: {
                    Text("打开相册")
                        .font(.system(size: 15))
                        .foregroundColor(Color.white.opacity(0.75))
                        .padding()
                })
                .sheet(isPresented: $showImagePicker, onDismiss: imagePickDismiss) {
                    ImagePickerView(selectedImage: $photo)
                }
                
                if let model = self.model {
                    OneDayPreviewView(family: family, model: model)
                }
            }
        }
        .onAppear() {
            let imgPath: String
            switch family {
            case .systemLarge:
                imgPath = largeImgPath
            case .systemMedium:
                imgPath = mediumImgPath
            default:
                imgPath = smallImgPath
            }
            guard imgPath.count > 0 else { return }
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
        let bgImage = saveBgImageCache(bgImagePath)
        
        photo = nil
        model = OneDayModel(content: DefaultContent,
                            bgImage: bgImage)
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func saveBgImageCache(_ imgPath: String) -> UIImage {
        switch family {
        case .systemLarge:
            largeText = ""
            largeImgPath = imgPath
        case .systemMedium:
            mediumText = ""
            mediumImgPath = imgPath
        default:
            smallText = ""
            smallImgPath = imgPath
        }
        
        let bgImage: UIImage
        if imgPath.count > 0 {
            if File.manager.fileExists(imgPath),
               let image = UIImage(contentsOfFile: imgPath) {
                JPrint("图片缓存成功！")
                bgImage = image
            } else {
                JPrint("图片缓存失败！")
                bgImage = family.jp.defaultImage
            }
        } else {
            JPrint("移除图片缓存！")
            bgImage = family.jp.defaultImage
        }
        
        return bgImage
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
    let family: WidgetFamily
    let model: OneDayModel
    
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
