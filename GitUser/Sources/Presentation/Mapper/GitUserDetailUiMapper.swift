//
//  GitUserDetailUiMapper.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import Domain
import Foundation

protocol GitUserDetailUiMapper {
    func mapToUiModel(oldUiModel: GitUserDetailUiModel, model: GitUserDetailModel) -> GitUserDetailUiModel
}

class GitUserDetailUiMapperImpl: GitUserDetailUiMapper {
    
    func mapToUiModel(oldUiModel: GitUserDetailUiModel, model: GitUserDetailModel) -> GitUserDetailUiModel {
        return oldUiModel.copy(
            name: model.name ?? model.login,
            avatarUrl: model.avatarUrl.orEmpty(),
            blog: model.blog.orEmpty(),
            location: model.location.ifNil(defaultValue: { R.string.localizable.not_set() }),
            followers: FollowerFormatter.formatLargeNumber(value: model.followers),
            following: FollowerFormatter.formatLargeNumber(value: model.following)
        )
    }
}
