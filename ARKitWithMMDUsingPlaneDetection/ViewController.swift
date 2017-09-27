//
//  ViewController.swift
//  ARKitWithMMDUsingPlaneDetection
//
//  Created by magicien on 2017/06/06.
//  Copyright © 2017年 DarkHorse. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import MMDSceneKit_iOS

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var node: SCNNode!
    var anchorNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        node = SCNNode()
        node.position = SCNVector3(0, 0, 0)
        node.scale = SCNVector3(0.005, 0.005, 0.005)
        
        let kishimen = MMDSceneSource(named: "art.scnassets/サンプル（きしめんAllStar).pmm")!.getScene()!
        for child in kishimen.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        //configuration.isLightEstimationEnabled = true
        
        // Run the view's session
        sceneView.session.run(configuration)
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

    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchorNode == nil else {
            return nil
        }
        guard anchor is ARPlaneAnchor else {
            return nil
        }
        
        let node = SCNNode()
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        sceneView.scene.rootNode.addChildNode(node)
        
        node.simdTransform = anchor.transform
        
        if anchorNode == nil {
            anchorNode = node
            
            self.node.removeFromParentNode()
            node.addChildNode(self.node)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if node == anchorNode {
            node.simdTransform = anchor.transform
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if node == anchorNode {
            anchorNode = nil
            
            self.node.removeFromParentNode()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
        MMDIKController.updateIK(renderer: renderer)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
