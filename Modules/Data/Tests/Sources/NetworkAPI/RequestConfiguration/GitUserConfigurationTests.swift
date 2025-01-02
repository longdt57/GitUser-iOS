//
//  GitUserConfigurationTests.swift
//  Domain
//
//  Created by Long Do on 02/01/2025.
//

import Alamofire
@testable import Data
import XCTest

class GitUserConfigurationTests: XCTestCase {

    // Test that baseURL is correctly set
    func testBaseURL() {
        // Arrange
        let configuration: GitUserConfiguration = .getUsers(since: 0, perPage: 20)

        // Act
        let baseURL = configuration.baseURL

        // Assert
        XCTAssertEqual(baseURL, "https://api.github.com")
    }

    // Test that endpoint is correctly set for `getUsers`
    func testGetUsersEndpoint() {
        // Arrange
        let configuration: GitUserConfiguration = .getUsers(since: 0, perPage: 20)

        // Act
        let endpoint = configuration.endpoint

        // Assert
        XCTAssertEqual(endpoint, "users")
    }

    // Test that endpoint is correctly set for `getUserDetail`
    func testGetUserDetailEndpoint() {
        // Arrange
        let username = "user1"
        let configuration: GitUserConfiguration = .getUserDetail(username: username)

        // Act
        let endpoint = configuration.endpoint

        // Assert
        XCTAssertEqual(endpoint, "users/\(username)")
    }

    // Test that method is correctly set for both `getUsers` and `getUserDetail`
    func testMethod() {
        // Test for getUsers
        let configuration1: GitUserConfiguration = .getUsers(since: 0, perPage: 20)
        XCTAssertEqual(configuration1.method, .get)

        // Test for getUserDetail
        let configuration2: GitUserConfiguration = .getUserDetail(username: "user1")
        XCTAssertEqual(configuration2.method, .get)
    }

    // Test that parameters are correctly set for `getUsers`
    func testGetUsersParameters() {
        // Arrange
        let configuration: GitUserConfiguration = .getUsers(since: 10, perPage: 30)

        // Act
        let parameters = configuration.parameters

        // Assert
        XCTAssertEqual(parameters?["per_page"] as? Int, 30)
        XCTAssertEqual(parameters?["since"] as? Int, 10)
    }

    // Test that parameters are nil for `getUserDetail`
    func testGetUserDetailParameters() {
        // Arrange
        let configuration: GitUserConfiguration = .getUserDetail(username: "user1")

        // Act
        let parameters = configuration.parameters

        // Assert
        XCTAssertNil(parameters)
    }

    // Test that headers are correctly set
    func testHeaders() {
        // Arrange
        let configuration: GitUserConfiguration = .getUsers(since: 0, perPage: 20)

        // Act
        let headers = configuration.headers

        // Assert
        XCTAssertEqual(headers?["Content-Type"], "application/json")
    }

    // Test that encoding is correctly set
    func testEncoding() {
        // Arrange
        let configuration: GitUserConfiguration = .getUsers(since: 0, perPage: 20)

        // Act
        let encoding = configuration.encoding

        // Assert
        XCTAssertTrue(encoding is URLEncoding)
    }
}
