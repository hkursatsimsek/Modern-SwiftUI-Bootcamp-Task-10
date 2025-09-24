//
//  PokemonServicing.swift
//  Modern-SwiftUI-Bootcamp-Task-10
//
//  Created by Kürşat Şimşek on 24.09.2025.
//


import Foundation

public protocol PokemonServicing {
    func fetchPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponse
    func fetchPokemonDetail(name: String) async throws -> PokemonDetail
}

public final class PokemonService: PokemonServicing {
    private let client: APIRequesting
    private let baseURL = URL(string: "https://pokeapi.co/api/v2")!

    public init(client: APIRequesting = APIClient()) {
        self.client = client
    }

    public func fetchPokemonList(limit: Int = 50, offset: Int = 0) async throws -> PokemonListResponse {
        guard var comps = URLComponents(url: baseURL.appendingPathComponent("pokemon"), resolvingAgainstBaseURL: false) else {
            throw HTTPError.invalidURL
        }
        comps.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        guard let url = comps.url else { throw HTTPError.invalidURL }
        let decoder = JSONDecoder()
        return try await client.get(url, as: PokemonListResponse.self, decoder: decoder)
    }

    public func fetchPokemonDetail(name: String) async throws -> PokemonDetail {
        let url = baseURL.appendingPathComponent("pokemon/").appendingPathComponent(name.lowercased())
        let decoder = JSONDecoder()
        return try await client.get(url, as: PokemonDetail.self, decoder: decoder)
    }
}
