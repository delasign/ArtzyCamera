//
//  NotificationBarView.swift
//  ArtzyCamera
//
//  Created by Oscar De la Hera Gomez on 12/4/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class NotificationView: UIView {
    
    private var title:String = "searching...";
    private var previousTitle:String = "";
    private var notificationLabel:UILabel = UILabel();

    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.notificationLabel.frame = self.bounds;
        self.updateNotification(title: self.title);
        
        
        self.addSubview(self.notificationLabel);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func generateAttributedTitle(string:String, size:CGFloat) -> NSMutableAttributedString{
        return NSMutableAttributedString(string: string, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Helvetica", size: size)]);
    }
    
    
    // Update Title
    
    public func updateNotification(title:String) {
        
        self.previousTitle = self.title;
        self.title = title;
        
        self.notificationLabel.attributedText = self.generateAttributedTitle(string: self.title, size: 18)
        self.notificationLabel.sizeToFit();
        self.notificationLabel.textAlignment = .center;
        self.notificationLabel.frame = CGRect(x: 0, y: kArtzyResetButtonMinY*0.33, width: self.bounds.width, height: self.notificationLabel.frame.height)
    }
    
    public func returnToPreviousTitle() {
        self.title = self.previousTitle;
        
        self.notificationLabel.attributedText = self.generateAttributedTitle(string: self.title, size: 18)
        self.notificationLabel.sizeToFit();
        self.notificationLabel.textAlignment = .center;
        self.notificationLabel.frame = CGRect(x: 0, y: kArtzyResetButtonMinY*0.33, width: self.bounds.width, height: self.notificationLabel.frame.height)
    }
    
}

