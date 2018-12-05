//
//  ArtzyCameraButton.swift
//  Artzy
//
//  Created by Oscar De la Hera Gomez on 8/2/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import UIKit
import ARKit
import Photos
import ReplayKit

class ArtzyCameraButton: UIButton {
    
    public var sceneView:ARSCNView = ARSCNView();
//    public var xArtAlertViewDelegate:xAlertViewDelegate?;
    public var cameraHUDDelegate:CameraHUDDelegate?;
    
    private let whiteCircle:UIView = UIView();
    private var whiteCircleSize:CGFloat {
        return kArtzyCameraButtonDimension*3/4;
    }
    
    private let videoCameraProgressArc:CAShapeLayer = CAShapeLayer();
    private var videoCameraProgressArcMargin:CGFloat {
        return kArtzyCameraButtonDimension/20;
    }
    
    private let circleGrowthTimeInterval:TimeInterval = 0.3;
    private var touchEnded:Bool = false;
    private var videoStarted:Bool = false;
    private var videoSaved:Bool = false;
    
    init() {
        // Initialize the view to fit the responsive design presented in the deck and sketch file
        // Instatiate Camera Circle
        
        super.init(frame: CGRect(x: (screenWidth - kArtzyCameraButtonDimension)/2, y: (screenHeight*0.9-kArtzyCameraButtonDimension), width: kArtzyCameraButtonDimension, height: kArtzyCameraButtonDimension));
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.6);
        self.layer.cornerRadius = kArtzyCameraButtonDimension/2;
        
        // Instatiate Camera Circle
        
        self.whiteCircle.backgroundColor = UIColor.white;
        self.whiteCircle.layer.cornerRadius = whiteCircleSize/2;
        self.whiteCircle.frame = CGRect(x: (self.frame.width-whiteCircleSize)/2, y: (self.frame.width-whiteCircleSize)/2, width: whiteCircleSize, height: whiteCircleSize);
        self.addSubview(self.whiteCircle);
        
        
        // Create the video camera progress arc
        
        self.videoCameraProgressArc.opacity = 0;
        self.videoCameraProgressArc.path = UIBezierPath(ovalIn: CGRect(x: self.videoCameraProgressArcMargin, y: self.videoCameraProgressArcMargin, width: self.frame.width - self.videoCameraProgressArcMargin*2, height: self.frame.width - self.videoCameraProgressArcMargin*2)).cgPath;
        self.videoCameraProgressArc.lineWidth = 5.0;
        self.videoCameraProgressArc.strokeStart = 0;
        self.videoCameraProgressArc.strokeEnd = 0;
        self.videoCameraProgressArc.strokeColor = UIColor.black.cgColor;
        self.videoCameraProgressArc.fillColor = UIColor.clear.cgColor;
        
        // Rotate 90 degrees anti clockwise
        self.videoCameraProgressArc.transform = CATransform3DMakeRotation(CGFloat(-Double.pi/2), 0,0,1);
        self.videoCameraProgressArc.position = CGPoint(x: 0, y: self.frame.height);
        
        
        self.layer.addSublayer(self.videoCameraProgressArc);
        
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    // BUTTON FUNCTIONALITY
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.touchEnded = false;
        self.videoSaved = false;
        
        UIView.animate(withDuration: circleGrowthTimeInterval, delay: 0, options: .curveEaseInOut, animations: {
            
            self.frame = CGRect(x: (screenWidth - kArtzyCameraButtonDimension*1.5)/2, y: (screenHeight*0.9-kArtzyCameraButtonDimension*1.25), width: kArtzyCameraButtonDimension*1.5, height: kArtzyCameraButtonDimension*1.5);
            self.layer.cornerRadius = kArtzyCameraButtonDimension*1.5/2;
            
            self.whiteCircle.frame = CGRect(x: (self.frame.width-self.whiteCircleSize)/2, y: (self.frame.width-self.whiteCircleSize)/2, width: self.whiteCircleSize, height: self.whiteCircleSize);
            
            self.videoCameraProgressArc.path = UIBezierPath(ovalIn: CGRect(x: self.videoCameraProgressArcMargin, y: self.videoCameraProgressArcMargin, width: self.frame.width - self.videoCameraProgressArcMargin*2, height: self.frame.width - self.videoCameraProgressArcMargin*2)).cgPath;
            
            self.videoCameraProgressArc.transform = CATransform3DMakeRotation(CGFloat(-Double.pi/2), 0,0,1);
            self.videoCameraProgressArc.position = CGPoint(x: 0, y: self.frame.height);
            
        }) { (finished) in
            print("FINISHED INWARD ANIMATION");
            // Begin Video Capture
            
            if (self.touchEnded == false){
                
                self.videoStarted = true;
                
                // Start the animation
                self.animateVideoRing();
                
                // Start recording the video
                self.cameraHUDDelegate?.startRecording();
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.touchEnded = true;
        
        
        print("STATE ", RPScreenRecorder.shared().isRecording )
        print("VIDEO STARTED ", self.videoStarted )
        
        if( self.videoStarted == false ){ //self.recorder?.status != .recording
            // Check if you actually started recording?
            if self.videoSaved == false {
                print("IMAGE");
                self.cameraHUDDelegate?.previewPhoto(image:self.sceneView.snapshot());
                
            }
            else {
                print("Video Already saved");
            }
        }
        else {
            self.videoStarted = false;
            
            // Screen Recorder isn't recording, theresfore stop recording.
            print("VIDEO");
            self.videoCameraProgressArc.removeAllAnimations();
            self.videoCameraProgressArc.opacity = 0;
        }
        
        UIView.animate(withDuration: circleGrowthTimeInterval, animations: {
            
            self.frame = CGRect(x: (screenWidth - kArtzyCameraButtonDimension)/2, y: (screenHeight*0.9-kArtzyCameraButtonDimension), width: kArtzyCameraButtonDimension, height: kArtzyCameraButtonDimension);
            self.layer.cornerRadius = kArtzyCameraButtonDimension/2;
            
            self.whiteCircle.frame = CGRect(x: (self.frame.width-self.whiteCircleSize)/2, y: (self.frame.width-self.whiteCircleSize)/2, width: self.whiteCircleSize, height: self.whiteCircleSize);
            
        });
        
    }
    
    // MARK :  ANIMATION FUNCTIONALITY
    
    func animateVideoRing(){
        // Set the Initial Stroke State
        self.videoCameraProgressArc.strokeStart = 0
        self.videoCameraProgressArc.strokeEnd = 0
        self.videoCameraProgressArc.opacity = 1;
        
        CATransaction.begin();
        CATransaction.setAnimationDuration(10);
        CATransaction.setDisableActions(true);
        CATransaction.setCompletionBlock {
            self.videoRingAnimationDidFinish();
        }
        
        // Set animation end state
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.toValue = 0
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.toValue = 1
        
        // Play Animation Repetitively
        let group = CAAnimationGroup()
        group.animations = [start, end];
        group.duration = 10
        group.autoreverses = false;
        group.repeatCount = 0 // repeat 0 times
        group.isRemovedOnCompletion = true;
        
        self.videoCameraProgressArc.add(group, forKey: nil)
        
        CATransaction.commit();
        
    }
    
    func videoRingAnimationDidFinish(){
        print("STOP VIDEO, ANIMATION COMPLETE");
        
        // Stop the button animation and hide the arc
        self.videoCameraProgressArc.removeAllAnimations();
        self.videoCameraProgressArc.opacity = 0;
        self.videoSaved = true;
        self.cameraHUDDelegate?.stopRecording();
    }
    
}

