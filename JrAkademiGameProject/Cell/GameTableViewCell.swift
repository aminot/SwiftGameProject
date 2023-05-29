import UIKit

class GameTableViewCell: UITableViewCell {
    // Özel hücre bileşenleri
    private let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 104).isActive = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20) // Kalın font, 20 px
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2 // İsim alt satıra geçebilir
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoriesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Hücre oluşturulduğunda çağrılır
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        
        NSLayoutConstraint.activate([
            gameImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            gameImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            gameImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            gameImageView.widthAnchor.constraint(equalToConstant: 120),
            gameImageView.heightAnchor.constraint(equalToConstant: 104),
            
            nameLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ratingLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 16),
            ratingLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -36),
            
            categoriesLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 16),
            categoriesLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8),
            categoriesLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])

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
