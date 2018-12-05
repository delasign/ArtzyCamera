//
//  HUDRecordingFunc.swift
//  ArtzyCamera
//
//  Created by Oscar De la Hera Gomez on 12/4/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension CameraHUDViewController {
    // MARK: RECORDING FUNCTIONALITY
    
    func startRecording() {
        
        self.createURLForVideo(withName: "test") { (videoURL) in
            self.prepareWriterAndInput(size:CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), videoURL: videoURL, completionHandler: { (error) in
                //
                guard error == nil else {
                    // it errored.
                    return
                }
                self.startAudioRecording { (result) in
                    
                    guard result == true else {
                        print("FAILED TO START AUDIO SESSION")
                        DispatchQueue.main.sync {
                            artzyNotificationView.updateNotification(title: "Audio Session Failed", style: .error);
                        }
                        return
                    }
                    
                    print("AUDIO SESSION ALLOWED");
                    self.videoStartTime = CMTime.zero;
                    self.lastTime = 0;
                    self.isRecording = true;
                }
            });
        };
    }
    
    func stopRecording() {
        
        DispatchQueue.main.async { [weak self] () -> Void in
            do {
                self!.isRecording = false;
                self!.endAudioRecording()
                try self!.recordingSession.setActive(false)
                
                self!.finishVideoRecording { (videoURL) in
                    DispatchQueue.main.sync {
                        self!.view.addSubview(self!.previewView);
                        self!.view.bringSubviewToFront(artzyNotificationView);
                    }
                    self!.previewView.showPreviewView(withURL: videoURL);
                }
            }
            catch {
                print("ERROR STOPPING RECORDING AUDIO SESSION")
                DispatchQueue.main.sync {
                    artzyNotificationView.updateNotification(title: "Error :\(error)", style: .error);
                }
            }
        }
    }
}
