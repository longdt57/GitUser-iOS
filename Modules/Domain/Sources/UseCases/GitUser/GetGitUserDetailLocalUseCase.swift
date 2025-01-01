//
//  GetGitUserDetailLocalUseCase.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import Combine
import Foundation

public class GetGitUserDetailLocalUseCase {

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
                    if let user = try await self.repository.getLocal(userName: userName) {
                        promise(.success(user))
                    } else {
                        promise(.failure(NSError(
                            domain: "User Detail Local",
                            code: 404,
                            userInfo: [NSLocalizedDescriptionKey: "User not found."]
                        )))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher() // Convert to AnyPublisher
    }
}
