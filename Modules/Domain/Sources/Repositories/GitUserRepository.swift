//
//  GitUserRepository.swift
//  Git Users
//
//  Created by Long Do on 30/12/2024.
//

import Foundation

public protocol GitUserRepository {
    func getRemote(since: Int, perPage: Int) async throws -> [GitUserModel]
    func getLocal(since: Int, perPage: Int) async throws -> [GitUserModel]
}
