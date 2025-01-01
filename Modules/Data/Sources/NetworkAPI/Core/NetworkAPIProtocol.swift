//
//  NetworkAPIProtocol.swift
//

import Alamofire
import Domain

public protocol NetworkAPIProtocol {

    func performRequest<T: Decodable>(
        _ configuration: RequestConfiguration,
        for type: T.Type
    ) async throws -> T
}

extension NetworkAPIProtocol {

    func request<T: Decodable>(
        session: Session,
        configuration: RequestConfiguration,
        decoder: JSONDecoder
    ) async throws -> T {
        do {
            return try await session.request(
                configuration.url,
                method: configuration.method,
                parameters: configuration.parameters,
                encoding: configuration.encoding,
                headers: configuration.headers,
                interceptor: configuration.interceptor
            )
            .serializingDecodable(T.self)
            .value
        } catch {
            throw error.mapToNetworkError()
        }
    }
}

extension Error {
    func mapToNetworkError() -> Error {
        if let afError = self as? AFError {
            // Handle Alamofire-specific errors
            switch afError {
            case let .sessionTaskFailed(error: underlyingError):
                if let urlError = underlyingError as? URLError,
                   urlError.code == .notConnectedToInternet {
                    return NetworkAPIError.noConnectivity
                }
            case .responseSerializationFailed(reason: .inputDataNilOrZeroLength):
                return NetworkAPIError.serverError
            default:
                break
            }

            // Try to parse and map API error only if underlyingError is Data
            if let responseData = afError.underlyingError as? Data {
                let apiError = parseApiError(responseData: responseData)
                return NetworkAPIError.apiError(
                    apiError,
                    httpCode: afError.responseCode ?? -1,
                    httpMessage: afError.errorDescription
                )
            } else {
                // In case the underlyingError is not Data, just return a default API error
                return NetworkAPIError.apiError(
                    nil,
                    httpCode: afError.responseCode ?? -1,
                    httpMessage: afError.errorDescription
                )
            }
        }

        // Default: Return self for unknown error types
        return self
    }

    private func parseApiError(responseData: Data) -> ApiError? {
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
            return errorResponse.mapToDomain()
        } catch {
            print("Failed to decode error response: \(error)")
            return nil
        }
    }
}
