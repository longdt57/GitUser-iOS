//
//  GitUserDetailLocalSourceImplTests.swift
//  Domain
//
//  Created by Long Do on 02/01/2025.
//

@testable import Data
import RealmSwift
import XCTest

class GitUserDetailLocalSourceImplTests: XCTestCase {

    var localSource: GitUserDetailLocalSourceImpl!

    override func setUp() {
        super.setUp()

        // Initialize your GitUserDetailLocalSourceImpl
        localSource = MockGitUserDetailLocalSourceImpl()

        // Create an in-memory Realm configuration for testing
        let mockRealm = try! localSource.getRealm()

        // Clear any existing data before each test
        try! mockRealm.write {
            mockRealm.deleteAll()
        }
    }

    override func tearDown() {
        // Clean up
        localSource = nil
        super.tearDown()
    }

    func testGetUserDetailByLogin() {
        // Arrange: Insert a GitUserDetail into the mock Realm
        let userDetail = GitUserDetail(value: ["login": "user1", "name": "User One"])
        localSource.upsert(userDetail: userDetail)

        // Act: Fetch the user detail using the `getUserDetailByLogin` method
        let fetchedUserDetail = try! localSource.getUserDetailByLogin(login: "user1")

        // Assert: Ensure that the correct user detail is returned
        XCTAssertNotNil(fetchedUserDetail)
        XCTAssertEqual(fetchedUserDetail?.login, "user1")
        XCTAssertEqual(fetchedUserDetail?.name, "User One")
    }

    func testGetUserDetailByLoginReturnsNilIfNotFound() {
        // Act: Try fetching user detail by a login that doesn't exist
        let fetchedUserDetail = try! localSource.getUserDetailByLogin(login: "nonexistentUser")

        // Assert: Ensure that the result is nil
        XCTAssertNil(fetchedUserDetail)
    }

    func testUpsertNewUserDetail() {
        // Arrange: Create a new GitUserDetail
        let newUserDetail = GitUserDetail(value: ["login": "user2", "name": "User Two"])

        // Act: Upsert the user detail into Realm
        localSource.upsert(userDetail: newUserDetail)

        // Assert: Verify that the user detail has been inserted
        let fetchedUserDetail = try! localSource.getUserDetailByLogin(login: "user2")
        XCTAssertNotNil(fetchedUserDetail)
        XCTAssertEqual(fetchedUserDetail?.login, "user2")
        XCTAssertEqual(fetchedUserDetail?.name, "User Two")
    }

    func testUpsertUpdateExistingUserDetail() {
        // Arrange: Insert a user detail into Realm first
        let existingUserDetail = GitUserDetail(value: ["login": "user3", "name": "User Three"])
        let mockRealm = try! localSource.getRealm()
        try! mockRealm.write {
            mockRealm.add(existingUserDetail)
        }

        // Act: Upsert (update) the existing user detail with new data
        let updatedUserDetail = GitUserDetail(value: ["login": "user3", "name": "Updated User Three"])
        localSource.upsert(userDetail: updatedUserDetail)

        // Assert: Verify that the existing user detail has been updated
        let fetchedUserDetail = try! localSource.getUserDetailByLogin(login: "user3")
        XCTAssertNotNil(fetchedUserDetail)
        XCTAssertEqual(fetchedUserDetail?.name, "Updated User Three")
    }

    class MockGitUserDetailLocalSourceImpl: GitUserDetailLocalSourceImpl {

        override func getRealm() throws -> Realm {
            let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
            return try! Realm(configuration: config)
        }
    }
}
