//
//  PhotoLibrary.swift
//  EmojiArt
//
//  Created by Nathan Getachew on 1/30/23.
//

import SwiftUI

struct PhotoLibrary : UIViewControllerRepresentable {
    var handlePickedImage : (UIImage?) -> Void
    
    static var isAvailable:Bool{
        UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(handlePickedImage: handlePickedImage)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var handlePickedImage : (UIImage?) -> Void
        init(handlePickedImage: @escaping (UIImage?) -> Void) {
            self.handlePickedImage = handlePickedImage
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            handlePickedImage(nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            handlePickedImage(info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage)
        }
        
    }
    
    
}
