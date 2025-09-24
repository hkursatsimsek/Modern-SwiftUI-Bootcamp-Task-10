//
//  PokemonListView.swift
//  Modern-SwiftUI-Bootcamp-Task-10
//
//  Created by Kürşat Şimşek on 24.09.2025.
//


import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Pokémon")
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: Text("Ara"))
                .toolbarTitleMenu { }
        }
        .task { await viewModel.onAppear() }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView("Yükleniyor...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let message = viewModel.errorMessage {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(.yellow)
                Text(message).multilineTextAlignment(.center)
                Button("Tekrar Dene") { Task { await viewModel.fetch() } }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(viewModel.filtered) { item in
                NavigationLink(value: item.name) {
                    PokemonRowView(name: item.name, url: item.url)
                }
            }
            .navigationDestination(for: String.self) { name in
                PokemonDetailView(name: name)
            }
        }
    }
}

#Preview {
    PokemonListView()
}
