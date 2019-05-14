//
//  GameViewController.swift
//  IOSFinal
//
//  Created by Kristine Legzdina on 19/04/2019.
//  Copyright © 2019 Kristine Legzdina. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    let CategoryTree = 2
    var sceneView:SCNView!
    var scene:SCNScene!
    
    //4
    var ballNode:SCNNode!
    var selfieStickNode:SCNNode!
    var motion = MotionHelper()
    var motionForce = SCNVector3(0, 0, 0)
    
    override func viewDidLoad() {
        setupScene() //2
        setupNodes()
        
      //  navigationController?.navigationBar.topItem?.hidesBackButton = true
    }
    
    //1 use to setup scene
    func setupScene(){
        
        //display scene
        sceneView = (self.view as! SCNView)
        sceneView.delegate = self
        
        scene = SCNScene(named: "art.scnassets/MainScene.scn")
        sceneView.scene = scene
        
        scene.physicsWorld.contactDelegate = self
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        tapRecognizer.addTarget(self, action: #selector(GameViewController.sceneViewTapped(recognizer:)))
        sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    //5
    func setupNodes() {
        ballNode = scene.rootNode.childNode(withName: "ball", recursively: true)!
        ballNode.physicsBody?.contactTestBitMask = CategoryTree
        selfieStickNode = scene.rootNode.childNode(withName: "selfieStick", recursively: true)!
    }
    
    @objc func sceneViewTapped (recognizer:UITapGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        
        let hitResults = sceneView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults.first
            if let node = result?.node {
                if node.name == "ball" {
                    ballNode.physicsBody?.applyForce(SCNVector3(x: 0, y:4, z: -2), asImpulse: true)
                }
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController : SCNSceneRendererDelegate {
    
    //this f-n call every frame, so camera manipulate is very good here
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let ball = ballNode.presentation
        let ballPosition = ball.position
        
        let targetPosition = SCNVector3(x: ballPosition.x, y: ballPosition.y + 5, z:ballPosition.z + 5)
        var cameraPosition = selfieStickNode.position
        
        let camDamping:Float = 0.3
        
        let xComponent = cameraPosition.x * (1 - camDamping) + targetPosition.x * camDamping
        let yComponent = cameraPosition.y * (1 - camDamping) + targetPosition.y * camDamping
        let zComponent = cameraPosition.z * (1 - camDamping) + targetPosition.z * camDamping
        
        cameraPosition = SCNVector3(x: xComponent, y: yComponent, z: zComponent)
        selfieStickNode.position = cameraPosition
        
        
        motion.getAccelerometerData { (x, y, z) in
            self.motionForce = SCNVector3(x: x * 0.05, y:0, z: (y + 0.8) * -0.05)
        }
        
        ballNode.physicsBody?.velocity += motionForce
    }
}

extension GameViewController : SCNPhysicsContactDelegate {
    //katru reizi kā ir kontakts
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var contactNode:SCNNode!
        
        if contact.nodeA.name == "ball" {
            contactNode = contact.nodeB //b->tree
        }else{
            contactNode = contact.nodeA
        }
        
        if contactNode.physicsBody?.categoryBitMask == CategoryTree {
            contactNode.isHidden = true //paslepjam,ja ar koku saskaras
            
            let waitAction = SCNAction.wait(duration: 15) //pec 15 s atkal parada koku
            let unhideAction = SCNAction.run { (node) in
                node.isHidden = false
            }
            
            let actionSequence = SCNAction.sequence([waitAction, unhideAction])
            
            contactNode.runAction(actionSequence)
        }
    }
}