//
//  ImageCroperView.swift
//  OneDay
//
//  Created by aa on 2021/7/23.
//

import UIKit
import SwiftUI
import WidgetKit

struct ImageCroperView: UIViewControllerRepresentable {
    
    let family: WidgetFamily
    @Binding var cropImage: UIImage?
    @Binding var cachePath: String
    @Binding var isCroped: Bool
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> CropViewController {
        let imageSize = family.jp.imageSize
        let imageCroper = CropViewController()
        imageCroper.image = cropImage
        imageCroper.resizeWHScale = imageSize.width / imageSize.height
        imageCroper.cachePath = cachePath
        imageCroper.delegate = context.coordinator // confirming the delegate
        return imageCroper
    }
    
    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {
        
    }
    
    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> ImageCroperCoordinator {
        return ImageCroperCoordinator(croper: self)
    }
    
}

class ImageCroperCoordinator: NSObject, CropViewControllerDelegate {
    
    var croper: ImageCroperView
    
    init(croper: ImageCroperView) {
        self.croper = croper
    }
    
    func cropViewController(_ croper: CropViewController, imageDidFinishCrop cachePath: String) {
        self.croper.isCroped = true
        self.croper.cachePath = cachePath
        self.croper.isPresented.wrappedValue.dismiss()
    }
    
    func dismissCropViewController() {
        self.croper.isCroped = false
        self.croper.isPresented.wrappedValue.dismiss()
    }
    
}
