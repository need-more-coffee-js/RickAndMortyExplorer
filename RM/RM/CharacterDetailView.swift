//
//  CharacterDetailView.swift
//  RM
//
//  Created by Денис Ефименков on 10.03.2025.
//

import SwiftUI
import Kingfisher

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        VStack {
            // Загружаем изображение с помощью Kingfisher
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
            Spacer()
        }
        .padding()
        .navigationTitle(character.name)
    }
}
