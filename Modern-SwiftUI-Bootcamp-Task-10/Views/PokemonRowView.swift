//
//  PokemonRowView.swift
//  Modern-SwiftUI-Bootcamp-Task-10
//
//  Created by Kürşat Şimşek on 24.09.2025.
//


import SwiftUI

struct PokemonRowView: View {
    let name: String
    let url: URL

    private var imageURL: URL? {
        // PokeAPI detail endpoint has sprites. For list, we can derive id from URL.
        // Example URL: https://pokeapi.co/api/v2/pokemon/1/
        let path = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let components = path.split(separator: "/")
        if let idString = components.last, let id = Int(idString) {
            return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
        }
        return nil
    }

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 48, height: 48)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    Image(systemName: "photo")
                        .frame(width: 48, height: 48)
                @unknown default:
                    EmptyView()
                }
            }
            Text(name.capitalized)
                .font(.body)
                .foregroundStyle(.primary)
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("\(name)"))
    }
}

#Preview {
    PokemonRowView(name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)
}
