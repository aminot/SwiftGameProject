import UIKit
import SnapKit

class GameTableViewCell: UITableViewCell {
    // Özel hücre bileşenleri
    private let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20) // Kalın font, 20 px
        label.numberOfLines = 2 // İsim alt satıra geçebilir
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let categoriesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let separatorView = UIView()
    
    // Hücre oluşturulduğunda çağrılır
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorView.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        addSubview(separatorView)
        
        setupUI()
    }
    
    // Hücre yeniden kullanıldığında çağrılır
    override func prepareForReuse() {
        super.prepareForReuse()
        gameImageView.image = nil
        nameLabel.text = nil
        ratingLabel.text = nil
        categoriesLabel.text = nil
    }
    
    // Hücre arayüzünü yapılandırır
    private func setupUI() {
        contentView.addSubview(gameImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(categoriesLabel)
        contentView.addSubview(separatorView) // Ayırıcı görünümü en altta olacak şekilde ekle
        
        gameImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.top.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView).offset(-24)
            make.width.equalTo(120)
            make.height.equalTo(104)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(gameImageView.snp.trailing).offset(16)
            make.top.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(gameImageView.snp.trailing).offset(16)
            make.bottom.equalTo(categoriesLabel.snp.top).offset(-8)
        }
        
        categoriesLabel.snp.makeConstraints { make in
            make.leading.equalTo(gameImageView.snp.trailing).offset(16)
            make.bottom.equalTo(separatorView.snp.top).offset(-16)
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.height.equalTo(8)
        }
    }
    
    // Hücre verilerini ayarlar
    func configure(with game: GameModel) {
        if let imageURL = URL(string: game.image),
           let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) {
            gameImageView.image = image
        }
        nameLabel.text = game.gameName
        ratingLabel.text = "Rating: \(game.metacritic)"
        categoriesLabel.text = "Categories:"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
