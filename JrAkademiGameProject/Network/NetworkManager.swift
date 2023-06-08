import Foundation
import Alamofire

struct NetworkManager {
    static let shared = NetworkManager()
    
    private let apiKey = "c58b253dd0d3487d93ee203a751e1ee0"
    private let baseUrl = "https://api.rawg.io/api/games"
    
    func fetchGames(pageSize: Int, completion: @escaping (Result<[GameModel], Error>) -> Void) {
        let parameters: [String: Any] = [
            "page_size": 8,
            "page": pageSize,
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
                           let id = result["id"] as? Int,
                           let genres = result["genres"] as? [[String: Any]] {
                            
                            var tags = [String]()
                            for genre in genres {
                                if let genreName = genre["name"] as? String {
                                    tags.append(genreName)
                                }
                            }
                       
                            let game = GameModel(gameName: name, metacritic: metacritic, image: backgroundImage, tags: tags, id: id)
                            
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
    
    func fetchGameDetails(id: Int, completion: @escaping (Result<GameDetailsModel, Error>) -> Void) {
        let url = "https://api.rawg.io/api/games/\(id)?key=c58b253dd0d3487d93ee203a751e1ee0"
     
        AF.request(url).responseDecodable(of: GameDetailsModel.self) { response in
            switch response.result {
            case .success(let gameDetails):
                completion(.success(gameDetails))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSearchGames(pageSize: Int, searchQuery: String, completion: @escaping (Result<[GameModel], Error>) -> Void) {
        let baseUrl = "https://api.rawg.io/api/games"
        let apiKey = "c58b253dd0d3487d93ee203a751e1ee0"
        
        let parameters: [String: Any] = [
            "page_size": 8,
            "page": pageSize,
            "search": searchQuery,
            "key": apiKey
        ]
        
        AF.request(baseUrl, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let results = json["results"] as? [[String: Any]] {
                    var games = [GameModel]()
                    
                    for result in results {
                        if let name = result["name"] as? String,
                           let backgroundImage = result["background_image"] as? String,
                           let id = result["id"] as? Int,
                           let genres = result["genres"] as? [[String: Any]] {
                            
                            var tags = [String]()
                            for genre in genres {
                                if let genreName = genre["name"] as? String {
                                    tags.append(genreName)
                                }
                            }
                            
                            let metacritic = result["metacritic"] as? Int ?? 0
                            
                            let game = GameModel(gameName: name, metacritic: metacritic, image: backgroundImage, tags: tags, id: id)
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
