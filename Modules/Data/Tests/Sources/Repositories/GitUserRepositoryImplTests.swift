//
//  GitUserRepositoryImplTests.swift
//  DataTests
//
//  Created by Long Do on 01/01/2025.
//

import Combine
@testable import Data
@testable import Domain
import XCTest

class GitUserRepositoryImplTests: XCTestCase {
    private var repository: GitUserRepositoryImpl!
    private var mockNetworkAPI: MockNetworkAPI!
    private var mockGitUserLocalSource: MockGitUserLocalSource!

    private let remoteUsers = [
        GitUser(id: 1, login: "User1", avatarUrl: "url1", htmlUrl: "html1"),
        GitUser(id: 2, login: "User2", avatarUrl: "url2", htmlUrl: "html2")
    ]

    private let localUsers = [
        GitUser(id: 3, login: "User3", avatarUrl: "url3", htmlUrl: "html3"),
        GitUser(id: 4, login: "User4", avatarUrl: "url4", htmlUrl: "html4")
    ]

    override func setUp() {
        super.setUp()
        mockNetworkAPI = MockNetworkAPI()
        mockGitUserLocalSource = MockGitUserLocalSource()
        repository = GitUserRepositoryImpl(networkAPI: mockNetworkAPI, gitUserLocalSource: mockGitUserLocalSource)
    }

    override func tearDown() {
        repository = nil
        mockNetworkAPI = nil
        mockGitUserLocalSource = nil
        super.tearDown()
    }

    func testGetRemote_Success_ReturnsMappedUsersAndSavesToLocal() async throws {
        // Arrange
        mockNetworkAPI.result = remoteUsers

        // Act
        let users = try await repository.getRemote(since: 0, perPage: 2)

        // Assert
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users[0].id, 1)
        XCTAssertEqual(users[0].login, "User1")
        XCTAssertTrue(mockGitUserLocalSource.didUpsert)
        XCTAssertEqual(mockGitUserLocalSource.upsertedUsers?.count, 2)
    }

    func testGetRemote_Failure_ThrowsError() async {
        // Arrange
        mockNetworkAPI.shouldThrowError = true

        // Act & Assert
        do {
            _ = try await repository.getRemote(since: 0, perPage: 10)
            XCTFail("Expected to throw an error, but no error was thrown")
        } catch {
            XCTAssertEqual(error as? MockError, MockError.testError)
        }
    }

    func testGetLocal_Success_ReturnsMappedUsers() async throws {
        // Arrange
        mockGitUserLocalSource.localUsers = localUsers

        // Act
        let users = try await repository.getLocal(since: 0, perPage: 2)

        // Assert
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users[0].id, 3)
        XCTAssertEqual(users[0].login, "User3")
    }

    func testGetLocal_Failure_ThrowsError() async {
        // Arrange
        mockGitUserLocalSource.shouldThrowError = true

        // Act & Assert
        do {
            _ = try await repository.getLocal(since: 0, perPage: 2)
            XCTFail("Expected to throw an error, but no error was thrown")
        } catch {
            XCTAssertEqual(error as? MockError, MockError.testError)
        }
    }

    // MARK: - Mock Classes

    class MockNetworkAPI: NetworkAPIProtocol {
        var result: [GitUser] = []
        var shouldThrowError = false

        func performRequest<T>(_ configuration: RequestConfiguration, for type: T.Type) async throws -> T
            where T: Decodable {
            if shouldThrowError {
                throw MockError.testError
            }
            guard let result = result as? T else {
                throw MockError.testError
            }
            return result
        }
    }

    class MockGitUserLocalSource: GitUserLocalSource {
        var localUsers: [GitUser] = []
        var didUpsert = false
        var upsertedUsers: [GitUser]?
        var shouldThrowError = false

        func getUsers(since: Int, perPage: Int) throws -> [GitUser] {
            if shouldThrowError {
                throw MockError.testError
            }
            return localUsers
        }

        func upsert(users: [GitUser]) {
            didUpsert = true
            upsertedUsers = users
        }
    }
}
