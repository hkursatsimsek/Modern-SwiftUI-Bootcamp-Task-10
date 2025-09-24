//
//  PokemonListViewModel.swift
//  Modern-SwiftUI-Bootcamp-Task-10
//
//  Created by Kürşat Şimşek on 24.09.2025.
//


import Foundation
import Combine

@MainActor
final class PokemonListViewModel: ObservableObject {
    // Input
    @Published var searchText: String = ""

    // Output
    @Published private(set) var pokemons: [NamedAPIResource] = []
    @Published private(set) var filtered: [NamedAPIResource] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil

    private let service: PokemonServicing
    private var cancellables: Set<AnyCancellable> = []

    init(service: PokemonServicing = PokemonService()) {
        self.service = service
        bindSearch()
    }

    func onAppear() {
        if pokemons.isEmpty {
            Task { await fetch() }
        }
    }

    func fetch(limit: Int = 100, offset: Int = 0) async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await service.fetchPokemonList(limit: limit, offset: offset)
            self.pokemons = response.results
            self.filtered = self.applyFilter(self.searchText, to: response.results)
            self.isLoading = false
        } catch {
            self.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            self.isLoading = false
        }
    }

    private func bindSearch() {
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self else { return }
                self.filtered = self.applyFilter(text, to: self.pokemons)
            }
            .store(in: &cancellables)
    }

    private func applyFilter(_ text: String, to items: [NamedAPIResource]) -> [NamedAPIResource] {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return items }
        return items.filter { $0.name.localizedCaseInsensitiveContains(trimmed) }
    }
}
