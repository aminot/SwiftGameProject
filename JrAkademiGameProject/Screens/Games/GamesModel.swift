//
//  GameModel.swift
//  YourAppName
//
//  Created by YourName on 29.05.2023.
//

import Foundation

struct GameModel {
    let gameName: String
    let id: Int
    let metacritic: Int
    let image: String
    let tags: [String]
    init(gameName: String, metacritic: Int, image: String, tags: [String],id: Int) {
        self.gameName = gameName
        self.metacritic = metacritic
        self.image = image
        self.tags = tags
        self.id = id
    }
}
