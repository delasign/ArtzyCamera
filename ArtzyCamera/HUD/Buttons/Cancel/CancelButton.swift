//
//  CancelButton.swift
//  ArtzyCamera
//
//  Created by Oscar De la Hera Gomez on 12/5/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import UIKit

class CancelButton: UIButton {
    
    public var viewControllerDelegate:ViewControllerDelegate?;
    public var cameraHUDDelegate:CameraHUDDelegate?;
    
    private var label:UILabel = UILabel();
    
    init() {
        // Initialize the view to fit the responsive design presented in the deck and sketch file
        // Instatiate Camera Circle
        
        super.init(frame: CGRect(x: kArtzyHUDButtonGap/2, y:kArtzyResetButtonMinY, width: kArtzyResetButtonDimension, height: kArtzyResetButtonDimension));
        self.layer.cornerRadius = 6;
        
        self.label.attributedText = self.generateAttributedTitle(string: "cancel", size: 18);
        self.label.sizeToFit();
        self.label.frame = CGRect(x: 0, y: kArtzMinYLabelLine-self.frame.minY, width: self.label.frame.width, height: self.label.frame.height);
        
        self.addSubview(self.label);
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
}
