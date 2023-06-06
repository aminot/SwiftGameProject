import UIKit
import SnapKit
import Carbon

class GamesVC: UIViewController, UISearchControllerDelegate {
  
    
    var fromSearch = false
    var gamesViewModel: GamesViewModel? = GamesViewModel()
    private let tableView = UITableView()
    private let cellIdentifier = "Cell"
    var games: [GameModel] = []
    var page = 1
    var pageSearch = 1
    
  

 


    
    private let renderer = Renderer(
        adapter: CustomTableViewAdapter(),
        updater: UITableViewUpdater()
    )
    

    
    func getData() {
        gamesViewModel?.fetchGames(pageSize: page, completion: { [weak self] in
            if let fetchedGames = self?.gamesViewModel?.games {
                for gamee in fetchedGames {
                    print(gamee.gameName,"eeee",fetchedGames.count)
                }
                
                self?.games.append(contentsOf: fetchedGames)
                
         
                    self?.render()
                
            }
        })
    }

    func searchData(key: String) {
         fromSearch = true
        gamesViewModel?.fetchSearchGames(pageSize: pageSearch, searchQuery: key, completion: { [weak self] in
            if let fetchedGames = self?.gamesViewModel?.games {
                for gamee in fetchedGames {
                    print(gamee.gameName,"eeee",fetchedGames.count)
                }
                self?.games.removeAll() // games listesini temizle
          
                self?.games.append(contentsOf: fetchedGames)
                
            
                self?.render()
            
             
                
            }
        })
    }

    


  
    // Veriyi alma fonksiyonu
    @objc func veriAlindi(notification: Notification) {
        if let veri = notification.userInfo?["veri"] as? Bool {
            // Veriyi kullan
            // Örneğin, başka bir view controller'ı açmak ve veriyi göndermek:
            if(!fromSearch)
            {
                page += 1
                getData()
            }
         

            
            print("tttt", veri)
        }
        
    }
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
       // print("ufuk",renderer.adapter.aa)
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
        
        if(games.isEmpty){
            print("gameboş")
            
         
            let updateCell = CellNode(id: "aa", emptyComponent(name: "No game has been searched."))
                gameCells.append(updateCell)
       
            
            let helloSection = Section(id: "hello", cells: gameCells)
            sections.append(helloSection)
            
            renderer.render(sections)
            
        }
        
        else
        {
   
            
            
            if(fromSearch){
                gameCells.removeAll() // Tüm hücreleri silmek için
                
                let helloSection = Section(id: "hello", cells: gameCells)
                sections.append(helloSection)
                
                renderer.render(sections)
                
            }
            
            
            for game in games {
                let categories = game.tags.joined(separator: ", ")
                
                var  helloMesssage = HelloMessage(gameId: game.id, name: game.gameName,
                                 url: game.image,
                                 rating: game.metacritic,
                                 categories: game.tags)
                
                helloMesssage.tapGestureHandler = { [weak self] gameID in
                            print(gameID,"ufuk")
                                // click Handler

                              //  let detailsViewController = DetailsViewController()

                               // detailsViewController.gamesId = String(gameID)

                               // self?.navigationController?.pushViewController(detailsViewController, animated: true)

                            }
                
                let gameCell = CellNode(id: "aaa" , helloMesssage)
                gameCells.append(gameCell)
                print("ufukkk", game.gameName)
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


extension GamesVC:  UISearchBarDelegate {
    
    // Diğer kodlar ve işlevler
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fromSearch = false
        self.games.removeAll()
        page = 1
        getData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        fromSearch = true
       
        if searchText.count < 4 {
            self.games.removeAll()
            render()
        } else if searchText.count >= 4 {
            searchData(key: searchText)
        }
    }
}

