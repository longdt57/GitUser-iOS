//
//  GetGitUserDetailLocalTest.swift
//  DataTests
//
//  Created by Long Do on 01/01/2025.
//

import XCTest
import Combine
@testable import Domain // Replace with your module name

class GetGitUserDetailLocalUseCaseTests: XCTestCase {
    
    private var useCase: GetGitUserDetailLocalUseCase!
    private var mockRepository: MockGitUserDetailRepository!
    private var cancellables: Set<AnyCancellable>!
    
    private let login = "longdt57"
    private let expectedUser = GitUserDetailModel(
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
        mockRepository = MockGitUserDetailRepository()
        useCase = GetGitUserDetailLocalUseCase(repository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInvokeReturnsUserFromLocal() {
        // Arrange
        mockRepository.localUser = expectedUser
        let expectation = XCTestExpectation(description: "Publisher should return the expected user")
        
        // Act
        useCase.invoke(userName: login)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, but got failure with error: \(error)")
                }
            }, receiveValue: { user in
                // Assert
                XCTAssertEqual(user, self.expectedUser)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testInvokeFailsWhenRepositoryThrows() {
        // Arrange
        mockRepository.shouldThrowError = true
        let expectation = XCTestExpectation(description: "Publisher should return an error")
        
        // Act
        useCase.invoke(userName: login)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // Assert
                    XCTAssertEqual(error as! GetGitUserDetailLocalUseCaseTests.MockError, MockError.testError)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but got a value")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testInvokeReturnsNilWhenNoUserFound() {
        // Arrange
        mockRepository.localUser = nil
        let expectation = XCTestExpectation(description: "Publisher should return an error")
        
        // Act
        useCase.invoke(userName: login)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill() // Error is expected since no user is found
                }
            }, receiveValue: { _ in
                XCTFail("Expected nil, but got a value")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Mock Repository
    
    class MockGitUserDetailRepository: GitUserDetailRepository {
        var localUser: GitUserDetailModel?
        var shouldThrowError: Bool = false
        
        func getRemote(userName: String) async throws -> GitUserDetailModel {
            throw MockError.testError
        }
        
        func getLocal(userName: String) async throws -> GitUserDetailModel? {
            if shouldThrowError {
                throw MockError.testError
            }
            return localUser
        }
    }
    
    enum MockError: Error {
        case testError
    }
}
