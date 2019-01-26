//
//  ImagePickerCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/26/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class ImagePickerCoordinator: NSObject {
    
    static let shared = ImagePickerCoordinator()
    
    private weak var responsibleController: UIViewController?
    private var imageSelectionCompletion: ((_ image: UIImage?) -> Void)?
    
    func showImagePicker(for controller: UIViewController, and sourceType: UIImagePickerController.SourceType? = nil,
                         with imageCompletion: @escaping (_ image: UIImage?) -> Void) {
        
        responsibleController = controller
        imageSelectionCompletion = imageCompletion
        
        /* Show specific source type if needed */
        if let source = sourceType {
            showImagePickerWithType(source)
        } else {
            showPhotoSelectionAlert()
        }
    }
}

// MARK: - Private

private extension ImagePickerCoordinator {
    func showPhotoSelectionAlert() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let galeryButton = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.showImagePickerWithType(.photoLibrary)
        }
        actionSheet.addAction(galeryButton)
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.showImagePickerWithType(.camera)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(cameraButton)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelButton)
        
        responsibleController?.present(actionSheet, animated: true, completion: nil)
    }
    
    private func showImagePickerWithType(_ type: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = type
        imagePicker.modalPresentationStyle = .fullScreen
        
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.barTintColor = .black
        imagePicker.navigationBar.tintColor = .white
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor.white]
        imagePicker.navigationBar.titleTextAttributes = attributes
        
        responsibleController?.present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerController Delegate

extension ImagePickerCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageSelectionCompletion?(pickedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
