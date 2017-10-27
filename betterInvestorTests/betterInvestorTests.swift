//
//  betterInvestorTests.swift
//  betterInvestorTests
//
//  Created by mehran najafi on 2017-10-19.
//  Copyright © 2017 Ron. All rights reserved.
//

import XCTest

class betterInvestorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // 1. given
        let guess = 10;
        
        // 2. when
        let guess_check = 10;
        
        // 3. then
        XCTAssertEqual(guess, guess_check, "Guess repeat is wrong")

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
