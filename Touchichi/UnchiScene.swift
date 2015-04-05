//
//  UnchiScene.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/21.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import SpriteKit

class UnchiScene: THScene, SKPhysicsContactDelegate {
    override init(size: CGSize) {
        super.init(size:size)
        preloadSounds([
            "unchiEmit",
            "unchiHitHiyoko",
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        /* Setup your scene here */
        backgroundColor = SKColor.greenColor()

        physicsWorld.gravity = CGVectorMake(0, -1.0)
        physicsWorld.contactDelegate = self
        
        addCommonHeader()
        
        let cow = CowSprite(
            img: "unchi/cow",
            name: "cow",
            scale:2.2
        )
        cow.position = CGPoint(x:cow.leftEndX(),y:cow.topEndY())
        cow.runAction(cow.switchTextureForeverAction(["unchi/cow","unchi/cow2"], interval: 0.70))
        addChild(cow)
        
        makeBirdPeriodically()
    }
    
    func makeBirdPeriodically(){
        runAction(SKAction.repeatActionForeverInSequence([
            SKAction.runBlock(){
                let bird = UnchiBird(
                    img:"unchi/birdWalk",
                    name:"bird",
                    scale:1.4
                )
                bird.addPhysics()
                bird.position = CGPoint(x:bird.size.width/2.0,y:140)
                bird.runActionInSequence([
                    SKAction.moveBy(CGVectorMake(SCREEN_SIZE.width, 0.0), duration: 3.0),
                    SKAction.runBlock(){ bird.removeFromParent() },
                    ])
                bird.runAction(bird.switchTextureForeverAction(["unchi/birdWalk","unchi/birdWalk2"], interval: 0.3))
                self.addChild(bird)
            },
            SKAction.waitForDuration(1.5)
            ]),withKey:"makeBirdAction")
    }
    
    func removeAllUnchiExcept(remainUnchi:UnchiSprite){
        enumerateChildNodesWithName("unchi", usingBlock: {
            (node,stop) in
            let unchi = node as UnchiSprite
            if unchi != remainUnchi { unchi.removeFromParent() }
        })
    }
    
    override func didBeginContact(firstNode: SKNode, secondNode: SKNode) {
        let firstSprite = firstNode as THSpriteNode
        let secondSprite = secondNode as THSpriteNode
        if(firstSprite.name == "bird"){
            let birdSprite = firstSprite as UnchiBird
            birdSprite.hitUnchi(secondNode as UnchiSprite)
        }else if(secondSprite.name == "bird"){
            let birdSprite = secondSprite as UnchiBird
            birdSprite.hitUnchi(firstNode as UnchiSprite)
        }
        
    }
}

class UnchiBird : THSpriteNode {
    func hitUnchi(unchi:UnchiSprite){
        let parentScene = self.parent as UnchiScene
        
        runAction(SKAction.playSound("unchiHitHiyoko"))
        
        parentScene.removeActionForKey("makeBirdAction")
        
        let cow = parentScene.childNodeWithName("cow") as THSpriteNode
        cow.disableTouch()
        
        parentScene.removeAllUnchiExcept(unchi)
        parentScene.enumerateChildNodesWithName("bird", usingBlock: {
            (bird,stop) in
            bird.removeAllActions()
        })
        
        unchi.physicsBody = nil
        unchi.position = CGPoint(x:unchi.position.x,y:unchi.position.y - 5)
        
        self.texture = textureFromPath("unchi/birdFail")
        unchi.texture = textureFromPath("unchi/unchiSmile")
        parentScene.removeAllUnchiExcept(unchi)
        parentScene.enumerateChildNodesWithName("bird", usingBlock: {
            (node,stop) in
            let bird = node as THSpriteNode
            bird.runActionInSequence([
                SKAction.waitForDuration(1.0),
                bird.changeTextureAction("unchi/birdRun"),
                SKAction.moveBy(CGVectorMake(SCREEN_SIZE.width, 0.0), duration: 1.0),
                bird.removeFromParentAction(),
            ])
        })
        unchi.runActionInSequence([
            SKAction.waitForDuration(1.0),
            SKAction.moveBy(CGVectorMake(SCREEN_SIZE.width, 0.0), duration: 1.0),
            self.removeFromParentAction(),
            SKAction.runBlock(){
                parentScene.makeBirdPeriodically()
                cow.enableTouch()
            }])
    }
    
    func addPhysics(){
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2.0)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.moving
    }
}

class CowSprite : THSpriteNode {
    override func onTouchBegan() {
        runAction(SKAction.playSound("unchiEmit"))
        let unchi = UnchiSprite(
            img:"unchi/unchi",
            name:"unchi",
            position:posByRatio(x: 0.42, y: 0.78),
            zPosition: 10.0
        )
        unchi.addPhysics()
        self.parent?.addChild(unchi)
        unchi.applyImpulse(dx:3.0,dy:0.0)
        unchi.applyAngularImpulse(-0.005)
    }
}

class UnchiSprite : THSpriteNode {
    func addPhysics(){
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2.0)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.moving
        self.physicsBody?.contactTestBitMask = PhysicsCategory.moving
    }
}