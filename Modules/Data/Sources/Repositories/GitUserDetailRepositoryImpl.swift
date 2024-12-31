//
//  GitUserDetailRepositoryImpl.swift
//  Data
//
//  Created by Long Do on 31/12/2024.
//

import Domain
import Resolver

public class GitUserDetailRepositoryImpl: GitUserDetailRepository {

    public init() {}

    @Injected var networkAPI: NetworkAPIProtocol
    @Injected var gitUserDetailLocalSource: GitUserDetailLocalSource

    public func getRemote(userName: String) async throws -> GitUserDetailModel {
        let configuration = GitUserConfiguration.getUserDetail(username: userName)
        let user = try await networkAPI.performRequest(configuration, for: GitUserDetail.self)
        saveToLocal(userDetail: user)
        return user.mapToDomain()
    }

    public func getLocal(userName: String) async throws -> GitUserDetailModel? {
        return try await gitUserDetailLocalSource.getUserDetailByLogin(login: userName)?.mapToDomain()
    }

    func saveToLocal(userDetail: GitUserDetail) {
        gitUserDetailLocalSource.upsert(userDetail: userDetail)
    }
}
