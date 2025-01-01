//
//  GetGitUserDetailRemoteUseCaseTests.swift
//  DomainTests
//
//  Created by Long Do on 01/01/2025.
//

import Combine
@testable import Domain
import XCTest

final class GetGitUserDetailRemoteUseCaseTests: XCTestCase {

    private var useCase: GetGitUserDetailRemoteUseCase!
    private var repositoryMock: MockGitUserDetailRepository!
    private var cancellables: Set<AnyCancellable>!

    private let login = MockUtil.login
    private let userDetail = MockUtil.userDetail

    override func setUp() {
        super.setUp()
        repositoryMock = MockGitUserDetailRepository(remoteUser: userDetail)
        useCase = GetGitUserDetailRemoteUseCase(repository: repositoryMock)
        cancellables = []
    }

    override func tearDown() {
        useCase = nil
        repositoryMock = nil
        cancellables = nil
        super.tearDown()
    }

    func testInvoke_Success() {
        let expectedUser = userDetail
        repositoryMock.remoteUser = expectedUser

        let expectation = XCTestExpectation(description: "Successfully fetch user details")

        // Act
        useCase.invoke(userName: login)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success but got failure with error: \(error)")
                }
            }, receiveValue: { userDetail in
                // Assert
                XCTAssertEqual(userDetail.id, expectedUser.id)
                XCTAssertEqual(userDetail.login, expectedUser.login)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }

    func testInvoke_Failure() {
        // Arrange
        repositoryMock.shouldThrowError = true

        let expectation = XCTestExpectation(description: "Failure fetching user details")

        // Act
        useCase.invoke(userName: login)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    // Assert
                    XCTAssertEqual(error as! MockError, MockError.testError)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got value")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }

    class MockGitUserDetailRepository: GitUserDetailRepository {
        var shouldThrowError: Bool = false
        var remoteUser: GitUserDetailModel

        init(remoteUser: GitUserDetailModel) {
            self.remoteUser = remoteUser
        }

        func getRemote(userName: String) async throws -> GitUserDetailModel {
            if shouldThrowError {
                throw MockError.testError
            }
            return remoteUser
        }

        func getLocal(userName: String) async throws -> GitUserDetailModel? {
            throw MockError.testError
        }
    }
}
