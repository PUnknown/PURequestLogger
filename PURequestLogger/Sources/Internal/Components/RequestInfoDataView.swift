import UIKit

class RequestInfoDataView: UIView {
    // MARK: - Variables
    private let headers: [String: String]
    private let data: Data?
    private var cnsWidth: NSLayoutConstraint?
    
    // MARK: - UI
    private let svContainer: UIScrollView = UIScrollView()
    
    // MARK: - Init
    init(headers: [String: String], data: Data?) {
        self.headers = headers
        self.data = data
        
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cnsWidth?.constant = bounds.width
        cnsWidth?.isActive = true
    }
    
    // MARK: - Configure
    private func configure() {
        addSubview(svContainer)
        svContainer.showsVerticalScrollIndicator = false
        svContainer.translatesAutoresizingMaskIntoConstraints = false
        svContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        svContainer.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        svContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        svContainer.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        let vwWidth = UIView()
        svContainer.addSubview(vwWidth)
        vwWidth.translatesAutoresizingMaskIntoConstraints = false
        cnsWidth = vwWidth.widthAnchor.constraint(equalToConstant: 0)
        vwWidth.topAnchor.constraint(equalTo: svContainer.topAnchor).isActive = true
        vwWidth.leftAnchor.constraint(equalTo: svContainer.leftAnchor).isActive = true
        vwWidth.rightAnchor.constraint(equalTo: svContainer.rightAnchor).isActive = true
        
        var lastView: UIView?
        for (title, value) in headers {
            let vw = TitleValueView()
            vw.title = title
            vw.value = value
            svContainer.addSubview(vw)
            vw.translatesAutoresizingMaskIntoConstraints = false
            vw.topAnchor.constraint(equalTo: lastView?.bottomAnchor ?? svContainer.topAnchor, constant: 8).isActive = true
            vw.leftAnchor.constraint(equalTo: svContainer.leftAnchor).isActive = true
            vw.rightAnchor.constraint(equalTo: svContainer.rightAnchor).isActive = true
            
            lastView = vw
        }
        
        if let bodyString = data?.prettyJSONString {
            let lbBody = UILabel()
            lbBody.numberOfLines = 0
            lbBody.font = .systemFont(ofSize: 14)
            lbBody.textColor = .black
            lbBody.text = bodyString
            svContainer.addSubview(lbBody)
            lbBody.translatesAutoresizingMaskIntoConstraints = false
            lbBody.topAnchor.constraint(equalTo: lastView?.bottomAnchor ?? svContainer.topAnchor, constant: 8).isActive = true
            lbBody.leftAnchor.constraint(equalTo: svContainer.leftAnchor).isActive = true
            lbBody.rightAnchor.constraint(equalTo: svContainer.rightAnchor).isActive = true
            
            lastView = lbBody
        }
        
        lastView?.bottomAnchor.constraint(equalTo: svContainer.bottomAnchor, constant: -16).isActive = true
    }
}
