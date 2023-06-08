import UIKit
import CoreData
import SnapKit
import Carbon

class FavoritesVC: UIViewController, UINavigationControllerDelegate {
    var fromSearch = false
    var gamesViewModel: FavoritesViewModel? = FavoritesViewModel()
    private let tableView = UITableView()
    private let cellIdentifier = "Cell"
    var gameArray: [GameData] = []
  
    private let renderer = Renderer(
        adapter: CustomFavoritesAdapter(),
        updater: UITableViewUpdater()
    )
    
    func getData() {
        gameArray.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["metacritic", "name", "image", "genres","id"]
        fetchRequest.returnsDistinctResults = true
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest) as! [NSDictionary]
            
            for result in results {
                if let metacritic = result["metacritic"] as? Int,
                   let id = result["id"] as? Int,
                   let name = result["name"] as? String,
                   let image = result["image"] as? String,
                   let genres = result["genres"] as? String {
                    let gameData = GameData(metacritic: metacritic, id: id, name: name, image: image, genres: genres)
                    gameArray.append(gameData)
                    print("metacritic:", metacritic)
                    print("id:", id)
                    print("name:", name)
                    print("image:", image)
                    print("genres:", genres)
                } else {
                    print("Hata: Veri uyumsuz veya eksik.")
                }
            }
            title = "Favorites (" + String(gameArray.count) + ")"
            self.tabBarItem.title = "Favorites"
            render()
            
        } catch let error as NSError {
            print("Could not fetch data: \(error), \(error.userInfo)")
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is FavoritesVC {
            getData()
           
            self.tabBarItem.title = "Favorites"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self

     
        tableView.contentInset.top = 0
        tableView.separatorStyle = .none
        renderer.target = tableView
        renderer.adapter.favoritesVC = self
        setupUI()
    }
    
    func render() {
        var sections: [Section] = []
        var gameCells: [CellNode] = []
        
        if gameArray.isEmpty {
            let updateCell = CellNode(id: "aa", EmptyComponent(name: "No game has been searched."))
            gameCells.append(updateCell)
            let helloSection = Section(id: "hello", cells: gameCells)
            sections.append(helloSection)
        } else {
            for gameData in gameArray {
                var helloMessage = HelloMessage(gameId: gameData.id,
                                                name: gameData.name,
                                                url: gameData.image,
                                                rating: gameData.metacritic,
                                                categories: [gameData.genres])
                
                helloMessage.tapGestureHandler = { [weak self] gameId in
                    print(gameId, "ufuk")
                    // click Handler
                    let detailsViewController = DetailsViewController()
                    detailsViewController.gameId = gameId
                    self?.title = "Favorites"
                    self?.navigationController?.pushViewController(detailsViewController, animated: true)
                }
                
                let gameCell = CellNode(id: "aaa", helloMessage)
                gameCells.append(gameCell)
            }
            
            let helloSection = Section(id: "hello", cells: gameCells)
            sections.append(helloSection)
        }
        
        
        renderer.render(sections)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.backgroundColor = UIColor(red: 0xF8/255, green: 0xF8/255, blue: 0xF8/255, alpha: 1.0)
    }
}

