//
//  GameViewController.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/04.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial scene
        let scene = MenuScene(size: SCREEN_SIZE)
        println(scene.size)
        
        let skView = view as SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFit
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}