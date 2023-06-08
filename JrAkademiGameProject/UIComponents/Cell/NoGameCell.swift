import UIKit
import Kingfisher
import SnapKit
import Carbon

class NoGameCell: UITableViewCell {

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {

        addSubview(nameLabel)
      
        
        backgroundColor = UIColor.white
        
    
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36) // nameLabel'i yatayda ortala
            make.centerX.equalToSuperview()
        }
    }
}


struct EmptyComponent: IdentifiableComponent {
    let name: String

    
    var id: String {
        name
    }
    
    func renderContent() -> NoGameCell {
        return NoGameCell(style: .default, reuseIdentifier: "NoGameCell")
    }
    
    func genreToString(array: [String]) -> String {
        return array.joined(separator: ", ")
    }
    
    func render(in content: NoGameCell) {
        content.nameLabel.text = name
    }
    
    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    func shouldContentUpdate(with next: EmptyComponent) -> Bool {
        return false
    }
}
