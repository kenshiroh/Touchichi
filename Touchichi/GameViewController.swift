//
//  GameViewController.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/04.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController,AMoAdViewDelegate {
    var bgmSuspendedOnSuspend : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = self
        
        // initial scene
        let scene = TopScene(size: SCREEN_SIZE)

        // 広告の初期化
        initializeAdView()
        
        let skView = view as SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFit
        skView.presentScene(scene)
        scene.initialize()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("appliWentBackground:"), name:UIApplicationDidEnterBackgroundNotification, object: nil)

        let foregroundNotification = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: NSOperationQueue.mainQueue()) {
            [unowned self] notification in
            
            // do whatever you want when the app is brought back to the foreground
            println("appli is back on forground!")
            if(self.bgmSuspendedOnSuspend == true){
                resumeBGM()
                self.bgmSuspendedOnSuspend = false
            }
        }
    }
    
    func appliWentBackground(notification : NSNotification){
        println("appli went background...")
        if(bgmPlayer != nil && bgmPlayer.playing == true){
            stopBGM()
            self.bgmSuspendedOnSuspend = true
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}