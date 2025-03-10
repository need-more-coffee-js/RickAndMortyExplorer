//
//  Character.swift
//  RM
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
    let origin: RMLocation
    let location: RMLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Episode: Decodable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, episode
        case airDate = "air_date"
    }
}

struct RMLocation: Decodable {
    let name: String
    let url: String
}

struct APIResponse: Decodable {
    let results: [Character]
}
