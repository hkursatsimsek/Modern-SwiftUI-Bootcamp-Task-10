//
//  PokemonDetailView.swift
//  Modern-SwiftUI-Bootcamp-Task-10
//
//  Created by Kürşat Şimşek on 24.09.2025.
//


import SwiftUI

struct PokemonDetailView: View {
    @StateObject private var viewModel: PokemonDetailViewModel

    init(name: String) {
        _viewModel = StateObject(wrappedValue: PokemonDetailViewModel(name: name))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Yükleniyor...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let message = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(.yellow)
                    Text(message).multilineTextAlignment(.center)
                    Button("Tekrar Dene") { Task { await viewModel.fetchDetail() } }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let detail = viewModel.detail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if let url = detail.sprites.front_default {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 240)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(radius: 4)
                                        .frame(maxWidth: .infinity)
                                case .failure:
                                    Image(systemName: "photo").frame(maxWidth: .infinity)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .padding(.top)
                        }

                        Text(detail.name.capitalized)
                            .font(.largeTitle.bold())

                        HStack(spacing: 12) {
                            Label("Yükseklik: \(detail.height)", systemImage: "ruler")
                            Label("Ağırlık: \(detail.weight)", systemImage: "scalemass")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tipler").font(.headline)
                            HStack { ForEach(detail.types.sorted(by: { $0.slot < $1.slot }), id: \.slot) { slot in
                                Text(slot.type.name.capitalized)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.thinMaterial, in: Capsule())
                            }}
                        }

                        Spacer(minLength: 20)
                    }
                    .padding()
                }
            } else {
                Text("Bir hata oluştu")
            }
        }
        .navigationTitle(viewModel.detail?.name.capitalized ?? "Detay")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.onAppear() }
    }
}

#Preview {
    NavigationStack { PokemonDetailView(name: "bulbasaur") }
}
