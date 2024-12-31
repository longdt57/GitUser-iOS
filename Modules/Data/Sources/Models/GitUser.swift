//
//  GitUser.swift
//  Data
//
//  Created by Long Do on 30/12/2024.
//

import Foundation
import RealmSwift
import Domain

public class GitUser: Object, Codable {
    @Persisted(primaryKey: true) var id: Int64
    @Persisted var login: String
    @Persisted var avatarUrl: String?
    @Persisted var htmlUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}

extension GitUser {
    func mapToDomain() -> GitUserModel {
        return GitUserModel(id: id, login: login, avatarUrl: avatarUrl, htmlUrl: htmlUrl)
    }
}
