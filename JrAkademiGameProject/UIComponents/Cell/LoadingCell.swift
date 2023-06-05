import UIKit
import Carbon
import SnapKit

class LoadingCell: UITableViewCell, Component {
    

    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 0.54, green: 0.54, blue: 0.56, alpha: 1.0)

        label.numberOfLines = 0 // İsim alt satıra geçebilir
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center // Ortala
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
    
        nameLabel.text = nil
    }
    
    // Hücre arayüzünü yapılandırır
    private func setupUI() {
        configure()
       
        contentView.addSubview(nameLabel)
    
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
         
            make.leading.trailing.equalTo(contentView).inset(8) // İçeriden 8 birim boşluk
            make.bottom.equalTo(contentView).inset(8) // Alt kısımdan 8 birim içeride olacak
        }
    }
    
    // Hücre verilerini ayarlar
    func configure() {
   
        
        nameLabel.text = "yükleniyor"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Carbon.Component protokolü gereği aşağıdaki metotları da implemente etmek gerekmektedir, ancak içerisine herhangi bir işlem yapmanıza gerek yok.
    
    func render(in content: LoadingCell) {
        // Burada herhangi bir işlem yapmanıza gerek yok
    }
    
    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 60) // Replace 64 with the desired height value
    }
    
    func renderContent() -> LoadingCell {
        return self
    }
}
