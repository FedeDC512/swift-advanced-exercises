//
//  Watch_Felix.swift
//  Felix
//
//  Created by Federico Agnello on 26/03/2026.
//

import SwiftUI
import SpriteKit
import Combine

// Category mask
// Felix: 1
// Platform: 2
// Hole: 4
// Ground: 8
// Little coin: 16
// Big coin: 32
// Finish: 64


class Watch_Felix: SKScene, SKPhysicsContactDelegate, ObservableObject {
    @Published var shouldJump = false
    
    var score = 0
    var gameEnded = false
    
    var felix = SKSpriteNode()
    var start = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var messageLabel = SKLabelNode()
    var actionFelix = SKAction()
    var coin = SKSpriteNode()
    var actionCoin = SKAction()
    let defaultImpulse = 4000
    var currentImpulse: Int = 0
    var startingTime: TimeInterval = 0
    private var isSetup = false
    
    override func sceneDidLoad() {
        setup()
    }
    
    func setup() {
        guard !isSetup else { return }
        isSetup = true
        
        physicsWorld.contactDelegate = self
        
        //Nodes:
        felix = childNode(withName: "Felix") as! SKSpriteNode
        start = childNode(withName: "Start") as! SKSpriteNode
        scoreLabel = camera!.childNode(withName: "score") as! SKLabelNode
        scoreLabel.text = String(score)
        messageLabel = camera!.childNode(withName: "message") as! SKLabelNode
        messageLabel.text = String("")

        //Actions:
        self.enumerateChildNodes(withName: "coin"){node,err  in
            node.run(SKAction(named: "coin")!)
        }
    }
    
    func jump() {
        guard !gameEnded else { return }
        felix.physicsBody?.applyImpulse(CGVector(dx: 0, dy: currentImpulse))
        felix.removeAllActions()
        actionFelix = SKAction(named: "jump")!
        felix.run(actionFelix)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let catA = contact.bodyA.categoryBitMask
        let catB = contact.bodyB.categoryBitMask
        
        if (catA+catB==5){ //4 + 1 Hole + Felix
            actionFelix = SKAction(named: "fall")!
            felix.run(actionFelix)
        }else if (catA+catB==9){ //8+1 Ground + Felix
            actionFelix = SKAction(named: "dead")!
            felix.run(actionFelix)
            gameEnded = true
            messageLabel.text = "YOU LOSE!!!"
            scene?.run(SKAction.playSoundFileNamed("error.wav", waitForCompletion: true))
        }else if (catA+catB==17){ //16+1 Little coin + Felix
            if(catA == 16) {
                contact.bodyA.node?.removeFromParent()
            } else{
                contact.bodyB.node?.removeFromParent()
            }
            score += 1
            scoreLabel.text = String(score)
        } else if (catA+catB==33){ //32+1 Big coin + Felix
            if(catA == 32) {
                contact.bodyA.node?.removeFromParent()
            } else{
                contact.bodyB.node?.removeFromParent()
            }
            score += 100
            scoreLabel.text = String(score)
        } else if (catA+catB==65){ //64 + 1 Finish + Felix
            felix.removeAllActions()
            actionFelix = SKAction(named: "jump")!
            felix.run(actionFelix)
            gameEnded = true
            messageLabel.text = "YOU WIN!!!"
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if shouldJump {
            shouldJump = false
            jump()
        }
        
        if startingTime == 0{
            startingTime = currentTime
        } else if (currentTime>=startingTime + 3){
            startingTime = currentTime
            currentImpulse = defaultImpulse
        }
    }
}
