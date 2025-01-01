//
//  GitUser.swift
//  Data
//
//  Created by Long Do on 30/12/2024.
//

import Domain
import Foundation
import RealmSwift

public class GitUser: Object, Codable {
    @Persisted(primaryKey: true) var id: Int64
    @Persisted var login: String
    @Persisted var avatarUrl: String?
    @Persisted var htmlUrl: String?

    public convenience init(id: Int64, login: String, avatarUrl: String? = nil, htmlUrl: String? = nil) {
        self.init()
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
    }

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
