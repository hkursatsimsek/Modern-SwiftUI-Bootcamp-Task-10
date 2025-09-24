//
//  PokemonDetailViewModel.swift
//  Modern-SwiftUI-Bootcamp-Task-10
//
//  Created by Kürşat Şimşek on 24.09.2025.
//


import Foundation
import Combine

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published private(set) var detail: PokemonDetail?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil

    private let name: String
    private let service: PokemonServicing

    init(name: String, service: PokemonServicing = PokemonService()) {
        self.name = name
        self.service = service
    }

    func onAppear() {
        if detail == nil {
            Task { await fetchDetail() }
        }
    }

    func fetchDetail() async {
        isLoading = true
        errorMessage = nil
        do {
            let data = try await service.fetchPokemonDetail(name: name)
            self.detail = data
            self.isLoading = false
        } catch {
            self.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            self.isLoading = false
        }
    }
}
