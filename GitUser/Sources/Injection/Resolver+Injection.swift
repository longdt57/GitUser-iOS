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
        registerViewModel()
        registerUseCases()
        registerNetwork()
        registerLocalSource()
        registerRepositories()
        registerDispatchQueueProvider()
        registerMappers()
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
        register(GitUserLocalSource.self) { GitUserLocalSource() }
        register(GitUserDetailLocalSource.self) { GitUserDetailLocalSource() }
    }

    private static func registerRepositories() {
        register(GitUserRepository.self) { GitUserRepositoryImpl() }
        register(GitUserDetailRepository.self) { GitUserDetailRepositoryImpl() }
    }

    private static func registerUseCases() {
        register(GetGitUserUseCase.self) { GetGitUserUseCase() }
        register(GetGitUserDetailRemoteUseCase.self) { GetGitUserDetailRemoteUseCase() }
        register(GetGitUserDetailLocalUseCase.self) { GetGitUserDetailLocalUseCase() }
    }

    private static func registerViewModel() {
        register(GitUserListViewModel.self) { GitUserListViewModel() }
        register(GitUserDetailViewModel.self) { GitUserDetailViewModel() }
    }

    private static func registerDispatchQueueProvider() {
        register(DispatchQueueProvider.self) { DefaultDispatchQueueProvider() }
    }

    private static func registerMappers() {
        register(GitUserDetailUiMapper.self) { GitUserDetailUiMapperImpl() }
    }
}
