//
//  ABC.swift
//  OneDay
//
//  Created by aa on 2021/9/9.
//

import UIKit
import SwiftUI
import WidgetKit

struct EditTextAlertController: UIViewControllerRepresentable {
    
    @Binding var text: String
    let family: WidgetFamily
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> UIAlertController {
        let alertCtr = UIAlertController(title: "编辑文案", message: family.jp.familyName, preferredStyle: .alert)
        alertCtr.addTextField { textField in
            textField.placeholder = "清空使用Hitokoto文案"
            textField.text = text
        }
        alertCtr.addAction(UIAlertAction(title: "确定", style: .default) { _ in
            text = alertCtr.textFields?.first?.text ?? ""
        })
        alertCtr.addAction(UIAlertAction(title: "取消", style: .cancel))
        return alertCtr
    }
    
    func updateUIViewController(_ uiViewController: UIAlertController, context: Context) {
        
    }
    
    // Connecting the Coordinator class with this struct
//    func makeCoordinator() -> ImageCroperCoordinator {
//        return ImageCroperCoordinator(croper: self)
//    }
    
    
}


public func AlertWithTextField(title: String?, message: String?, placeholder: String?, text: Binding<String>, confirmText: (() -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addTextField() {
        $0.placeholder = placeholder
        $0.text = text.wrappedValue
    }
    alert.addAction(UIAlertAction(title: "确认", style: .default) { _ in
        if let str = alert.textFields?.first?.text as NSString? {
            if str.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
                text.wrappedValue = ""
            } else {
                text.wrappedValue = str as String
            }
        } else {
            text.wrappedValue = ""
        }
        confirmText?()
    })
    alert.addAction(UIAlertAction(title: "取消", style: .cancel) { _ in })
    showAlert(alert: alert)
}

func showAlert(alert: UIAlertController) {
    if let controller = topMostViewController() {
        controller.present(alert, animated: true)
    }
}


private func topMostViewController() -> UIViewController? {
    guard let rootController = keyWindow()?.rootViewController else {
        return nil
    }
    return topMostViewController(for: rootController)
}

private func keyWindow() -> UIWindow? {
    UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?
                .windows
                .filter { $0.isKeyWindow }
                .first
}

private func topMostViewController(for controller: UIViewController) -> UIViewController {
    if let presentedController = controller.presentedViewController {
        return topMostViewController(for: presentedController)
    } else if let navigationController = controller as? UINavigationController {
        guard let topController = navigationController.topViewController else {
            return navigationController
        }
        return topMostViewController(for: topController)
    } else if let tabController = controller as? UITabBarController {
        guard let topController = tabController.selectedViewController else {
            return tabController
        }
        return topMostViewController(for: topController)
    }
    return controller
}

