import UIKit

class RequestInfoDataView: UIView {
    // MARK: - Variables
    private let headers: [String: String]
    private let data: Data?
    private var cnsBodyHeight: NSLayoutConstraint?
    
    // MARK: - UI
    private let svContainer: UIScrollView = UIScrollView()
    private let tvBody: UITextView = UITextView()
    
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
        
        guard bounds.width > 0 else { return }
        
        tvBody.layoutIfNeeded()
        cnsBodyHeight?.constant = tvBody.sizeThatFits(.init(width: tvBody.bounds.width, height: .greatestFiniteMagnitude)).height + 1
        cnsBodyHeight?.isActive = true
    }
    
    // MARK: - Configure
    private func configure() {
        addSubview(svContainer)
        svContainer.translatesAutoresizingMaskIntoConstraints = false
        svContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        svContainer.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        svContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        svContainer.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        let vwWidth = UIView()
        svContainer.addSubview(vwWidth)
        vwWidth.translatesAutoresizingMaskIntoConstraints = false
        vwWidth.widthAnchor.constraint(equalTo: svContainer.widthAnchor).isActive = true
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
            vw.leftAnchor.constraint(equalTo: svContainer.leftAnchor, constant: 16).isActive = true
            vw.rightAnchor.constraint(equalTo: svContainer.rightAnchor, constant: -16).isActive = true
            
            lastView = vw
        }
        
        var bodyString: String? = nil
        if let rawData = data {
            if rawData.count <= 1 * 1024 * 1024 /* 1 mb */, let jsonString = rawData.prettyJSONString {
                bodyString = jsonString
            } else {
                bodyString = String(data: rawData, encoding: .utf8)
            }
        }
        if let bodyString = bodyString {
            tvBody.font = .systemFont(ofSize: 14)
            tvBody.textColor = .black
            tvBody.text = bodyString
            tvBody.isEditable = false
            svContainer.addSubview(tvBody)
            tvBody.translatesAutoresizingMaskIntoConstraints = false
            tvBody.topAnchor.constraint(equalTo: lastView?.bottomAnchor ?? svContainer.topAnchor, constant: 8).isActive = true
            tvBody.leftAnchor.constraint(equalTo: svContainer.leftAnchor, constant: 16).isActive = true
            tvBody.rightAnchor.constraint(equalTo: svContainer.rightAnchor, constant: -16).isActive = true
            cnsBodyHeight = tvBody.heightAnchor.constraint(equalToConstant: 0)
            
            lastView = tvBody
        }
        
        lastView?.bottomAnchor.constraint(equalTo: svContainer.bottomAnchor, constant: -16).isActive = true
    }
}
