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

enum ArtzyNotificationStyle {
    case searching
    case itemFound
    case preview
    case error
    case previous
}

class NotificationView: UIView {
    
    public var title:String = "searching...";
    private var previousTitle:String = "";
    private var notificationLabel:UILabel = UILabel();
    
    

    override init(frame: CGRect) {
        super.init(frame: frame);
        
        artzyNotificationBlimp = NotificationBlimp(frame: kArtzyBlimpBaseRect);
        self.addSubview(artzyNotificationBlimp)
        
        self.notificationLabel.frame = kArtzyNotificationLabelRect;
        self.updateNotification(title: self.title, style:.searching);
        
        self.addSubview(self.notificationLabel);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func generateAttributedTitle(string:String, size:CGFloat) -> NSMutableAttributedString{
        return NSMutableAttributedString(string: string, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Helvetica", size: size)]);
    }
    
    
    // Update Title
    
    public func updateNotification(title:String, style:ArtzyNotificationStyle) {
        
        self.previousTitle = self.title;
        self.title = title;
        
        self.notificationLabel.attributedText = self.generateAttributedTitle(string: self.title, size: 18)
        self.notificationLabel.numberOfLines = 3
        
        self.notificationLabel.textAlignment = .center;
        self.notificationLabel.frame = kArtzyNotificationLabelRect
        self.notificationLabel.sizeToFit();
        
        self.notificationLabel.frame = CGRect(x: kArtzyNotificationLabelRect.minX, y: kArtzyNotificationLabelRect.minY, width: kArtzyNotificationLabelRect.width, height: self.notificationLabel.frame.height)
        
        artzyNotificationBlimp.updateNotificationStyle(style:style);
    }
    
    public func returnToPreviousTitle() {
        self.title = self.previousTitle;
        
        self.notificationLabel.attributedText = self.generateAttributedTitle(string: self.title, size: 18)
        self.notificationLabel.numberOfLines = 3
        
        self.notificationLabel.textAlignment = .center;
        self.notificationLabel.frame = kArtzyNotificationLabelRect
        self.notificationLabel.sizeToFit();
        self.notificationLabel.frame = CGRect(x: kArtzyNotificationLabelRect.minX, y: kArtzyNotificationLabelRect.minY, width: kArtzyNotificationLabelRect.width, height: self.notificationLabel.frame.height)
        
        artzyNotificationBlimp.updateNotificationStyle(style:.previous);
    }
    
    public func makeNotificationBlink() {
        
        
    }
}

