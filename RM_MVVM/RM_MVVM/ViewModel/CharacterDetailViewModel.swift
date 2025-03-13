//
//  CharacterDetailViewModel.swift
//  RM_MVVM
//
//  Created by Денис Ефименков on 10.03.2025.
//

import Combine

class CharacterDetailViewModel: ObservableObject {
    @Published var episodes: [Episode] = []
    @Published var isLoading = false
    @Published var error: Error? = nil
    
    private var cancellables = Set<AnyCancellable>()
    let character: Character
    
    init(character: Character) {
        self.character = character
    }
    
    func fetchEpisodes() {
        isLoading = true
        let episodeURLs = character.episode
        
        Publishers.MergeMany(episodeURLs.map { RickAndMortyService.shared.fetchEpisode(url: $0) })
            .collect()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            }, receiveValue: { [weak self] episodes in
                self?.episodes = episodes
            })
            .store(in: &cancellables)
    }
}
