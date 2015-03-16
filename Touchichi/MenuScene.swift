//
//  MenuScene.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/09.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import SpriteKit

let iconSceneDic = [
    [
        "image": "page/buttonDaikonTouch",
        "scene": TopScene(size:SCREEN_SIZE),
        "position": [0.25,0.68],
    ],
    [
        "image": "page/buttonHamsterPyon",
        "scene": TopScene(size:SCREEN_SIZE),
        "position": [0.25,0.32],
    ],
    [
        "image": "page/buttonUnchi",
        "scene": TopScene(size:SCREEN_SIZE),
        "position": [0.5,0.5],
    ],
    [
        "image": "page/buttonHide",
        "scene": TopScene(size:SCREEN_SIZE),
        "position": [0.75,0.32],
    ],
    [
        "image": "page/buttonPig",
        "scene": TopScene(size:SCREEN_SIZE),
        "position": [0.75,0.68],
    ],
]

class MenuScene: SKScene {
    override init(size: CGSize){
        super.init(size:size)
        /* Setup your scene here */
        backgroundColor = SKColor.fromHexCode("#00a900")
        
        let iconbg = THSpriteNode(img:"page/iconbg")
        iconbg.position = CGPoint(x: size.width/2, y:size.height/2)
        addChild(iconbg)
        
        [0.2,0.4,0.6,0.8].each{(range) in
            let hiyoko = bgHiyoko(img:"hiyoko/yellowFront")
            hiyoko.position = posByRatio(x:CGFloat(range),y:0.9)
            hiyoko.defaultPosition = hiyoko.position
            hiyoko.jumpingAction()
            self.addChild(hiyoko)
        }
        
        iconSceneDic.each{(config) in
            let icon = iconImage(img: config["image"] as String,scene:config["scene"] as SKScene,pos:config["position"] as [CGFloat])
            self.addChild(icon)
        }
        let hiyoko = bgHiyoko(img:"hiyoko/yellowFront")
     }
    required init(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class iconImage : THSpriteNode {
    var transitionScene : SKScene
    init(img:String,scene:SKScene,pos:[CGFloat]){
        transitionScene = scene
        let tiltAngle : CGFloat = 15.0
        super.init(img:img)
        self.position = posByRatio(x:pos[0], y:pos[1])
        self.scaleBy(1.7)
        self.zRotation = radFromDegree(-1.0*tiltAngle)
        self.runAction(SKAction.repeatActionForeverInSequence([
            SKAction.rotateByDegree(2.0 * tiltAngle, duration: 0.8),
            SKAction.rotateByDegree(-2.0 * tiltAngle, duration: 0.8),
            ]))
    }
    
    override func onTouchBegan() {
        let parentScene = self.parent as SKScene
        parentScene.changeScene(transitionScene)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class bgHiyoko : THSpriteNode {
    var defaultPosition : CGPoint = ZERO_POINT
    
    override init(img: String){
        super.init(img:img)
    }
    
    override func onTouchBegan() {
        if touchDisabled { return }
        self.removeAllActions()
        self.position = self.defaultPosition
        self.yScale *= -1
        let changeToGuruguru = self.changeTextureAction("hiyoko/yellowGuruguru")
        let changeToGuruguru2 = self.changeTextureAction("hiyoko/yellowGuruguru2")
        
        self.runAction(SKAction.repeatActionForeverInSequence([
            changeToGuruguru,
            SKAction.waitForDuration(0.3),
            changeToGuruguru2,
            SKAction.waitForDuration(0.3),
        ]))
        self.touchDisabled = true
    }
    
    func flipSide() -> SKAction {
        return SKAction.sequence([
            SKAction.runBlock(){
                self.xScale *= -1
            },
            SKAction.waitForDuration(0.5)
            ])
    }
    
    func jumpingAction() {
        let jumpAction = SKAction.sequence([
            SKAction.moveBy(CGVectorMake(0,20),duration:0.20),
            SKAction.moveBy(CGVectorMake(0,-20),duration:0.20),
            SKAction.waitForDuration(Double(randBelow(13))/10),
        ])
        
        self.runAction(SKAction.repeatActionForever(self.flipSide()),withKey:"flipSide")
        
        self.runAction( SKAction.repeatActionForever(SKAction.group([
            jumpAction
            ])),withKey:"jumpAction")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}