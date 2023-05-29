import Foundation
import Alamofire

class GamesViewModel {
    let apiKey = "3be8af6ebf124ffe81d90f514e59856c"
    let baseUrl = "https://api.rawg.io/api/games"
    
    var games: [GameModel] = [] // Dizi özelliği tanımla ve başlangıçta boş bir diziyle başlat
    
    func fetchGames(completion: @escaping () -> Void) {
        let parameters: [String: Any] = [
            "page_size": 10,
            "page": 1,
            "key": apiKey
        ]
        
        AF.request(baseUrl, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                // İstek başarılı, verileri işleyin
                if let json = value as? [String: Any], let results = json["results"] as? [[String: Any]] {
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
                            
                    
                            // Oyunu games dizisine ekle
                            self.games.append(game)
                        }
                        completion() // Veri çekme tamamlandığında completion closure'ını çağır
                        
                    }
                }
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }
}
