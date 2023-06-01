import Foundation

class GamesViewModel {
    var games: [GameModel] = []
    
    func fetchGames(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchGames { [weak self] result in
            switch result {
            case .success(let games):
                self?.games = games
                completion()
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }
}
