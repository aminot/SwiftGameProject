import UIKit
import CoreData
import SnapKit
import Carbon

class GamesVC: UIViewController, UISearchControllerDelegate {

    var fromSearch = false
    var tempKey : String = ""
   var searchBarLoadingPage = 1
    var gamesViewModel: GamesViewModel? = GamesViewModel()
    private let tableView = UITableView()
    private let cellIdentifier = "Cell"

    private let renderer = Renderer(
        adapter: CustomTableViewAdapter(),
        updater: UITableViewUpdater()
    )

    func getData() {
        gamesViewModel?.fetchGames(completion: { [weak self] in
            if let fetchedGames = self?.gamesViewModel?.getGames() {
                self?.render()
            }
        })
    }

    func searchData(key: String) {
        fromSearch = true
        gamesViewModel?.fetchSearchGames(searchQuery: key, completion: { [weak self] in
            if let fetchedGames = self?.gamesViewModel?.getGames() {
                self?.render()
            }
        })
    }
    func searchData2(key: String) {
        fromSearch = true
        gamesViewModel?.fetchSearchGames2(pageSearch: searchBarLoadingPage, searchQuery: key, completion: { [weak self] in
            if let fetchedGames = self?.gamesViewModel?.getGames() {
                self?.render()
            }
        })
    }
    

    @objc func veriAlindi(notification: Notification) {
        if let veri = notification.userInfo?["veri"] as? Bool {
            if !fromSearch {
                gamesViewModel?.loadMoreGames(completion: { [weak self] in
                    self?.render()
                })
            }
            else
            {
                if  (gamesViewModel?.games.count)! > 6 {
                    searchBarLoadingPage += 1
                    searchData2(key:tempKey)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController

        NotificationCenter.default.addObserver(self, selector: #selector(veriAlindi(notification:)), name: NSNotification.Name("İslemTamamlandi"), object: nil)

        title = "Games"
        tableView.contentInset.top = -25
        tableView.separatorStyle = .none
        renderer.target = tableView

        setupUI()
    }

    func render() {
        var sections: [Section] = []
        var gameCells: [CellNode] = []

        let fetchedGames = gamesViewModel?.getGames() ?? []

        if fetchedGames.isEmpty {


            let updateCell = CellNode(id: "aa", EmptyComponent(name: "No game has been searched."))
            gameCells.append(updateCell)

            let helloSection = Section(id: "hello", cells: gameCells)
            sections.append(helloSection)

            renderer.render(sections)
        } else {
        

            for game in fetchedGames {
                var helloMesssage = HelloMessage(gameId: game.id, name: game.gameName, url: game.image, rating: game.metacritic, categories: game.tags)

                helloMesssage.tapGestureHandler = { [weak self] gameID in
                    let detailsViewController = DetailsViewController()
                    detailsViewController.gameId = gameID
                    self?.navigationController?.pushViewController(detailsViewController, animated: true)
                }

                let gameCell = CellNode(id: "aaa", helloMesssage)
                gameCells.append(gameCell)
            }
                
            if(!fromSearch){
                let updateCell = CellNode(id: "aa", LoadingCell())
                gameCells.append(updateCell)
            }
          

            let helloSection = Section(id: "hello", cells: gameCells)
            sections.append(helloSection)

            renderer.render(sections)
        }
    }

    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.backgroundColor = UIColor(red: 0xF8/255, green: 0xF8/255, blue: 0xF8/255, alpha: 1.0)
    }
}

extension GamesVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBarLoadingPage = 1
        fromSearch = false
        gamesViewModel?.deleteGames()
        gamesViewModel?.fetchGames(completion: { [weak self] in
            self?.render()
        })
      render()
    
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fromSearch = true
   
        if searchText.count < 4 {
            gamesViewModel?.deleteGames()
       
            self.render()
       
        } else if searchText.count >= 4 {
            tempKey = searchText
            searchData(key: searchText)
        }
    }
}
