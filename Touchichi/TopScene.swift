//
//  TopScene.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/09.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import SpriteKit

class TopScene: SKScene {
    override init(size: CGSize){
        super.init(size:size)
        /* Setup your scene here */
        backgroundColor = SKColor.fromHexCode("#00a900")
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        
        let bgPicture = THSpriteNode(img: "page/topbg")
        bgPicture.scaleBy(4.0)
        bgPicture.position = CGPoint(x: size.width/2, y: size.height/2)
        
        let scale : CGFloat = 1.08
        println(bgPicture.size)
        println(frame.size)
        println(self.view?.frame.size)
        self.addChild(bgPicture)
        
        let bgHiyoko = BgHiyokoAtMenu(img: "page/buttontop")
        bgHiyoko.scaleBy(4.0)
        bgHiyoko.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(bgHiyoko)
    }
    required init(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BgHiyokoAtMenu : THSpriteNode {
    override func onTouchBegan() {
        let scene = self.parent as SKScene
        scene.changeScene(MenuScene(size: scene.size))
    }
}
