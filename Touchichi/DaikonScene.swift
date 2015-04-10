//
//  DaikonScene.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/29.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import SpriteKit

class DaikonScene: THScene {
    override init(size: CGSize) {
        super.init(size:size)
        preloadSounds([
            "daikonTouched",
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initialize() {
        /* Setup your scene here */
        backgroundColor = SKColor.fromHexCode("#008080")
        
        addCommonHeader()
        addDaikon(15)
    }

    func addDaikon(addNum:Int){
        for i in 1...addNum {
            let xRatio = CGFloat(randBelow(100))/100.0
            let yRatio = CGFloat(randBelow(100))/100.0
            let daikon = DaikonSprite(
                img:"daikon/walk",
                name:"daikon",
                scale:2.0,
                position:posByRatio(x:xRatio,y:yRatio)
            )
            daikon.startRandomWalk()
            addChild(daikon)
        }
    }

    override func penetrateTouch() -> Bool{
        return true
    }
}

class DaikonSprite : THSpriteNode {
    func startRandomWalk(){
        runAction(self.switchTextureForeverAction(["daikon/walk","daikon/walk2"],interval:0.3))
        runActionInSequenceForever([
            SKAction.runBlock(){
                if(self.isOutOfScreen()){
                    println("daiko out of screen!! adding new one")
                    let parentScene = self.parent as DaikonScene
                    self.removeAllActions()
                    self.removeFromParent()
                    parentScene.addDaikon(1)
                    return
                }
                let rangeX = CGFloat(randBetween(-40,40))
                let rangeY = CGFloat(randBetween(-40,40))
                if rangeX < 0 {
                    self.xScale = abs(self.xScale)
                }else{
                    self.xScale = -abs(self.xScale)
                }
                let waitDuration = NSTimeInterval(randBelow(100)) / 30.0
                self.runAction(SKAction.moveBy(CGVectorMake(rangeX,rangeY),duration:waitDuration))
            },
            SKAction.waitForDuration(0.5),
        ])
    }
    
    override func onTouchBegan(){
        disableTouch()
        let parentScene = self.parent as THScene
        parentScene.runAction(SKAction.playSound("daikonTouched"))
        self.removeAllActions()
        runActionInSequence([
            changeTextureAction("daikon/non"),
            SKAction.waitForDuration(2.0),
            SKAction.runBlock(){
                self.startRandomWalk()
                self.enableTouch()
            }
        ])
    }
}