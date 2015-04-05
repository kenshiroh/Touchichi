//
//  HideScene.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/23.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import SpriteKit

let hidingObjectConf = [
    [
        "image": "daikon/normalFace",
        "afterImage": "daikon/iyanFace",
        "positionRatio" : [0.5,0.35],
    ],
    [
        "image": "ninjin/plain",
        "afterImage": "",
        "positionRatio" : [0.5,0.35],
    ],
    [
        "image": "turnip/turnip",
        "afterImage": "turnip/turnipSmile",
        "positionRatio" : [0.5,0.35],
    ],
    [
        "image": "daikon/longFace",
        "afterImage": "",
        "positionRatio" : [0.5,0.35],
    ],
]

class HideScene: THScene {
    override init(size: CGSize) {
        super.init(size:size)
        preloadSounds([
            "pullInDirt",
            "goingOutOfDirt",
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        /* Setup your scene here */
        backgroundColor = SKColor.fromHexCode("#38f2f2")
        
        addCommonHeader()
        addDirt()
        addHidingObject()
    }
    
    func addDirt(){
        let dirt = HideDirt(
            img: "daikon/dirt",
            scale: 3.3,
            zPosition:10.0
        )
        dirt.position = CGPoint(x:centerX(),y:dirt.bottomEndY())
        self.addChild(dirt)
    }
    
    func addHidingObject(){
        let objConf = hidingObjectConf[randBelow(hidingObjectConf.count)]
        let imgPath = objConf["image"] as String
        let afterImage = objConf["afterImage"] as String
        let positionRatio = objConf["positionRatio"] as [CGFloat]
        let defPosition = posByRatio(x: positionRatio[0], y: positionRatio[1])
        let hideObj = HideObject(
            img:imgPath,
            position:defPosition,
            scale:4.0,
            name:"hidingObj"
        )
        hideObj.originalImage = imgPath
        hideObj.afterImage = afterImage == "" ? imgPath : afterImage
        addChild(hideObj)
    }
    
}

class HideDirt : THSpriteNode {
    override func onTouchBegan() {
        let parentScene = parent as THScene
        let hidingObj = parentScene.childNodeWithName("hidingObj")
        if( hidingObj != nil){
            hidingObj?.onTouchBegan()
        }
    }
}

class HideObject : THSpriteNode {
    var afterImage : String = ""
    var originalImage : String = ""
    var touchedCount : Int = 0
    
    override func onTouchBegan() {
        if self.isTouchDisabled() { return }
        touchedCount += 1
        disableTouch()
        if touchedCount == 3 {
            runAction(SKAction.playSound("goingOutOfDirt"))
            runActionInSequence([
                self.changeTextureAction(self.originalImage),
                SKAction.moveBy(CGVectorMake(0.0, 200.0), duration: 0.3),
                self.changeTextureAction(self.afterImage),
                SKAction.runBlock(){ self.enableTouch() },
            ])
        
        }
        else if touchedCount == 4 {
            runActionInSequence([
                SKAction.scaleTo(0.01, duration: 0.5),
                SKAction.runBlock(){
                    self.enableTouch()
                    let parentScene = self.parent as HideScene
                    self.removeFromParent()
                    println("hideobj removed!!")
                    parentScene.addHidingObject()
                }
            ])
        }
        else{
            runAction(SKAction.playSound("pullInDirt"))
            runActionInSequence(SKAction.vibrateActionSequence())
            runActionInSequence([
                SKAction.moveBy(CGVectorMake(0.0, 10.0), duration: 1.0),
                SKAction.runBlock(){ self.enableTouch() }
            ])
        }
    }
}