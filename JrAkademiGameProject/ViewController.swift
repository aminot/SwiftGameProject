import UIKit
import SnapKit

class ViewController: UIViewController {

    var customTabBarController: UITabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // TabBarController'ı oluştur
        customTabBarController = UITabBarController()

        // GamesViewController'ı oluştur
        let gamesViewController = GamesVC()
        gamesViewController.title = "Games"
        gamesViewController.tabBarItem = UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller"), tag: 0)
        let gamesNavigationController = UINavigationController(rootViewController: gamesViewController)
        gamesNavigationController.navigationBar.prefersLargeTitles = true

        // FavoritesViewController'ı oluştur
        let favoritesViewController = GamesVC()
        favoritesViewController.title = "Favorites"
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 1)
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        favoritesNavigationController.navigationBar.prefersLargeTitles = true

        // Arama çubuğunu oluştur
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        gamesNavigationController.navigationItem.searchController = searchController
        gamesNavigationController.navigationItem.hidesSearchBarWhenScrolling = false

        // TabBarController'a bölümleri ekle
        customTabBarController.viewControllers = [gamesNavigationController, favoritesNavigationController]

        // TabBarController'ı görüntüle
        addChild(customTabBarController)
        view.addSubview(customTabBarController.view)
        customTabBarController.didMove(toParent: self)

        // Arama çubuğunu GamesViewController'ın NavigationBar'ına ekle
        gamesViewController.navigationItem.searchController = searchController

        // TabBarController'ın constraints'lerini ayarla
        customTabBarController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
