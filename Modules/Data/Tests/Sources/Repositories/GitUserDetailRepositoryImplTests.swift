//
//  GitUserDetailRepositoryImplTests.swift
//  DataTests
//
//  Created by Long Do on 01/01/2025.
//

import XCTest
import Combine
@testable import Data
@testable import Domain

class GitUserDetailRepositoryImplTests: XCTestCase {
    private var repository: GitUserDetailRepositoryImpl!
    private var mockNetworkAPI: MockNetworkAPI!
    private var mockGitUserDetailLocalSource: MockGitUserDetailLocalSource!
    
    // Updated user information
    private let login = "longdt57"
    private let user = GitUserDetail(
        id: 8_809_113,
        login: "longdt57",
        name: "Logan",
        avatarUrl: "https://avatars.githubusercontent.com/u/8809113?v=4",
        blog: "https://www.linkedin.com/in/longdt57/",
        location: "Hanoi",
        followers: 10,
        following: 5
    )
    
    override func setUp() {
        super.setUp()
        mockNetworkAPI = MockNetworkAPI()
        mockGitUserDetailLocalSource = MockGitUserDetailLocalSource()
        repository = GitUserDetailRepositoryImpl(networkAPI: mockNetworkAPI, gitUserDetailLocalSource: mockGitUserDetailLocalSource)
    }
    
    override func tearDown() {
        repository = nil
        mockNetworkAPI = nil
        mockGitUserDetailLocalSource = nil
        super.tearDown()
    }
    
    func testGetRemote_Success_ReturnsMappedUserAndSavesToLocal() async throws {
        // Arrange
        mockNetworkAPI.result = user
        
        // Act
        let fetchedUser = try await repository.getRemote(userName: login)
        
        // Assert
        XCTAssertEqual(fetchedUser.id, user.id)
        XCTAssertEqual(fetchedUser.login, user.login)
        XCTAssertTrue(mockGitUserDetailLocalSource.didUpsert)
        XCTAssertEqual(mockGitUserDetailLocalSource.upsertedUser?.id, user.id)
    }
    
    func testGetRemote_Failure_ThrowsError() async {
        // Arrange
        mockNetworkAPI.shouldThrowError = true
        
        // Act & Assert
        do {
            _ = try await repository.getRemote(userName: login)
            XCTFail("Expected error, but got success")
        } catch {
            XCTAssertEqual(error as? MockError, MockError.testError)
        }
    }
    
    func testGetLocal_Success_ReturnsMappedUser() async throws {
        // Arrange
        mockGitUserDetailLocalSource.localUser = user
        
        // Act
        let fetchedUser = try await repository.getLocal(userName: login)
        
        // Assert
        XCTAssertEqual(fetchedUser?.id, user.id)
        XCTAssertEqual(fetchedUser?.login, user.login)
    }
    
    func testGetLocal_Failure_ThrowsError() async {
        // Arrange
        mockGitUserDetailLocalSource.shouldThrowError = true
        
        // Act & Assert
        do {
            _ = try await repository.getLocal(userName: login)
            XCTFail("Expected error, but got success")
        } catch {
            XCTAssertEqual(error as? MockError, MockError.testError)
        }
    }
    
    // MARK: - Mock Classes
    
    class MockNetworkAPI: NetworkAPIProtocol {
        var result: GitUserDetail?
        var shouldThrowError = false
        
        func performRequest<T>(_ configuration: RequestConfiguration, for type: T.Type) async throws -> T where T: Decodable {
            if shouldThrowError {
                throw MockError.testError
            }
            guard let result = result as? T else {
                throw MockError.testError
            }
            return result
        }
    }
    
    class MockGitUserDetailLocalSource: GitUserDetailLocalSource {
        var localUser: GitUserDetail?
        var didUpsert = false
        var upsertedUser: GitUserDetail?
        var shouldThrowError = false
        
        func getUserDetailByLogin(login: String) throws -> GitUserDetail? {
            if shouldThrowError {
                throw MockError.testError
            }
            return localUser
        }
        
        func upsert(userDetail: GitUserDetail) {
            didUpsert = true
            upsertedUser = userDetail
        }
    }
    
    // MARK: - Mock Error
    
    enum MockError: Error {
        case testError
    }
}

