//
//  ArtzyItem.swift
//  ArtzyCamera
//
//  Created by Oscar De la Hera Gomez on 12/3/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class PieceOfArtzy: NSObject, UITextFieldDelegate {
    
    public var node:SCNNode?;
    public var referenceImage:ARReferenceImage?;
    public var sceneView:ARSCNView?;
    public var artzyHUD:UIWindow?;
    
    
    public var isWithinFieldOfView:Bool = false;
    public var weight:Float = 0;
    public var offset:Float = 0;
    public var distanceToCamera:Float = 0;
    public let glowModifierView:UIView = UIView();
    
    public func start() {
        
        DispatchQueue.main.sync {
            artzyNotificationView.updateNotification(title: "displaying \(self.referenceImage!.name!)", style: .itemFound);
        }
        
        if self.referenceImage!.name == "mondriaan"{
//            self.performAdamLocalStroke()
            self.performAdamLocalStatic()
        }

        
        
    }
    
    public func didUpdateAtTime() {
//        self.node?.rotation.y += 0.01
        
    }
    
    
    
    public func setIsWithinFieldOfView(bool:Bool){
        self.isWithinFieldOfView = bool;
        
        if bool {
            // VISIBLE
            self.showArtzyPieceHUD();
        }
        else {
            // INVISIBLE
            self.hideArtzyPieceHUD()
        }
    }
    
    public func showArtzyPieceHUD() {
        
    }
    
    public func hideArtzyPieceHUD() {
        
    }
    
    // MARK : CREATOR TOOLS
    
    func showDetectionPlane() {
        // Create a plane to visualize the initial position of the detected image.
        let plane = SCNPlane(width: self.referenceImage!.physicalSize.width,
                             height: self.referenceImage!.physicalSize.height)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.opacity = 0.25
        
        /*
         `SCNPlane` is vertically oriented in its local coordinate space, but
         `ARImageAnchor` assumes the image is horizontal in its local space, so
         rotate the plane to match.
         */
        planeNode.eulerAngles.x = -.pi / 2
        
        /*
         Image anchors are not tracked after initial detection, so create an
         animation that limits the duration for which the plane visualization appears.
         */
        planeNode.runAction(self.imageHighlightAction)
        
        // Add the plane visualization to the scene.
        self.node!.addChildNode(planeNode)
    }
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
            ])
    }
    
    // Pieces
    
    func performAdamLocalStatic() {
        let scn:SCNScene? = SCNScene(named: "art.scnassets/localxAdamfu.scn");
        
        for child in scn!.rootNode.childNodes {
            child.categoryBitMask = 4;
            child.position = SCNVector3.init(child.position.x, 0.1, child.position.z);
            
            self.addColorShaderForChild(child: child, red: 1, blue: 1, green: 1);
            if child.name! == "halo" {
                child.categoryBitMask = 3;
                child.position = SCNVector3.init(child.position.x, 0.074, child.position.z);
            }
            else if child.name! == "haloDrip" {
                child.categoryBitMask = 3;
            }
            
            self.node!.addChildNode(child);
            
        }
        
        DispatchQueue.main.sync {
            self.sceneView!.scene.rootNode.addChildNode(self.node!);
        }
        
        if let path = Bundle.main.path(forResource: "GlowInTwoColors", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path)  {
                print("DICT EXISTS");
                let dict2 = dict as! [String : AnyObject]
                let technique = SCNTechnique(dictionary:dict2)
                self.sceneView!.technique = technique
            }
            
        }
    }
    
    func performAdamLocalStroke() {
     
        let scn:SCNScene? = SCNScene(named: "art.scnassets/localxAdamfu.scn");
        
        for child in scn!.rootNode.childNodes {
            child.categoryBitMask = 4;
            child.position = SCNVector3.init(child.position.x, 0.1, child.position.z);
            
            let globalLoopTime:Float = 15;
            
            if child.name! == "local" {
                self.addStrokeShaderWithTimeForChild(child: child, loopTime: globalLoopTime, startTime: 0, endTime: 8);
            }
            else if child.name! == "drip1" {
                self.addStrokeShaderWithTimeForChild(child: child, loopTime: globalLoopTime, startTime: 0.25, endTime: 0.5);
            }
            else if child.name! == "drip2" {
                self.addStrokeShaderWithTimeForChild(child: child, loopTime: globalLoopTime, startTime: 1.75, endTime: 2.5);
            }
            else if child.name! == "drip3" {
                self.addStrokeShaderWithTimeForChild(child: child, loopTime: globalLoopTime, startTime: 2.75, endTime: 2.85);
            }
            else if child.name! == "drip4" {
                self.addStrokeShaderWithTimeForChild(child: child, loopTime: globalLoopTime, startTime: 3.15, endTime: 3.75);
            }
            else if child.name! == "drip5" {
                self.addStrokeShaderWithTimeForChild(child: child, loopTime: globalLoopTime, startTime: 4.1, endTime: 5.4);
            }
            else if child.name! == "drip6" {
                self.addStrokeShaderWithTimeForChild(child: child, loopTime: globalLoopTime, startTime: 7, endTime: 7.5);
            }
            else if child.name! == "drip7" {
                self.addStrokeShaderWithTimeForChild(child: child, loopTime: globalLoopTime, startTime: 7.05, endTime: 7.55);
            }
            else if child.name! == "drip8" {
                self.addStrokeShaderWithTimeForChild(child: child, loopTime: globalLoopTime, startTime: 8, endTime: 8.5);
            }
            else if child.name! == "halo" {
                child.categoryBitMask = 3;
                child.position = SCNVector3.init(child.position.x, 0.074, child.position.z);
                self.addStrokeShaderWithTimeForChild(child: child, loopTime: globalLoopTime, startTime: 8, endTime: 9);
            }
            else if child.name! == "haloDrip" {
                child.categoryBitMask = 3;
                self.addStrokeShaderWithTimeForChild(child: child, loopTime: globalLoopTime, startTime: 9, endTime: 9.5);
            }
            
            
            self.node!.addChildNode(child);
            
        }
        
        DispatchQueue.main.sync {
            self.sceneView!.scene.rootNode.addChildNode(self.node!);
        }
        
        if let path = Bundle.main.path(forResource: "GlowInTwoColors", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path)  {
                print("DICT EXISTS");
                let dict2 = dict as! [String : AnyObject]
                let technique = SCNTechnique(dictionary:dict2)
                self.sceneView!.technique = technique
            }
            
        }
        
    }
    
    
}