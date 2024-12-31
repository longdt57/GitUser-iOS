//
//  BaseViewModel.swift
//  app
//
//  Created by Long Do.
//

import Combine
import Data
import Foundation
import Resolver

open class BaseViewModel: ObservableObject {

    @Injected var dispatchQueueProvider: DispatchQueueProvider

    @Published var loading: LoadingState = .none
    @Published var error: ErrorState = .none

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
        case NetworkAPIError.generic:
            self.error = .messageError(ErrorState.MessageError.common)
        case NetworkAPIError.dataNotFound:
            self.error = .messageError(ErrorState.MessageError.network())
        default:
            self.error = .messageError(ErrorState.MessageError.common)
        }
    }

    func hideError() {
        error = .none
    }

    func onErrorPrimaryAction() {
        hideError()
    }

    func onErrorSecondaryAction() {
        hideError()
    }

    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
}

extension BaseViewModel {

    func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case let .failure(error):
            handleError(error: error)
        }
        hideLoading()
    }
}
