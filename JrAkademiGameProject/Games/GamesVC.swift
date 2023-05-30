import UIKit
import SnapKit

class GamesVc: UIViewController, UISearchBarDelegate {
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
        // Bottom Tab Navigation
        let tabBarController = UITabBarController()
        let gameViewController = UIViewController()
        let gameLabel = UILabel()
        gameViewController.tabBarItem = UITabBarItem(title: "Games", image: UIImage(named: "Vector"), selectedImage: UIImage(named: "aaaSelectedImage"))
        let favarotiesViewController = UIViewController()
        favarotiesViewController.view.backgroundColor = .white
        favarotiesViewController.title = "bbb"
        favarotiesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "Icon"), selectedImage: UIImage(named: "bbbSelectedImage"))
        tabBarController.viewControllers = [gameViewController, favarotiesViewController]
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
        
        // GAMES yazısı sadece gameViewController'a eklenecek
        let gamesLabel = UILabel()
        gamesLabel.text = "GAMES"
        gamesLabel.textAlignment = .left
        gamesLabel.font = UIFont(name: "Roboto", size: 34)
        gamesLabel.textColor = UIColor(named: "#000000")
        gameViewController.view.addSubview(gamesLabel)
        
        let boldFontDescriptor = gamesLabel.font.fontDescriptor.withSymbolicTraits(.traitBold)
        let boldFont = UIFont(descriptor: boldFontDescriptor!, size: gamesLabel.font.pointSize)
        gamesLabel.font = boldFont
        
        gamesLabel.snp.makeConstraints { make in
            make.leading.equalTo(gameViewController.view).offset(16)
            make.top.equalTo(gameViewController.view).offset(90)
            make.width.equalTo(109)
            make.height.equalTo(41)
        }
        
        // Search Bar
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for the games"
        gameViewController.view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.leading.equalTo(gameViewController.view).offset(16)
            make.top.equalTo(gamesLabel.snp.bottom).offset(9)
            make.trailing.equalTo(gameViewController.view).offset(-16)
        }
        
        searchBar.delegate = self
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // Hücre kimliği için GameTableViewCell sınıfını kaydet
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        gameViewController.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.trailing.equalTo(gameViewController.view)
            make.bottom.equalTo(tabBarController.tabBar.snp.top)
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Arama çubuğunda metin değiştiğinde yapılacak işlemler
        print("Arama çubuğunda yeni metin: \(searchText)")
    }
}

extension GamesVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GameTableViewCell ?? GameTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        
        // Veriyi al
        let game = games[indexPath.row]
        
        // Hücreyi yapılandır
        cell.configure(with: game)
        
        // Yapılandırılmış hücreyi döndür
        return cell
    }
}
