//
//  CharacterDetailViewModelTests.swift
//  RM_MVVMTests
//
//  Created by Денис Ефименков on 10.03.2025.
//

import XCTest
import Combine
@testable import RM_MVVM

class CharacterDetailViewModelTests: XCTestCase {
    var viewModel: CharacterDetailViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        let character = Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", type: "", gender: "Male", origin: Location(name: "Earth", url: ""), location: Location(name: "Earth", url: ""), image: "", episode: ["https://rickandmortyapi.com/api/episode/1"], url: "", created: "")
        viewModel = CharacterDetailViewModel(character: character)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchEpisodes() {
        // Ожидание завершения асинхронной операции
        let expectation = XCTestExpectation(description: "Fetch episodes")
        
        viewModel.$episodes
            .dropFirst() // Игнорируем начальное значение
            .sink { episodes in
                XCTAssertFalse(episodes.isEmpty)
                expectation.fulfill() // Завершаем ожидание
            }
            .store(in: &cancellables)
        
        viewModel.fetchEpisodes()
        
        // Ожидаем завершения в течение 5 секунд
        wait(for: [expectation], timeout: 5)
    }
}
