import UIKit

class RequestLogInfoTableViewCell: UITableViewCell {
    // MARK: - Constants
    static let cellReuseId = "RequestLogInfoTableCell"
    
    // MARK: - UI
    private let lbStatusCode: UILabel = UILabel()
    private let lbTitle: UILabel = UILabel()
    private let lbHost: UILabel = UILabel()
    private let lbTime: UILabel = UILabel()
    private let lbDuration: UILabel = UILabel()
    private let lbSize: UILabel = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lbStatusCode.text = nil
        lbTitle.text = nil
        lbHost.text = nil
        lbTime.text = nil
        lbDuration.text = nil
        lbSize.text = nil
    }
    
    // MARK: - Inputs
    func configure(with viewModel: RequestLogInfoViewModel) {
        lbTitle.text = viewModel.title
        lbHost.text = viewModel.host
        lbTime.text = viewModel.timeString
        lbDuration.text = viewModel.durationString
        lbSize.text = viewModel.sizeString
        
        let textColor: UIColor
        if let statusCode = viewModel.statusCode {
            lbStatusCode.text = "\(statusCode)"
            switch statusCode {
            case ..<400:
                textColor = .black
            case 400..<500:
                textColor = .systemYellow
            default:
                textColor = .systemRed
            }
        } else {
            lbStatusCode.text = "???"
            textColor = .systemRed
        }
        
        lbStatusCode.textColor = textColor
        lbTitle.textColor = textColor
    }
    
    // MARK: - Configure
    private func configure() {
        contentView.addSubview(lbStatusCode)
        lbStatusCode.font = .boldSystemFont(ofSize: 16)
        lbStatusCode.translatesAutoresizingMaskIntoConstraints = false
        lbStatusCode.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        lbStatusCode.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        
        contentView.addSubview(lbTitle)
        lbTitle.numberOfLines = 0
        lbTitle.font = .boldSystemFont(ofSize: 16)
        lbTitle.translatesAutoresizingMaskIntoConstraints = false
        lbTitle.topAnchor.constraint(equalTo: lbStatusCode.topAnchor).isActive = true
        lbTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 64).isActive = true
        lbTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
        contentView.addSubview(lbHost)
        lbHost.numberOfLines = 0
        lbHost.font = .systemFont(ofSize: 12)
        lbHost.textColor = .systemGray
        lbHost.translatesAutoresizingMaskIntoConstraints = false
        lbHost.topAnchor.constraint(equalTo: lbTitle.bottomAnchor, constant: 8).isActive = true
        lbHost.leftAnchor.constraint(equalTo: lbTitle.leftAnchor).isActive = true
        lbHost.rightAnchor.constraint(equalTo: lbTitle.rightAnchor, constant: -16).isActive = true
        
        contentView.addSubview(lbTime)
        lbTime.font = .systemFont(ofSize: 12)
        lbTime.textColor = .systemGray
        lbTime.translatesAutoresizingMaskIntoConstraints = false
        lbTime.topAnchor.constraint(equalTo: lbHost.bottomAnchor, constant: 8).isActive = true
        lbTime.leftAnchor.constraint(equalTo: lbTitle.leftAnchor).isActive = true
        
        contentView.addSubview(lbSize)
        lbSize.font = .systemFont(ofSize: 12)
        lbSize.textColor = .systemGray
        lbSize.translatesAutoresizingMaskIntoConstraints = false
        lbSize.topAnchor.constraint(equalTo: lbTime.topAnchor).isActive = true
        lbSize.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -64).isActive = true
        
        contentView.addSubview(lbDuration)
        lbDuration.font = .systemFont(ofSize: 12)
        lbDuration.textColor = .systemGray
        lbDuration.translatesAutoresizingMaskIntoConstraints = false
        lbDuration.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        lbDuration.topAnchor.constraint(equalTo: lbTime.topAnchor).isActive = true
        lbDuration.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
}
