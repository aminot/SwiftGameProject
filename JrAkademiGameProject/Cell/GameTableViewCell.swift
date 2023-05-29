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
    
    private let separatorView = UIView()
    // Hücre oluşturulduğunda çağrılır
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorView.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)

                addSubview(separatorView)
                separatorView.translatesAutoresizingMaskIntoConstraints = false
                
                // Ayırıcı görünümünün konumunu ve boyutunu ayarlayın
                separatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                separatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                separatorView.heightAnchor.constraint(equalToConstant: 8).isActive = true
            
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

        NSLayoutConstraint.activate([
            gameImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            gameImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            gameImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            gameImageView.widthAnchor.constraint(equalToConstant: 120),
            gameImageView.heightAnchor.constraint(equalToConstant: 104),

            nameLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            ratingLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 16),
            ratingLabel.bottomAnchor.constraint(equalTo: categoriesLabel.topAnchor, constant: -8),

            categoriesLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 16),
            categoriesLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -16),

            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 8)
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
