//
//  CharacterListViewController.swift
//  RM
//
//  Created by Денис Ефименков on 10.03.2025.
//

import UIKit
import Combine
import SwiftGifOrigin
import SwiftUI


class CharacterListViewController: UIViewController {
    private var tableView = UITableView()
    private var characters: [Character] = []
    private var filteredCharacters: [Character] = []
    private var cancellables = Set<AnyCancellable>()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        fetchCharacters()
    }
    
    private func setupUI() {
        // Настройка таблицы
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Включаем динамическую высоту ячейки
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by name or status"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // UISegmentControl для фильтрации по статусу
        let statusFilter = UISegmentedControl(items: ["All", "Alive", "Dead", "Unknown"])
        statusFilter.addTarget(self, action: #selector(statusFilterChanged(_:)), for: .valueChanged)
        statusFilter.selectedSegmentIndex = 0
        navigationItem.titleView = statusFilter
    }
    
    private func fetchCharacters() {
        RickAndMortyService.shared.fetchCharacters()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] characters in
                self?.characters = characters
                self?.filteredCharacters = characters
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
    
    private func showFullScreenLoaderAndNavigate(to character: Character) {
        // Создаем и показываем FullScreenLoaderView
        let loaderView = FullScreenLoaderView(frame: view.bounds)
        view.addSubview(loaderView)
        
        // Задержка 2 секунды перед переходом
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            // Убираем лоадер
            loaderView.removeFromSuperview()
            
            // Переходим на CharacterDetailView
            let detailView = CharacterDetailView(character: character)
            let hostingController = UIHostingController(rootView: detailView)
            self?.navigationController?.pushViewController(hostingController, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        let character = filteredCharacters[indexPath.row]
        cell.configure(with: character)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = filteredCharacters[indexPath.row]
        showFullScreenLoaderAndNavigate(to: character)
    }
}

// MARK: - UISearchResultsUpdating
extension CharacterListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        filterCharacters(searchText: searchText)
    }
    
    private func filterCharacters(searchText: String?) {
        if let searchText = searchText, !searchText.isEmpty {
            filteredCharacters = characters.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else {
            filteredCharacters = characters
        }
        tableView.reloadData()
    }
}

// MARK: - Вспомогательное расширение для String
extension Optional where Wrapped == String {
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}
