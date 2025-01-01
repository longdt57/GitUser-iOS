//
//  Resolver+Injection.swift
// iOS MVVM
//
//  Created by Do, LongThanh | MDSD on 2024/11/25.
//

import Data
import Domain
import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        defaultScope = .graph

        registerJson()
        registerNetwork()
        registerLocalSource()
        registerRepositories()
        registerUseCases()
        registerDispatchQueueProvider()
        registerMappers()
        registerViewModel()
    }

    private static func registerJson() {
        register(JSONDecoder.self) {
            JSONDecoder()
        }.scope(.application)
    }

    private static func registerNetwork() {
        register(NetworkAPIProtocol.self) { NetworkAPI(decoder: resolve()) }
    }

    private static func registerLocalSource() {
        register(GitUserLocalSource.self) { GitUserLocalSourceImpl() }
        register(GitUserDetailLocalSource.self) { GitUserDetailLocalSourceImpl() }
    }

    private static func registerRepositories() {
        register(GitUserRepository.self) { GitUserRepositoryImpl(networkAPI: resolve(), gitUserLocalSource: resolve()) }
        register(GitUserDetailRepository.self) { GitUserDetailRepositoryImpl(
            networkAPI: resolve(),
            gitUserDetailLocalSource: resolve()
        ) }
    }

    private static func registerUseCases() {
        register(GetGitUserUseCase.self) { GetGitUserUseCase(repository: resolve()) }
        register(GetGitUserDetailRemoteUseCase.self) { GetGitUserDetailRemoteUseCase(repository: resolve()) }
        register(GetGitUserDetailLocalUseCase.self) { GetGitUserDetailLocalUseCase(repository: resolve()) }
    }

    private static func registerViewModel() {
        register(GitUserListViewModel.self) {
            GitUserListViewModel(useCase: resolve(), dispatchQueueProvider: resolve())
        }
        register(GitUserDetailViewModel.self) { GitUserDetailViewModel(
            dispatchQueueProvider: resolve(),
            getRemoteUseCase: resolve(),
            getLocalUseCase: resolve(),
            gitUserDetailUiMapper: resolve()
        ) }
    }

    private static func registerDispatchQueueProvider() {
        register(DispatchQueueProvider.self) { DefaultDispatchQueueProvider() }
    }

    private static func registerMappers() {
        register(GitUserDetailUiMapper.self) { GitUserDetailUiMapperImpl() }
    }
}
