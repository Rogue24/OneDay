//
//  OneDayPreferenceKey.swift
//  OneDay
//
//  Created by aa on 2025/2/24.
//

import SwiftUI

struct OneDayPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
