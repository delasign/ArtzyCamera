//
//  AppVariables.swift
//  ArtzyCamera
//
//  Created by Oscar De la Hera Gomez on 12/3/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import Foundation
import UIKit

var artzyNotificationView:NotificationView  = NotificationView();

var screenWidth:CGFloat                     = CGFloat();
var screenHeight:CGFloat                    = CGFloat();

var kArtzyCameraButtonDimension:CGFloat     = CGFloat();
var kArtzyCameraButtonMinY:CGFloat          = CGFloat();

var kArtzyResetButtonDimension:CGFloat      = CGFloat();
var kArtzyResetButtonMinY:CGFloat           = CGFloat();

var kArtzyHUDButtonGap:CGFloat              = CGFloat();
var kArtzyHUDButtonDimension:CGFloat        = CGFloat();
var kArtzyHUDButtonMinY:CGFloat             = CGFloat();


public func instantiateArtzyVariables() {
    kArtzyCameraButtonDimension = screenWidth*0.2;
    kArtzyCameraButtonMinY = screenHeight*0.9-kArtzyCameraButtonDimension;
    
    kArtzyResetButtonDimension = screenWidth*0.125;
    kArtzyResetButtonMinY = screenHeight*0.05+kArtzyHUDButtonGap/2
    kArtzyHUDButtonDimension = 0.15*screenWidth;
    kArtzyHUDButtonGap = 0.048*screenWidth;
    kArtzyHUDButtonMinY = kArtzyCameraButtonMinY-kArtzyHUDButtonDimension-kArtzyHUDButtonGap;
}
