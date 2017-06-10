//
//  GameScene.swift
//  FlappyBird
//
//  Created by Anthony Kim on 6/6/17.
//  Copyright © 2017 anthonykim. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Obstacle   : UInt32 = 1
    static let Player: UInt32 = 2
    static let Scoremark: UInt32 = 4
    static let Ground: UInt32 = 8
    static let Ceiling: UInt32 = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player:SKSpriteNode!
    
    var gameStarted = false
    
    var score = 0
    var scoreLabel = SKLabelNode(fontNamed: "Arial")
    
    var died = false
    
    override func didMove(to view: SKView) {
        
        createScene()
    }
    
    func createScene(){
        physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "sky")
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        background.size = CGSize(width: size.width, height: size.height)
        background.zPosition = -1
        addChild(background)
    
        player = SKSpriteNode(imageNamed: "onepunchhead")
        player.position = CGPoint(x: size.width * 0.2, y: size.height * 0.5)
        player.size = CGSize(width: size.width * 0.15, height: size.width * 0.2)
        player.zPosition = 2
        addChild(player)
        
        scoreLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.87)
        scoreLabel.text = "0"
        scoreLabel.fontColor = UIColor.white
        scoreLabel.fontSize = size.height * 0.1
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        
        let ceiling = SKSpriteNode(color: UIColor.black, size: CGSize(width: size.width, height: 1))
        ceiling.position = CGPoint(x: size.width / 2, y: size.height + 0.5)
        ceiling.zPosition = 1
        addChild(ceiling)
        
        let ground = SKSpriteNode(color: UIColor.black, size: CGSize(width: size.width, height: 1))
        ground.position = CGPoint(x: size.width / 2, y: -0.5)
        ground.zPosition = 1
        addChild(ground)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle
        player.physicsBody?.collisionBitMask = PhysicsCategory.Ceiling|PhysicsCategory.Ground|PhysicsCategory.Obstacle
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: ceiling.size)
        ceiling.physicsBody?.affectedByGravity = false
        ceiling.physicsBody?.isDynamic = false
        ceiling.physicsBody?.categoryBitMask = PhysicsCategory.Ceiling
        ground.physicsBody?.collisionBitMask = PhysicsCategory.Player
        
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.Player
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
            gameStarted = true
            
            player.physicsBody?.affectedByGravity = true
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
            
            run(SKAction.repeatForever(SKAction.sequence([
                SKAction.run(addObstacle),
                SKAction.wait(forDuration: 2.5)
                ])))
        } else {
            if died == true {
                
            } else {
                player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
            }
        }
    }
    
    func addObstacle() {
        
        let randHeight = random(min: size.height * 0.1, max: size.height - (2.5 * player.frame.height) - (size.height * 0.1))
        let topHeight = size.height - (2.5 * player.frame.height) - randHeight
        
        
//        let obstacle = SKSpriteNode(imageNamed: "naruto")
        let obstacle = SKSpriteNode(color: UIColor.green, size: CGSize(width: size.width * 0.3, height: randHeight))
        let topPipe = SKSpriteNode(color: UIColor.green, size: CGSize(width: size.width * 0.3, height: topHeight))
        
//        obstacle.size = CGSize(width: size.width * 0.3, height: randHeight)
        obstacle.position = CGPoint(x: size.width + obstacle.frame.width / 2, y: obstacle.frame.height / 2)
        obstacle.zPosition = 1
        addChild(obstacle)
        
        topPipe.position = CGPoint(x: size.width + obstacle.frame.width / 2, y: size.height - (topPipe.frame.height / 2))
        topPipe.zPosition = 1
        addChild(topPipe)
        
        let scoremark = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 1, height: player.frame.height * 2.5))
        scoremark.position = CGPoint(x: size.width + obstacle.frame.width, y: randHeight + (player.frame.height * 2.5) / 2)
        scoremark.zPosition = 1
        addChild(scoremark)
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        obstacle.physicsBody?.collisionBitMask = PhysicsCategory.Player
        
        topPipe.physicsBody = SKPhysicsBody(rectangleOf: topPipe.size)
        topPipe.physicsBody?.affectedByGravity = false
        topPipe.physicsBody?.isDynamic = false
        topPipe.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        topPipe.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        topPipe.physicsBody?.collisionBitMask = PhysicsCategory.Player
        
        scoremark.physicsBody = SKPhysicsBody(rectangleOf: scoremark.size)
        scoremark.physicsBody?.affectedByGravity = false
        scoremark.physicsBody?.isDynamic = false
        scoremark.physicsBody?.categoryBitMask = PhysicsCategory.Scoremark
        scoremark.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        scoremark.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let actionMove = SKAction.move(to: CGPoint(x: -obstacle.size.width/2, y: obstacle.frame.height / 2), duration: 4.0)
        let actionMoveDone = SKAction.removeFromParent()
        
        obstacle.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        let topMove = SKAction.move(to: CGPoint(x: -obstacle.size.width/2, y: size.height - (topPipe.frame.height / 2)), duration: 4.0)
        topPipe.run(SKAction.sequence([topMove, actionMoveDone]))
        
        let actionMove2 = SKAction.move(to: CGPoint(x: 0, y: randHeight + (player.frame.height * 2.5) / 2), duration: 4.0)
        
        scoremark.run(SKAction.sequence([actionMove2, actionMoveDone]))
    }
    
    func hitPipe(obstacle: SKSpriteNode) {
        print("Hit")
        died = true
        let delay = SKAction.wait(forDuration: 2)
        run(delay, completion: {
            self.removeAllChildren()
            self.removeAllActions()
            self.died = false
            self.gameStarted = false
            self.score = 0
            self.createScene()
        })
    }
    
    func passPipe(scoremark: SKSpriteNode) {
        score+=1
        scoreLabel.text = String(score)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var scoremark: SKPhysicsBody
        var obstacle: SKPhysicsBody
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 {
            obstacle = contact.bodyA
            hitPipe(obstacle: obstacle.node as! SKSpriteNode)
        } else if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1 {
            obstacle = contact.bodyB
            hitPipe(obstacle: obstacle.node as! SKSpriteNode)
        } else if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 4 {
            scoremark = contact.bodyB
            passPipe(scoremark: scoremark.node as! SKSpriteNode)
        } else if contact.bodyA.categoryBitMask == 4 && contact.bodyB.categoryBitMask == 2 {
            scoremark = contact.bodyA
            passPipe(scoremark: scoremark.node as! SKSpriteNode)
        }
        
        
    }
    
    
    
    
    
}
