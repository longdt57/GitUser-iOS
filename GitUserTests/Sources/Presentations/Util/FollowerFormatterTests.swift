//
//  FollowerFormatterTests.swift
//  DomainTests
//
//  Created by Long Do on 02/01/2025.
//

@testable import GitUser
import XCTest

final class FollowerFormatterTests: XCTestCase {

    // Test case for when value is less than or equal to the max value
    func testFormatLargeNumber_valueLessThanMax_shouldReturnValueAsString() {
        // Arrange
        let value = 50
        let max = 100

        // Act
        let result = FollowerFormatter.formatLargeNumber(value: value, max: max)

        // Assert
        XCTAssertEqual(result, "50", "The formatted number should match the value as string.")
    }

    // Test case for when value is greater than the max value
    func testFormatLargeNumber_valueGreaterThanMax_shouldReturnMaxPlus() {
        // Arrange
        let value = 150
        let max = 100

        // Act
        let result = FollowerFormatter.formatLargeNumber(value: value, max: max)

        // Assert
        XCTAssertEqual(result, "100+", "The formatted number should be '100+' when value exceeds max.")
    }

    // Test case for default max value when not provided
    func testFormatLargeNumber_withoutMax_shouldUseDefaultMax() {
        // Arrange
        let value = 150

        // Act
        let result = FollowerFormatter.formatLargeNumber(value: value)

        // Assert
        XCTAssertEqual(result, "100+", "The formatted number should be '100+' by default when value exceeds 100.")
    }
}
