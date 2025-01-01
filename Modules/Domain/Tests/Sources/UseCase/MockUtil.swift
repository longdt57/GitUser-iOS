//
//  MockUtil.swift
//  DataTests
//
//  Created by Long Do on 01/01/2025.
//  Copyright © 2025 Nimble. All rights reserved.
//

import Foundation
@testable import Domain

public struct MockUtil {
    public static let login = "longdt57"
    public static let expectedUser = GitUserDetailModel(
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
