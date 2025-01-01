//
//  GetGitUserUseCase.swift
//  Git Users
//
//  Created by Long Do on 30/12/2024.
//

import Combine
import Foundation

public class GetGitUserUseCase {

    public init(repository: GitUserRepository) {
        self.repository = repository
    }

    private let repository: GitUserRepository

    // Use Future to wrap the async operation and return a Combine publisher
    public func invoke(since: Int, perPage: Int) -> AnyPublisher<[GitUserModel], Error> {
        return Future { promise in
            Task {
                do {
                    let localUsers = try await self.repository.getLocal(since: since, perPage: perPage)
                    if !localUsers.isEmpty {
                        promise(.success(localUsers))
                        return
                    } else {
                        let result = try await self.repository.getRemote(since: since, perPage: perPage)
                        promise(.success(result)) // Fulfill the promise with success
                    }
                } catch {
                    promise(.failure(error)) // Fulfill the promise with failure
                }
            }
        }
        .eraseToAnyPublisher() // Optionally, erase the type to return a more general publisher type
    }
}
