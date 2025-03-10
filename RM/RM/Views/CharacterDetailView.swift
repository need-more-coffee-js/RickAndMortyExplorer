//
//  CharacterDetailView.swift
//  RM
//
//  Created by Денис Ефименков on 10.03.2025.
//

import SwiftUI
import Kingfisher
import Combine

struct CharacterDetailView: View {
    let character: Character
    @State private var episodes: [Episode] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            // Детали персонажа
            KFImage(URL(string: character.image))
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
            
            Text(character.name)
                .font(.title)
            Text("Status: \(character.status)")
                .foregroundColor(character.status == "Alive" ? .green : .red)
            Text("Species: \(character.species)")
            Text("Gender: \(character.gender)")
            
            
            Text("Episodes")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 20)
            
            // Список эпизодов
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(episodes, id: \.id) { episode in
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
        .navigationTitle(character.name)
        .onAppear {
            loadEpisodes()
        }
    }
    
    private func loadEpisodes() {
        let episodeURLs = character.episode
        var loadedEpisodes: [Episode] = []
        
        let group = DispatchGroup()
        
        for url in episodeURLs {
            group.enter()
            RickAndMortyService.shared.fetchEpisode(url: url)
                .sink(receiveCompletion: { _ in
                    group.leave()
                }, receiveValue: { episode in
                    loadedEpisodes.append(episode)
                })
                .store(in: &cancellables)
        }
        
        group.notify(queue: .main) {
            self.episodes = loadedEpisodes
            self.isLoading = false
        }
    }
    
    @State private var cancellables = Set<AnyCancellable>()
}
