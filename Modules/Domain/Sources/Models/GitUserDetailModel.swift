//
//  GitUserDetailModel.swift
//  Domain
//
//  Created by Long Do on 31/12/2024.
//

import Foundation

public struct GitUserDetailModel: Identifiable, Equatable {
    public var id: Int64
    public var login: String
    public var name: String?
    public var avatarUrl: String?
    public var blog: String?
    public var location: String?
    public var followers: Int
    public var following: Int

    // Public initializer
    public init(
        id: Int64,
        login: String,
        name: String? = nil,
        avatarUrl: String? = nil,
        blog: String? = nil,
        location: String? = nil,
        followers: Int,
        following: Int
    ) {
        self.id = id
        self.login = login
        self.name = name
        self.avatarUrl = avatarUrl
        self.blog = blog
        self.location = location
        self.followers = followers
        self.following = following
    }
}
