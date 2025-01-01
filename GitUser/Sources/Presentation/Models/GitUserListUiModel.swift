//
//  GitUserListUiModel.swift
//  Git Users
//
//  Created by Long Do on 31/12/2024.
//

import Domain
import Foundation

struct GitUserListUiModel {

    init(users: [GitUserModel] = []) {
        self.users = users
    }

    var users: [GitUserModel] = []
}
