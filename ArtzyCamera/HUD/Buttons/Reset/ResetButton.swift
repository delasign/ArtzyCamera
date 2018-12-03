//
//  ResetButton.swift
//  Artzy
//
//  Created by Oscar De la Hera Gomez on 9/15/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import UIKit

class ResetButton: UIButton {
    
    public var viewControllerDelegate:ViewControllerDelegate?;
    public var cameraHUDDelegate:CameraHUDDelegate?;

    init() {
        // Initialize the view to fit the responsive design presented in the deck and sketch file
        // Instatiate Camera Circle
        
        var fraction:CGFloat = 0.6;
        
        super.init(frame: CGRect(x: screenWidth - kArtzyCameraButtonDimension*fraction - kArtzyHUDButtonGap/2, y:kArtzyHUDButtonGap/2, width: kArtzyCameraButtonDimension*fraction, height: kArtzyCameraButtonDimension*fraction));
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.6);
        self.setAttributedTitle(self.generateAttributedTitle(string: "RESET", size: 12), for: .normal);
//        self.setTitle("RESET", for: .normal)
        
//        self.setBackgroundImage(UIImage(named:"resetButton"), for: .normal);
        self.layer.cornerRadius = 6;
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func generateAttributedTitle(string:String, size:CGFloat) -> NSMutableAttributedString{
        return NSMutableAttributedString(string: string, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Helvetica", size: size)]);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.global().async { [weak self] in
            self?.viewControllerDelegate?.resetTracking();
            self?.cameraHUDDelegate?.resetCameraHUD();
//            FileManager.default.clearTmpDirectory();
//            artzyAssetsManager.loadAssets();
        }
    }
    
}
