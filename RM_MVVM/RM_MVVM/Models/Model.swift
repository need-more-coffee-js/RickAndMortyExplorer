//
//  Model.swift
//  RM_MVVM
//
//  Created by Денис Ефименков on 10.03.2025.
//

import Foundation

struct Character: Decodable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String] // Ссылки на эпизоды
    let url: String
    let created: String
}

struct Location: Decodable {
    let name: String
    let url: String
}

struct Episode: Decodable, Identifiable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, episode
        case airDate = "air_date"
    }
}

struct APIResponse: Decodable {
    let results: [Character]
}
