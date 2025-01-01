//
//  GitUserDetailRepositoryImpl.swift
//  Data
//
//  Created by Long Do on 31/12/2024.
//

import Domain

public class GitUserDetailRepositoryImpl: GitUserDetailRepository {

    public init(networkAPI: NetworkAPIProtocol, gitUserDetailLocalSource: GitUserDetailLocalSource) {
        self.networkAPI = networkAPI
        self.gitUserDetailLocalSource = gitUserDetailLocalSource
    }

    private let networkAPI: NetworkAPIProtocol
    private let gitUserDetailLocalSource: GitUserDetailLocalSource

    public func getRemote(userName: String) async throws -> GitUserDetailModel {
        let configuration = GitUserConfiguration.getUserDetail(username: userName)
        let user = try await networkAPI.performRequest(configuration, for: GitUserDetail.self)
        saveToLocal(userDetail: user)
        return user.mapToDomain()
    }

    public func getLocal(userName: String) async throws -> GitUserDetailModel? {
        return try gitUserDetailLocalSource.getUserDetailByLogin(login: userName)?.mapToDomain()
    }

    func saveToLocal(userDetail: GitUserDetail) {
        gitUserDetailLocalSource.upsert(userDetail: userDetail)
    }
}
