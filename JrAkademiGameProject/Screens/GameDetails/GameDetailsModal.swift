//
//  GameDetailsModal.swift
//  JrAkademiGameProject
//
//  Created by ufuk donmez on 6.06.2023.
//

import Foundation
// MARK: - Welcome
struct GameDetailsModel: Decodable {
    let name: String?
    let descriptionRaw: String?
    let backgroundImageAdditional: String?
    let website: String?
    let redditURL: String?
    let metacritic:Int?
    let genres : [Genre]?
    
  enum CodingKeys: String, CodingKey {
    case name
    case descriptionRaw = "description_raw"
    case backgroundImageAdditional = "background_image_additional"
    case website
    case redditURL = "reddit_url"
    case metacritic
    case genres
  }
}


// MARK: - Genre

struct Genre: Codable {
    let name: String?
    enum CodingKeys: String, CodingKey {
        case name
    }
}
