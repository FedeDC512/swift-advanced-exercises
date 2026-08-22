//
//  TV_Felix.swift
//  Felix
//
//  Created by Federico Agnello on 26/03/2026.
//

import SpriteKit

// Category mask
// Felix: 1
// Platform: 2
// Hole: 4
// Ground: 8
// Little coin: 16
// Big coin: 32
// Finish: 64


class TV_Felix: SKScene, SKPhysicsContactDelegate {
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
    
    override func didMove(to view: SKView) {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameEnded {
            felix.physicsBody?.applyImpulse(CGVector(dx: 0, dy: currentImpulse))
            felix.removeAllActions()
            actionFelix = SKAction(named: "jump")!
            felix.run(actionFelix)
        } else {
            let newScene = SKScene(fileNamed:"TV_Felix")
            newScene!.scaleMode = self.scaleMode
            self.view?.presentScene(newScene!, transition: SKTransition.fade(withDuration: 1.0))
        }
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
        if startingTime == 0{
            startingTime = currentTime
        } else if (currentTime>=startingTime + 3){
            startingTime = currentTime
            currentImpulse = defaultImpulse
        }
    }
}
