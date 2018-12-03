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


protocol ArtzyViewControllerDelegate {
    func resetTracking();
}


class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    public var activeArtzyPieces:[NSMutableDictionary] = [NSMutableDictionary]();
    
    
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
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self
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
        sceneView.session.pause()
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
        
        // Prepare Recorder
        //        self.recorder?.prepare(configuration)
        
        // REMOVE ALL OBJECTS
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode();
        }
        
        //        sceneView.debugOptions = [.showBoundingBoxes];
        
        let plane:SCNPlane = SCNPlane(width: 0, height: 0);
        let centerNode:SCNNode = SCNNode(geometry: plane);
        centerNode.position = SCNVector3.init(0, 0, 0);
        centerNode.name = "scene_center";
        sceneView.scene.rootNode.addChildNode(centerNode);
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
                "artzy" : pieceOfArtzy,
                "withinPointOfView": false,
                "distanceToObject": 0
            ]

            self.activeArtzyPieces.append(ArtzyPieces);
            
            
        }
    }
    
    var prevPosition:SCNVector3?
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
//        let randomFloat:Float = Float(arc4random());
//        print("RANDOM FLOAT : ", randomFloat)
        self.sceneView.technique?.setObject(NSNumber(value: 1), forKeyedSubscript: "customVariableSymbol" as NSCopying)
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
