//
//  GitUserDetailViewModel.swift
//  Git Users
//
//  Created by Long Do on 31/12/2024.
//

import Combine
import Domain
import Foundation

class GitUserDetailViewModel: BaseViewModel {

    @Published var uiModel = GitUserDetailUiModel()

    private let getRemoteUseCase: GetGitUserDetailRemoteUseCase
    private let getLocalUseCase: GetGitUserDetailLocalUseCase
    private let gitUserDetailUiMapper: GitUserDetailUiMapper

    init(
        dispatchQueueProvider: DispatchQueueProvider,
        getRemoteUseCase: GetGitUserDetailRemoteUseCase,
        getLocalUseCase: GetGitUserDetailLocalUseCase,
        gitUserDetailUiMapper: GitUserDetailUiMapper
    ) {
        self.getRemoteUseCase = getRemoteUseCase
        self.getLocalUseCase = getLocalUseCase
        self.gitUserDetailUiMapper = gitUserDetailUiMapper
        super.init(dispatchQueueProvider: dispatchQueueProvider)
    }

    func handleAction(action: GitUserDetailAction) {
        switch action {
        case let .setUserLogin(login):
            setUserLogin(login)
        }
    }

    private func getLocal() {
        getLocalUseCase.invoke(userName: getLogin())
            .receive(on: dispatchQueueProvider.backgroundQueue)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] result in
                    self?.handleSuccess(result: result)
                }
            )
            .store(in: &cancellables)
    }

    private func fetchRemote() {
        let execute: (Bool) -> AnyPublisher = { isEmpty in
            let publisher = self.getRemoteUseCase.invoke(userName: self.getLogin())
            return isEmpty ? self.injectLoading(publisher: publisher).eraseToAnyPublisher() : publisher
                .eraseToAnyPublisher()
        }

        execute(isDataEmpty())
            .subscribe(on: dispatchQueueProvider.backgroundQueue)
            .receive(on: dispatchQueueProvider.mainQueue)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.handleError(error: error)
                    }
                },
                receiveValue: { [weak self] result in
                    self?.handleSuccess(result: result)
                }
            )
            .store(in: &cancellables)
    }

    private func setUserLogin(_ login: String) {
        uiModel.login = login
        getLocal()
        fetchRemote() // Refresh data from api
    }

    private func handleSuccess(result: GitUserDetailModel) {
        uiModel = gitUserDetailUiMapper.mapToUiModel(oldUiModel: uiModel, model: result)
    }

    override func handleError(error: any Error) {
        if isDataEmpty() {
            super.handleError(error: error)
        } else {
            #if DEBUG
                print(error)
            #endif
        }
    }

    override func onErrorPrimaryAction(errorState: ErrorState) {
        switch errorState {
        case let .messageError(messageError):
            if messageError.primaryButton == R.string.localizable.common_retry() {
                fetchRemote()
            }
        default: break
        }
        super.onErrorPrimaryAction(errorState: errorState)
    }

    private func isDataEmpty() -> Bool {
        uiModel.name.isEmpty
    }

    private func getLogin() -> String {
        uiModel.login
    }
}
