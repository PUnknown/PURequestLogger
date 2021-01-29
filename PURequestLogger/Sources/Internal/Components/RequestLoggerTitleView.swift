import UIKit

class RequestLoggerTitleView: UIView {
    // MARK: - UI
    private let lbTitle: UILabel = UILabel()
    private let lbAppName: UILabel = UILabel()
    
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
        lbTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        lbTitle.textColor = .black
        lbTitle.text = "Request Logger"
        lbTitle.translatesAutoresizingMaskIntoConstraints = false
        lbTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lbTitle.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lbTitle.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor).isActive = true
        lbTitle.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor).isActive = true
        
        addSubview(lbAppName)
        lbAppName.font = .systemFont(ofSize: 14)
        lbAppName.textColor = .systemGray
        lbAppName.text = Bundle.main.infoDictionary?["CFBundleName"] as? String
        lbAppName.translatesAutoresizingMaskIntoConstraints = false
        lbAppName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lbAppName.topAnchor.constraint(equalTo: lbTitle.bottomAnchor).isActive = true
        lbAppName.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor).isActive = true
        lbAppName.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor).isActive = true
        lbAppName.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
