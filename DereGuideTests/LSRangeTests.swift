//
//  LSRangeTests.swift
//  DereGuideTests
//
//  Created by zzk on 06/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import XCTest
@testable import DereGuide

class LSRangeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let r1 = LSRange(begin: 1, end: 10)
        let r2 = LSRange(begin: 2, end: 8)
        assert(r1.subtract(r2) == [LSRange(begin: 1, end: 2), LSRange(begin: 8, end: 10)])
        
        let r3 = LSRange(begin: 10, end: 20)
        assert(r1.subtract(r3) == [r1])
        assert(r1.intersects(r3) == false)
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
