//
//  CharacterCell.swift
//  RM_MVVM
//
//  Created by Денис Ефименков on 10.03.2025.
//

import SwiftUI
import Kingfisher

struct CharacterCell: View {
    let character: Character
    
    var body: some View {
        HStack {
            // Изображение персонажа
            KFImage(URL(string: character.image))
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            // Имя персонажа
            Text(character.name)
                .font(.headline)
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
