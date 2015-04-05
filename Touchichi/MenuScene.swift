//
//  MenuScene.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/09.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import SpriteKit

let iconSceneConf = [
    [
        "image": "page/buttonDaikonTouch",
        "scene": DaikonScene(size:SCREEN_SIZE),
        "position": [0.25,0.68],
    ],
    [
        "image": "page/buttonHamsterPyon",
        "scene": DokanScene(size:SCREEN_SIZE),
        "position": [0.25,0.32],
    ],
    [
        "image": "page/buttonUnchi",
        "scene": UnchiScene(size:SCREEN_SIZE),
        "position": [0.5,0.5],
    ],
    [
        "image": "page/buttonHide",
        "scene": HideScene(size:SCREEN_SIZE),
        "position": [0.75,0.32],
    ],
    [
        "image": "page/buttonPig",
        "scene": PigScene(size:SCREEN_SIZE),
        "position": [0.75,0.68],
    ],
]

class MenuScene: THScene {
    var currentPage : Int = 1
    override init(size: CGSize){
        super.init(size:size)
        /* Setup your scene here */
        backgroundColor = SKColor.fromHexCode("#00a900")
        
        loadPage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        
    }
    
    func loadPage(){
        self.removeAllChildren()
        let iconbg = THSpriteNode(img:"page/iconbg",scale:0.95)
        iconbg.position = CGPoint(x: size.width/2, y:size.height/2)
        addChild(iconbg)

        println(currentPage)
        if currentPage == 1 {
            loadIconListPage(1)
        }
        
        if currentPage > 1 {
            loadTBDPage()
        }
    }
    
    func loadTBDPage(){
        let leftArrow = leftMenuArrowIcon(
            img: "page/arrow",
            scale: 1.7
        )
        leftArrow.position = CGPoint(x: leftArrow.leftEndX()+5, y: centerY())
        leftArrow.runAction(leftArrow.tiltForeverAction(15.0))
        addChild(leftArrow)

        let tba = THSpriteNode(img:"page/tba",scale:3.0,position:CGPointMake(centerX(),centerY()))
        addChild(tba)
}
    
    func loadIconListPage(pageNum:Int){
        
        [0.2,0.4,0.6,0.8].each{(range) in
            let imageName = "hiyoko/yellowFront"
            let hiyoko : bgHiyoko = bgHiyoko(img:imageName)
            hiyoko.position = posByRatio(x:CGFloat(range),y:0.9)
            hiyoko.defaultPosition = hiyoko.position
            hiyoko.jumpingAction()
            self.addChild(hiyoko)
        }
        
        iconSceneConf.each{(config) in
            let icon = iconImage(img: config["image"] as String,scene:config["scene"] as THScene,pos:config["position"] as [CGFloat])
            self.addChild(icon)
        }
        
        let rightArrow = rightMenuArrowIcon(
            img: "page/arrow",
            scale: 1.7
        )
        rightArrow.xScale *= -1
        rightArrow.position = CGPoint(x: rightArrow.rightEndX(), y: centerY())
        rightArrow.runAction(rightArrow.tiltForeverAction(15.0))
        addChild(rightArrow)
    }
}

class rightMenuArrowIcon : THSpriteNode {
    override func onTouchBegan() {
        let parentScene = self.parent as MenuScene
        parentScene.currentPage += 1
        parentScene.loadPage()
    }
}

class leftMenuArrowIcon : THSpriteNode {
    override func onTouchBegan() {
        let parentScene = self.parent as MenuScene
        parentScene.currentPage -= 1
        parentScene.loadPage()
    }
}

class iconImage : THSpriteNode {
    var transitionScene : THScene
    init(img:String,scene:THScene,pos:[CGFloat]){
        transitionScene = scene
        super.init(img:img)
        self.position = posByRatio(x:pos[0], y:pos[1])
        self.scaleBy(1.7)
        self.runAction(self.tiltForeverAction(15.0))
    }
    
    override func onTouchBegan() {
        let parentScene = self.parent as THScene
        parentScene.changeScene(transitionScene)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class bgHiyoko : THSpriteNode {
    var defaultPosition : CGPoint = ZERO_POINT
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
}