import UIKit
import Carbon
import SnapKit

class GameTableViewCell: UITableViewCell, Component {

   func render(in content: GameTableViewCell) {
       // Burada herhangi bir işlem yapmanıza gerek yok
   }

   func referenceSize(in bounds: CGRect) -> CGSize? {

       return CGSize(width: bounds.width, height: 136) // Replace 64 with the desired height value

   }

   func renderContent() -> GameTableViewCell {
       return self
   }
    
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
        label.numberOfLines = 0 // İsim alt satıra geçebilir
        label.lineBreakMode = .byWordWrapping
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
    init(nameLabelText: String, ratingLabelText: Int, categoriesLabelText: String, gameImageURL: String) {
        super.init(style: .default, reuseIdentifier: nil)
        separatorView.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
     //   addSubview(separatorView)
        
        nameLabel.text = nameLabelText
        categoriesLabel.text = categoriesLabelText
        let fullText = "metacritic: \(ratingLabelText)"
        let attributedString = NSMutableAttributedString(string: fullText)

        let range = (fullText as NSString).range(of: String(ratingLabelText))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)

        ratingLabel.attributedText = attributedString



        
        if let imageURL = URL(string: gameImageURL),
           let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) {
            gameImageView.image = image
        }
            
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
        contentView.addSubview(separatorView)
        
        contentView.backgroundColor = UIColor.white // Kırmızı renk
    
        
        
        gameImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.leading.equalTo(contentView).offset(16)
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
            make.leading.trailing.bottom.equalTo(contentView)
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
