//
//  PigScene.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/25.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import SpriteKit

let pigPatternConf = [
    [
        "image":"pig/butt",
        "lookBackImage": "pig/lookBack",
        "leftPosition": [0.20,0.50],
        "xRatio": 0.20,
    ],
    [
        "image":"dharma/dharma",
        "lookBackImage": "dharma/dharma2",
        "xRatio": 0.20,
    ],
    [
        "image":"thief/thief",
        "lookBackImage": "thief/thief2",
        "xRatio": 0.15,
    ],
]

class PigScene: THScene,SKPhysicsContactDelegate {
    override init(size: CGSize) {
        super.init(size:size)
        preloadSounds([
            "pigApproach",
            "pigHit",
            "pigGoAway",
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initialize() {
        /* Setup your scene here */
        enableTouch()

        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        backgroundColor = SKColor.fromHexCode("#4acfdd")
        addCommonHeader()
        addPigObjects()
    }
    
    override func onTouchScene(node: SKNode) {
        disableTouch()
        runAction(SKAction.playSound("pigApproach"))
        let leftPig = childNodeWithName("leftPig") as! PigLeftSprite
        let rightPig = childNodeWithName("rightPig") as! PigRightSprite
        leftPig.startMoving()
        rightPig.startMoving()
    }
    
    override func didBeginContact(firstNode: SKNode, secondNode: SKNode, contactPoint: CGPoint) {
        var leftPig : PigLeftSprite
        var rightPig : PigRightSprite
        runAction(SKAction.playSound("pigHit"))
        if(firstNode.name == "leftPig"){
            leftPig = firstNode as! PigLeftSprite
            rightPig = secondNode as! PigRightSprite
        }else{
            leftPig = secondNode as! PigLeftSprite
            rightPig = firstNode as! PigRightSprite
        }
        leftPig.beginContact()
        rightPig.beginContact()
    }
    
    func addPigObjects(){
        let objConf = pigPatternConf[randBelow(pigPatternConf.count)]
        let image = objConf["image"] as! String
        let lookBackImage = objConf["lookBackImage"] as! String
        let xRatio = objConf["xRatio"] as! CGFloat
        let defScale : CGFloat = 2.3
        let leftPig = PigLeftSprite(
            img:image,
            position:posByRatio(x: xRatio, y: 0.5),
            scale:defScale,
            name:"leftPig"
        )
        leftPig.addPhysics()
        let rightPig = PigRightSprite(
            img:image,
            position:posByRatio(x: 1.0-xRatio, y: 0.5),
            scale:defScale,
            name:"rightPig"
        )
        leftPig.lookBackImage = lookBackImage
        rightPig.addPhysics()
        rightPig.xScale *= -1
        addChildren([leftPig,rightPig])
    }
}

class PigLeftSprite : THSpriteNode {
    var lookBackImage : String = ""
    
    func addPhysics(){
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2.0)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.moving
        self.physicsBody?.contactTestBitMask = PhysicsCategory.moving
        self.physicsBody?.collisionBitMask = PhysicsCategory.All
    }
    
    func beginContact(){
        let parentScene = self.parent as! THScene
        self.physicsBody = nil
        self.removeAllActions()
        self.runActionInSequence([
            SKAction.waitForDuration(3.0),
            self.changeTextureAction(lookBackImage,scaleBy:1.7),
            SKAction.waitForDuration(2.0),
            parentScene.changeSceneAction(PigScene(size:SCREEN_SIZE))
        ])
    }

    func startMoving(){
        runAction(repeatSwitchingXScaleAction())
        runAction(SKAction.moveBy(CGVectorMake(SCREEN_SIZE.width, 0.0), duration: 10.0))
    }
}

class PigRightSprite : THSpriteNode {
    func addPhysics(){
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2.0)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.moving
    }

    func beginContact(){
        self.physicsBody = nil
        self.removeAllActions()
        self.runActionInSequence([
            SKAction.waitForDuration(1.0),
            SKAction.runBlock(){
                self.runAction(SKAction.playSound("pigGoAway"))
                let angle : CGFloat = -360.0*10.0
                self.runAction(SKAction.rotateByAngle(radFromDegree(angle), duration: 3.0))
                self.runActionInSequence([
                    SKAction.moveBy(CGVectorMake(SCREEN_SIZE.width, SCREEN_SIZE.height), duration: 3.0),
                    self.removeFromParentAction()
                ])
            }
        ])
    }

    func startMoving(){
        runAction(repeatSwitchingXScaleAction())
        runAction(SKAction.moveBy(CGVectorMake(-SCREEN_SIZE.width, 0.0), duration: 10.0))
    }
}