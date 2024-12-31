//
//  NetworkAPI.swift
//

import Alamofire

public class NetworkAPI: NetworkAPIProtocol {

    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    public func performRequest<T: Decodable>(
        _ configuration: RequestConfiguration,
        for type: T.Type
    ) async throws -> T {
        try await request(
            session: Session(),
            configuration: configuration,
            decoder: decoder
        )
    }
}
