//
//  GitUserListViewModel.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import Combine
import Domain
import Foundation
import Resolver

class GitUserListViewModel: BaseViewModel {

    @Injected var useCase: GetGitUserUseCase

    @Published private(set) var uiModel: GitUserListUiModel = .init()

    func handleAction(action: GitUserListAction) {
        switch action {
        case .loadIfEmpty:
            loadIfEmpty()
        case .loadMore:
            loadMore()
        }
    }

    private func loadIfEmpty() {
        if uiModel.users.isEmpty {
            loadMore()
        }
    }

    private func loadMore() {
        if isLoading() { return }

        showLoading()

        // Call the useCase to fetch more users
        useCase.invoke(since: getSince(), perPage: GitUserListViewModel.PERPAGE)
            .receive(on: dispatchQueueProvider.backgroundQueue)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        self?.handleError(error: error)
                    }
                    // Hide loading once the operation completes
                    self?.dispatchQueueProvider.mainQueue.async {
                        self?.hideLoading()
                    }
                },
                receiveValue: { [weak self] result in
                    self?.dispatchQueueProvider.mainQueue.async {
                        self?.handleSuccess(result)
                    }
                }
            )
            .store(in: &cancellables)
    }

    private func handleSuccess(_ result: [GitUserModel]) {
        uiModel.users.append(contentsOf: result)
    }

    private func getSince() -> Int {
        return uiModel.users.count
    }

    // Define constant for PER_PAGE
    private static let PERPAGE = 20
}
