//
//  APIRequesting.swift
//  Modern-SwiftUI-Bootcamp-Task-10
//
//  Created by Kürşat Şimşek on 24.09.2025.
//


import Foundation

public protocol APIRequesting {
    func get<T: Decodable>(_ url: URL, as type: T.Type, decoder: JSONDecoder) async throws -> T
}

public final class APIClient: APIRequesting {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func get<T: Decodable>(_ url: URL, as type: T.Type, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalCacheData

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw HTTPError.invalidResponse }
            guard 200..<300 ~= http.statusCode else { throw HTTPError.statusCode(http.statusCode) }
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw HTTPError.decoding(error)
            }
        } catch {
            if let httpError = error as? HTTPError { throw httpError }
            throw HTTPError.transport(error)
        }
    }
}
