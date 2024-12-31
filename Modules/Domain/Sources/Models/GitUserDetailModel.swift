//
//  GitUserDetailModel.swift
//  Domain
//
//  Created by Long Do on 31/12/2024.
//

import Foundation

public struct GitUserDetailModel: Identifiable, Equatable {
    public let id: Int64
    public let login: String
    public let name: String?
    public let avatarUrl: String?
    public let blog: String?
    public let location: String?
    public let followers: Int
    public let following: Int

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
