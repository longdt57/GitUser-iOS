//
//  GetGitUserDetailRemoteUseCase.swift
//  iOS MVVM
//
//  Created by Long Do on 30/12/2024.
//

import Foundation
import Resolver
import Combine

public class GetGitUserDetailRemoteUseCase {
    
    @Injected var repository: GitUserDetailRepository
    
    // Convert to return an AnyPublisher
    func invoke(userName: String) -> AnyPublisher<GitUserDetailModel, Error> {
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
        .eraseToAnyPublisher()  // Convert to AnyPublisher
    }
}
