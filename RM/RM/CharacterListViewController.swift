//
//  CharacterListViewController.swift
//  RM
//
//  Created by Денис Ефименков on 10.03.2025.
//

import UIKit
import Combine
import Kingfisher
import SwiftUI

class CharacterListViewController: UIViewController {
    private var tableView = UITableView()
    private var characters: [Character] = [] // Исходный массив персонажей
    private var filteredCharacters: [Character] = [] // Отфильтрованный массив
    private var cancellables = Set<AnyCancellable>()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        fetchCharacters()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by name or status"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Добавляем сегментированный контрол для фильтрации по статусу
        let statusFilter = UISegmentedControl(items: ["All", "Alive", "Dead", "Unknown"])
        statusFilter.addTarget(self, action: #selector(statusFilterChanged(_:)), for: .valueChanged)
        statusFilter.selectedSegmentIndex = 0
        navigationItem.titleView = statusFilter
    }
    
    private func fetchCharacters() {
        RickAndMortyService.shared.fetchCharacters()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] characters in
                self?.characters = characters
                self?.filteredCharacters = characters // Изначально отображаем всех персонажей
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    // Обработка изменения фильтра по статусу
    @objc private func statusFilterChanged(_ sender: UISegmentedControl) {
        let selectedStatus = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "All"
        filterCharacters(searchText: searchController.searchBar.text, status: selectedStatus)
    }
    
    // Фильтрация персонажей по имени и статусу
    private func filterCharacters(searchText: String?, status: String) {
        filteredCharacters = characters.filter { character in
            let matchesName = searchText.isEmptyOrNil ? true : character.name.lowercased().contains(searchText!.lowercased())
            let matchesStatus = status == "All" ? true : character.status == status
            return matchesName && matchesStatus
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let character = filteredCharacters[indexPath.row]
        
        // Устанавливаем имя персонажа
        cell.textLabel?.text = character.name
        
        // Загружаем изображение с помощью Kingfisher
        if let imageURL = URL(string: character.image) {
            cell.imageView?.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "person.fill"))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = filteredCharacters[indexPath.row]
        let detailView = CharacterDetailView(character: character)
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension CharacterListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        let selectedStatus = (navigationItem.titleView as? UISegmentedControl)?.titleForSegment(at: (navigationItem.titleView as? UISegmentedControl)?.selectedSegmentIndex ?? 0) ?? "All"
        filterCharacters(searchText: searchText, status: selectedStatus)
    }
}

// MARK: - Вспомогательное расширение для String
extension Optional where Wrapped == String {
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}
