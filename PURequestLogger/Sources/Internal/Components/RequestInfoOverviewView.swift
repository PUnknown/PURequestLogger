import UIKit

class RequestInfoOverviewView: UIView {
    // MARK: - Variables
    private let requestInfo: RequestLogInfo
    private var cnsWidth: NSLayoutConstraint?
    
    // MARK: - UI
    private let svContainer: UIScrollView = UIScrollView()
    
    // MARK: - Init
    init(requestInfo: RequestLogInfo) {
        self.requestInfo = requestInfo
        
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
        
        var lastView = addTitleView(title: "URL", value: requestInfo.request.url, constrainedTo: vwWidth.bottomAnchor)
        if let method = requestInfo.request.method {
            lastView = addTitleView(title: "Method", value: method, constrainedTo: lastView.bottomAnchor)
        }
        if let statusCode = requestInfo.response?.statusCode {
            lastView = addTitleView(title: "Status code", value: String(statusCode), constrainedTo: lastView.bottomAnchor)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        lastView = addTitleView(
            title: "Request start time",
            value: dateFormatter.string(from: Date(timeIntervalSince1970: requestInfo.request.startTime)),
            constrainedTo: lastView.bottomAnchor)
        lastView = addTitleView(
            title: "Request completion time",
            value: dateFormatter.string(from: Date(timeIntervalSince1970: requestInfo.request.completedTime)),
            constrainedTo: lastView.bottomAnchor)
        lastView = addTitleView(
            title: "Request duration",
            value: String(format: "%.0lf ms", requestInfo.request.duration * 1000),
            constrainedTo: lastView.bottomAnchor)
        
        let requestSize = requestInfo.request.body?.count ?? 0
        let totalSize: Bytes
        lastView = addTitleView(
            title: "Request size",
            value: requestSize.prettySizeString,
            constrainedTo: lastView.bottomAnchor)
        if let response = requestInfo.response {
            let responseSize = response.data?.count ?? 0
            lastView = addTitleView(
                title: "Response size",
                value: responseSize.prettySizeString,
                constrainedTo: lastView.bottomAnchor)
            totalSize = requestSize + responseSize
        } else {
            totalSize = requestSize
        }
        lastView = addTitleView(
            title: "Total size",
            value: totalSize.prettySizeString,
            constrainedTo: lastView.bottomAnchor)
        if let error = requestInfo.error {
            lastView = addTitleView(title: "ERROR", value: error, constrainedTo: lastView.bottomAnchor)
            lastView.textColor = .systemRed
        }
        
        lastView.bottomAnchor.constraint(equalTo: svContainer.bottomAnchor, constant: -16).isActive = true
    }
    
    // MARK: - Private
    private func addTitleView(title: String, value: String, constrainedTo topAnchor: NSLayoutYAxisAnchor) -> TitleValueView {
        let vw = TitleValueView()
        vw.title = title
        vw.value = value
        svContainer.addSubview(vw)
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        vw.leftAnchor.constraint(equalTo: svContainer.leftAnchor, constant: 16).isActive = true
        vw.rightAnchor.constraint(equalTo: svContainer.rightAnchor, constant: -16).isActive = true
        
        return vw
    }
}
