//
//  CharacterListViewModelTests.swift
//  RM_MVVMTests
//
//  Created by Денис Ефименков on 10.03.2025.
//

import XCTest
import Combine
@testable import RM_MVVM

class CharacterListViewModelTests: XCTestCase {
    var viewModel: CharacterListViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = CharacterListViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchCharacters() {
        // Ожидание завершения асинхронной операции
        let expectation = XCTestExpectation(description: "Fetch characters")
        
        viewModel.$characters
            .dropFirst() // Игнорируем начальное значение
            .sink { characters in
                XCTAssertFalse(characters.isEmpty)
                expectation.fulfill() // Завершаем ожидание
            }
            .store(in: &cancellables)
        
        viewModel.fetchCharacters()
        
        // Ожидаем завершения в течение 5 секунд
        wait(for: [expectation], timeout: 5)
    }
    
    func testFilterCharactersByName() {
        // Моковые данные
        viewModel.characters = [
            Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", type: "", gender: "Male", origin: Location(name: "Earth", url: ""), location: Location(name: "Earth", url: ""), image: "", episode: [], url: "", created: ""),
            Character(id: 2, name: "Morty Smith", status: "Alive", species: "Human", type: "", gender: "Male", origin: Location(name: "Earth", url: ""), location: Location(name: "Earth", url: ""), image: "", episode: [], url: "", created: ""),
            Character(id: 3, name: "Summer Smith", status: "Alive", species: "Human", type: "", gender: "Female", origin: Location(name: "Earth", url: ""), location: Location(name: "Earth", url: ""), image: "", episode: [], url: "", created: "")
        ]
        
        // Фильтрация по имени
        let filtered = viewModel.filteredCharacters(searchText: "Rick")
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.name, "Rick Sanchez")
    }
    
    func testFilterCharactersByStatus() {
        // Моковые данные
        viewModel.characters = [
            Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", type: "", gender: "Male", origin: Location(name: "Earth", url: ""), location: Location(name: "Earth", url: ""), image: "", episode: [], url: "", created: ""),
            Character(id: 2, name: "Morty Smith", status: "Alive", species: "Human", type: "", gender: "Male", origin: Location(name: "Earth", url: ""), location: Location(name: "Earth", url: ""), image: "", episode: [], url: "", created: ""),
            Character(id: 3, name: "Summer Smith", status: "Alive", species: "Human", type: "", gender: "Female", origin: Location(name: "Earth", url: ""), location: Location(name: "Earth", url: ""), image: "", episode: [], url: "", created: "")
        ]
        
        // Фильтрация по статусу
        let filtered = viewModel.filteredCharacters(searchText: "Alive")
        XCTAssertEqual(filtered.count, 3)
    }
    
    func testFilterCharactersNoMatch() {
        // Моковые данные
        viewModel.characters = [
            Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", type: "", gender: "Male", origin: Location(name: "Earth", url: ""), location: Location(name: "Earth", url: ""), image: "", episode: [], url: "", created: ""),
            Character(id: 2, name: "Morty Smith", status: "Alive", species: "Human", type: "", gender: "Male", origin: Location(name: "Earth", url: ""), location: Location(name: "Earth", url: ""), image: "", episode: [], url: "", created: ""),
            Character(id: 3, name: "Summer Smith", status: "Alive", species: "Human", type: "", gender: "Female", origin: Location(name: "Earth", url: ""), location: Location(name: "Earth", url: ""), image: "", episode: [], url: "", created: "")
        ]
        
        // Фильтрация по несуществующему значению
        let filtered = viewModel.filteredCharacters(searchText: "Unknown")
        XCTAssertTrue(filtered.isEmpty)
    }
}
