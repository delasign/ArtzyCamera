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
}

class CameraHUDViewController: UIViewController, CameraHUDDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    var previewView: PreviewView = PreviewView();
    var cameraButton: ArtzyCameraButton = ArtzyCameraButton();
    var resetButton:ResetButton = ResetButton();
    public var viewControllerDelegate:ViewControllerDelegate?;
    public var  sceneView:ARSCNView = ARSCNView();
    
    // Recording
    private var isRecording:Bool = false;
    var snapshotArray:[[String:Any]] = [[String:Any]]()
    var lastTime:TimeInterval = 0
    private var videoStartTime:CMTime?;
    
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
        
        // Set the view's delegate
//        self.sceneView.delegate = self as? ARSCNViewDelegate
//        self.sceneView.session.delegate = self as! ARSessionDelegate
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
            
            self.cameraButton = ArtzyCameraButton();
            self.cameraButton.sceneView = self.sceneView;
            self.cameraButton.cameraHUDDelegate = self;
            
            self.view.addSubview(self.cameraButton);
            
            self.resetButton = ResetButton();
            self.resetButton.viewControllerDelegate = self.viewControllerDelegate;
            self.resetButton.cameraHUDDelegate = self;
            self.view.addSubview(self.resetButton);
            
            self.previewView = PreviewView(frame: self.view.frame);
            self.previewView.cameraHUDDelegate = self;
            self.view.addSubview(self.previewView);
        }
    }
    
    public func resetCameraHUD() {
        
        DispatchQueue.main.async {
            for view in self.view.subviews {
                view.removeFromSuperview();
            }
        
            self.intializeBasicCameraHUD();
        }
    }
    
    // MARK: DID UPDATE AT TIME
    
    public func didUpdateAtTime(time: TimeInterval) {
        
        if self.isRecording {
            
            if self.lastTime == 0 || (self.lastTime + 1/25) < time {
                DispatchQueue.main.async { [weak self] () -> Void in
                    
                    let scale = CMTimeScale(NSEC_PER_SEC)
                    var currentFrameTime:CMTime = CMTime(value: CMTimeValue((self?.sceneView.session.currentFrame!.timestamp)! * Double(scale)), timescale: scale);
                    
                    if self?.lastTime == 0 {
                        self?.videoStartTime = currentFrameTime;
                    }
                    
                    print("[artzyhud] UPDATE AT TIME : \(time)");
                    guard self != nil else { return }
                    self!.lastTime = time;
                    
                    // VIDEO
                    
                    self?.createPixelBufferFromUIImage(image: (self?.sceneView.snapshot())!, completionHandler: { (error, pixelBuffer) in
                       
                        guard error == nil else {
                            print("failed to get pixelBuffer");
                            return
                        }
                        
                        currentFrameTime = currentFrameTime - self!.videoStartTime!;
                        
                        // Add pixel buffer to video input
                        self!.pixelBufferAdaptor!.append(pixelBuffer!, withPresentationTime: currentFrameTime);
                        
                    });
                }
            }
        }
    }
    
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
//
                    guard result == true else {
                        print("FAILED TO START AUDIO SESSION")
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
        self.isRecording = false;
        self.endAudioRecording()
        self.finishVideoRecording { (videoURL) in
            self.previewView.showPreviewView(withURL: videoURL);
        }
    }
    
    
    
    // MARK:  AUDIO FUNCTIONALITY
    
    func startAudioRecording(completionHandler:@escaping(Bool) -> ()) {
        
        self.recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try self.recordingSession.setCategory(.playAndRecord, mode: .default)
            try self.recordingSession.setActive(true)
            
            print("REQUESTED SESSION")
            
            self.recordingSession!.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
//                        self.loadRecordingUI()
                        print("SESSION ALLOWED")
                        let microphone = AVCaptureDevice.default(.builtInMicrophone, for: AVMediaType.audio, position: .unspecified)
                        
                        do {
                            try self.micInput = AVCaptureDeviceInput(device: microphone!);
                            
                            self.captureSession = AVCaptureSession();
                            
                            if (self.captureSession?.canAddInput(self.micInput!))! {
                                self.captureSession?.addInput(self.micInput!);
                                
                                self.audioOutput = AVCaptureAudioDataOutput();
                                
                                if self.captureSession!.canAddOutput(self.audioOutput!){
                                    self.captureSession!.addOutput(self.audioOutput!)
                                    self.audioOutput?.setSampleBufferDelegate(self, queue: DispatchQueue.global());
                                    
                                    self.captureSession?.startRunning();
                                    completionHandler(true);
                                }
                                
                            }
                        }
                        catch {
                            completionHandler(false);
                        }
                    } else {
//                        self.loadFailUI()
                        completionHandler(false);
                        
                    }
                }
            }
        } catch {
//            self.loadFailUI()
            completionHandler(false);
        }
        
        
    }
    
    func endAudioRecording() { //completionHandler:@escaping()->()

        self.captureSession!.stopRunning();
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard sampleBuffer != nil else {
            print("SAMPLE BUFFER EQUALS NIL ")
            return
        }
        
        
        // You now have the sample buffer - correct the timestamp to the video timestamp
        
        //https://github.com/takecian/video-examples-ios/blob/master/recordings/TimelapseCameraEngine.swift
        
        var count: CMItemCount = 0
        CMSampleBufferGetSampleTimingInfoArray(sampleBuffer, entryCount: 0, arrayToFill: nil, entriesNeededOut: &count);
        var info = [CMSampleTimingInfo](repeating: CMSampleTimingInfo(duration: CMTimeMake(value: 0, timescale: 0), presentationTimeStamp: CMTimeMake(value: 0, timescale: 0), decodeTimeStamp: CMTimeMake(value: 0, timescale: 0)), count: count)
        CMSampleBufferGetSampleTimingInfoArray(sampleBuffer, entryCount: count, arrayToFill: &info, entriesNeededOut: &count);
        
        let scale = CMTimeScale(NSEC_PER_SEC)
        var currentFrameTime:CMTime = CMTime(value: CMTimeValue((self.sceneView.session.currentFrame!.timestamp) * Double(scale)), timescale: scale);
        
        if self.videoStartTime == CMTime.zero {
            self.videoStartTime = currentFrameTime;
        }
        
        currentFrameTime = currentFrameTime-self.videoStartTime!;
        
        for i in 0..<count {
            info[i].decodeTimeStamp = currentFrameTime
            info[i].presentationTimeStamp = currentFrameTime
        }

        var soundbuffer:CMSampleBuffer?
        
        CMSampleBufferCreateCopyWithNewTiming(allocator: kCFAllocatorDefault, sampleBuffer: sampleBuffer, sampleTimingEntryCount: count, sampleTimingArray: &info, sampleBufferOut: &soundbuffer);
        

        self.audioInput?.append(soundbuffer!);
    }
    
}
