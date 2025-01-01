//
//  ErrorResponse.swift
//  Data
//
//  Created by Long Do on 02/01/2025.
//

import Domain
import Foundation

struct ErrorResponse: Codable {
    let message: String
}

extension ErrorResponse {
    func mapToDomain() -> ApiError {
        ApiError(message: message)
    }
}
