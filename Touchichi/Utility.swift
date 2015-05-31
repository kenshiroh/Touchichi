//
//  Utility.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/06.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import SpriteKit
import AVFoundation

///////////////////
// AdObject
///////////////////

var amoadView: AMoAdView!
var controller: GameViewController!

func addAdView(){
    controller.view.addSubview(amoadView)
}

func initializeAdView(){
    let iphoneScreenSize = UIScreen.mainScreen().applicationFrame.size
    let height = iphoneScreenSize.height / 9.0
    let adRect = CGRectMake(
        0,
        iphoneScreenSize.height-50,
        iphoneScreenSize.width,
        height)
    amoadView = AMoAdView(frame: adRect)
    println("adsize:")
    println(adRect)
    amoadView.sid = "62056d310111552cb7f04a8a5f63addba5adae91fd08aa653cd9d68c981f3228"
    amoadView.rotateTransition = AMoAdRotateTransitionFlipFromLeft
    amoadView.clickTransition = AMoAdClickTransitionJump
}

func removeAdView(){
    amoadView.removeFromSuperview()
}



///////////////////
// Sound and Music
///////////////////

let SOUND_PREFIX = "sounds/"
var bgmPlayer: AVAudioPlayer!

let soundDict = [
    // top
    "topBGM": "BGM1.mp3",
    "hiyokoCrash": "stupid3.mp3",
    // unchi
    "unchiEmit": "unchi3.mp3",
    "unchiHitHiyoko": "jumpCute1.mp3",
    "hiyokoRunAway": "hamsterPyu.mp3",
    // daikon touch
    "daikonTouched": "boyoyon.mp3",
    // hat
    "hatGone": "flee1.mp3",
    // pull from dirt
    "pullInDirt": "touch1.mp3",
    "goingOutOfDirt": "pulled1.mp3",
    // hiyoko crash
    "piyopiyo": "hiyoko.mp3",
    "poyon": "stupid3.mp3",
    // hanachochin
    "chochinBigger": "pulled2.mp3",
    "chochinSmaller": "pulled2.mp3",
    "chochinTapped": "pulled2.mp3",
    "chochinBroken": "flee1.mp3",
    // hitsuji
    "hitsujiHiyokoTokotoko": "hiyoko.mp3",
    "hitsujiHiyokoCrushed": "nyu1.mp3",
    // hamster dokan
    "emitFromDokan": "boon1.mp3",
    "hamsterHitEachOther": "pulled3.mp3",
    "catAppear": "hamsterCat2.mp3",
    "catBecomeScary": "hamsterCat1.mp3",
    "hamstersGoAway": "hamsterPyu.mp3",
    // hamsterCatch
    "objectDropFromUp": ".mp3",
    "unchiHitHamster": "unchi1.mp3",
    "fruitsHitHamster": "hightPiro.mp3",
    // swan
    "swansHitEachOther": "touch1.mp3",
    "heardGoingToSky": "heart.mp3",
    // pig
    "pigApproach": "pulled1.mp3",
    "pigHit": "touch1.mp3",
    "pigGoAway": "flee1.mp3",
]

func playBGM(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(
        filename, withExtension: nil)
    if (url == nil) {
        println("Could not find file: \(filename)")
        return
    }
    else if(bgmPlayer != nil && bgmPlayer.playing){
        println("BGM already playing")
        return
    }
    
    var error: NSError? = nil
    bgmPlayer =
        AVAudioPlayer(contentsOfURL: url, error: &error)
    if bgmPlayer == nil {
        println("Could not create audio player: \(error!)")
        return
    }
    AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, error: nil)
    bgmPlayer.numberOfLoops = -1
    bgmPlayer.prepareToPlay()
    bgmPlayer.play()
}

func stopBGM(){
    if bgmPlayer == nil { return }
    if bgmPlayer.playing {
        bgmPlayer.pause()
    }
}

func resumeBGM(){
    bgmPlayer.play()
}


///////////////////
// sprites and textures
///////////////////

var TEXTURE_CACHE : Dictionary<String,SKTexture> = [:]
let IMAGE_PREFIX : String = "images/"
let DEFAULT_SCALE: CGFloat = 320/400/4

func textureFromPath(path:String) -> SKTexture{
    let fullStr : String = IMAGE_PREFIX + path
    if(TEXTURE_CACHE[fullStr] == nil){
        TEXTURE_CACHE[fullStr] = SKTexture(imageNamed: fullStr)
    }
    return TEXTURE_CACHE[fullStr]!
}

struct PhysicsCategory {
    static let None         : UInt32 = 0
    static let All          : UInt32 = UInt32.max
    static let background   : UInt32 = 0b01      // 1
    static let moving       : UInt32 = 0b11      // 3
}

///////////////////
// size and positions
///////////////////

let ZERO_POINT : CGPoint = CGPoint(x:0.0,y:0.0)
let SCREEN_SIZE : CGSize = CGSize(width: 320.0,height:568.0)
let IPHONE_SIZE = UIScreen.mainScreen().applicationFrame.size


func centerX() -> CGFloat {
    return SCREEN_SIZE.width / 2.0
}

func centerY() -> CGFloat {
    return SCREEN_SIZE.height / 2.0
}

func radFromDegree(degree:CGFloat) -> CGFloat {
    return CGFloat(M_PI / 180.0 * Double(degree))
}

func posByRatio(#x:CGFloat,#y:CGFloat) -> CGPoint {
    return CGPoint(x: SCREEN_SIZE.width*x,y:SCREEN_SIZE.height*y)
}

///////////////////
// other utility functions
///////////////////

func randBelow(limit:Int) -> Int {
    return Int(arc4random_uniform(UInt32(limit)))
}

func randBetween(bottom:Int,top:Int) -> Int {
    let range = top - bottom
    return Int(arc4random_uniform(UInt32(range))) + bottom
}
