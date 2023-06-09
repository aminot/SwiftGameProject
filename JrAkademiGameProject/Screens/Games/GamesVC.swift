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
    var idArray : [Int] = []
    var isTypingAllowed : Bool = true
    private let renderer = Renderer(
        adapter: CustomTableViewAdapter(),
        updater: UITableViewUpdater()
    )




    
    func getData() {
        gamesViewModel?.fetchGames(completion: { [weak self] in
            if let fetchedGames = self?.gamesViewModel?.getGames() {
                self?.render()
                self?.tableView.reloadData()
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

    func deleteAllData() {    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "JrAkademiGameProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Clicked")
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else { continue }
                context.delete(objectData)
            }
            try context.save()
        } catch let error {
            print("Error deleting data: \(error)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //getData()
       //getData()
        //fetchAllIDs()
       //deleteAllData()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getData()
        self.fetchAllIDs()
       
        
    }
    

    func fetchAllIDs(){
        var idArray: [Int] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return 
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Clicked")
        fetchRequest.propertiesToFetch = ["id"] // Burada "id" yerine varlıkta kullandığınız ID özelliğinin adını kullanmalısınız
        fetchRequest.resultType = .dictionaryResultType
        
        do {
            let results = try context.fetch(fetchRequest) as? [[String: Any]]
            
            for result in results ?? [] {
                if let id = result["id"] as? Int {
                    idArray.append(id)
                }
            }
        } catch let error as NSError {
            print("Could not fetch IDs. \(error), \(error.userInfo)")
        }
        self.idArray=idArray
   
    
 
    }

    
    func saveClicked(id : Int){
        // CoreData'deki veritabanı işlemlerini gerçekleştir
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Clicked", in: context)!
            let dataObject = NSManagedObject(entity: entity, insertInto: context)
            
            dataObject.setValue(id, forKeyPath: "id")
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
      
    }
 
    func checkId(_ id: Int) -> Bool {
        return idArray.contains(id)
    }
    
    func render() {
        var sections: [Section] = []
        var gameCells: [CellNode] = []

        let fetchedGames = gamesViewModel?.getGames() ?? []

        if fetchedGames.isEmpty {


            let updateCell = CellNode(id: "aa", EmptyComponent(name: "No game has been searched."))
            gameCells.append(updateCell)

            let gamesSection = Section(id: "hello", cells: gameCells)
            sections.append(gamesSection)

            renderer.render(sections)
        } else {
        

            for game in fetchedGames {
                var gamesCell : GamesCell
                if(checkId(game.id)){
                    gamesCell = GamesCell(gameId: game.id, name: game.gameName, url: game.image, rating: game.metacritic, categories: game.tags, color: UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0))
                    
                }
                else
                {
                    gamesCell = GamesCell(gameId: game.id, name: game.gameName, url: game.image, rating: game.metacritic, categories: game.tags, color: UIColor.white)
                }
              

                gamesCell.tapGestureHandler = { [weak self] gameID in
                    self?.saveClicked(id:gameID)
                 
                    let detailsViewController = DetailsViewController()
                    detailsViewController.gameId = gameID
                    self?.navigationController?.pushViewController(detailsViewController, animated: true)
                }

                let gameCell = CellNode(id: "aaa", gamesCell)
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
        gamesViewModel?.deleteGames()
        searchBarLoadingPage = 1
        fromSearch = false
        gamesViewModel?.deleteGames()
        gamesViewModel?.fetchGames(completion: { [weak self] in
          self?.render()
        })
      render()
    
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !isTypingAllowed {

                    searchBar.text = searchText
            if searchText.count < 4 {
                gamesViewModel?.deleteGames()
           
                self.render()
                self.tableView.reloadData()
           
            } else if searchText.count >= 4 {
                tempKey = searchText
                searchData(key: searchText)
                self.tableView.reloadData()
            }
            
        }
        fromSearch = true
   
  
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if !isTypingAllowed {
            return false
            }
        isTypingAllowed = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isTypingAllowed = true
        }
        return true
    }
    
}
