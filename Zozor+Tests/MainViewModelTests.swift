//
//  Zozor_Tests.swift
//  CountOnMeTests
//
//  Created by Ambroise COLLON on 30/08/2016.
//  Copyright © 2016 Ambroise Collon. All rights reserved.
//

import XCTest
@testable import CountOnMe

final class MainViewModelTests: XCTestCase {
    
    func testGivenAMainViewModel_WhenViewDidLoad_ThenDisplayedTextIsCorrectlyReturned() {
        let source = MainSource()
        let viewModel = MainViewModel(source: source)
        let expectation = self.expectation(description: "Returned text")
        
        viewModel.displayedText = { text in
            XCTAssertEqual(text, "0")
            expectation.fulfill()
        }
        viewModel.viewDidLoad()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testGivenAMainViewModel_WhenDidPressOperandWithAGoodIndex_ThenDisplayedTextIsCorrectlyReturned() {
        let source = MainSource()
        let viewModel = MainViewModel(source: source)
        let expectation = self.expectation(description: "Returned text")
        
        var counter = 0
        viewModel.displayedText = { text in
            if counter == 1 {
                XCTAssertEqual(text, "2")
                expectation.fulfill()
            }
            counter += 1
        }
        
        viewModel.viewDidLoad()
        viewModel.didPressOperand(at: 2)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testGivenAMainViewModel_WhenDidPressOperatorWithAGoodIndexAndCorrectDisplayedText_ThenDisplayedTextIsCorrectlyReturned() {
        let source = MainSource()
        let viewModel = MainViewModel(source: source)
        let expectation = self.expectation(description: "Returned text")
        
        var counter = 0
        viewModel.displayedText = { text in
            if counter == 2 {
                XCTAssertEqual(text, "1+")
                expectation.fulfill()
            }
            counter += 1
        }
        
        viewModel.viewDidLoad()
        viewModel.didPressOperand(at: 1)
        viewModel.didPressOperator(at: 0)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testGivenAMainViewModel_WhenClean_ThenDisplayedTextIsCorrectlyReturned() {
        let source = MainSource()
        let viewModel = MainViewModel(source: source)
        let expectation = self.expectation(description: "Returned text")
        
        var counter = 0
        viewModel.displayedText = { text in
            if counter == 1 {
                XCTAssertEqual(text, "0")
                expectation.fulfill()
            }
            counter += 1
        }
        
        viewModel.viewDidLoad()
        viewModel.clear()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
}
