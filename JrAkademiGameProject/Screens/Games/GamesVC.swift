import UIKit
import SnapKit
import Carbon



class GamesVc: UIViewController, UISearchBarDelegate {

    private let tableView = UITableView()
    private let cellIdentifier = "Cell"

    var isToggled = false {
        didSet { render() }
    }

    private let renderer = Renderer(
        adapter: UITableViewAdapter(),
        updater: UITableViewUpdater()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Hello"
        tableView.contentInset.top = 44
        tableView.separatorStyle = .none
        renderer.target = tableView

        setupUI()
        render()
    }

    func render() {
        var sections: [Section] = []

        // Create a cell item containing the HelloMessage view
        let helloCell = CellNode(id: "hello", HelloMessage(name: "ufuk", surname: "dönmez"))
        let spacerCell = CellNode(id: "spacer", SpacerComponent(250)) // 10 bir boşluk yüksekliği
        let helloCell2 = CellNode(id: "hello", HelloMessage(name: "saaaa", surname: "saaa"))

        // Convert helloCell2 into a ViewNode
        let helloCell2ViewNode = ViewNode(HelloMessage(name: "fffff", surname: "fffff"))

        // Create a section and assign the cell items and footer to it
        let helloSection = Section(id: "hello", cells: [helloCell, spacerCell], footer: helloCell2ViewNode)

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
        tableView.backgroundColor = UIColor.red
    }

    // MARK: - UISearchBarDelegate
}
