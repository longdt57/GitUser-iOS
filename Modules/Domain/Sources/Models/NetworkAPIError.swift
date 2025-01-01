//
//  NetworkAPIError.swift
//  Domain
//
//  Created by Long Do on 02/01/2025.
//

import Foundation

public enum NetworkAPIError: Error {
    case noConnectivity
    case serverError
    case apiError(ApiError?, httpCode: Int, httpMessage: String?)
}

// API Error Model
public struct ApiError {
    public let message: String

    public init(message: String) {
        self.message = message
    }
}
