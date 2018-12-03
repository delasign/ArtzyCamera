//
//  PreviewView.swift
//  Artzy
//
//  Created by Oscar De la Hera Gomez on 12/3/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PreviewView: UIView {
    
    public var cameraHUDDelegate:CameraHUDDelegate?
    
    private var player:AVPlayer?
    private var playerLayer:AVPlayerLayer?
    private var videoURL:URL?
    
    private var saveButton:UIButton = UIButton();
    private var cancelButton:UIButton = UIButton();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight);
        self.alpha = 0;
        self.isUserInteractionEnabled = false;
        
        // Save button
        let saveButtonWidth:CGFloat = screenWidth/4;
        let saveButtonHeight:CGFloat = screenHeight/15;
        self.saveButton.frame = CGRect(x: screenWidth - saveButtonWidth - kArtzyHUDButtonGap/2, y: (screenHeight-kArtzyHUDButtonGap/2-saveButtonHeight), width: saveButtonWidth, height: saveButtonHeight);
        self.saveButton.layer.cornerRadius = saveButtonHeight/2;
        self.saveButton.backgroundColor = UIColor.white.withAlphaComponent(0.6);
        self.saveButton.setAttributedTitle(self.generateAttributedTitle(string: "SAVE", size:12), for: .normal);
        self.saveButton.addTarget(self, action: #selector(self.saveButtonPressed), for: .touchUpInside);
        
        // Cancel button
        // SAME AS RESET BUTTON
        let fraction:CGFloat = 0.6;
        self.cancelButton.frame = CGRect(x: kArtzyHUDButtonGap/2, y:kArtzyHUDButtonGap/2, width: kArtzyCameraButtonDimension*fraction, height: kArtzyCameraButtonDimension*fraction);
        self.cancelButton.backgroundColor = UIColor.white.withAlphaComponent(0.6);
        self.cancelButton.setAttributedTitle(self.generateAttributedTitle(string: "CANCEL", size:8), for: .normal);
        self.cancelButton.addTarget(self, action: #selector(self.cancelButtonPressed), for: .touchUpInside);
        
        // Loop Observer
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { _ in
            self.player?.seek(to: CMTime.zero)
            self.player?.play()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func generateAttributedTitle(string:String, size:CGFloat) -> NSMutableAttributedString{
        return NSMutableAttributedString(string: string, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Helvetica", size: size)]);
    }
    
    public func showPreviewView(withURL:URL) {
        self.alpha = 1
        self.isUserInteractionEnabled = true;
        self.videoURL = withURL;
        self.createPreviewVideo();
    }
    
    private func hidePreviewView() {
        self.alpha = 0
        self.isUserInteractionEnabled = false;
    }
    
    private func createPreviewVideo() {
        
        guard self.videoURL != nil else {
            print("No video url")
            return
        }
        
        self.player = AVPlayer(url: self.videoURL!);
        
        guard self.player != nil else {
            print("Failed to create player")
            return
        }
        
        self.playerLayer = AVPlayerLayer();
        self.playerLayer? = AVPlayerLayer(player: self.player);
        self.playerLayer?.frame = self.frame;
        
        guard self.playerLayer != nil else {
            print("Failed to create player layer")
            return
        }
        
        
        // Add Player Layer
        self.layer.addSublayer(self.playerLayer!);
        
        // Bring buttons to front
        DispatchQueue.main.async {
            self.addSubview(self.saveButton);
            self.addSubview(self.cancelButton);
        }
        
        self.player!.play();
        
    }
    
    
    // MARK : BUTTON FUNCTIONALITY
    
    @objc private func saveButtonPressed() {
        self.cameraHUDDelegate?.exportVideo();
        self.removeVideoPreview();
        self.hidePreviewView();
    }
    
    @objc private func cancelButtonPressed() {
        self.removeVideoPreview();
        FileManager.default.clearTmpDirectory();
        self.hidePreviewView();
    }
    
    // MARK : COMMON FUNCTIONALITY
    
    private func removeVideoPreview() {
        
        self.player!.pause();
        self.playerLayer?.removeFromSuperlayer();
        
        self.player = nil;
        self.playerLayer = nil;
        
        self.saveButton.removeFromSuperview();
        self.cancelButton.removeFromSuperview();
        
    }
    
    
    
}
