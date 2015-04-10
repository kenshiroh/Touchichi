//
//  TopScene.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/09.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import SpriteKit

class TopScene: THScene {
    override func initialize() {
        /* Setup your scene here */
        backgroundColor = SKColor.fromHexCode("#00a900")
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")

        playBGM("sounds/BGM1.mp3")

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

}

class BgHiyokoAtMenu : THSpriteNode {
    override func onTouchBegan() {
        let scene = self.parent as THScene
        scene.changeScene(MenuScene(size: scene.size))
    }
}
