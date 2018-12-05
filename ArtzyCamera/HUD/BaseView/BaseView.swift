//
//  BaseView.swift
//  ArtzyCamera
//
//  Created by Oscar De la Hera Gomez on 12/4/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import ARKit

class BaseView: UIView {
    
    public var cameraHUDDelegate:CameraHUDDelegate?
    public var viewControllerDelegate:ViewControllerDelegate?;
    public var sceneView:ARSCNView = ARSCNView();
    
    var cameraButton: ArtzyCameraButton = ArtzyCameraButton();
    var resetButton:ResetButton = ResetButton();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.alpha = 1;
        
        
        

    }
    
    public func start() {
        self.cameraButton = ArtzyCameraButton();
        self.cameraButton.sceneView = self.sceneView;
        self.cameraButton.cameraHUDDelegate = self.cameraHUDDelegate;
        
        self.addSubview(self.cameraButton);
        
        self.resetButton = ResetButton();
        self.resetButton.viewControllerDelegate = self.viewControllerDelegate;
        self.resetButton.cameraHUDDelegate = self.cameraHUDDelegate;
        self.addSubview(self.resetButton);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func generateAttributedTitle(string:String, size:CGFloat) -> NSMutableAttributedString{
        return NSMutableAttributedString(string: string, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Helvetica", size: size)]);
    }
    
    public func showBaseView(withURL:URL) {
        self.alpha = 1
        self.isUserInteractionEnabled = true;
    }
    
    private func hideBaseView() {
        self.alpha = 0
        self.isUserInteractionEnabled = false;
    }
    
    // MARK : BUTTON FUNCTIONALITY
    
//    @objc private func resetButtonPressed() {
//        self.cameraHUDDelegate?.exportVideo();
//        self.removeVideoPreview();
//        self.hideBaseView();
//    }
//
//    @objc private func cancelButtonPressed() {
//        self.removeVideoPreview();
//        FileManager.default.clearTmpDirectory();
//        self.hideBaseView();
//    }
    
}
