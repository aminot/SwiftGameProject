import Foundation

class GamesViewModel {
    var games: [GameModel] = []
    
    func fetchGames(pageSize: Int, completion: @escaping () -> Void) {
        NetworkManager.shared.fetchGames(pageSize: pageSize) { [weak self] result in
            switch result {
            case .success(let games):
                self?.games = games // Gelen oyunları mevcut games dizisine ekleyin
       
                completion()
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }



}
