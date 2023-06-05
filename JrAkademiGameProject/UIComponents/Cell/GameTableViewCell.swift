import UIKit
import Kingfisher
import SnapKit
import Carbon

class GameTableViewCell: UITableViewCell {
    let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let categoriesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(gameImageView)
        addSubview(nameLabel)
        addSubview(ratingLabel)
        addSubview(categoriesLabel)
        addSubview(separatorView)
        
        backgroundColor = UIColor.white
        
        gameImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(120)
            make.height.equalTo(104)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(gameImageView.snp.top)
            make.leading.equalTo(gameImageView.snp.trailing).offset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
            make.bottom.lessThanOrEqualTo(gameImageView.snp.bottom)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.bottom.equalTo(gameImageView.snp.bottom).offset(-24)
            make.leading.equalTo(gameImageView.snp.trailing).offset(16)
        }
        
        categoriesLabel.snp.makeConstraints { make in
            make.bottom.equalTo(gameImageView.snp.bottom).offset(0)
            make.leading.equalTo(gameImageView.snp.trailing).offset(16)
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(8)
        }
    }
}

struct HelloMessage: IdentifiableComponent {
    let name: String
    let url: String
    let rating: Int
    let categories: [String]
    
    var id: String {
        name
    }
    
    func renderContent() -> GameTableViewCell {
        return GameTableViewCell(style: .default, reuseIdentifier: "GameTableViewCell")
    }
    
    func genreToString(array: [String]) -> String {
        return array.joined(separator: ", ")
    }
    
    func render(in content: GameTableViewCell) {
        content.nameLabel.text = name
        if let imageUrl = URL(string: url) {
            let processor = DownsamplingImageProcessor(size: CGSize(width: 120, height: 104))
            content.gameImageView.kf.setImage(
                with: imageUrl,
                options: [.processor(processor)]
            )
        }
        content.ratingLabel.text = String(rating)
        content.categoriesLabel.text = genreToString(array: categories)
    }
    
    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 136)
    }
    
    func shouldContentUpdate(with next: HelloMessage) -> Bool {
        return false
    }
}
