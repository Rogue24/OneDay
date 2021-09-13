//
//  ABC.swift
//  OneDay
//
//  Created by aa on 2021/9/9.
//

import UIKit
import SwiftUI
import WidgetKit

func AlertWithTextField(title: String?, message: String?, placeholder: String?, text: Binding<String>, confirmText: (() -> Void)? = nil) {
    guard let topMostVC = GetTopMostViewController() else { return }
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addTextField() {
        $0.placeholder = placeholder
        $0.text = text.wrappedValue
    }
    alert.addAction(UIAlertAction(title: "确认", style: .default) { _ in
        var finalText = ""
        if let str = alert.textFields?.first?.text as NSString?,
           str.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            finalText = str as String
        }
        text.wrappedValue = finalText
        confirmText?()
    })
    alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
    
    topMostVC.present(alert, animated: true)
}

private func GetKeyWindow() -> UIWindow? {
    UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .compactMap { $0 as? UIWindowScene }
            .first?
                .windows
                .filter { $0.isKeyWindow }
                .first
}

private func GetTopMostViewController() -> UIViewController? {
    guard let rootVC = GetKeyWindow()?.rootViewController else { return nil }
    return GetTopMostViewController(from: rootVC)
}

private func GetTopMostViewController(from vc: UIViewController) -> UIViewController {
    if let presentedVC = vc.presentedViewController {
        return GetTopMostViewController(from: presentedVC)
    }
    
    switch vc {
    case let navCtr as UINavigationController:
        guard let topVC = navCtr.topViewController else { return navCtr }
        return GetTopMostViewController(from: topVC)
        
    case let tabBarCtr as UITabBarController:
        guard let selectedVC = tabBarCtr.selectedViewController else { return tabBarCtr }
        return GetTopMostViewController(from: selectedVC)
        
    default:
        return vc
    }
}

