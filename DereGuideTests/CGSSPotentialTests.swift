//
//  CGSSPotentialTests.swift
//  DereGuideTests
//
//  Created by zzk on 2018/4/4.
//  Copyright © 2018 zzk. All rights reserved.
//

import XCTest
@testable import DereGuide

class CGSSPotentialTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEquatable() {
        let p1 = Potential(vocalLevel: 0, danceLevel: 0, visualLevel: 10, lifeLevel: 1)
        let p2 = Potential(vocalLevel: 0, danceLevel: 0, visualLevel: 10, lifeLevel: 1)
        let p3 = Potential(vocalLevel: 1, danceLevel: 0, visualLevel: 10, lifeLevel: 1)
        XCTAssert(p1 == p2)
        XCTAssert(p1 != p3)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
