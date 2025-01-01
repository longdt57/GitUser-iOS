//
//  AppXCTestCase.swift
//  GitUserTests
//
//  Created by Long Do on 01/01/2025.
//

import Foundation
import XCTest

class AppXCTestCase: XCTestCase {
    func advanceUntilIdle() {
        let expectation = XCTestExpectation(description: "advanceUntilIdle")
        // Wait for the expectation to be fulfilled or timeout
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Fulfill the expectation when the async task is completed (simulating loading)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
