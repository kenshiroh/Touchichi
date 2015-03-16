//
//  SpriteKitExtensions.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/07.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import Foundation
import SpriteKit

extension Array {
    func each (blk: T -> ()) {
        for object in self {
            blk(object)
        }
    }
}

class THSpriteNode : SKSpriteNode {
    var touchDisabled : Bool = false
    var path : String = ""
    
    init(size:CGSize){
        super.init(texture:nil,color:UIColor.clearColor(),size:size)
    }

    init(img: String){
        let fullStr = "images/" + img
        let texture = SKTexture(imageNamed: fullStr)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        init_common(img)
        self.name = fullStr
        printInfo()
    }
    
    init(img: String, name: String){
        super.init(texture: textureFromPath(img), color: UIColor.clearColor(), size: textureFromPath(img).size())
        init_common(img)
        self.name = name
        printInfo()
    }
    
    init(img: String, scale: CGFloat){
        super.init(texture: textureFromPath(img), color: UIColor.clearColor(), size: textureFromPath(img).size())
        init_common(img)
        self.scaleBy(scale)
    }
    
    private func init_common(path:String){
        let scale : CGFloat = 320 / 400 / 4
        self.xScale = scale
        self.yScale = scale
        self.path = path
    }
    
    func changeTextureAction(imageNamed: String) -> SKAction {
        return SKAction.runBlock(){
            self.texture = textureFromPath(imageNamed)
        }
    }
    
    func scaleBy(scale: CGFloat){
        self.xScale *= scale
        self.yScale *= scale
        printInfo()
    }
    
    func topEndY() -> CGFloat {
        return SCREEN_SIZE.height - self.size.height / 2.0
    }
    
    func bottomEndY() -> CGFloat {
        return self.size.height / 2.0
    }
    
    func leftEndX() -> CGFloat {
        return self.size.width / 2.0
    }
    
    func rightEndX() -> CGFloat {
        return SCREEN_SIZE.width - self.size.width / 2.0
    }
    
    func addRectBackgroundPhysics(){
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.background
        self.physicsBody?.collisionBitMask = PhysicsCategory.All
        self.physicsBody?.restitution = 0.8
    }
    
    
    func printInfo(){
        println(self.name)
        println(self.size)
        println(self.position)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SKNode {
    func onTouchBegan(){
        if((self.name) != nil){
            println("empty action called on " + self.name!)
        }else{
            println("empty action called")
        }
    }
    func addChildren(children:[SKNode]){
        children.each{(child) in
            self.addChild(child)
        }
    }
    func childrenByNames(nameList:[String]) -> [SKNode]{
        var result : [SKNode] = []
        nameList.each{ (name) in
            result.append(self.childNodeWithName(name)!)
        }
        return result
    }
    func removeChildrenByNames(nameList:[String]){
        let children = self.childrenByNames(nameList)
        children.each{(child) in
            child.removeFromParent()
        }
    }
}

extension SKAction {
    class func rotateByDegree(degree:CGFloat,duration:NSTimeInterval) -> SKAction {
        return SKAction.rotateByAngle(radFromDegree(degree), duration: duration)
    }
    class func repeatActionForeverInSequence(actions:[SKAction]) -> SKAction {
        return SKAction.repeatActionForever(SKAction.sequence(actions))
    }
    class func customAction(actionBlock: (SKNode!,CGFloat) -> Void) -> SKAction {
        return customActionWithDuration(0.00001, actionBlock: actionBlock)
    }
    
}

extension SKScene {
    public override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch: AnyObject? = touches.anyObject()
        let pointInScene = touch?.locationInNode(self)
        let touchedNode = self.nodeAtPoint(pointInScene!)
        touchedNode.onTouchBegan()
    }

    func changeSceneAction(nextScene: SKScene) -> SKAction {
        return SKAction.runBlock(){
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.view?.presentScene(nextScene,transition:reveal)
        }
    }
    
    func changeScene(nextScene: SKScene){
        runAction(changeSceneAction(nextScene))
    }

    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        didBeginContact(firstBody,secondBody:secondBody)
    }
    
    func didBeginContact(firstBody: SKPhysicsBody,secondBody: SKPhysicsBody){
        // for overriding
    }
    
    func makeWallsAllAround(){
        let ceiling = THSpriteNode(size:CGSize(width: SCREEN_SIZE.width, height: 1.0))
        ceiling.name = "ceiling"
        ceiling.addRectBackgroundPhysics()
        ceiling.position = CGPoint(x:centerX(),y:ceiling.topEndY())
        let floor = THSpriteNode(size:ceiling.size)
        floor.name = "floor"
        floor.addRectBackgroundPhysics()
        floor.position = CGPoint(x:centerX(),y:ceiling.bottomEndY())
        let leftWall = THSpriteNode(size:CGSize(width:1.0,height:SCREEN_SIZE.height))
        leftWall.name = "leftWall"
        leftWall.addRectBackgroundPhysics()
        leftWall.position = CGPoint(x:leftWall.leftEndX(),y:centerY())
        let rightWall = THSpriteNode(size:leftWall.size)
        rightWall.name = "rightWall"
        rightWall.addRectBackgroundPhysics()
        rightWall.position = CGPoint(x: rightWall.rightEndX(), y: centerY())
        
        addChildren([ceiling,floor,leftWall,rightWall])
    }
    
    func removeWallsAllAround(){
        self.removeChildrenByNames(["ceiling","floor","leftWall","rightWall"])
    }
    
    func addCommonHeader(){
        let buttonScale : CGFloat = 1.7
        let headerZPosition : CGFloat = 100.0
        
        let homeBG = THSpriteNode(img: "icon/homeBG",scale: buttonScale)
        homeBG.position = CGPoint(x:homeBG.leftEndX(),y:homeBG.topEndY())
        homeBG.zPosition = headerZPosition
        
        let homeButton = THSpriteNode(img: "icon/homeDefault",scale: buttonScale)
        homeButton.position = CGPoint(x:homeBG.leftEndX(),y:homeBG.topEndY())
        homeButton.zPosition = headerZPosition
        homeButton.addRectBackgroundPhysics()
        homeButton.name = "homeButton"
        
        let chooseBG = THSpriteNode(img: "icon/chooseBG",scale: buttonScale)
        chooseBG.position = CGPoint(x:homeBG.rightEndX(),y:homeBG.topEndY())
        chooseBG.zPosition = headerZPosition

        let chooseButton = THSpriteNode(img: "icon/chooseDefault",scale: buttonScale)
        chooseButton.position = CGPoint(x:homeBG.rightEndX(),y:homeBG.topEndY())
        chooseButton.zPosition = headerZPosition
        chooseButton.addRectBackgroundPhysics()
        chooseButton.name = "chooseButton"

        addChildren([homeBG,chooseBG,homeButton,chooseButton])
    }
}