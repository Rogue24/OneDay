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
    
    @Binding var cropImage: UIImage?
    @Binding var family: WidgetFamily
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> CropViewController {
        let imageCroper = CropViewController()
        imageCroper.image = cropImage
        imageCroper.family = family
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
    
    func cropViewController(_ croper: CropViewController, imageDidFinishCrop iamge: UIImage?) {
        self.croper.cropImage = iamge
        self.croper.family = croper.family
        self.croper.isPresented.wrappedValue.dismiss()
    }
    
}
