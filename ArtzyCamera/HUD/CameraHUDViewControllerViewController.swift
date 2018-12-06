//
//  HiddenStatusBarViewController.swift
//  xArt
//
//  Created by Oscar De la Hera Gomez on 8/2/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import UIKit
import ARKit
import AVFoundation
import Photos

protocol CameraHUDDelegate {
    func startRecording();
    func stopRecording();
    func resetCameraHUD();
    func exportVideo();
    func saveImage(image:UIImage);
    func previewPhoto(image:UIImage)
}

class CameraHUDViewController: UIViewController, CameraHUDDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    // Views
    var baseView: BaseView = BaseView();
    var previewView: PreviewView = PreviewView();
    
    // Delegates
    public var viewControllerDelegate:ViewControllerDelegate?;
    // Sceneview
    public var  sceneView:ARSCNView = ARSCNView();
    private var sampleImage:UIImage?
    private var renderer:SCNRenderer?
    
    // Recording
    public var isRecording:Bool = false;
    var snapshotArray:[[String:Any]] = [[String:Any]]()
    var lastTime:TimeInterval = 0
    public var videoStartTime:CMTime?;
    
    // Asset Writer
    var pixelBufferAdaptor:AVAssetWriterInputPixelBufferAdaptor?
    var videoInput:AVAssetWriterInput?;
    var audioInput:AVAssetWriterInput?;
    var assetWriter:AVAssetWriter?;
    
    // Audio
    var captureSession: AVCaptureSession?
    var micInput:AVCaptureDeviceInput?
    var audioOutput:AVCaptureAudioDataOutput?
    var recordingSession:AVAudioSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intializeBasicCameraHUD();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: STARTING / REFRESHING FUNCTIONALITY
    
    func intializeBasicCameraHUD() {
        DispatchQueue.main.async {
            // Do any additional setup after loading the view.

            self.sampleImage = self.sceneView.snapshot();
            
            self.renderer = SCNRenderer(device: MTLCreateSystemDefaultDevice(), options: [:])
            self.renderer!.scene = self.sceneView.scene
            self.renderer!.pointOfView = self.sceneView.pointOfView
            
            self.baseView = BaseView(frame: self.view.frame);
            self.baseView.cameraHUDDelegate = self;
            self.baseView.viewControllerDelegate = self.viewControllerDelegate;
            self.baseView.sceneView = self.sceneView;
            
            self.baseView.start();
            self.view.addSubview(self.baseView);
            
            self.previewView = PreviewView(frame: self.view.frame);
            self.previewView.cameraHUDDelegate = self;
            
            artzyNotificationView = NotificationView(frame: CGRect(x: screenWidth*0.25, y: 0, width: screenWidth*0.5, height: screenHeight*0.2));
            self.view.addSubview(artzyNotificationView)
            
            
        }
    }
    
    public func resetCameraHUD() {
        
        self.viewControllerDelegate?.resetTracking();
        
        DispatchQueue.main.async {
            for view in self.view.subviews {
                view.removeFromSuperview();
            }
        
            self.intializeBasicCameraHUD();
        }
    }
    
    // MARK: DID UPDATE AT TIME
    
    let filmQueue:DispatchQueue = DispatchQueue(label: "filmQueue");
    var snapshot:UIImage?;
    let scale = CMTimeScale(NSEC_PER_SEC)

    public func didUpdateAtTime(time: TimeInterval) {
        
        
            if self.isRecording {
                
                if self.lastTime == 0 || (self.lastTime + 1/25) < time {
                    
//                    filmQueue.sync { [weak self] () -> Void in
                    
                    var currentFrameTime:CMTime = CMTime(value: CMTimeValue((self.sceneView.session.currentFrame!.timestamp) * Double(scale)), timescale: scale);

                    if self.lastTime == 0 {
                        self.videoStartTime = currentFrameTime;
                    }
                    
                    print("[artzyhud] UPDATE AT TIME : \(time)");
                    
                    self.lastTime = time;
                    
                    // VIDEO

                    let snapshot:UIImage = self.sceneView.snapshot()
                    
                    self.createPixelBufferFromUIImage(image:snapshot, completionHandler: { (error, pixelBuffer) in

                        guard error == nil else {
                            print("failed to get pixelBuffer");
                            return
                        }

                        currentFrameTime = currentFrameTime - self.videoStartTime!;


                        if (self.videoInput?.isReadyForMoreMediaData)! {
                            // Add pixel buffer to video input
                            self.pixelBufferAdaptor!.append(pixelBuffer!, withPresentationTime: currentFrameTime);
                            return
                        }
                        else {
                            print("FAILED TO PASS DATA")
                        }
                    });
                    
//                }
            }
        }
    }
}
