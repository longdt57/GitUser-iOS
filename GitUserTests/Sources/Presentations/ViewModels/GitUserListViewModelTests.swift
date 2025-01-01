//
//  GitUserListViewModelTests.swift
//  GitUserTests
//
//  Created by Long Do on 01/01/2025.
//

import Combine
@testable import Domain
@testable import GitUser
import XCTest

class GitUserListViewModelTests: AppXCTestCase {

    // Test instance
    private var viewModel: GitUserListViewModel!
    private var mockUseCase: MockGetGitUserUseCase!
    private var mockDispatchQueueProvider: MockDispatchQueueProvider!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockDispatchQueueProvider = MockDispatchQueueProvider()
        mockUseCase = MockGetGitUserUseCase(repository: MockGitUserRepository())
        viewModel = GitUserListViewModel(useCase: mockUseCase, dispatchQueueProvider: mockDispatchQueueProvider)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        mockDispatchQueueProvider = nil
        cancellables = nil
        super.tearDown()
    }

    func testHandleLoadIfEmpty_whenUsersEmpty_shouldLoadMore() {
        // Act: Call the action to load if empty
        viewModel.handleAction(action: .loadIfEmpty)

        // Assert: Verify that loadMore is triggered
        XCTAssertTrue(mockUseCase.invokeCalled, "loadMore should be triggered when users are empty")
    }

    func testHandleLoadIfEmpty_whenUsersEmpty() {
        // Arrange: Set up the initial state with users already loaded
        mockUseCase.result = [GitUserModel(id: 1, login: "user1", avatarUrl: nil, htmlUrl: nil)]

        // Act: Call the action to load if empty
        viewModel.handleAction(action: .loadIfEmpty)

        advanceUntilIdle()
        // Assert: Verify that result is as expected
        XCTAssertTrue(mockUseCase.invokeCalled, "loadMore should be triggered when users are empty")
        XCTAssertEqual(viewModel.uiModel.users.count, 1)
    }

    func testLoadMore_whenLoading_shouldNotLoadAgain() {
        // Arrange: Set up loading state
        viewModel.showLoading()

        // Act: Call loadMore while already loading
        viewModel.handleAction(action: .loadMore)

        // Assert: Verify that loadMore is not triggered again while loading
        XCTAssertFalse(mockUseCase.invokeCalled, "loadMore should not be called while already loading")
    }

    func testLoadMore_whenErrorOccurs_shouldHandleError() {
        // Arrange: Ensure the view model is not loading
        viewModel.hideLoading()

        // Mock error
        mockUseCase.error = NSError(domain: "TestError", code: 0, userInfo: nil)

        // Act: Call loadMore
        viewModel.handleAction(action: .loadMore)

        advanceUntilIdle()
        // Assert: Verify that error state is updated
        XCTAssertEqual(
            viewModel.error,
            .messageError(ErrorState.MessageError.common),
            "Error state should be updated when an error occurs"
        )
    }

    func testHandleSuccess_shouldAppendUsers() {
        // Arrange: Set up some users in the viewModel
        let initialUsers = [GitUserModel(id: 1, login: "user1", avatarUrl: nil, htmlUrl: nil)]
        mockUseCase.result = initialUsers
        viewModel.handleAction(action: .loadIfEmpty)
        advanceUntilIdle()

        // Act: Call handleSuccess with new users
        let newUsers = [GitUserModel(id: 2, login: "user2", avatarUrl: nil, htmlUrl: nil)]
        mockUseCase.result = initialUsers
        viewModel.handleAction(action: .loadMore)

        advanceUntilIdle()
        // Assert: Verify that the new users are appended
        XCTAssertEqual(
            viewModel.uiModel.users.count,
            initialUsers.count + newUsers.count,
            "Users should be appended to the uiModel"
        )
    }

    func testShowLoading_shouldUpdateLoadingState() {
        // Act: Call showLoading
        viewModel.showLoading()

        // Assert: Verify loading state is set to .loading
        XCTAssertTrue(viewModel.isLoading(), "Loading state should be .loading")
    }

    func testHideLoading_shouldUpdateLoadingState() {
        // Act: Call hideLoading
        viewModel.hideLoading()

        // Assert: Verify loading state is set to .none
        XCTAssertFalse(viewModel.isLoading(), "Loading state should be .none")
    }

    class MockGetGitUserUseCase: GetGitUserUseCase {
        var result: [GitUserModel] = []
        var error: Error?
        var invokeCalled = false // Flag to track if invoke is called

        override func invoke(since: Int, perPage: Int) -> AnyPublisher<[GitUserModel], Error> {
            invokeCalled = true // Set the flag when invoke is called
            if let error = error {
                return Fail(error: error).eraseToAnyPublisher()
            }
            return Just(result)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }

    // Unreachable code
    class MockGitUserRepository: GitUserRepository {
        func getRemote(since: Int, perPage: Int) async throws -> [GitUserModel] {
            throw MockError.testError
        }

        func getLocal(since: Int, perPage: Int) async throws -> [GitUserModel] {
            throw MockError.testError
        }
    }
}
