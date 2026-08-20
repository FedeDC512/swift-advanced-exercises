//
//  FlowerScene.swift
//  Gyroscope Gravity Flowers
//
//  Created by Federico Agnello on 13/03/2026.
//

import Foundation
import SpriteKit
import CoreMotion

class FlowerScene: SKScene {

    private let motionManager = CMMotionManager()
    private let motionQueue = OperationQueue()
    private let gravityFactor: Double = 20.0
    
    override func didMove(to view: SKView) {
        let xMid = 0
        let yMid = 0
        let sceneHeight = self.size.height
        let sceneWidth = self.size.width
        
        let flower1 = SKSpriteNode(imageNamed: "flower-OY")
        flower1.position = CGPoint(x: xMid, y: yMid)
        flower1.setScale(0.5)
        flower1.physicsBody = SKPhysicsBody(texture: flower1.texture ?? SKTexture(), size: flower1.size)
        flower1.physicsBody?.isDynamic = true
        flower1.physicsBody?.affectedByGravity = true
        flower1.physicsBody?.allowsRotation = true
        flower1.physicsBody?.restitution = 0.2
        flower1.physicsBody?.friction = 0.8
        flower1.physicsBody?.linearDamping = 0.5
        scene?.addChild(flower1)
        
        let flower2 = SKSpriteNode(imageNamed: "flower-VO")
        flower2.position = CGPoint(x: xMid + 200, y: yMid - 250)
        flower2.setScale(0.5)
        flower2.physicsBody = SKPhysicsBody(texture: flower2.texture ?? SKTexture(), size: flower2.size)
        flower2.physicsBody?.isDynamic = true
        flower2.physicsBody?.affectedByGravity = true
        flower2.physicsBody?.allowsRotation = true
        flower2.physicsBody?.restitution = 0.2
        flower2.physicsBody?.friction = 0.8
        flower2.physicsBody?.linearDamping = 0.5
        scene?.addChild(flower2)
        
        let flower3 = SKSpriteNode(imageNamed: "flower-GB")
        flower3.position = CGPoint(x: xMid + 200, y: yMid + 250)
        flower3.setScale(0.5)
        flower3.physicsBody = SKPhysicsBody(texture: flower3.texture ?? SKTexture(), size: flower3.size)
        flower3.physicsBody?.isDynamic = true
        flower3.physicsBody?.affectedByGravity = true
        flower3.physicsBody?.allowsRotation = true
        flower3.physicsBody?.restitution = 0.2
        flower3.physicsBody?.friction = 0.8
        flower3.physicsBody?.linearDamping = 0.5
        scene?.addChild(flower3)
        
        let flower4 = SKSpriteNode(imageNamed: "flower-GB")
        flower4.position = CGPoint(x: xMid - 200, y: yMid - 250)
        flower4.setScale(0.5)
        flower4.physicsBody = SKPhysicsBody(texture: flower4.texture ?? SKTexture(), size: flower4.size)
        flower4.physicsBody?.isDynamic = true
        flower4.physicsBody?.affectedByGravity = true
        flower4.physicsBody?.allowsRotation = true
        flower4.physicsBody?.restitution = 0.2
        flower4.physicsBody?.friction = 0.8
        flower4.physicsBody?.linearDamping = 0.5
        scene?.addChild(flower4)
        
        let flower5 = SKSpriteNode(imageNamed: "flower-VO")
        flower5.position = CGPoint(x: xMid - 200, y: yMid + 250)
        flower5.setScale(0.5)
        flower5.physicsBody = SKPhysicsBody(texture: flower5.texture ?? SKTexture(), size: flower5.size)
        flower5.physicsBody?.isDynamic = true
        flower5.physicsBody?.affectedByGravity = true
        flower5.physicsBody?.allowsRotation = true
        flower5.physicsBody?.restitution = 0.2
        flower5.physicsBody?.friction = 0.8
        flower5.physicsBody?.linearDamping = 0.5
        scene?.addChild(flower5)
        
        let flower6 = SKSpriteNode(imageNamed: "flower-BY")
        flower6.position = CGPoint(x: xMid, y: yMid + 500)
        flower6.setScale(0.5)
        flower6.physicsBody = SKPhysicsBody(texture: flower6.texture ?? SKTexture(), size: flower6.size)
        flower6.physicsBody?.isDynamic = true
        flower6.physicsBody?.affectedByGravity = true
        flower6.physicsBody?.allowsRotation = true
        flower6.physicsBody?.restitution = 0.2
        flower6.physicsBody?.friction = 0.8
        flower6.physicsBody?.linearDamping = 0.5
        scene?.addChild(flower6)

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.01
            motionManager.startDeviceMotionUpdates(to: motionQueue) { [weak self] data, error in
                guard let gravity = data?.gravity, let strong = self else { return }
                DispatchQueue.main.async {
                    strong.physicsWorld.gravity = CGVector(dx: gravity.x * strong.gravityFactor, dy: gravity.y * strong.gravityFactor)
                }
            }
        }
    }

    override func willMove(from view: SKView) {
        super.willMove(from: view)
        motionManager.stopDeviceMotionUpdates()
    }
}
