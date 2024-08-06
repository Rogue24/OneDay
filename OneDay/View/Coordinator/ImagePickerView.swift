//
//  ImagePickerView.swift
//  OneDay
//
//  Created by aa on 2021/7/22.
//

import UIKit
import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: Data?
    @Environment(\.presentationMode) var isPresented
//    var sourceType: UIImagePickerController.SourceType
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(picker: self)
    }
    
}

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[.mediaType] as? String, mediaType == UTType.image.identifier,
           let url = info[.imageURL] as? URL, let data = try? Data(contentsOf: url) {
            self.picker.selectedImage = data
        }
        self.picker.isPresented.wrappedValue.dismiss()
    }
}
