//
//  ViewControllerReplayKitFunctionality.swift
//  xArt
//
//  Created by Oscar De la Hera Gomez on 8/2/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

extension CameraHUDViewController {
    
    public func saveVideo(withName:String, imageArray:[[String:Any]], fps:Int, size:CGSize) {
        
        self.createURLForVideo(withName: withName) { (videoURL) in
            self.prepareWriterAndInput(size:size, videoURL: videoURL, completionHandler: { (error) in
                
                guard error == nil else {
                    // it errored.
                    return
                }
                
                self.createVideo(imageArray: imageArray, fps: fps, size:size, completionHandler: { _ in
                    print("[F] saveVideo :: DONE");
                    
                    guard error == nil else {
                        // it errored.
                        return
                    }
                    
                    self.finishVideoRecordingAndSave();
                    
                });
            });
        }
        
    }
    
    public func createURLForVideo(withName:String, completionHandler:@escaping (URL)->()) {
        // Clear the location for the temporary file.
        let temporaryDirectoryURL:URL = URL.init(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true);
        let targetURL:URL = temporaryDirectoryURL.appendingPathComponent("\(withName).mp4")
        // Delete the file, incase it exists.
        do {
            try FileManager.default.removeItem(at: targetURL);
            
        } catch let error {
            NSLog("Unable to delete file, with error: \(error)")
        }
        // return the URL
        completionHandler(targetURL);
    }
    
    public func prepareWriterAndInput(size:CGSize, videoURL:URL, completionHandler:@escaping(Error?)->()) {
        
        do {
            self.assetWriter = try AVAssetWriter(outputURL: videoURL, fileType: AVFileType.mp4)
            
            // Input is the mic audio of the AVAudioEngine            
            let audioOutputSettings = [
                AVFormatIDKey : kAudioFormatMPEG4AAC,
                AVNumberOfChannelsKey : 2,
                AVSampleRateKey : 44100.0,
                AVEncoderBitRateKey: 192000
                ] as [String : Any]
            
            self.audioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: audioOutputSettings);
            self.audioInput!.expectsMediaDataInRealTime = true
            self.assetWriter?.add(self.audioInput!);
            
//            self.audioInput.
            
            // Video Input Creator
            
            let videoOutputSettings: Dictionary<String, Any> = [
                AVVideoCodecKey : AVVideoCodecType.h264,
                AVVideoWidthKey : size.width,
                AVVideoHeightKey : size.height
            ];
            
            self.videoInput  = AVAssetWriterInput (mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
            self.videoInput!.expectsMediaDataInRealTime = true
            self.assetWriter!.add(self.videoInput!)
            
            // Create Pixel buffer Adaptor
            
            let sourceBufferAttributes:[String : Any] = [
                (kCVPixelBufferPixelFormatTypeKey as String): Int(kCVPixelFormatType_32ARGB),
                (kCVPixelBufferWidthKey as String): Float(size.width),
                (kCVPixelBufferHeightKey as String): Float(size.height)] as [String : Any]
            
            self.pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: self.videoInput!, sourcePixelBufferAttributes: sourceBufferAttributes);
    
            self.assetWriter?.startWriting();
            self.assetWriter?.startSession(atSourceTime: CMTime.zero);
            completionHandler(nil);
        }
        catch {
            print("Failed to create assetWritter with error : \(error)");
            completionHandler(error);
        }
    }
    
    private func createVideo(imageArray:[[String:Any]], fps:Int, size:CGSize, completionHandler:@escaping(String?)->()) {
        
        var currentframeTime:CMTime = CMTime.zero;
        var currentFrame:Int = 0;
        
        let startTime:CMTime = (imageArray[0])["time"] as! CMTime;
        
        while (currentFrame < imageArray.count) {
            
            // When the video input is ready for more media data...
            if (self.videoInput?.isReadyForMoreMediaData)!  {
                print("processing current frame :: \(currentFrame)");
                // Get current UI Image
                let currentImage:UIImage = (imageArray[currentFrame])["image"] as! UIImage;
                
                // Create the pixel buffer
                self.createPixelBufferFromUIImage(image: currentImage) { (error, pixelBuffer) in
                    
                    guard error == nil else {
                        completionHandler("failed to get pixelBuffer");
                        return
                    }
                    
                    // Calc the current frame time
                    currentframeTime = (imageArray[currentFrame])["time"] as! CMTime - startTime;
                    print("SECONDS : \(currentframeTime.seconds)")
                    print("Current frame time :: \(currentframeTime)");
                    
                    // Add pixel buffer to video input
                    self.pixelBufferAdaptor!.append(pixelBuffer!, withPresentationTime: currentframeTime);
                    
                    // increment frame
                    currentFrame += 1;
                }
            }
        }
        
        // FINISHED
        completionHandler(nil);
    }
    
    
    public func createPixelBufferFromCGImage(image:CGImage, completionHandler:@escaping(String?, CVPixelBuffer?) -> ()) {
        //https://stackoverflow.com/questions/44400741/convert-image-to-cvpixelbuffer-for-machine-learning-swift
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, image.width, image.height, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            completionHandler("Failed to create pixel buffer", nil)
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: image.width, height: image.height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: CGFloat(image.height))
        context?.scaleBy(x: 1.0, y: -1.0)
        
