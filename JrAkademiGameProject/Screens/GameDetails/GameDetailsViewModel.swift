//
//  GameDetailsViewModel.swift
//  JrAkademiGameProject
//
//  Created by ufuk donmez on 6.06.2023.
//

import Foundation
import Alamofire
class GameDetailsViewModel {
    var gameDetails: GameDetailsModel?
    private var url: String?
    private let networkManager = NetworkManager()
    // MARK: DefaultRequest
    func fetchGames(gameId: Int, completion: @escaping (GameDetailsModel?) -> Void) {
        NetworkManager.shared.fetchGameDetails(id: gameId) { result in
            switch result {
            case .success(let gameDetails):
                // İstek başarılıysa gameDetails kullanılabilir
                completion(gameDetails) // gameDetails'i completion bloğuyla ViewController'a iletiyoruz
                print(gameDetails.metacritic , gameDetails.genres ,"ufukkkk")
                print(gameDetails.descriptionRaw)
                // Diğer özellikler için de gameDetails üzerinden erişim sağlanabilir
            case .failure(let error):
                // İstek başarısız olduysa hata işleme yapılabilir
                print(error.localizedDescription)
                completion(nil) // Hata durumunda nil değeriyle completion bloğunu çağırıyoruz
            }
        }
    }
}
