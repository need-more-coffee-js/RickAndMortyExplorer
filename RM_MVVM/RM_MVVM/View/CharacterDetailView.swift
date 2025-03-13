//
//  CharacterDetailView.swift
//  RM_MVVM
//
//  Created by Денис Ефименков on 10.03.2025.
//

import SwiftUI
import Kingfisher

struct CharacterDetailView: View {
    @StateObject private var viewModel: CharacterDetailViewModel
    
    init(character: Character) {
        _viewModel = StateObject(wrappedValue: CharacterDetailViewModel(character: character))
    }
    
    var body: some View {
        VStack {
            KFImage(URL(string: viewModel.character.image))
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
            
            Text(viewModel.character.name)
                .font(.title)
            Text("Status: \(viewModel.character.status)")
                .foregroundColor(viewModel.character.status == "Alive" ? .green : .red)
            Text("Species: \(viewModel.character.species)")
            Text("Gender: \(viewModel.character.gender)")
            
            Text("Episodes")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 20)
            
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.episodes) { episode in
                            VStack(alignment: .leading) {
                                Text(episode.name)
                                    .font(.headline)
                                Text(episode.episode)
                                    .font(.subheadline)
                                Text(episode.airDate)
                                    .font(.caption)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(viewModel.character.name)
        .onAppear {
            viewModel.fetchEpisodes()
        }
    }
}
