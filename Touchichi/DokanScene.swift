//
//  DokanScene.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/14.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import SpriteKit

let hamsterTypeList = [
    "blue",
    "green",
    "beige",
    "pink",
]

class DokanScene: SKScene, SKPhysicsContactDelegate {
    var movingHamsters : [THSpriteNode] = []
    override init(size: CGSize) {
        super.init(size:size)
        backgroundColor = SKColor.fromHexCode("#59004f")
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        addCommonHeader()
        makeWallsAllAround()
        
        let dokan = Dokan(img:"hamster/dokan",scale:2.5)
        dokan.position = CGPoint(x:dokan.leftEndX()-30,y:30)
        dokan.zRotation = radFromDegree(-45)
        dokan.addRectBackgroundPhysics()
        addChild(dokan)
        
    }
        
    override func onTouchBegan() {
        self.enumerateChildNodesWithName("movingHamster") {
            node,stop in
            node
            node.physicsBody?.applyImpulse(CGVectorMake(100.0, 100.0))
        }
    }
    
    override func didBeginContact(firstBody: SKPhysicsBody, secondBody: SKPhysicsBody) {
        // both are hamster
        if(firstBody.categoryBitMask == PhysicsCategory.moving){
            let hamster1 = firstBody.node as hamsterDokan
            let hamster2 = secondBody.node as hamsterDokan
            hamster1.runHitFaceActionIfNormal()
            hamster2.runHitFaceActionIfNormal()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches,withEvent:event)
        
    }

    required init(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Dokan : THSpriteNode {
    override func onTouchBegan() {
        if touchDisabled { return }
        touchDisabled = true
        
        // 土管の発射後の収縮
        runAction(SKAction.sequence([
            SKAction.scaleBy(1.3, duration: 0.13),
            SKAction.scaleBy(0.8, duration: 0.13),
            SKAction.scaleBy(1.15, duration: 0.13),
            SKAction.scaleBy(0.9, duration: 0.13),
            SKAction.scaleBy(1.05, duration: 0.13),
            SKAction.scaleBy(0.89, duration: 0.13),
            SKAction.runBlock(){ self.touchDisabled = false }
            ]))
        
        // 発射されるハムスター
        let hamColor = hamsterTypeList[randBelow(4)]
        let hamster = hamsterDokan(img: "hamster/" + hamColor,name:hamColor)
        let parentScene : SKScene = self.parent as SKScene
        parentScene.addChild(hamster)
        hamster.name = "movingHamster"
        hamster.zRotation = radFromDegree(-45.0)
        hamster.position = posByRatio(x: 0.24, y: 0.15)
        hamster.physicsBody = SKPhysicsBody(circleOfRadius: hamster.size.width/2.0)
        hamster.physicsBody?.dynamic = true
        hamster.physicsBody?.restitution = 1.0
        hamster.physicsBody?.categoryBitMask = PhysicsCategory.moving
        hamster.physicsBody?.collisionBitMask = PhysicsCategory.All
        hamster.physicsBody?.contactTestBitMask = PhysicsCategory.moving
        hamster.physicsBody?.applyImpulse(CGVectorMake(100.0, 100.0))
    }
}

class hamsterDokan : THSpriteNode {
    var hitFaceNow : Bool = false
    
    override init(img: String,name:String){
        super.init(img:img,name:name)
        self.scaleBy(1.4)
    }
    
    func runHitFaceActionIfNormal(){
        if hitFaceNow { return }
        runAction(SKAction.sequence([
            self.changeTextureAction(self.path + "Hit"),
            SKAction.runBlock(){ self.hitFaceNow = true },
            SKAction.waitForDuration(0.5),
            self.changeTextureAction(self.path),
            SKAction.runBlock(){ self.hitFaceNow = false }
            ]))
    }
    
    override func onTouchBegan() {
        self.physicsBody?.applyImpulse(CGVectorMake(100.0, 100.0))
    }
    
    required init(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}