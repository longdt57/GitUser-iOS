//
//  GetGitUserUseCaseTests.swift
//  DomainTests
//
//  Created by Long Do on 01/01/2025.
//

import Combine
@testable import Domain
import XCTest

class GetGitUserUseCaseTests: XCTestCase {

    private var useCase: GetGitUserUseCase!
    private var mockRepository: MockGitUserRepository!
    private var cancellables: Set<AnyCancellable>!
    
    private let expectedUsers = [
        GitUserModel(id: 1, login: "User1", avatarUrl: nil, htmlUrl: nil),
        GitUserModel(id: 2, login: "User2", avatarUrl: nil, htmlUrl: nil)
    ]

    override func setUp() {
        super.setUp()
        mockRepository = MockGitUserRepository()
        useCase = GetGitUserUseCase(repository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        cancellables = nil
        super.tearDown()
    }

    func testReturnsLocalDataWhenAvailable() {
        // Arrange
        let expectedUsers = self.expectedUsers
        mockRepository.localUsers = expectedUsers

        let expectation = XCTestExpectation(description: "Fetches local users")

        // Act
        useCase.invoke(since: 0, perPage: 2)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { users in
                // Assert
                XCTAssertEqual(users, expectedUsers)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchesRemoteDataWhenLocalDataIsEmpty() {
        // Arrange
        mockRepository.localUsers = []
        let expectedUsers = self.expectedUsers
        mockRepository.remoteUsers = expectedUsers

        let expectation = XCTestExpectation(description: "Fetches remote users")

        // Act
        useCase.invoke(since: 0, perPage: 2)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { users in
                // Assert
                XCTAssertEqual(users, expectedUsers)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testThrowsErrorWhenBothLocalAndRemoteFail() {
        // Arrange
        mockRepository.shouldThrowError = true

        let expectation = XCTestExpectation(description: "Handles error when both local and remote fail")

        // Act
        useCase.invoke(since: 0, perPage: 2)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    // Assert
                    XCTAssertEqual(error as? MockError, MockError.testError)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
    
    class MockGitUserRepository: GitUserRepository {
        var localUsers: [GitUserModel] = []
        var remoteUsers: [GitUserModel] = []
        var shouldThrowError: Bool = false
        
        func getRemote(since: Int, perPage: Int) async throws -> [GitUserModel] {
            if shouldThrowError {
                throw MockError.testError
            }
            return remoteUsers
        }
        
        func getLocal(since: Int, perPage: Int) async throws -> [GitUserModel] {
            if shouldThrowError {
                throw MockError.testError
            }
            return localUsers
        }
        
    }

    
    enum MockError: Error {
        case testError
    }
}
