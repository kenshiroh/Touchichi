//
//  TouchichiTests.swift
//  TouchichiTests
//
//  Created by Kenshiroh Hirose on 2015/03/04.
//  Copyright (c) 2015年 Kenshiroh Hirose. All rights reserved.
//

import UIKit
import XCTest
import SpriteKit

class TouchichiTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTHSpriteNode(){
        let thSprite = THSpriteNode(size:CGSize(width: 10, height: 10))
    }
    
    func testUtility(){
        XCTAssert(Config.json["test"].string == "testvalue", "success!")
        XCTAssert(randBelow(10) < 10,"success!")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
