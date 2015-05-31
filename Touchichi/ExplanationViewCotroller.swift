//
//  ExplanationViewCotroller.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/04/29.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import SpriteKit

class ExplanationViewController : UIViewController {
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.performSegueWithIdentifier("toGame", sender: nil)
    }
}

class ExplanationUITextView : UITextView {
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("touch on uitextview")
        self.parentViewController!.performSegueWithIdentifier("toGame", sender: nil)
    }
}