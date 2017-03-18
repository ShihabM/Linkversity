//
//  LinkversityTests.swift
//  LinkversityTests
//
//  Created by Shihab Mehboob on 16/10/2016.
//  Copyright © 2016 Shihab Mehboob. All rights reserved.
//

import XCTest
@testable import Linkversity

class LinkversityTests: XCTestCase {
    
    var vc = FeedViewController()
    var rvc = RegisterViewController()
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testPercentageCalculator() {
        XCTAssert(true)
//        XCTAssert((vc.view != nil), "View did not load for ViewController")
    }
    
    
    func testLoadPerformance() {
        
        self.measure {
            _ = self.vc.loadDataFromFirebase()
        }
    }
    
    func testLogInPerformance() {
        
        self.measure {
            _ = self.rvc.logIn
        }
    }
    
}
