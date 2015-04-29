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
    
    init(img: String, scale: CGFloat = 1.0, name:String = "",position:CGPoint = ZERO_POINT,zPosition:CGFloat = 0.0,zRotation:CGFloat=0.0){
        super.init(texture: textureFromPath(img), color: UIColor.clearColor(), size: textureFromPath(img).size())
        let scale = DEFAULT_SCALE * scale
        self.path = img
        if name == "" { self.name = img }
        else { self.name = name }
        if scale != 1.0 { self.xScale = scale }
        if scale != 1.0 { self.yScale = scale }
        if position != ZERO_POINT { self.position = position }
        if(zPosition != 0.0) { self.zPosition = zPosition }
        if(zRotation != 0.0) { self.zRotation = zRotation }
        printInfo()
    }
    
    
    // physics
    func applyImpulse(#dx:CGFloat,dy:CGFloat){
        self.physicsBody?.applyImpulse(CGVectorMake(dx, dy))
    }
    
    func applyAngularImpulse(pulse:CGFloat){
        self.physicsBody?.applyAngularImpulse(pulse)
    }
    
    func disableTouch(){
        self.touchDisabled = true
    }
    
    func enableTouch(){
        self.touchDisabled = false
    }

    override func isTouchDisabled() -> Bool {
        if touchDisabled { return true }
        return false
    }

    
    private func init_common(path:String){
        self.path = path
    }

    // actions
    func changeTextureAction(imageNamed: String) -> SKAction {
        return SKAction.runBlock(){
            self.texture = textureFromPath(imageNamed)
        }
    }

    func changeTextureAction(imageNamed: String, scaleBy: CGFloat) -> SKAction {
        return SKAction.runBlock(){
            self.texture = textureFromPath(imageNamed)
            self.xScale *= scaleBy
            self.yScale *= scaleBy
        }
    }
    
    func tiltForeverAction(tiltAngle:CGFloat,interval:NSTimeInterval=0.8) -> SKAction {
        self.zRotation = -radFromDegree(tiltAngle)
        return SKAction.repeatActionForeverInSequence([
            SKAction.rotateByDegree(2.0 * tiltAngle, duration: interval),
            SKAction.rotateByDegree(-2.0 * tiltAngle, duration: interval),
        ])
    }
    
    func switchTextureForeverAction(images:[String],interval:NSTimeInterval) -> SKAction {
        var actionSequence : [SKAction] = []
        images.each{ (imageName) in
            actionSequence.append(self.changeTextureAction(imageName))
            actionSequence.append(SKAction.waitForDuration(interval))
        }
        return SKAction.repeatActionForeverInSequence(actionSequence)
    }
    
    func repeatSwitchingXScaleAction(interval:NSTimeInterval = 0.3) -> SKAction{
        return SKAction.repeatActionForeverInSequence([
            SKAction.scaleXTo(CGFloat(-1.0 * self.xScale), duration: 0.0),
            SKAction.waitForDuration(interval),
            SKAction.scaleXTo(CGFloat(self.xScale), duration: 0.0),
            SKAction.waitForDuration(interval),
        ])
    }
    
    func removeFromParentAction() -> SKAction{
        return SKAction.runBlock(){ self.removeFromParent() }
    }
    
    
    func runActionInSequence(sequence:[SKAction]){
        self.runAction(SKAction.sequence(sequence))
    }
    
    func runActionInSequenceForever(sequence:[SKAction]){
        self.runAction(SKAction.repeatActionForeverInSequence(sequence))
    }

    func scaleBy(scale: CGFloat){
        self.xScale *= scale
        self.yScale *= scale
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
    
    func addCircleMovingObjectPhysics(){
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2.0)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.moving
        self.physicsBody?.collisionBitMask = PhysicsCategory.moving
        self.physicsBody?.restitution = 0.8
    }

    override func isOutOfScreen() -> Bool {
        if(self.position.x < -self.size.width/2) { return true }
        if(self.position.x > SCREEN_SIZE.width + self.size.width/2.0) { return true }
        if(self.position.y < -self.size.height/2) { return true }
        if(self.position.y > SCREEN_SIZE.height + self.size.height/2.0) { return true }
        return false
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
    
    func childrenByName(targetName:String) -> [SKNode] {
        var selected : [SKNode] = []
        for child : AnyObject in children {
            let node = child as SKNode
            if(node.name != nil && node.name == targetName){
                selected.append(node)
            }
        }
        return selected
    }

    func removeChildrenByNames(nameList:[String]){
        let children = self.childrenByNames(nameList)
        children.each{(child) in
            child.removeFromParent()
        }
    }
    
    // needs to be overrided
    func isOutOfScreen() -> Bool { return false }
    func isTouchDisabled() -> Bool { return false }

    func removeChildrenFromParentByNameIfOutOfScreen(inputName:String){
        self.enumerateChildNodesWithName(inputName, usingBlock: {
            (child,stop) in
            if child.isOutOfScreen() { child.removeFromParent() }
        })
    }
    
    func countChildrenWithName(inputName:String) -> Int {
        var count:Int = 0
        self.enumerateChildNodesWithName(inputName, usingBlock: {
            (child,stop) in
            count += 1
        })
        return count
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
    class func vibrateActionSequence(interval:NSTimeInterval = 0.13) -> [SKAction] {
        return [
            SKAction.scaleBy(1.3, duration: interval),
            SKAction.scaleBy(0.8, duration: interval),
            SKAction.scaleBy(1.15, duration: interval),
            SKAction.scaleBy(0.9, duration: interval),
            SKAction.scaleBy(1.05, duration: interval),
            SKAction.scaleBy(0.89, duration: interval),
        ]
    }
    class func playSound(path:String) -> SKAction {
        if(soundDict.indexForKey(path) == nil) {
            println("sound "+path+" do not exist in dictionary!")
            return SKAction.runBlock(){}
        }
        return SKAction.playSoundFileNamed(SOUND_PREFIX+soundDict[path]!, waitForCompletion: false)
    }
}

class THScene : SKScene {
    var resetReady : Bool = false
    var headerIsSet : Bool = false
    var touchDisabled : Bool = false
    let imagesToPreload : [String] = []
    let soundsToPreload : [String] = []
    
    override init(size: CGSize) {
        super.init(size:size)
    }

    // to be overrided
    func initialize(){}
    
    func preloadImages(imagesToPreload:[String]){
        imagesToPreload.each(){ (imagePath) in
            let path = imagePath as String
            textureFromPath(path)
        }
    }
    
    func preloadSounds(soundsToPreload: [String]){
        soundsToPreload.each(){ (soundPath) in
            let path = soundPath as String
            SKAction.playSound(path)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch: AnyObject? = touches.anyObject()
        let pointInScene = touch?.locationInNode(self)
        let touchedNode = self.nodeAtPoint(pointInScene!)
        let nodes = self.nodesAtPoint(pointInScene!) as [THSpriteNode]
        println(touchedNode.name)
        if touchedNode.name != nil {
            if touchedNode.name == "homeButton" { self.changeScene(TopScene(size:SCREEN_SIZE)); return; }
            if touchedNode.name == "menuButton" { self.changeScene(MenuScene(size:SCREEN_SIZE)); return; }
        }
        if !self.isTouchDisabled() { onTouchScene(touchedNode); }
        
        if penetrateTouch() == true {
            for node : THSpriteNode in nodes {
                if !node.isTouchDisabled() {
                    node.onTouchBegan()
                }
            }
        }
        else if !touchedNode.isTouchDisabled() {
            touchedNode.onTouchBegan()
        }
    }
    
    func disableTouch(){
        self.touchDisabled = true
    }
    
    func penetrateTouch() -> Bool{
        return false
    }
    
    func enableTouch(){
        self.touchDisabled = false
    }
    
    override func isTouchDisabled() -> Bool {
        if touchDisabled { return true }
        return false
    }
    
    func destruct(){}
    
    // needs to be overrided
    func onTouchScene(node:SKNode){}
    func didBeginContact(firstNode: SKNode,secondNode: SKNode,contactPoint: CGPoint){}

    func changeSceneAction(nextScene: THScene) -> SKAction {
        let scene = self
        return SKAction.runBlock(){
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.destruct()
            stopBGM()
            removeAdView()
            self.view?.presentScene(nextScene,transition:reveal)
            nextScene.initialize()
            scene.removeAllActions()
            scene.removeAllChildren()
        }
    }
    
    func changeScene(nextScene: THScene){
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
        
        if(firstBody.node == nil || secondBody.node == nil) { return }
        didBeginContact(firstBody.node!,secondNode:secondBody.node!,contactPoint: contact.contactPoint)
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
        
        let homeBG = THSpriteNode(img:"icon/homeBG",scale: buttonScale)
        homeBG.position = CGPoint(x:homeBG.leftEndX(),y:homeBG.topEndY())
        homeBG.zPosition = headerZPosition
        
        let homeButton = HomeButtonSprite(img: "icon/homeDefault",scale: buttonScale)
        homeButton.position = CGPoint(x:homeBG.leftEndX(),y:homeBG.topEndY())
        homeButton.zPosition = headerZPosition
        homeButton.addRectBackgroundPhysics()
        homeButton.name = "homeButton"
        
        let chooseBG = THSpriteNode(img: "icon/chooseBG",scale: buttonScale)
        chooseBG.position = CGPoint(x:homeBG.rightEndX(),y:homeBG.topEndY())
        chooseBG.zPosition = headerZPosition

        let chooseButton = ChooseButtonSprite(img: "icon/chooseDefault",scale: buttonScale)
        chooseButton.position = CGPoint(x:homeBG.rightEndX(),y:homeBG.topEndY())
        chooseButton.zPosition = headerZPosition
        chooseButton.addRectBackgroundPhysics()
        chooseButton.name = "chooseButton"

        addChildren([homeBG,chooseBG,homeButton,chooseButton])
        headerIsSet = true
    }
}

class ChooseButtonSprite : THSpriteNode {
    override func onTouchBegan() {
        let parentScene = self.parent as THScene
        parentScene.changeScene(MenuScene(size:SCREEN_SIZE))
    }
}

class HomeButtonSprite : THSpriteNode {
    override func onTouchBegan() {
        let parentScene = self.parent as THScene
        parentScene.changeScene(TopScene(size:SCREEN_SIZE))
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.nextResponder()
            if parentResponder is UIViewController {
                return parentResponder as UIViewController!
            }
        }
        return nil
    }
}