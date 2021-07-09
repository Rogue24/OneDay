//
//  ScreenFit.Extension.swift
//  Neves
//
//  Created by aa on 2021/2/7.
//

import UIKit

extension Int {
    var px: CGFloat { CGFloat(self) * BasisWScale }
}

extension Float {
    var px: CGFloat { CGFloat(self) * BasisWScale }
}

extension Double {
    var px: CGFloat { CGFloat(self) * BasisWScale }
}

extension CGFloat {
    var px: CGFloat { self * BasisWScale }
}

extension CGPoint {
    var px: CGPoint { .init(x: self.x * BasisWScale, y: self.y * BasisWScale) }
    
    static func px(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        CGPoint(x: x * BasisWScale, y: y * BasisWScale)
    }
}

extension CGSize {
    var px: CGSize { .init(width: self.width * BasisWScale, height: self.height * BasisWScale) }
    
    static func px(_ w: CGFloat, _ h: CGFloat) -> CGSize {
        CGSize(width: w * BasisWScale, height: h * BasisWScale)
    }
}

extension CGRect {
    var px: CGRect { .init(x: self.origin.x * BasisWScale,
                           y: self.origin.y * BasisWScale,
                           width: self.width * BasisWScale,
                           height: self.height * BasisWScale) }
    
    static func px(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGRect {
        CGRect(x: x * BasisWScale,
               y: y * BasisWScale,
               width: w * BasisWScale,
               height: h * BasisWScale)
    }
    
    static func px(_ origin: CGPoint, _ size: CGSize) -> CGRect {
        CGRect(origin: .init(x: origin.x * BasisWScale,
                             y: origin.y * BasisWScale),
               size: .init(width: size.width * BasisWScale,
                           height: size.height * BasisWScale))
    }
}
