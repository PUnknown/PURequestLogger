import UIKit
import CoreData

open class PURequestLogger: RequestLogsViewControllerOutput {
    public static let sharedInstance: PURequestLogger = PURequestLogger()
    
    // MARK: - Variables
    private let coreDataManager = CoreDataManager.sharedInstance
    
    // MARK: - Init
    init() {}
    
    // MARK: - Inputs
    open func logRequestInfo(_ requestInfo: PURequestInfo) {
        let request = RequestLogInfo.Request(
            url: requestInfo.request.url?.absoluteString ?? "",
            method: requestInfo.request.httpMethod,
            headers: requestInfo.request.allHTTPHeaderFields,
            body: requestInfo.request.httpBody,
            startTime: requestInfo.timeline.requestStartTime,
            duration: requestInfo.timeline.requestDuration,
            completedTime: requestInfo.timeline.requestCompletedTime,
            cURL: requestInfo.request.cURL())
        let response = requestInfo.response.map {
            RequestLogInfo.Response(
                statusCode: $0.statusCode,
                headers: $0.allHeaderFields as? [String: String],
                data: requestInfo.responseData)
        }
        
        addLogRequestInfo(RequestLogInfo(
            id: UUID().uuidString,
            request: request,
            response: response,
            error: requestInfo.error?.localizedDescription))
    }
    
    open func presentLogsViewController() {
        let topViewController = UIApplication.shared.topViewController
        guard !(topViewController is RequestLogsViewController || topViewController is RequestInfoViewController) else {
            return
        }
        
        let vc = RequestLogsViewController()
        vc.output = self
        
        let nc = UINavigationController(rootViewController: vc)
        (topViewController?.navigationController ?? topViewController)?.present(nc, animated: true, completion: nil)
    }
    
    // MARK: - Private
    private func addLogRequestInfo(_ info: RequestLogInfo) {
        guard let requestManaged = NSEntityDescription.insertNewObject(
            forEntityName: "RequestLogInfoManaged",
            into: coreDataManager.mainContext) as? RequestLogInfoManaged else { return }
        
        updateRequestManaged(requestManaged, fromRequestInfo: info)
    }
    
    private func updateRequestManaged(
      _ requestInfoManaged: RequestLogInfoManaged,
      fromRequestInfo requestInfo: RequestLogInfo) {
        let encoder = JSONEncoder()
        
        guard let requestData = try? encoder.encode(requestInfo.request),
              let requestString = String(data: requestData, encoding: .utf8) else { return }
        
        let responseString: String?
        if let response = requestInfo.response {
            guard let responseData = try? encoder.encode(response),
                  let respString = String(data: responseData, encoding: .utf8) else { return }
            
            responseString = respString
        } else {
            responseString = nil
        }
        
        coreDataManager.mainContext.perform { [weak self] in
            guard let sself = self else { return }
            
            requestInfoManaged.id = requestInfo.id
            requestInfoManaged.request = requestString
            requestInfoManaged.response = responseString
            requestInfoManaged.error = requestInfo.error
            
            sself.coreDataManager.saveContext(sself.coreDataManager.mainContext) { _ in }
        }
    }
    
    // MARK: - RequestLogsViewControllerOutput
    func requestLogsViewControllerDidTapClose(_ vc: RequestLogsViewController) {
        vc.dismiss(animated: true)
    }
}
