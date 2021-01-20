//
//  GameScene.swift
//  MyFlappyBird
//
//  Created by nju on 2021/1/13.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // physicalworld
    let birdCategory: UInt32 = 0x1 << 0
    let pipeCategory: UInt32 = 0x1 << 1
    let floorCategory: UInt32 = 0x1 << 2
    
    // game status
    enum GameStatus {
      case prepare
      case running
      case over
    }
    var gamestatus : GameStatus = .prepare
    
    func GameParpare() {
        gamestatus = .prepare
        removeAllPipesNode()
        gameoverlable.removeFromParent()
        meters = 0
        bird.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        bird.physicsBody?.isDynamic = false
        birdStartFly()
    }
    
    func GameStart() {
        gamestatus = .running
        bird.physicsBody?.isDynamic = true
        startCreateRandomPipesAction()
    }
    
    func GameOver() {
        gamestatus = .over
        birdstopFly()
        stopCreateRandomPipesAction()
        isUserInteractionEnabled = false
        addChild(gameoverlable)
        gameoverlable.position = CGPoint(x: self.size.width*0.5, y: self.size.height)
        gameoverlable.run(SKAction.move(by: CGVector(dx: 0, dy: -self.size.height*0.5), duration: 0.5), completion: {
            self.isUserInteractionEnabled = true
        })
    }
    
    // floor
    var floor1: SKSpriteNode!
    var floor2: SKSpriteNode!
    
    // bird
    var bird: SKSpriteNode!
    
    // score
    var meters = 0{
        didSet {
            metersLabel.text = "meters:\(meters)"
        }
    }
    
    func birdStartFly() {
        let flyAction = SKAction.animate(
            with:
                [SKTexture(imageNamed: "player1"),
                 SKTexture(imageNamed: "player2"),
                 SKTexture(imageNamed: "player3"),
                 SKTexture(imageNamed: "player2")],
            timePerFrame:
                0.15
        )
        bird.run(SKAction.repeatForever(flyAction), withKey: "fly")
    }
    
    func birdstopFly() {
        bird.removeAction(forKey: "fly")
    }
    
    lazy var gameoverlable : SKLabelNode = {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Game Over"
        return label
    }()
    lazy var metersLabel: SKLabelNode = {
        let label = SKLabelNode(text: "meters:0")
        label.verticalAlignmentMode = .top
        label.horizontalAlignmentMode = .center
        return label
    }()
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        // Set background
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        // Set physicalworld
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        
        // Set floors
        // Set floor1
        floor1 = SKSpriteNode(imageNamed: "floor")
        floor1.anchorPoint = CGPoint(x: 0, y: 0)
        floor1.position = CGPoint(x: 0, y: 0)
        floor1.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: floor1.size.width, height: floor1.size.height))
        floor1.physicsBody?.categoryBitMask = floorCategory
        addChild(floor1)
        // Set floor2
        floor2 = SKSpriteNode(imageNamed: "floor")
        floor2.anchorPoint = CGPoint(x: 0, y: 0)
        floor2.position = CGPoint(x: floor1.size.width, y: 0)
        floor2.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: floor2.size.width, height: floor2.size.height))
        floor2.physicsBody?.categoryBitMask = floorCategory
        addChild(floor2)
        
        // Set bird
        bird = SKSpriteNode(imageNamed: "player1")
        bird.physicsBody = SKPhysicsBody(texture: bird.texture!, size: bird.size)
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.contactTestBitMask = floorCategory | pipeCategory
        addChild(bird)
        
        // Set Score
        metersLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height)
        metersLabel.zPosition = 100
        addChild(metersLabel)
        
        GameParpare()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if gamestatus == .running{
            meters += 1
        }
        if gamestatus != .over{
            movescene()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gamestatus {
        case .prepare:
            GameStart()
        case .running:
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
        default:
            GameParpare()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gamestatus != .running{
            return
        }
        else {
            var bodyA : SKPhysicsBody
            var bodyB : SKPhysicsBody
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                bodyA = contact.bodyA
                bodyB = contact.bodyB
            }
            else {
                bodyA = contact.bodyB
                bodyB = contact.bodyA
            }
            if(bodyA.categoryBitMask == birdCategory && bodyB.categoryBitMask == pipeCategory) ||
                (bodyA.categoryBitMask == birdCategory && bodyB.categoryBitMask == floorCategory) {
                GameOver()
            }
        }
    }
    
    func movescene() {
        // floor
        floor1.position = CGPoint(x: floor1.position.x-1, y: floor1.position.y)
        floor2.position = CGPoint(x: floor2.position.x-1, y: floor2.position.y)
        if floor1.position.x < -floor1.size.width {
            floor1.position = CGPoint(x: floor2.position.x+floor2.size.width, y: floor1.position.y)
        }
        if floor2.position.x < -floor2.size.width {
            floor2.position = CGPoint(x: floor1.position.x+floor1.size.width, y: floor2.position.y)
        }
        
        // pipes
        for pipeNode in self.children where pipeNode.name == "pipe" {
            if let pipeSprite = pipeNode as? SKSpriteNode {
                pipeSprite.position = CGPoint(x: pipeSprite.position.x-1, y: pipeSprite.position.y)
                if pipeSprite.position.x < -pipeSprite.size.width*0.5 {
                    pipeSprite.removeFromParent()
                }
            }
        }
    }
    
    func addPipes(topSize: CGSize, bottomsize: CGSize) {
        //Create topPipe
        let topTexture = SKTexture(imageNamed: "topPipe")
        let topPipe = SKSpriteNode(texture: topTexture, size: topSize)
        topPipe.name = "pipe"
        topPipe.position = CGPoint(x: self.size.width+topPipe.size.width*0.5, y: self.size.height-topPipe.size.height*0.5)
        topPipe.physicsBody = SKPhysicsBody(texture: topTexture, size: topSize)
        topPipe.physicsBody?.isDynamic = false
        topPipe.physicsBody?.categoryBitMask = pipeCategory
        
        //Create bottomPipe
        let bottomTexture = SKTexture(imageNamed: "bottomPipe")
        let bottomPipe = SKSpriteNode(texture: bottomTexture, size: bottomsize)
        bottomPipe.name = "pipe"
        bottomPipe.position = CGPoint(x: self.size.width+bottomPipe.size.width*0.5, y: self.floor1.size.height+bottomPipe.size.height*0.5)
        bottomPipe.physicsBody = SKPhysicsBody(texture: bottomTexture, size: bottomsize)
        bottomPipe.physicsBody?.isDynamic = false
        bottomPipe.physicsBody?.categoryBitMask = pipeCategory
        
        addChild(topPipe)
        addChild(bottomPipe)
    }
    
    func createRandomPipes() {
        //print("create two random pipes")
        let height = self.size.height-self.floor1.size.height
        let pipeGap = CGFloat(arc4random_uniform(UInt32(bird.size.height)))+bird.size.height*2.5
        let pipeWidth = CGFloat(60.0)
        let topPipeHeight = CGFloat(arc4random_uniform(UInt32(height - pipeGap)))
        let bottomPipeHeight = height - pipeGap - topPipeHeight
        addPipes(topSize: CGSize(width: pipeWidth, height: topPipeHeight), bottomsize: CGSize(width: pipeWidth, height: bottomPipeHeight))
    }
    
    func startCreateRandomPipesAction() {
        //print("Start Create Random Pipes")
        let waitAct = SKAction.wait(forDuration: 3.5, withRange: 1.0)
        let generatePipeAct = SKAction.run {
            self.createRandomPipes()
        }
        run(SKAction.repeatForever(SKAction.sequence([waitAct, generatePipeAct])), withKey: "createPipe")
    }
    
    func stopCreateRandomPipesAction() {
        self.removeAction(forKey: "createPipe")
    }
    
    func removeAllPipesNode() {
        for pipe in self.children where pipe.name == "pipe" {
            pipe.removeFromParent()
        }
    }
}
