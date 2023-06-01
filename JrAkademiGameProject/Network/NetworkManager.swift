import Foundation
import Alamofire

struct NetworkManager {
    static let shared = NetworkManager()
    
    private let apiKey = "3be8af6ebf124ffe81d90f514e59856c"
    private let baseUrl = "https://api.rawg.io/api/games"
    
    func fetchGames(completion: @escaping (Result<[GameModel], Error>) -> Void) {
        let parameters: [String: Any] = [
            "page_size": 6,
            "page": 1,
            "key": apiKey
        ]
        
        AF.request(baseUrl, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let results = json["results"] as? [[String: Any]] {
                    var games = [GameModel]()
                    
                    for result in results {
                        if let name = result["name"] as? String,
                           let metacritic = result["metacritic"] as? Int,
                           let backgroundImage = result["background_image"] as? String,
                           let genres = result["genres"] as? [[String: Any]] {
                            
                            var tags = [String]()
                            for genre in genres {
                                if let genreName = genre["name"] as? String {
                                    tags.append(genreName)
                                }
                            }
                            
                            let game = GameModel(gameName: name, metacritic: metacritic, image: backgroundImage, tags: tags)
                            
                            games.append(game)
                        }
                    }
                    
                    completion(.success(games))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
