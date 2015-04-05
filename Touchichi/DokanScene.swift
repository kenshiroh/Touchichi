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

class DokanScene: THScene, SKPhysicsContactDelegate {
    var catAppeared : Bool = false
    override init(size: CGSize) {
        super.init(size:size)
        preloadSounds([
            "emitFromDokan",
            "hamsterHitEachOther",
            "catAppear"
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        backgroundColor = SKColor.fromHexCode("#59004f")
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        let dokan = Dokan(img:"hamster/dokan",scale:2.5)
        dokan.position = CGPoint(x:dokan.leftEndX()-30,y:30)
        dokan.zRotation = radFromDegree(-45)
        dokan.addRectBackgroundPhysics()
        dokan.name = "dokan"
        addChild(dokan)

        self.addCommonHeader()
        self.makeWallsAllAround()
    }
    
    override func onTouchBegan() {
        self.accelerateAllHamsters()
    }
    
    func accelerateAllHamsters(){
        self.enumerateChildNodesWithName("movingHamster") {
            node,stop in
            node
            node.physicsBody?.applyImpulse(CGVectorMake(100.0, 100.0))
        }
    }
    
    override func didBeginContact(firstNode: SKNode, secondNode: SKNode) {
        // both are hamsters
        if(firstNode.physicsBody?.categoryBitMask == PhysicsCategory.moving){
            runAction(SKAction.playSound("hamsterHitEachOther"))
            let hamster1 = firstNode as hamsterDokan
            let hamster2 = secondNode as hamsterDokan
            hamster1.runHitFaceActionIfNormal()
            hamster2.runHitFaceActionIfNormal()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches,withEvent:event)
    }

    func catAppear(){
        let cat = THSpriteNode(
            img: "cat/cat",
            scale:3.0,
            zPosition: -100.0
            )
        cat.position = CGPoint(x:-1*cat.size.width,y:centerY())
        let dokan = self.childNodeWithName("dokan") as Dokan
        self.catAppeared = true
        cat.runAction(
            cat.switchTextureForeverAction(["cat/cat","cat/cat2"],interval:0.5)
        )
        cat.runActionInSequence([
            SKAction.playSound("catAppear"),
            SKAction.moveTo(CGPoint(x:centerX(),y:centerY()), duration:4.0),
            SKAction.runBlock(){
                dokan.disableTouch()
                cat.removeAllActions()
                cat.runActionInSequence([
                    SKAction.waitForDuration(2.0),
                    cat.changeTextureAction("cat/catScary"),
                    SKAction.playSound("catBecomeScary"),
                    SKAction.playSound("hamstersGoAway"),
                    SKAction.runBlock(){ self.hamstersGoAway() },
                    SKAction.waitForDuration(3.0),
                    self.changeSceneAction(DokanScene(size:self.size)),
                ])
            }
        ])
        addChild(cat)
    }
    
    func hamstersGoAway(){
        self.removeWallsAllAround()
        self.accelerateAllHamsters()
    }
}

class Dokan : THSpriteNode {
    override func onTouchBegan() {
        disableTouch()

        let parentScene : DokanScene = self.parent as DokanScene
        if parentScene.catAppeared { return }
        
        // 土管の発射後の収縮
        var sequence = [SKAction.playSound("emitFromDokan")]
        sequence.extend(SKAction.vibrateActionSequence())
        sequence.append(SKAction.runBlock(){ self.enableTouch() })
        runActionInSequence(sequence)
        
        // 発射されるハムスター
        let hamColor = hamsterTypeList[randBelow(4)]
        let hamster = hamsterDokan(
            img: "hamster/" + hamColor,
            name:"movingHamster",
            scale:1.4,
            zRotation:radFromDegree(-45.0),
            position:posByRatio(x: 0.24, y: 0.15)
        )
        hamster.addPhysics()
        parentScene.addChild(hamster)
        hamster.physicsBody?.applyImpulse(CGVectorMake(100.0, 100.0))
        
        if(parentScene.countChildrenWithName("movingHamster") > 5){
            parentScene.catAppear()
        }
        
    }
    
}

class hamsterDokan : THSpriteNode {
    var hitFaceNow : Bool = false
    
    func addPhysics(){
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2.0)
        self.physicsBody?.dynamic = true
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.categoryBitMask = PhysicsCategory.moving
        self.physicsBody?.collisionBitMask = PhysicsCategory.All
        self.physicsBody?.contactTestBitMask = PhysicsCategory.moving
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
}