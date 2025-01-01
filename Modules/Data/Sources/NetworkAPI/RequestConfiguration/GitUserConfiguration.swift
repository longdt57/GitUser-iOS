//
//  GitUserConfiguration.swift
//  Data
//
//  Created by Long Do on 30/12/2024.
//

import Alamofire
import Foundation

enum GitUserConfiguration {
    case getUsers(since: Int, perPage: Int) // e.g., /users?per_page=20&since=0
    case getUserDetail(username: String) // e.g., /users/{username}
}

extension GitUserConfiguration: RequestConfiguration {
    var baseURL: String {
        return "https://api.github.com"
    }

    var endpoint: String {
        switch self {
        case .getUsers:
            return "users" // We leave the query parameters to be added in `parameters`
        case let .getUserDetail(username):
            return "users/\(username)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getUsers, .getUserDetail:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .getUsers(since, perPage):
            return [
                "per_page": perPage,
                "since": since
            ]
        case .getUserDetail:
            return nil
        }
    }

    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }

    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
}
