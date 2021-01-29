import Foundation

class RequestLogInfo {
    let id: String
    let request: Request
    let response: Response?
    let error: String?
    
    init(id: String, request: Request, response: Response?, error: String?) {
        self.id = id
        self.request = request
        self.response = response
        self.error = error
    }
}

extension RequestLogInfo {
    struct Request: Codable {
        let url: String
        let method: String?
        let headers: [String: String]?
        let body: Data?
        let startTime: TimeInterval
        let duration: TimeInterval
        let completedTime: TimeInterval
        let cURL: String
    }
    
    struct Response: Codable {
        let statusCode: Int
        let headers: [String: String]?
        let data: Data?
    }
}
