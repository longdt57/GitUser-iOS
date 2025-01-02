//
//  GitUserLocalSourceImplTests.swift
//  Domain
//
//  Created by Long Do on 02/01/2025.
//

@testable import Data
import RealmSwift
import XCTest

class GitUserLocalSourceImplTests: XCTestCase {

    var localSource: GitUserLocalSourceImpl!

    override func setUp() {
        super.setUp()

        // Initialize your GitUserLocalSourceImpl
        localSource = MockGitUserLocalSourceImpl()

        // Create an in-memory Realm configuration for testing
        let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
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

    func testGetUsersWithPagination() {
        // Arrange: Insert some sample users into the mock Realm
        let users = [
            GitUser(value: ["id": 1, "login": "user1"]),
            GitUser(value: ["id": 2, "login": "user2"]),
            GitUser(value: ["id": 3, "login": "user3"]),
            GitUser(value: ["id": 4, "login": "user4"]),
            GitUser(value: ["id": 5, "login": "user5"])
        ]

        localSource.upsert(users: users)

        // Act: Fetch users using the `getUsers` method
        let fetchedUsers = try! localSource.getUsers(since: 2, perPage: 2)

        // Assert: Check that the correct users were returned
        XCTAssertEqual(fetchedUsers.count, 2)
        XCTAssertEqual(fetchedUsers[0].id, 3)
        XCTAssertEqual(fetchedUsers[1].id, 4)
    }

    func testGetUsersWithEmptyResult() {
        // Act: Try fetching users with invalid offset (since > available users)
        let fetchedUsers = try! localSource.getUsers(since: 10, perPage: 2)

        // Assert: Ensure that the result is empty
        XCTAssertTrue(fetchedUsers.isEmpty)
    }

    func testUpsertUpdateExistingUser() {
        // Arrange: Insert a user into Realm first
        let existingUser = GitUser(value: ["id": 1, "login": "user1"])
        let mockRealm = try! localSource.getRealm()
        try! mockRealm.write {
            mockRealm.add(existingUser)
        }

        // Act: Upsert (update) the existing user with new data
        let updatedUsers = [
            GitUser(value: ["id": 1, "login": "updatedUser1"])
        ]
        localSource.upsert(users: updatedUsers)

        // Assert: Verify that the existing user has been updated
        let fetchedUser = try! localSource.getUsers(since: 0, perPage: 1).first
        XCTAssertNotNil(fetchedUser)
        XCTAssertEqual(fetchedUser?.login, "updatedUser1")
    }

    class MockGitUserLocalSourceImpl: GitUserLocalSourceImpl {

        override func getRealm() throws -> Realm {
            let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
            return try! Realm(configuration: config)
        }
    }
}
