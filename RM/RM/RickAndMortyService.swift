//
//  RickAndMortyService.swift
//  RM
//
//  Created by Денис Ефименков on 10.03.2025.
//

import Foundation
import Combine

class RickAndMortyService {
    static let shared = RickAndMortyService()
    private let baseURL = "https://rickandmortyapi.com/api"
    
    func fetchCharacters() -> AnyPublisher<[Character], Error> {
        let url = URL(string: "\(baseURL)/character")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
