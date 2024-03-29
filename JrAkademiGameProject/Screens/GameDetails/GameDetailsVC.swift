import UIKit
import CoreData
import Carbon

class DetailsViewController: UIViewController {

    var viewModel: GameDetailsViewModel? = GameDetailsViewModel()
    private let tableView = UITableView()
    var gameId: Int = 0
    var gameDetails: GameDetailsModel?
    var isToggled = false {
        didSet { render() }
    }
    private let renderer = Renderer(
        adapter: UITableViewAdapter(),
        updater: UITableViewUpdater())
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        renderer.target = tableView
        let favoriteButton = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = favoriteButton
        setupTableView()
        getData(gameId: gameId)

    }
    func checkIfAlreadyFavorited() {
        guard let name = gameDetails?.name else {
            return
        }
        let alreadyFavorited = isGameAlreadyFavorited(name: name)
        if alreadyFavorited {
            navigationItem.rightBarButtonItem?.title = "Favorited"
        }
    }
    func isGameAlreadyFavorited(name: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results.count > 0
        } catch let error as NSError {
            print("Error searching for favorite: \(error), \(error.userInfo)")
            return false
        }
    }
    func getData(gameId: Int) {
        viewModel?.fetchGames(gameId: gameId) { gameDetails in
            if let gameDetails = gameDetails {
                self.gameDetails = gameDetails
                self.render()
                self.checkIfAlreadyFavorited()
            }
        }
    }
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func render() {
        var sections: [Section] = []
        var cellNodes: [CellNode] = []
        guard let imageUrl = gameDetails?.backgroundImageAdditional else {
            return
        }
        cellNodes.append(CellNode(id: "hello", ImageWithTitleComponent(
            imageUrl: imageUrl, name: gameDetails?.name ?? "")))
        cellNodes.append(CellNode(id: "hello", DescriptionComponent(
            description: gameDetails?.descriptionRaw ?? "")))
        cellNodes.append(CellNode(id: "urlReddit", OpenUrlComponent(
            websiteName: "reddit", url: gameDetails?.redditURL ?? "https://www.reddit.com/")))
        cellNodes.append(CellNode(id: "urlReddit", OpenUrlComponent(
            websiteName: "website", url: gameDetails?.website ?? "https://www.reddit.com/")))
        let helloSection = Section(id: "hello", cells: cellNodes)
        sections.append(helloSection)
        renderer.render(sections)
    }
    @objc private func favoriteButtonTapped() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        guard let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: managedContext) else {
            print("Error: Favorite entity not found.")
            return
        }
        var combinedGenres: String?
        if let genres = gameDetails?.genres {
            let genreNames = genres.compactMap { $0.name }
            combinedGenres = genreNames.joined(separator: ", ")
        }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        let name = gameDetails?.name ?? ""
        let image = gameDetails?.backgroundImageAdditional ?? ""
        let metacritic = gameDetails?.metacritic ?? 0
        let genres = combinedGenres ?? ""
        let predicateFormat = "name == %@ AND image == %@ AND metacritic == %d AND genres == %@"
        let predicate = NSPredicate(format: predicateFormat, name, image, metacritic, genres)
        fetchRequest.predicate = predicate
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results.count > 0 {
                showAlert(message: "This game is already in favorites.")
                return
            }
        } catch let error as NSError {
            print("Error searching for favorite: \(error), \(error.userInfo)")
        }
        let favorite = NSManagedObject(entity: entity, insertInto: managedContext)
        favorite.setValue(gameDetails?.name, forKey: "name")
        favorite.setValue(gameDetails?.backgroundImageAdditional, forKey: "image")
        favorite.setValue(gameDetails?.metacritic, forKey: "metacritic")
        favorite.setValue(combinedGenres, forKey: "genres")
        favorite.setValue(gameId, forKey: "id")
        do {
            try managedContext.save()
            showAlert(message: "Favorite saved.")
            navigationItem.rightBarButtonItem?.title = "Favorited"
        } catch let error as NSError {
            print("Error saving favorite: \(error), \(error.userInfo)")
        }
    }
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isToggled.toggle()
    }
    // Delegate Function
    func detailsFetched() {
        render()
    }
}
