//
//  TopScene.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/09.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import SpriteKit

class TopScene: THScene {
    var detailButton = UIButton()
    override func initialize() {
        /* Setup your scene here */
        backgroundColor = SKColor.fromHexCode("#00a900")

        playBGM("sounds/BGM1.mp3")
        addAdView()
        if detailButton.titleLabel?.text == nil { initDetailButton() }
        addDetailButton()

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
    
    func initDetailButton(){
        detailButton.frame = CGRectMake(0,0,150,35)
        detailButton.backgroundColor = UIColor.blueColor()
        detailButton.layer.masksToBounds = true
        detailButton.setTitle("ほごしゃのかたへ", forState: UIControlState.Normal)
        detailButton.titleLabel?.adjustsFontSizeToFitWidth = true
        detailButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        detailButton.layer.cornerRadius = 5.0
        detailButton.layer.borderColor = UIColor.whiteColor().CGColor
        detailButton.layer.borderWidth = 1.0
        detailButton.layer.position = CGPoint(x: IPHONE_SIZE.width/2.0, y:IPHONE_SIZE.height*4.0/5.0)
        detailButton.addTarget(self, action: Selector("detailButtonTouched"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func addDetailButton(){
        self.view?.addSubview(detailButton)
    }
    
    func detailButtonTouched(){
        controller.performSegueWithIdentifier("toExplanation", sender: nil)
    }
    
    override func destruct() {
        detailButton.removeFromSuperview()
    }
}

class BgHiyokoAtMenu : THSpriteNode {
    override func onTouchBegan() {
        let scene = self.parent as THScene
        scene.changeScene(MenuScene(size: scene.size))
    }
}
