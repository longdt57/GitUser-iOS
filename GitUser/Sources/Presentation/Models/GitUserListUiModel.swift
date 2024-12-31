//
//  GitUserListUiModel.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import Domain
import Foundation

struct GitUserListUiModel {
    var users: [GitUserModel] = []

    init(users: [GitUserModel] = []) {
        self.users = users
    }
}
