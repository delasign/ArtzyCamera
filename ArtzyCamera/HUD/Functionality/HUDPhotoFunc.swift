//
//  ArtzyCameraButtonPhotoFunctionality.swift
//  Artzy
//
//  Created by Oscar De la Hera Gomez on 8/2/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension CameraHUDViewController {
    
    func previewPhoto(image:UIImage) {
        
        self.view.addSubview(self.previewView);
        self.view.bringSubviewToFront(artzyNotificationView);
        self.previewView.showPreviewView(withImage:image);
        
    }
    
    public func saveImage(image:UIImage){
        // Save as UI Image
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print("ERROR");
            
            let alertController = UIAlertController(title: "Your image failed to save", message: nil, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
//            self.xArtAlertViewDelegate?.updateTextAndPresent(newText: error.localizedDescription);
        } else {
            print("SAVED");
            let alertController = UIAlertController(title: "Your image was successfully saved", message: nil, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
//            self.xArtAlertViewDelegate?.updateTextAndPresent(newText: "SAVED");
        }
    }
}

