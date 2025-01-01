//
//  GitUserRepositoryImpl.swift
//  Data
//
//  Created by Long Do on 30/12/2024.
//

import Domain

public class GitUserRepositoryImpl: GitUserRepository {

    public init(networkAPI: NetworkAPIProtocol, gitUserLocalSource: GitUserLocalSource) {
        self.networkAPI = networkAPI
        self.gitUserLocalSource = gitUserLocalSource
    }

    private let networkAPI: NetworkAPIProtocol
    private let gitUserLocalSource: GitUserLocalSource

    public func getRemote(since: Int, perPage: Int) async throws -> [GitUserModel] {
        let configuration = GitUserConfiguration.getUsers(since: since, perPage: perPage)
        let users: [GitUser] = try await networkAPI.performRequest(configuration, for: [GitUser].self)
        saveToLocal(users: users)
        return mapToDomain(users)
    }

    public func getLocal(since: Int, perPage: Int) async throws -> [GitUserModel] {
        let users = try await gitUserLocalSource.getUsers(since: since, perPage: perPage)
        return mapToDomain(users)
    }

    private func mapToDomain(_ users: [GitUser]) -> [GitUserModel] {
        return users.map { $0.mapToDomain() }
    }

    private func saveToLocal(users: [GitUser]) {
        gitUserLocalSource.upsert(users: users)
    }
}