//        UIGraphicsPushContext(context!)
//        image.draw(in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
//        UIGraphicsPopContext()
//        context.draw(image, in: CGRect(x: 0.0,y: 0.0,width: image.width, height: image.height));
//        context?.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height));
        
        UIGraphicsPushContext(context!)
        context?.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height));
        UIGraphicsPopContext()
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        completionHandler(nil, pixelBuffer)
    }
    
    public func createPixelBufferFromUIImage(image:UIImage, completionHandler:@escaping(String?, CVPixelBuffer?) -> ()) {
        //https://stackoverflow.com/questions/44400741/convert-image-to-cvpixelbuffer-for-machine-learning-swift
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            completionHandler("Failed to create pixel buffer", nil)
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        completionHandler(nil, pixelBuffer)
    }
    
    
    public func finishVideoRecordingAndSave() {
        self.videoInput!.markAsFinished();
        self.audioInput?.markAsFinished();
        self.assetWriter?.finishWriting(completionHandler: {
            print("output url : \(self.assetWriter?.outputURL)");
            
            PHPhotoLibrary.requestAuthorization({ (status) in
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: (self.assetWriter?.outputURL)!)
                }) { saved, error in
                    
                    guard error == nil else {
                        print("failed to save video");
                        print("error : \(error)")
                        return
                    }
                    
                    if saved {
                        let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                    self.snapshotArray.removeAll();
                    FileManager.default.clearTmpDirectory();
                }
            })
        })
    }
    
    public func finishVideoRecording(completionHandler:@escaping(URL)->()) {
        self.videoInput!.markAsFinished();
        self.audioInput?.markAsFinished();
        self.assetWriter?.finishWriting(completionHandler: {
            print("output url : \(self.assetWriter?.outputURL)");
            
            completionHandler((self.assetWriter?.outputURL)!);
        })
    }
    
    public func exportVideo() {
        PHPhotoLibrary.requestAuthorization({ (status) in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: (self.assetWriter?.outputURL)!)
            }) { saved, error in
                
                guard error == nil else {
                    print("failed to save video");
                    print("error : \(error)")
                    return
                }
                
                if saved {
                    let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                FileManager.default.clearTmpDirectory();
            }
        })
    }
    
}


extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirURL = FileManager.default.temporaryDirectory
            let tmpDirectory = try contentsOfDirectory(atPath: tmpDirURL.path)
            try tmpDirectory.forEach { file in
                let fileUrl = tmpDirURL.appendingPathComponent(file)
                try removeItem(atPath: fileUrl.path)
            }
        } catch {
            //catch the error somehow
        }
    }
}
