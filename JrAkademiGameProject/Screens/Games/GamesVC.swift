import UIKit
import SnapKit
import Carbon

class GamesVC: UIViewController {
    var gamesViewModel: GamesViewModel? = GamesViewModel()
    private let tableView = UITableView()
    private let cellIdentifier = "Cell"
    var games: [GameModel] = []
    var page = 1

    var isToggled = false {
        didSet { render() }
    }
    
    private let renderer = Renderer(
        adapter: CustomTableViewAdapter(),
        updater: UITableViewUpdater()
    )
    

    
    func getData() {
        gamesViewModel?.fetchGames(pageSize: page, completion: { [weak self] in
            if let fetchedGames = self?.gamesViewModel?.games {
                for gamee in fetchedGames {
                    print(gamee.gameName,"pppp")
                }
                
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
            page += 1
            getData()
        

            
            print("ufuk", veri)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
       // print("ufuk",renderer.adapter.aa)
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
     
  
        for game in games {
            let categories = game.tags.joined(separator: ", ")
            
            let gameCell = CellNode(id: "", HelloMessage(name: game.gameName,
                                                         url: game.image,
                                                         rating: game.metacritic,
                                                         categories: game.tags))
            gameCells.append(gameCell)
            print("ufukkk", game.gameName)
        }
        
        let updateCell = CellNode(id: "aa", LoadingCell())
        gameCells.append(updateCell)
        
        let helloSection = Section(id: "hello", cells: gameCells)
        sections.append(helloSection)

        renderer.render(sections)
     
    
    }


    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isToggled.toggle()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.backgroundColor = UIColor(red: 0xF8/255, green: 0xF8/255, blue: 0xF8/255, alpha: 1.0)
    }
}
