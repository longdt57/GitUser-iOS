//
//  MockUtil.swift
//  GitUserTests
//
//  Created by Long Do on 02/01/2025.
//

@testable import Domain
import Foundation

public enum MockUtil {
    public static let login = "longdt57"
    public static let userDetail = GitUserDetailModel(
        id: 8_809_113,
        login: "longdt57",
        name: "Logan",
        avatarUrl: "https://avatars.githubusercontent.com/u/8809113?v=4",
        blog: "https://www.linkedin.com/in/longdt57/",
        location: "Hanoi",
        followers: 10,
        following: 5
    )
}
