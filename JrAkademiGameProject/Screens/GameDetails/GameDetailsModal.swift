//
//  GameDetailsModal.swift
//  JrAkademiGameProject
//
//  Created by ufuk donmez on 6.06.2023.
//

import Foundation
// MARK: - Welcome
struct GameDetailsModal: Decodable {
  let name: String?
  let descriptionRaw: String?
  let backgroundImageAdditional: String?
  let website: String?
  let redditURL: String?
    
  enum CodingKeys: String, CodingKey {
    case name
    case descriptionRaw = "description_raw"
    case backgroundImageAdditional = "background_image_additional"
    case website
    case redditURL = "reddit_url"
  }
}
