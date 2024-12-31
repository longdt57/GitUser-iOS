//
//  GitUserDetail.swift
//
//  Created by Long Do on 30/12/2024.
//

import Domain
import Foundation
import RealmSwift

public class GitUserDetail: Object, Codable {

    @Persisted(primaryKey: true) var id: Int64
    @Persisted var login: String
    @Persisted var name: String?
    @Persisted var avatarUrl: String?
    @Persisted var blog: String?
    @Persisted var location: String?
    @Persisted var followers: Int?
    @Persisted var following: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case name
        case avatarUrl = "avatar_url"
        case blog
        case location
        case followers
        case following
    }
}

extension GitUserDetail {
    func mapToDomain() -> GitUserDetailModel {
        return GitUserDetailModel(
            id: id,
            login: login,
            name: name,
            avatarUrl: avatarUrl,
            blog: blog,
            location: location,
            followers: followers ?? 0, // Default to 0 if nil
            following: following ?? 0 // Default to 0 if nil
        )
    }
}
