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
        
        super.init(frame: CGRect(x: screenWidth - kArtzyResetButtonDimension - kArtzyHUDButtonGap/2, y:kArtzyResetButtonMinY, width: kArtzyResetButtonDimension, height: kArtzyResetButtonDimension));
        self.setAttributedTitle(self.generateAttributedTitle(string: "reset", size: 18), for: .normal);
        self.layer.cornerRadius = 6;
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func generateAttributedTitle(string:String, size:CGFloat) -> NSMutableAttributedString{
        return NSMutableAttributedString(string: string, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Helvetica", size: size)]);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.global().async { [weak self] in
            self?.cameraHUDDelegate?.resetCameraHUD();
        }
    }
    
}
