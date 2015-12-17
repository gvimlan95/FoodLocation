//
//  PhotoTakingHelper.swift
//  FoodLocation
//
//  Created by VIMLAN.G on 8/11/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit

typealias PhotoTakingHelperCallback = UIImage? -> Void

class PhotoTakingHelper: NSObject {
    
    weak var viewController : UIViewController!
    var callback: PhotoTakingHelperCallback
    var imagePickerController : UIImagePickerController?
    
    init(viewController : UIViewController!,callback: PhotoTakingHelperCallback) {
        
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection() {
        
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
            
            let cameraAction = UIAlertAction(title: "From Camera", style: .Default) { (action) in
                
                self.showImagePickerController(.Camera)
            }
            alertController.addAction(cameraAction)
        }
        let photoLibraryAction = UIAlertAction(title: "From Photo Library", style: .Default) { (action) in
            
            self.showImagePickerController(.PhotoLibrary)
        }
        alertController.addAction(photoLibraryAction)
        
        self.viewController.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func showImagePickerController(sourceType:UIImagePickerControllerSourceType) {
        
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
    
}

extension PhotoTakingHelper : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        viewController.dismissViewControllerAnimated(false, completion: nil)
        
        callback(image)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(false, completion: nil)
    }
}
