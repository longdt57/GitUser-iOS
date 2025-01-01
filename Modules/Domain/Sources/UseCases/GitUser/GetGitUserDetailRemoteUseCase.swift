//
//  GetGitUserDetailRemoteUseCase.swift
//  Git Users
//
//  Created by Long Do on 30/12/2024.
//

import Combine
import Foundation

public class GetGitUserDetailRemoteUseCase {

    public init(repository: GitUserDetailRepository) {
        self.repository = repository
    }

    private let repository: GitUserDetailRepository

    // Convert to return an AnyPublisher
    public func invoke(userName: String) -> AnyPublisher<GitUserDetailModel, Error> {
        // Wrap the async call in a Combine publisher (Future in this case)
        return Future { promise in
            Task {
                do {
                    let userDetail = try await self.repository.getRemote(userName: userName)
                    promise(.success(userDetail))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher() // Convert to AnyPublisher
    }
}
