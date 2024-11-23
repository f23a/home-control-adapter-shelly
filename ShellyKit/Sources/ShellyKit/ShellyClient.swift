//
//  ShellyClient.swift
//  GoeKit
//
//  Created by Christoph Pageler on 30.04.24.
//

import Foundation

public class ShellyClient {
    public var baseURL: URL

    public init?(address: String) {
        guard let urlFromString = URL(string: "http://\(address)") else { return nil }
        baseURL = urlFromString
    }

    public func status() async throws -> ShellyStatusResponse {
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw ShellyError.failedToBuildURL
        }
        urlComponents.path = "/rpc/PM1.GetStatus"
        urlComponents.queryItems = [
            .init(name: "id", value: "0")
        ]
        guard let statusURL = urlComponents.url else { throw ShellyError.failedToBuildURL }
        let response = try await URLSession.shared.data(from: statusURL)
        return try JSONDecoder().decode(ShellyStatusResponse.self, from: response.0)
    }
}

public struct ShellyStatusResponse: Codable {
    public var apower: Double?
}

public enum ShellyError: Error {
    case failedToBuildURL
}
