//
//  GetGitUserDetailLocalUseCaseTest.swift
//  DataTests
//
//  Created by Long Do on 01/01/2025.
//

import Combine
@testable import Domain // Replace with your module name
import XCTest

class GetGitUserDetailLocalUseCaseTests: XCTestCase {

    private var useCase: GetGitUserDetailLocalUseCase!
    private var mockRepository: MockGitUserDetailRepository!
    private var cancellables: Set<AnyCancellable>!

    private let login = MockUtil.login
    private let userDetail = MockUtil.userDetail

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
        mockRepository.localUser = userDetail
        let expectation = XCTestExpectation(description: "Publisher should return the expected user")

        // Act
        useCase.invoke(userName: login)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, but got failure with error: \(error)")
                }
            }, receiveValue: { user in
                // Assert
                XCTAssertEqual(user, self.userDetail)
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
                if case let .failure(error) = completion {
                    // Assert
                    XCTAssertEqual(error as! MockError, MockError.testError)
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
}
