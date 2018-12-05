//
//  ViewController.swift
//  ArtzyCamera
//
//  Created by Oscar De la Hera Gomez on 12/3/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Photos
import AVKit


protocol ViewControllerDelegate {
    func resetTracking();
}


class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, ViewControllerDelegate {
    
    public var activeArtzyPieces:[NSMutableDictionary] = [NSMutableDictionary]();
    
    var HUD:UIWindow!
    @IBOutlet var sceneView: ARSCNView!
    
    /// A serial queue for thread safety when modifying the SceneKit node graph.
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // HIDE STATUS BAR
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("VIEW DID LOAD");
        //Instantiate variables
        screenWidth = self.view.frame.width;
        screenHeight = self.view.frame.height;
        instantiateArtzyVariables();
        
        // Set the view's delegate
        self.sceneView.delegate = self
        self.sceneView.session.delegate = self
//        self.sceneView.rendersContinuously = true;
        
        self.HUD = UIWindow(frame: self.view.frame);
        
        let cameraHUD:CameraHUDViewController = CameraHUDViewController();
        cameraHUD.sceneView = self.sceneView;
        cameraHUD.viewControllerDelegate = self;
        self.HUD.rootViewController = cameraHUD;
        self.HUD.rootViewController!.view.alpha = 1;
        self.HUD.makeKeyAndVisible()
        
        if let camera = self.sceneView.pointOfView?.camera {
//            camera.wantsHDR = true
//            camera.wantsExposureAdaptation = true
//            camera.whitePoint = 1.0
//            camera.exposureOffset = 1
//            camera.minimumExposure = 1
//            camera.maximumExposure = 1
        }
        
        
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    print("AUthorized");
                } else {
                    print("status ", PHPhotoLibrary.authorizationStatus() );
                }
            })
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission () {
            [unowned self] allowed in
            if allowed {
                // Microphone allowed, do what you like!
                
            } else {
                // User denied microphone. Tell them off!
                
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start the AR experience
        resetTracking()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        self.sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - Session management (Image detection setup)
    
    /// Prevents restarting the session while a restart is in progress.
    var isRestartAvailable = true
    
    /// Creates a new AR configuration to run on the `session`.
    /// - Tag: ARReferenceImage-Loading
    public func resetTracking() {
        
        print("RESET TRACKING");
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        // REMOVE ALL OBJECTS
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode();
        }
    }
    
    // MARK: - ARSCNViewDelegate (Image detection results)
    /// - Tag: ARImageAnchor-Visualizing
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        
        print("REGISTERED IMAGE : \(referenceImage)");
        
        updateQueue.async {
            
            let pieceOfArtzy:PieceOfArtzy = PieceOfArtzy();
            pieceOfArtzy.sceneView = self.sceneView;
            //            artzyPiece.artzyHUD = self.artzyHUD;
            pieceOfArtzy.node = node;
            pieceOfArtzy.referenceImage = referenceImage;
            pieceOfArtzy.start();

            let ArtzyPieces:NSMutableDictionary = [
                "node" : node,
                "pieceOfArtzy" : pieceOfArtzy,
                "withinPointOfView": false,
                "distanceToObject": 0
            ]

            self.activeArtzyPieces.append(ArtzyPieces);
            
            
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.sceneView.technique?.setObject(NSNumber(value: 1), forKeyedSubscript: "customVariableSymbol" as NSCopying)
        DispatchQueue.main.async {
            (self.HUD.rootViewController as! CameraHUDViewController).didUpdateAtTime(time:time);
            
            for ArtzyDict in self.activeArtzyPieces {
                let pieceOfArtzy:PieceOfArtzy = ArtzyDict.value(forKey: "pieceOfArtzy") as! PieceOfArtzy;
                pieceOfArtzy.didUpdateAtTime();
            }
            
            
        }
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
    
    
    
    
}
