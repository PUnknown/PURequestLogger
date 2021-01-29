import UIKit

class TitleValueView: UIView {
    // MARK: - Variables
    var title: String = "" {
        didSet { lbTitle.text = title }
    }
    var value: String = "" {
        didSet { lbValue.text = value }
    }
    var textColor: UIColor = .black {
        didSet {
            lbTitle.textColor = textColor
            lbValue.textColor = textColor
        }
    }
    
    // MARK: - UI
    private let lbTitle: UILabel = UILabel()
    private let lbValue: UILabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func configure() {
        addSubview(lbTitle)
        lbTitle.numberOfLines = 0
        lbTitle.font = .systemFont(ofSize: 14, weight: .semibold)
        lbTitle.textColor = textColor
        lbTitle.translatesAutoresizingMaskIntoConstraints = false
        lbTitle.widthAnchor.constraint(equalToConstant: 128).isActive = true
        lbTitle.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lbTitle.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        lbTitle.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        
        addSubview(lbValue)
        lbValue.numberOfLines = 0
        lbValue.font = .systemFont(ofSize: 14, weight: .regular)
        lbValue.textColor = textColor
        lbValue.translatesAutoresizingMaskIntoConstraints = false
        lbValue.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lbValue.leftAnchor.constraint(equalTo: lbTitle.rightAnchor, constant: 8).isActive = true
        lbValue.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        lbValue.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
