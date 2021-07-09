//
//  ContentView.swift
//  OneDay
//
//  Created by aa on 2021/7/7.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
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
                    Text("点我刷新小组件")
                        .font(.system(size: 15))
                        .foregroundColor(Color.white.opacity(0.75))
                        .padding()
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
