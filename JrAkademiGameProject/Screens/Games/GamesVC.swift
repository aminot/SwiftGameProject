import UIKit
import SnapKit

class GamesVC: UIViewController {
    var gamesViewModel: GamesViewModel? = GamesViewModel()
    private let tableView = UITableView()
    private let cellIdentifier = "Cell"
    var games: [GameModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesViewModel?.fetchGames(completion: { [weak self] in
            // Veri çekme tamamlandığında closure içinde güncelleme yap
            if let gamesViewModel = self?.gamesViewModel {
                self?.games = gamesViewModel.games

                DispatchQueue.main.async {
                    // TableView'ı güncelle
                    self?.tableView.reloadData()
                }
            }
        })

        setupUI()
    }
    
    private func setupUI() {
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension GamesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GameTableViewCell ?? GameTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        
        let game = games[indexPath.row]
        cell.configure(with: game)
        
        return cell
    }
}
