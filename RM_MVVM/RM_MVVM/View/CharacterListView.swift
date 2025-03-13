//
//  CharacterListView.swift
//  RM_MVVM
//
//  Created by Денис Ефименков on 10.03.2025.
//

import SwiftUI

struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Поле поиска
                SearchBar(text: $searchText, placeholder: "Search by name or status")
                    .padding(.horizontal)
                
                // Список персонажей
                List {
                    ForEach(viewModel.filteredCharacters(searchText: searchText)) { character in
                        NavigationLink(destination: CharacterDetailView(character: character)) {
                            CharacterCell(character: character)
                        }
                    }
                }
                .navigationTitle("Characters")
                .overlay {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchCharacters()
        }
    }
}

// SearchBar
struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
    }
}
