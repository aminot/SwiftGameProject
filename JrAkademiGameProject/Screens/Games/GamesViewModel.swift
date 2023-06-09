import Foundation

class GamesViewModel {
     var games: [GameModel] = []
    private var page = 1
    private var pageSearch = 1
    func getGames() -> [GameModel] {
        return games.isEmpty ? [] : games
    }
    func deleteGames() {
        page = 1
        games.removeAll()
       
    }
    func fetchGames(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchGames(pageSize: page) { [weak self] result in
            switch result {
            case .success(let games):
                self?.games.append(contentsOf: games)
                completion()
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }
    func fetchSearchGames(searchQuery: String, completion: @escaping () -> Void) {
        pageSearch = 1
        games.removeAll()
        NetworkManager.shared.fetchSearchGames(pageSize: pageSearch, searchQuery: searchQuery) { [weak self] result in
            switch result {
            case .success(let games):
                self?.games.append(contentsOf: games)
                completion()
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }
    func fetchSearchGames2(pageSearch: Int, searchQuery: String, completion: @escaping () -> Void) {
        NetworkManager.shared.fetchSearchGames(pageSize: pageSearch, searchQuery: searchQuery) { [weak self] result in
            switch result {
            case .success(let games):
                self?.games.append(contentsOf: games)
                completion()
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }
    func loadMoreGames(completion: @escaping () -> Void) {
        page += 1
        fetchGames(completion: completion)
    }
    func loadMoreSearchGames(searchQuery: String, completion: @escaping () -> Void) {
        pageSearch += 1
        fetchSearchGames(searchQuery: searchQuery, completion: completion)
    }
}
