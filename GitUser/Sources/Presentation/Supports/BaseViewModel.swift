//
//  BaseViewModel.swift
//  app
//
//  Created by Long Do.
//

import Combine
import Domain
import Foundation

open class BaseViewModel: ObservableObject {

    init(dispatchQueueProvider: DispatchQueueProvider) {
        self.dispatchQueueProvider = dispatchQueueProvider
    }

    @Published var loading: LoadingState = .none
    @Published var error: ErrorState = .none

    let dispatchQueueProvider: DispatchQueueProvider
    var cancellables = Set<AnyCancellable>()

    func showLoading() {
        loading = .loading()
    }

    func isLoading() -> Bool {
        if case .loading = loading {
            return true
        }
        return false
    }

    func hideLoading() {
        loading = .none
    }

    func handleError(error: Error) {
        switch error {
        case NetworkAPIError.noConnectivity:
            self.error = .messageError(ErrorState.MessageError.network())
        case NetworkAPIError.serverError:
            self.error = .messageError(ErrorState.MessageError.server())
        case let NetworkAPIError.apiError(apiError, httpCode, httpMessage):
            self.error = .messageError(ErrorState.MessageError.api(messageBody: apiError?.message))
        default:
            self.error = .messageError(ErrorState.MessageError.common)
        }
    }

    func hideError() {
        error = .none
    }
    
    func injectLoading<T: Publisher>(
        publisher: T
    ) -> Publishers.HandleEvents<T> {
        return publisher.handleEvents(
            receiveSubscription: { _ in
                self.showLoading()
            },
            receiveCompletion: { _ in
                self.hideLoading()
            }
        )
    }

    func onErrorPrimaryAction(errorState: ErrorState) {
        hideError()
    }

    func onErrorSecondaryAction(errorState: ErrorState) {
        hideError()
    }

    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}
