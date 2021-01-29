import UIKit

class RequestInfoViewController: UIViewController {
    // MARK: - Variables
    
    // MARK: - DI
    private let requestInfo: RequestLogInfo
    
    // MARK: - UI
    private let scSegment: UISegmentedControl
    private let vwOverviewView: RequestInfoOverviewView
    private let vwRequestView: RequestInfoDataView
    private let vwResponseView: RequestInfoDataView
    
    // MARK: - Init
    init(requestInfo: RequestLogInfo) {
        self.requestInfo = requestInfo
        if requestInfo.response != nil {
            scSegment = .init(items: ["Overview", "Request", "Response"])
        } else {
            scSegment = .init(items: ["Overview", "Request"])
        }
        vwOverviewView = .init(requestInfo: requestInfo)
        vwRequestView = .init(headers: requestInfo.request.headers ?? [:], data: requestInfo.request.body)
        vwResponseView = .init(headers: requestInfo.response?.headers ?? [:], data: requestInfo.response?.data)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        configure()
    }
    
    // MARK: - Configure
    private func configure() {
        view.backgroundColor = .white
        
        view.addSubview(scSegment)
        scSegment.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            scSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        } else {
            scSegment.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        }
        scSegment.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        scSegment.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        scSegment.addTarget(self, action: #selector(selectSegment(_:)), for: .valueChanged)
        scSegment.selectedSegmentIndex = 0
        
        view.addSubview(vwOverviewView)
        vwOverviewView.translatesAutoresizingMaskIntoConstraints = false
        vwOverviewView.topAnchor.constraint(equalTo: scSegment.bottomAnchor, constant: 8).isActive = true
        vwOverviewView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        vwOverviewView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vwOverviewView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        view.addSubview(vwRequestView)
        vwRequestView.translatesAutoresizingMaskIntoConstraints = false
        vwRequestView.topAnchor.constraint(equalTo: scSegment.bottomAnchor, constant: 8).isActive = true
        vwRequestView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        vwRequestView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vwRequestView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        view.addSubview(vwResponseView)
        vwResponseView.translatesAutoresizingMaskIntoConstraints = false
        vwResponseView.topAnchor.constraint(equalTo: scSegment.bottomAnchor, constant: 8).isActive = true
        vwResponseView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        vwResponseView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vwResponseView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        configureNavigationBar()
        updateUI()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(share))
        navigationItem.title = [requestInfo.request.method, requestInfo.request.url.hostEndpoint.endpoint]
            .compactMap({ $0 })
            .joined(separator: " ")
    }
    
    // MARK: - Actions
    @objc private func share() {
        let vcShare = UIActivityViewController(activityItems: [requestInfo.request.cURL], applicationActivities: nil)
        vcShare.popoverPresentationController?.sourceView = view
        present(vcShare, animated: true)
    }
    
    @objc private func selectSegment(_ sender: UISegmentedControl) {
        updateUI()
    }
    
    // MARK: - Private
    private func updateUI() {
        vwOverviewView.isHidden = scSegment.selectedSegmentIndex != 0
        vwRequestView.isHidden = scSegment.selectedSegmentIndex != 1
        vwResponseView.isHidden = scSegment.selectedSegmentIndex != 2
    }
}
