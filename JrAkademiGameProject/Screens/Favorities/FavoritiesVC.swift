import UIKit
import CoreData
import SnapKit
import Carbon

class FavoritiesVC: UIViewController, UINavigationControllerDelegate {
  
    
    var fromSearch = false
    var gamesViewModel: FavoritiesViewModel? = FavoritiesViewModel()
    private let tableView = UITableView()
    private let cellIdentifier = "Cell"
    var games: [GameModel] = []
    var metacriticArray: [Int] = []
    var nameArray: [String] = []
    var imageArray: [String] = []
    var genresArray: [String] = []
  

 


    
    private let renderer = Renderer(
   
        adapter: CustomFavoritesAdapter(),
        updater: UITableViewUpdater()
    )
    

    
    func getData() -> Bool {
        
        metacriticArray.removeAll()
         nameArray.removeAll()
         imageArray.removeAll()
         genresArray.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedObjectContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorities")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["metacritic", "name", "image", "genres"]
        fetchRequest.returnsDistinctResults = true
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest) as! [NSDictionary]
             
            for result in results {
                if let metacritic = result["metacritic"] as? Int {
                    metacriticArray.append(metacritic)
                    print("metacritic:", metacritic)
                } else {
                    print("Hata: metacritic değeri bulunamadı veya türü uyumsuz.")
                }

                if let name = result["name"] as? String {
                    nameArray.append(name)
                    print("name:", name)
                } else {
                    print("Hata: name değeri bulunamadı veya türü uyumsuz.")
                }

                if let image = result["image"] as? String {
                    imageArray.append(image)
                    print("image:", image)
                } else {
                    print("Hata: image değeri bulunamadı veya türü uyumsuz.")
                }

                if let genres = result["genres"] as? String {
                    genresArray.append(genres)
                    print("genres:", genres)
                } else {
                    print("Hata: genres değeri bulunamadı veya türü uyumsuz.")
                }

            }
            
            // Metacritic, name, image ve genres değerlerini içeren dizileri kullanabilirsiniz.
            print(metacriticArray)
            print(nameArray)
            print(imageArray)
            print(genresArray)
            render()
            
        } catch let error as NSError {
            print("Could not fetch data: \(error), \(error.userInfo)")
        }
        return false
    }



  

    
 
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        var isFirstAppearance = true
            
        if isFirstAppearance && viewController is FavoritiesVC {
                   isFirstAppearance = false
                   metacriticArray.removeAll()
                   nameArray.removeAll()
                   imageArray.removeAll()
                   genresArray.removeAll()
                   getData()
               }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
      //  getData()
       // print("ufuk",renderer.adapter.aa)
      
        title = "Favorites "
        tableView.contentInset.top = 0
        tableView.separatorStyle = .none
        renderer.target = tableView
 
        renderer.adapter.favoritiesVC = self

        setupUI()

    }
    
    
    func render() {
        var sections: [Section] = []
        var gameCells: [CellNode] = []
        
        if(nameArray.isEmpty){
     
            
         
            let updateCell = CellNode(id: "aa", emptyComponent(name: "No game has been searched."))
                gameCells.append(updateCell)
       
            
            let helloSection = Section(id: "hello", cells: gameCells)
            sections.append(helloSection)
            
            renderer.render(sections)
            
        }
        
        else
        {
   
            
            
       
            
            
            for index in 0..<nameArray.count {
                let name = nameArray[index]
                let url = imageArray[index]
                let rating = metacriticArray[index]
                let categories = [genresArray[index]]
                
                var helloMessage = HelloMessage(gameId: 1, name: name,
                                                url: url,
                                                rating: rating,
                                                categories: categories)
                
                let gameCell = CellNode(id: "aaa", helloMessage)
                gameCells.append(gameCell)
              
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




