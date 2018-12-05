//
//  SaveButton.swift
//  ArtzyCamera
//
//  Created by Oscar De la Hera Gomez on 12/5/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import UIKit

class SaveButton: UIButton {
    
    public var viewControllerDelegate:ViewControllerDelegate?;
    public var cameraHUDDelegate:CameraHUDDelegate?;
    
    private var label:UILabel = UILabel();
    private var saveIcon:UIImageView = UIImageView(); //UIImage(named: "saveIcon");
    
    init() {
        // Initialize the view to fit the responsive design presented in the deck and sketch file
        // Instatiate Camera Circle
        
        var kArtzySaveButtonDimension:CGFloat = CGFloat();
        kArtzySaveButtonDimension = screenHeight/6
        
        super.init(frame: CGRect(x: (screenWidth-kArtzySaveButtonDimension)/2, y:screenHeight*0.7325, width: kArtzySaveButtonDimension, height: kArtzySaveButtonDimension));
        self.layer.cornerRadius = 6;
        
        self.label.attributedText = self.generateAttributedTitle(string: "save", size: 18);
        self.label.sizeToFit();
        self.label.textAlignment = .center;
        self.label.frame = CGRect(x: 0, y: self.frame.height*0.75, width: self.frame.width, height: self.label.frame.height);
        self.addSubview(self.label);
        
        self.saveIcon.frame = CGRect(x: self.frame.height*0.25, y: self.frame.height*0.125, width: self.frame.height*0.5, height: self.frame.height*0.5);
        self.saveIcon.image = UIImage(named: "saveIcon");
        self.addSubview(self.saveIcon)
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
