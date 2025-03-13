//
//  CharacterListViewModel.swift
//  RM_MVVM
//
//  Created by Денис Ефименков on 10.03.2025.
//

import Combine

class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var error: Error? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchCharacters() {
        isLoading = true
        RickAndMortyService.shared.fetchCharacters()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            }, receiveValue: { [weak self] characters in
                self?.characters = characters
            })
            .store(in: &cancellables)
    }
    
    // Фильтрация персонажей
    func filteredCharacters(searchText: String) -> [Character] {
        guard !searchText.isEmpty else {
            return characters
        }
        
        let lowercasedSearchText = searchText.lowercased()
        return characters.filter { character in
            character.name.lowercased().contains(lowercasedSearchText) ||
            character.status.lowercased().contains(lowercasedSearchText)
        }
    }
}
