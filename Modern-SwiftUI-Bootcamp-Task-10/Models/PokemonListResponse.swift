//
//  PokemonListResponse.swift
//  Modern-SwiftUI-Bootcamp-Task-10
//
//  Created by Kürşat Şimşek on 24.09.2025.
//


import Foundation

// MARK: - List endpoint models
public struct PokemonListResponse: Codable, Equatable {
    public let count: Int
    public let next: URL?
    public let previous: URL?
    public let results: [NamedAPIResource]
}

public struct NamedAPIResource: Codable, Equatable, Identifiable {
    public var id: String { name }
    public let name: String
    public let url: URL
}

// MARK: - Detail endpoint model
public struct PokemonDetail: Codable, Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let sprites: Sprites
    public let height: Int
    public let weight: Int
    public let types: [PokemonTypeSlot]
}

public struct Sprites: Codable, Equatable {
    public let front_default: URL?
}

public struct PokemonTypeSlot: Codable, Equatable {
    public let slot: Int
    public let type: NamedAPIResourceLite
}

public struct NamedAPIResourceLite: Codable, Equatable {
    public let name: String
    public let url: URL
}
