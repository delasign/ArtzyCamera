//
//  HUDAudioFunc.swift
//  ArtzyCamera
//
//  Created by Oscar De la Hera Gomez on 12/4/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import Foundation
import AVFoundation

extension CameraHUDViewController {
    
    // MARK:  AUDIO FUNCTIONALITY
    
    func startAudioRecording(completionHandler:@escaping(Bool) -> ()) {
        
        self.recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try self.recordingSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .videoRecording, options: [.defaultToSpeaker])
            try self.recordingSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            print("REQUESTED SESSION")
            
            self.recordingSession!.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //                        self.loadRecordingUI()
                        print("SESSION ALLOWED")
//                        let microphone = AVCaptureDevice.default(.builtInMicrophone, for: AVMediaType.audio, position: .unspecified)
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
    
    func endAudioCapture() {
            self.captureSession!.stopRunning();
    }
    
    public func endAudioSession() {
        do {
            try self.recordingSession.setActive(false, options: .notifyOthersOnDeactivation)
        }
        catch {
            print("ERROR CANCELLING RECORDING SESSION : \(error)")
        }
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
        
        if (self.audioInput?.isReadyForMoreMediaData)! {
            self.audioInput?.append(soundbuffer!);
        }
        else {
            print("Audio Data Failed");
        }
        
        
    }
}
