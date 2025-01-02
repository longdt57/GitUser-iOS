//
//  GitUserListViewModel.swift
//  Git Users
//
//  Created by Long Do on 31/12/2024.
//

import Combine
import Domain
import Foundation

class GitUserListViewModel: BaseViewModel {

    @Published private(set) var uiModel: GitUserListUiModel = .init()

    private let useCase: GetGitUserUseCase

    init(useCase: GetGitUserUseCase, dispatchQueueProvider: DispatchQueueProvider) {
        self.useCase = useCase
        super.init(dispatchQueueProvider: dispatchQueueProvider)
    }

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

        // Call the useCase to fetch more users
        injectLoading(publisher: useCase.invoke(since: getSince(), perPage: GitUserListViewModel.PERPAGE))
            .subscribe(on: dispatchQueueProvider.backgroundQueue)
            .receive(on: dispatchQueueProvider.mainQueue)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        self?.handleError(error: error)
                    }
                },
                receiveValue: { [weak self] result in
                    self?.handleSuccess(result)
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
    
    override func onErrorPrimaryAction(errorState: ErrorState) {
        switch errorState {
            case .messageError(let messageError):
                if messageError.primaryButton == R.string.localizable.common_retry() {
                    handleAction(action: .loadMore)
                }
            default: break
        }
        super.onErrorPrimaryAction(errorState: errorState)
    }

    // Define constant for PER_PAGE
    private static let PERPAGE = 20
}
