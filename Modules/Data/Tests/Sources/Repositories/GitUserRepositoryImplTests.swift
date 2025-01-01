////
////  GitUserRepositoryImplTests.swift
////  DataTests
////
////  Created by Long Do on 01/01/2025.
////
//
//import XCTest
//import Domain
//@testable import Data
//
//class GitUserRepositoryImplTests: XCTestCase {
//    
//    var repository: GitUserRepositoryImpl!
//    var mockNetworkAPI: MockNetworkAPI!
//    var mockGitUserLocalSource: MockGitUserLocalSource!
//    
//    override func setUp() {
//        super.setUp()
//        mockNetworkAPI = MockNetworkAPI()
//        mockGitUserLocalSource = MockGitUserLocalSource()
//        repository = GitUserRepositoryImpl(networkAPI: mockNetworkAPI, gitUserLocalSource: mockGitUserLocalSource)
//    }
//    
//    override func tearDown() {
//        repository = nil
//        mockNetworkAPI = nil
//        mockGitUserLocalSource = nil
//        super.tearDown()
//    }
//    
//    func testGetRemoteReturnsMappedUsersAndSavesToLocal() async throws {
//        // Arrange
//        let remoteUsers = [
//            GitUser(id: 1, login: "User1", avatarUrl: nil, htmlUrl: nil),
//            GitUser(id: 2, login: "User2", avatarUrl: nil, htmlUrl: nil)
//        ]
//        mockNetworkAPI.result = remoteUsers
//        
//        // Act
//        let users = try await repository.getRemote(since: 0, perPage: 10)
//        
//        // Assert
//        XCTAssertEqual(users.count, 2)
//        XCTAssertEqual(users[0].id, 1)
//        XCTAssertEqual(users[0].login, "User1")
//        
//        XCTAssertTrue(mockGitUserLocalSource.didUpsert)
//        XCTAssertEqual(mockGitUserLocalSource.upsertedUsers?.count, 2)
//    }
//    
//    func testGetLocalReturnsMappedUsers() async throws {
//        // Arrange
//        let localUsers = [
//            GitUser(id: 3, login: "User3", avatarUrl: nil, htmlUrl: nil),
//            GitUser(id: 4, login: "User4", avatarUrl: nil, htmlUrl: nil)
//        ]
//        mockGitUserLocalSource.localUsers = localUsers
//        
//        // Act
//        let users = try await repository.getLocal(since: 0, perPage: 10)
//        
//        // Assert
//        XCTAssertEqual(users.count, 2)
//        XCTAssertEqual(users[0].id, 3)
//        XCTAssertEqual(users[0].login, "User3")
//    }
//    
//    func testGetRemoteThrowsErrorOnNetworkFailure() async {
//        // Arrange
//        mockNetworkAPI.shouldThrowError = true
//        
//        // Act
//        do {
//            _ = try await repository.getRemote(since: 0, perPage: 10)
//            XCTFail("Expected error to be thrown")
//        } catch {
//            // Assert
//            XCTAssertEqual(error as? MockError, MockError.testError)
//        }
//    }
//    
//    func testGetLocalThrowsErrorOnDataSourceFailure() async {
//        // Arrange
//        mockGitUserLocalSource.shouldThrowError = true
//        
//        // Act
//        do {
//            _ = try await repository.getLocal(since: 0, perPage: 10)
//            XCTFail("Expected error to be thrown")
//        } catch {
//            // Assert
//            XCTAssertEqual(error as? MockError, MockError.testError)
//        }
//    }
//}
//
//// MARK: - Mocks
//
//class MockNetworkAPI: NetworkAPIProtocol {
//    var result: [GitUser] = []
//    var shouldThrowError: Bool = false
//    
//    func performRequest<T>(_ configuration: RequestConfiguration, for type: T.Type) async throws -> T where T : Decodable {
//        if shouldThrowError {
//            throw MockError.testError
//        }
//        guard let result = result as? T else {
//            throw MockError.testError
//        }
//        return result
//    }
//}
//
//private class MockGitUserLocalSource: GitUserLocalSource {
//    var localUsers: [GitUser] = []
//    var didUpsert = false
//    var upsertedUsers: [GitUser]?
//    var shouldThrowError = false
//    
//    func getUsers(since: Int, perPage: Int) async throws -> [GitUser] {
//        if shouldThrowError {
//            throw MockError.testError
//        }
//        return localUsers
//    }
//    
//    func upsert(users: [GitUser]) {
//        didUpsert = true
//        upsertedUsers = users
//    }
//}
//
//// MARK: - Mock Models
//
//struct GitUser: Decodable {
//    let id: Int
//    let login: String
//    let avatarUrl: String?
//    let htmlUrl: String?
//    
//    func mapToDomain() -> GitUserModel {
//        return GitUserModel(id: Int64(id), login: login, avatarUrl: avatarUrl, htmlUrl: htmlUrl)
//    }
//}
//
//enum MockError: Error {
//    case testError
//}
