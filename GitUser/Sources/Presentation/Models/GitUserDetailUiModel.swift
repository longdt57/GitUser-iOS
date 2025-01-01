//
//  GitUserDetailUiModel.swift
//  Git Users
//
//  Created by Long Do on 31/12/2024.
//

import Foundation

struct GitUserDetailUiModel {
    var login: String
    var name: String
    var avatarUrl: String
    var blog: String
    var location: String
    var followers: String
    var following: String

    // Initializer with default values
    init(
        login: String = "",
        name: String = "",
        avatarUrl: String = "",
        blog: String = "",
        location: String = "",
        followers: String = "",
        following: String = ""
    ) {
        self.login = login
        self.name = name
        self.avatarUrl = avatarUrl
        self.blog = blog
        self.location = location
        self.followers = followers
        self.following = following
    }

    func copy(
        login: String? = nil,
        name: String? = nil,
        avatarUrl: String? = nil,
        blog: String? = nil,
        location: String? = nil,
        followers: String? = nil,
        following: String? = nil
    ) -> GitUserDetailUiModel {
        GitUserDetailUiModel(
            login: login ?? self.login,
            name: name ?? self.name,
            avatarUrl: avatarUrl ?? self.avatarUrl,
            blog: blog ?? self.blog,
            location: location ?? self.location,
            followers: followers ?? self.followers,
            following: following ?? self.following
        )
    }
}
