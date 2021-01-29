import UIKit
import CoreData

protocol RequestLogsViewControllerOutput: class {
    func requestLogsViewControllerDidTapClose(_ vc: RequestLogsViewController)
}

class RequestLogsViewController: UITableViewController,
  UISearchResultsUpdating,
  NSFetchedResultsControllerDelegate {
    // MARK: - Variables
    weak var output: RequestLogsViewControllerOutput!
    private let coreDataManager = CoreDataManager.sharedInstance
    private var fetchedResultsController: NSFetchedResultsController<RequestLogInfoManaged>!
    
    private var requestInfos: [RequestLogInfo] = []
    private var requestInfoViewModels: [RequestLogInfoViewModel] = []
    private var cachedRequestInfos: [RequestLogInfo]?
    
    private let dateFormatter = DateFormatter()
    private var isUpdating: Bool = false
    private var searchText: String?
    
    // MARK: - UI
    private let searchController = UISearchController(searchResultsController: nil)
    private let vwNavbarTitle: RequestLoggerTitleView = RequestLoggerTitleView()
    private let vwNavbarBackground: UIView = UIView()
    
    // MARK: - Init
    init() {
        super.init(style: .plain)
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
        dateFormatter.dateFormat = "HH:mm:ss"

        tableView.register(
            RequestLogInfoTableViewCell.self,
            forCellReuseIdentifier: RequestLogInfoTableViewCell.cellReuseId)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .black
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        let context = coreDataManager.mainContext!
        let entityName = "RequestLogInfoManaged"
        let request = NSFetchRequest<RequestLogInfoManaged>(entityName: entityName)
        request.entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        request.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
        updateFetchedResult(fetchedResultsController.fetchedObjects)
        
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(clear))
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .stop,
            target: self,
            action: #selector(tapClose))
        if #available(iOS 11, *) {
            navigationItem.searchController = searchController
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.titleView = vwNavbarTitle
        
        view.addSubview(vwNavbarBackground)
        vwNavbarBackground.backgroundColor = .white
        vwNavbarBackground.translatesAutoresizingMaskIntoConstraints = false
        vwNavbarBackground.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        vwNavbarBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vwNavbarBackground.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        if #available(iOS 11, *) {
            vwNavbarBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            vwNavbarBackground.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        }
    }
    
    // MARK: - Actions
    @objc private func clear() {
        guard let managedObjects = fetchedResultsController.fetchedObjects else { return }
        
        let context = coreDataManager.mainContext!
        context.perform { [weak self] in
            guard let sself = self else { return }
            
            for object in managedObjects {
                context.delete(object)
            }
            sself.coreDataManager.saveContext(context) { _ in }
        }
    }
    
    @objc private func tapClose() {
        output.requestLogsViewControllerDidTapClose(self)
    }
    
    // MARK: - Private
    private func updateFetchedResult(_ fetchedObjects: [NSFetchRequestResult]?) {
        guard let managedRequests = fetchedObjects as? [RequestLogInfoManaged] else { return }
        
        let infos = managedRequests
            .compactMap({ getRequestInfo(fromManaged: $0) })
            .sorted(by: { $0.request.startTime > $1.request.startTime })
        if isUpdating {
            cachedRequestInfos = infos
        } else {
            requestInfos = infos
            updateUI()
        }
    }
    
    private func getRequestInfo(fromManaged requestInfoManaged: RequestLogInfoManaged) -> RequestLogInfo? {
        let decoder = JSONDecoder()
        guard let requestData = requestInfoManaged.request.data(using: .utf8),
            let request = try? decoder.decode(RequestLogInfo.Request.self, from: requestData) else { return nil }
        
        let response: RequestLogInfo.Response?
        if let responseString = requestInfoManaged.response {
            guard let responseData = responseString.data(using: .utf8),
                let resp = try? decoder.decode(RequestLogInfo.Response.self, from: responseData) else { return nil }
            
            response = resp
        } else {
            response = nil
        }
           
        return RequestLogInfo(
            id: requestInfoManaged.id,
            request: request,
            response: response,
            error: requestInfoManaged.error)
    }
    
    private func updateUI() {
        let newViewModels = requestInfos
            .map { buildViewModel(from: $0) }
            .filter { viewModel in searchText.map { viewModel.title.lowercased().contains($0) } ?? true }
        if requestInfoViewModels.isEmpty || newViewModels.isEmpty {
            requestInfoViewModels = newViewModels
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            return
        }
        
        var deletes: [IndexPath] = []
        var inserts: [IndexPath] = []
        
        for index in stride(from: requestInfoViewModels.count - 1, through: 0, by: -1) {
            let viewModel = requestInfoViewModels[index]
            guard !newViewModels.contains(where: { $0.id == viewModel.id }) else { continue }
            
            requestInfoViewModels.remove(at: index)
            deletes.append(.init(row: index, section: 0))
        }
        
        for (index, viewModel) in newViewModels.enumerated() {
            guard !requestInfoViewModels.contains(where: { $0.id == viewModel.id }) else { continue }
            
            requestInfoViewModels.insert(viewModel, at: index)
            inserts.append(.init(row: index, section: 0))
        }
        
        requestInfoViewModels = newViewModels
        performBatchUpdates(deletes: deletes, inserts: inserts)
    }
    
    private func performBatchUpdates(deletes: [IndexPath], inserts: [IndexPath]) {
        guard !deletes.isEmpty || !inserts.isEmpty else { return }
        
        let updateActions = { [weak self] in
            guard let sself = self else { return }
            
            sself.tableView.deleteRows(at: deletes, with: .fade)
            sself.tableView.insertRows(at: inserts, with: .fade)
        }
        let completion: (Bool) -> Void = { [weak self] _ in
            guard let sself = self else { return }
            
            if let cachedInfos = self?.cachedRequestInfos {
                sself.requestInfos = cachedInfos
                sself.cachedRequestInfos = nil
                sself.updateUI()
            } else {
                sself.isUpdating = false
            }
        }
        
        isUpdating = true
        DispatchQueue.main.async { [weak self] in
            guard let sself = self else { return }
            
            if #available(iOS 11, *) {
                sself.tableView.performBatchUpdates({
                    updateActions()
                }, completion: completion)
            } else {
                sself.tableView.beginUpdates()
                updateActions()
                sself.tableView.endUpdates()
                
                completion(true)
            }
        }
    }
    
    private func buildViewModel(from requestLogInfo: RequestLogInfo) -> RequestLogInfoViewModel {
        let hostAndEndpoint = requestLogInfo.request.url.hostEndpoint
        let title = [requestLogInfo.request.method, hostAndEndpoint.endpoint].compactMap { $0 }.joined(separator: " ")
        let totalSize = (requestLogInfo.request.body?.count ?? 0) + (requestLogInfo.response?.data?.count ?? 0)
        
        return RequestLogInfoViewModel(
            id: requestLogInfo.id,
            statusCode: requestLogInfo.response?.statusCode,
            title: title,
            host: hostAndEndpoint.host,
            timeString: dateFormatter.string(from: Date(timeIntervalSince1970: requestLogInfo.request.startTime)),
            durationString: String(format: "%.0lf ms", requestLogInfo.request.duration * 1000),
            sizeString: totalSize.prettySizeString)
    }
    
    // MARK: - UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestInfoViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RequestLogInfoTableViewCell.cellReuseId,
                for: indexPath) as? RequestLogInfoTableViewCell,
            requestInfoViewModels.indices.contains(index) else { return UITableViewCell() }
        
        cell.configure(with: requestInfoViewModels[index])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let requestInfo = requestInfos.first(where: { $0.id == requestInfoViewModels[indexPath.row].id }) else {
            return
        }
        
        navigationController?.pushViewController(RequestInfoViewController(requestInfo: requestInfo), animated: true)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateFetchedResult(controller.fetchedObjects)
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        let searchBarText = (searchController.searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        searchText = searchBarText.isEmpty ? nil : searchBarText.lowercased()
        updateUI()
    }
}
