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
        repositoryMock = MockGitUserDetailRepository()
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
        let expectedUser = self.expectedUser
        repositoryMock.remoteUserResult = .success(expectedUser)

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
        let expectedError = MockError.testError
        repositoryMock.remoteUserResult = .failure(expectedError)

        let expectation = XCTestExpectation(description: "Failure fetching user details")

        // Act
        useCase.invoke(userName: login)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    // Assert
                    XCTAssertEqual(error as! GetGitUserDetailRemoteUseCaseTests.MockError, expectedError)
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
        
        var remoteUserResult: Result<GitUserDetailModel, Error> = .failure(MockError.testError)
        var localUserResult: Result<GitUserDetailModel?, Error> = .failure(MockError.testError)
        
        func getRemote(userName: String) async throws -> GitUserDetailModel {
            switch remoteUserResult {
                case let .success(user): return user
                case let .failure(error): throw error
            }
        }
        
        func getLocal(userName: String) async throws -> GitUserDetailModel? {
            switch localUserResult {
                case let .success(user): return user
                case let .failure(error): throw error
            }
        }
    }
    
    enum MockError: Error {
        case testError
    }

}
