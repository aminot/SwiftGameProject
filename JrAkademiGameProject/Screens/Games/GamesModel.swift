//
//  GameModel.swift
//  YourAppName
//
//  Created by YourName on 29.05.2023.
//

import Foundation

struct GameModel {
    let gameName: String
    let metacritic: Int
    let image: String
    let tags: [String]
    
    init(gameName: String, metacritic: Int, image: String, tags: [String]) {
        self.gameName = gameName
        self.metacritic = metacritic
        self.image = image
        self.tags = tags
    }
}
