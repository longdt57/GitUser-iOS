//
//  GitUserDetailViewModel.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import Foundation
import Resolver
import Combine
import Domain

class GitUserDetailViewModel : BaseViewModel {
    
    @Published var uiModel = GitUserDetailUiModel()
    
    @Injected var getRemoteUseCase: GetGitUserDetailRemoteUseCase
    @Injected var getLocalUseCase: GetGitUserDetailLocalUseCase
    @Injected var gitUserDetailUiMapper: GitUserDetailUiMapper
    
    func handleAction(action: GitUserDetailAction) {
        switch action {
            case .setUserLogin(let login):
                setUserLogin(login)
        }
    }
    
    private func getLocal() {
        getLocalUseCase.invoke(userName: getLogin())
            .receive(on: dispatchQueueProvider.backgroundQueue)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.handleCompletion(completion: completion)
                },
                receiveValue: { [weak self] result in
                    self?.handleSuccess(result: result)
                })
            .store(in: &cancellables)
    }
    
    private func fetchRemote() {
        if (isDataEmpty()) {
            showLoading()
        }
        getRemoteUseCase.invoke(userName: getLogin())
            .receive(on: dispatchQueueProvider.backgroundQueue)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.handleCompletion(completion: completion)
                },
                receiveValue: { [weak self] result in
                    self?.handleSuccess(result: result)
                })
            .store(in: &cancellables)
    }
    
    private func setUserLogin(_ login: String) {
        uiModel.login = login
        getLocal()
        fetchRemote() // Refresh data from api
    }
    
    private func handleSuccess(result: GitUserDetailModel) {
        self.uiModel = gitUserDetailUiMapper.mapToUiModel(oldUiModel: uiModel, model: result)
    }
    
    override func handleError(error: any Error) {
        if (isDataEmpty()) {
            super.handleError(error: error)
        } else {
            #if DEBUG
            print(error)
            #endif
        }
    }
    
    private func isDataEmpty() -> Bool {
        return uiModel.name.isEmpty
    }
    
    private func getLogin() -> String {
        return uiModel.login
    }
}
