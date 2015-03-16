//
//  Utility.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/06.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import SpriteKit

let ZERO_POINT : CGPoint = CGPoint(x:0.0,y:0.0)
let SCREEN_SIZE : CGSize = CGSize(width: 320.0,height:568.0)

class Config {
    let jsonVal:JSON = nil
    class var json : JSON {
        struct Static {
            static let instance : Config = Config()
        }
        return Static.instance.jsonVal
    }
    init(){
        let path = NSBundle(forClass:Config.self).pathForResource("configuration",ofType:"json")
        let data = NSData(contentsOfFile: path!)
        jsonVal = JSON(data:data!)
    }
}

struct PhysicsCategory {
    static let None         : UInt32 = 0
    static let All          : UInt32 = UInt32.max
    static let background   : UInt32 = 0b01      // 1
    static let moving       : UInt32 = 0b11      // 3
}


var TEXTURE_CACHE : Dictionary<String,SKTexture> = [:]

func textureFromPath(path:String) -> SKTexture{
    let fullStr : String = "images/" + path
    if(TEXTURE_CACHE[fullStr] == nil){
        TEXTURE_CACHE[fullStr] = SKTexture(imageNamed: fullStr)
    }
    return TEXTURE_CACHE[fullStr]!
}

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


func randBelow(limit:Int) -> Int {
    return Int(arc4random_uniform(UInt32(limit)))
}