//
//  BaseViewModelTests.swift
//  GitUserTests
//
//  Created by Long Do on 01/01/2025.
//

import Combine
@testable import Data
@testable import GitUser
import XCTest

class BaseViewModelTests: XCTestCase {

    // Test instance
    private var viewModel: BaseViewModel!
    private var mockDispatchQueueProvider: MockDispatchQueueProvider!

    override func setUp() {
        super.setUp()
        mockDispatchQueueProvider = MockDispatchQueueProvider()
        viewModel = BaseViewModel(dispatchQueueProvider: mockDispatchQueueProvider)
    }

    override func tearDown() {
        viewModel = nil
        mockDispatchQueueProvider = nil
        super.tearDown()
    }

    func testShowLoading() {
        // Arrange
        // The view model starts with .none, we will call showLoading

        // Act
        viewModel.showLoading()

        // Assert
        XCTAssertEqual(viewModel.loading, .loading())
    }

    func testIsLoading() {
        // Arrange
        // Initially, loading should be .none

        // Act
        let isLoadingInitially = viewModel.isLoading()
        viewModel.showLoading()
        let isLoadingAfterShow = viewModel.isLoading()
        viewModel.hideLoading()
        let isLoadingAfterHide = viewModel.isLoading()

        // Assert
        XCTAssertFalse(isLoadingInitially) // .none
        XCTAssertTrue(isLoadingAfterShow) // .loading
        XCTAssertFalse(isLoadingAfterHide) // .none
    }

    func testHideLoading() {
        // Arrange
        viewModel.showLoading() // Set to loading first

        // Act
        viewModel.hideLoading()

        // Assert
        XCTAssertEqual(viewModel.loading, .none)
    }

    func testHandleError_genericError() {
        // Arrange
        let error = NetworkAPIError.generic

        // Act
        viewModel.handleError(error: error)

        // Assert
        XCTAssertEqual(viewModel.error, .messageError(ErrorState.MessageError.common))
    }

    func testHandleError_dataNotFoundError() {
        // Arrange
        let error = NetworkAPIError.dataNotFound

        // Act
        viewModel.handleError(error: error)

        // Assert
        XCTAssertEqual(viewModel.error, .messageError(ErrorState.MessageError.network()))
    }

    func testHandleError_otherError() {
        // Arrange
        let error = NSError(domain: "SomeError", code: 1, userInfo: nil)

        // Act
        viewModel.handleError(error: error)

        // Assert
        XCTAssertEqual(viewModel.error, .messageError(ErrorState.MessageError.common))
    }

    func testHideError() {
        // Arrange
        viewModel.handleError(error: NetworkAPIError.generic) // Set error state

        // Act
        viewModel.hideError()

        // Assert
        XCTAssertEqual(viewModel.error, .none)
    }

    func testOnErrorPrimaryAction() {
        // Arrange
        viewModel.handleError(error: NetworkAPIError.generic) // Set error state

        // Act
        viewModel.onErrorPrimaryAction()

        // Assert
        XCTAssertEqual(viewModel.error, .none)
    }

    func testOnErrorSecondaryAction() {
        // Arrange
        viewModel.handleError(error: NetworkAPIError.generic) // Set error state

        // Act
        viewModel.onErrorSecondaryAction()

        // Assert
        XCTAssertEqual(viewModel.error, .none)
    }

    func testDeinit_cancelsCancellables() {
        // Arrange
        var viewModel: BaseViewModel? = BaseViewModel(dispatchQueueProvider: mockDispatchQueueProvider)

        // Act
        let cancellables = viewModel?.cancellables
        viewModel = nil

        // Assert
        XCTAssertEqual(cancellables?.isEmpty, true)
    }
}
