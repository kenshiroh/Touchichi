//
//  TemplateScene.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/14.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import SpriteKit

class TemplateScene: SKScene {
    override init(size: CGSize){
        super.init(size:size)
        /* Setup your scene here */
        backgroundColor = SKColor.fromHexCode("#00a900")
    }
    required init(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SampleSprite : THSpriteNode {
    override init(img: String){
        super.init(img:img)
    }

    required init(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}