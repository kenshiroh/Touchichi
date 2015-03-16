//
//  String+Hex.swift
//  Touchichi
//
//  Created by Kenshiroh Hirose on 2015/03/04.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import UIKit
import SpriteKit

extension String {
    func hexComponents() -> [String?] {
        let code = self
        let offset = code.hasPrefix("#") ? 1 : 0
        let start: String.Index = code.startIndex
        return [
            code[advance(start, offset)...advance(start, offset + 1)],
            code[advance(start, offset + 2)...advance(start, offset + 3)],
            code[advance(start, offset + 4)...advance(start, offset + 5)]
        ]
    }
}

extension SKColor {
    class func fromHexCode(code: String, alpha: Double = 1.0) -> SKColor {
        let rgbValues = code.hexComponents().map {
            (component: String?) -> CGFloat in
            if let hex = component {
                var rgb: CUnsignedInt = 0
                if NSScanner(string: hex).scanHexInt(&rgb) {
                    return CGFloat(rgb) / 255.0
                }
            }
            return 0.0
        }
        return SKColor(red: rgbValues[0], green: rgbValues[1], blue: rgbValues[2], alpha: 1.0)
    }
}