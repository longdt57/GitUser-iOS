//
//  GetGitUserDetailLocalUseCase.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import Foundation
import Resolver
import Combine

public class GetGitUserDetailLocalUseCase {
    
    @Injected var repository: GitUserDetailRepository
    
    // Convert to return an AnyPublisher
    func invoke(userName: String) -> AnyPublisher<GitUserDetailModel, Error> {
        // Wrap the async call in a Combine publisher (Future in this case)
        return Future { promise in
            Task {
                do {
                    if let user = try await self.repository.getLocal(userName: userName) {
                        promise(.success(user))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()  // Convert to AnyPublisher
    }
}

