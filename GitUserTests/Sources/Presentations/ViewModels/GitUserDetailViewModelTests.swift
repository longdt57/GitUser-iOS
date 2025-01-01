//
//  GitUserDetailViewModelTests.swift
//  GitUserTests
//
//  Created by Long Do on 01/01/2025.
//

import Combine
@testable import Domain
@testable import GitUser
import XCTest

final class GitUserDetailViewModelTests: AppXCTestCase {

    // Test instance
    private var viewModel: GitUserDetailViewModel!
    private var mockGetRemoteUseCase: MockGetGitUserDetailRemoteUseCase!
    private var mockGetLocalUseCase: MockGetGitUserDetailLocalUseCase!
    private var mockDispatchQueueProvider: MockDispatchQueueProvider!
    private var cancellables: Set<AnyCancellable>!

    // Class-level mock user detail data
    private var userDetail: GitUserDetailModel!

    override func setUp() {
        super.setUp()

        // Initialize common mock data
        userDetail = MockUtil.userDetail

        mockDispatchQueueProvider = MockDispatchQueueProvider()
        mockGetRemoteUseCase = MockGetGitUserDetailRemoteUseCase()
        mockGetLocalUseCase = MockGetGitUserDetailLocalUseCase()
        viewModel = GitUserDetailViewModel(
            dispatchQueueProvider: mockDispatchQueueProvider,
            getRemoteUseCase: mockGetRemoteUseCase,
            getLocalUseCase: mockGetLocalUseCase,
            gitUserDetailUiMapper: MockGitUserDetailUiMapper()
        )
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        mockGetRemoteUseCase = nil
        mockGetLocalUseCase = nil
        mockDispatchQueueProvider = nil
        cancellables = nil
        super.tearDown()
    }

    func testSetUserLogin_whenCalled_shouldFetchLocalAndRemoteData() {
        // Arrange: Set up the initial login
        let login = "user1"
        viewModel.uiModel.login = login

        // Act: Set the user login
        viewModel.handleAction(action: .setUserLogin(login: login))

        // Assert: Verify that local and remote data are fetched
        XCTAssertTrue(mockGetLocalUseCase.invokeCalled, "Local use case should be called")
        XCTAssertTrue(mockGetRemoteUseCase.invokeCalled, "Remote use case should be called")
    }

    func testFetchRemote_whenSuccessful_shouldUpdateUiModel() {
        // Arrange: Set up the mock response
        mockGetRemoteUseCase.result = userDetail

        // Act: Fetch remote data
        viewModel.handleAction(action: .setUserLogin(login: "user1"))
        advanceUntilIdle()

        // Assert: Verify that the UI model is updated
        XCTAssertEqual(viewModel.uiModel.name, userDetail.name, "The UI model name should match the fetched data")
        XCTAssertEqual(
            viewModel.uiModel.avatarUrl,
            userDetail.avatarUrl,
            "The UI model avatar URL should match the fetched data"
        )
    }

    func testFetchRemote_whenErrorOccurs_shouldHandleError() {
        // Arrange: Mock an error response
        mockGetRemoteUseCase.error = NSError(domain: "TestError", code: 0, userInfo: nil)

        // Act: Fetch remote data
        viewModel.handleAction(action: .setUserLogin(login: "user1"))

        // Assert: Verify that the error handling method is invoked
        XCTAssertTrue(viewModel.error != nil, "Error state should be updated when an error occurs")
    }

    func testFetchLocal_whenDataExists_shouldUpdateUiModel() {
        // Arrange: Set up mock local data response
        mockGetLocalUseCase.result = userDetail

        // Act: Fetch local data
        viewModel.handleAction(action: .setUserLogin(login: "user1"))

        advanceUntilIdle()
        // Assert: Verify that the UI model is updated with local data
        XCTAssertEqual(viewModel.uiModel.name, userDetail.name, "The UI model name should match the local data")
        XCTAssertEqual(
            viewModel.uiModel.avatarUrl,
            userDetail.avatarUrl,
            "The UI model avatar URL should match the local data"
        )
    }

    func testFetchLocal_whenErrorOccurs_shouldHandleError() {
        // Arrange: Mock an error response for local use case
        mockGetLocalUseCase.error = NSError(domain: "TestError", code: 1, userInfo: nil)

        // Act: Fetch local data
        viewModel.handleAction(action: .setUserLogin(login: "user1"))

        // Assert: Verify that the error handling method is invoked
        XCTAssertTrue(viewModel.error != nil, "Error state should be updated when local data fetch fails")
    }

    // Mock classes
    final class MockGetGitUserDetailRemoteUseCase: GetGitUserDetailRemoteUseCase {
        var result: GitUserDetailModel?
        var error: Error?
        var invokeCalled = false

        init() {
            super.init(repository: MockGitUserDetailRepository())
        }

        override func invoke(userName: String) -> AnyPublisher<GitUserDetailModel, Error> {
            invokeCalled = true
            if let error = error {
                return Fail(error: error).eraseToAnyPublisher()
            }
            if let result = result {
                return Just(result)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            return Fail(error: MockError.testError).eraseToAnyPublisher()
        }
    }

    final class MockGetGitUserDetailLocalUseCase: GetGitUserDetailLocalUseCase {
        var result: GitUserDetailModel = MockUtil.userDetail
        var error: Error?
        var invokeCalled = false

        init() {
            super.init(repository: MockGitUserDetailRepository())
        }

        override func invoke(userName: String) -> AnyPublisher<GitUserDetailModel, Error> {
            invokeCalled = true
            if let error = error {
                return Fail(error: error).eraseToAnyPublisher()
            }
            return Just(result)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }

    // Unreachable class
    final class MockGitUserDetailRepository: GitUserDetailRepository {
        func getRemote(userName: String) async throws -> GitUserDetailModel {
            throw MockError.testError
        }

        func getLocal(userName: String) async throws -> GitUserDetailModel? {
            throw MockError.testError
        }
    }

    final class MockGitUserDetailUiMapper: GitUserDetailUiMapper {
        func mapToUiModel(oldUiModel: GitUserDetailUiModel, model: GitUserDetailModel) -> GitUserDetailUiModel {
            return GitUserDetailUiModel(
                login: model.login,
                name: model.name ?? model.login,
                avatarUrl: model.avatarUrl.orEmpty(),
                blog: model.blog.orEmpty(),
                location: model.location.ifNil(defaultValue: { R.string.localizable.not_set() }),
                followers: FollowerFormatter.formatLargeNumber(value: model.followers),
                following: FollowerFormatter.formatLargeNumber(value: model.following)
            )
        }
    }
}
