//
//  View+.swift
//  OneDay
//
//  Created by aa on 2024/3/18.
//

import SwiftUI

@available(iOS 15.0.0, *)
extension View {
    func baseShadow(color: SwiftUI.Color = .black.opacity(0.3)) -> some View {
        modifier(BaseShadowModifier(color: color))
    }
    
    func strokeStyle(cornerRadius: CGFloat = 30) -> some View {
        modifier(StrokeStyle(cornerRadius: cornerRadius))
    }
    
    func iconStyle(size: CGFloat, cornerRadius: CGFloat) -> some View {
        modifier(IconStyle(size: size, cornerRadius: cornerRadius))
    }
}
