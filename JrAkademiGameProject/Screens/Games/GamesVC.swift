import UIKit
import SnapKit
import Carbon

class GamesVC: UIViewController {
    var gamesViewModel: GamesViewModel? = GamesViewModel()
    private let tableView = UITableView()
    private let cellIdentifier = "Cell"
    var games: [GameModel] = []
    
    var isToggled = false {
        didSet { render() }
    }
    
    private let renderer = Renderer(
        adapter: UITableViewAdapter(),
        updater: UITableViewUpdater()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesViewModel?.fetchGames(completion: { [weak self] in
            // Veri çekme tamamlandığında closure içinde güncelleme yap
            if let gamesViewModel = self?.gamesViewModel {
                self?.games = gamesViewModel.games
                self?.render()
                DispatchQueue.main.async {
                    // TableView'ı güncelle
                    self?.tableView.reloadData()
                }
            }
        })

        title = "Hello"
        tableView.contentInset.top = 44
        tableView.separatorStyle = .none
        renderer.target = tableView

        setupUI()
       
    }
    
    func render() {
        var sections: [Section] = []
        var gameCells: [CellNode] = []
        
        for game in games {
            let categories = game.tags.joined(separator: ", ")
            let gameCell = CellNode(id: game.gameName, GameTableViewCell(nameLabelText: game.gameName, ratingLabelText: game.metacritic, categoriesLabelText: categories, gameImageURL: game.image))
            gameCells.append(gameCell)
        }
        
        let helloSection = Section(id: "hello", cells: gameCells)
        sections.append(helloSection)
        
        renderer.render(sections)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isToggled.toggle()
    }
    
    
    private func setupUI() {
        // TableView ve diğer arayüz bileşenlerini burada yapılandırabilirsiniz.
        view.addSubview(tableView) // TableView'ı ekranın görünür kısmına ekleyin
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
                }
        tableView.backgroundColor = UIColor.white
    }
}



 

