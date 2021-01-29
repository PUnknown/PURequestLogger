import Foundation

typealias URLString = String

extension URLString {
    var hostEndpoint: URLHostEndpoint {
        let url = self.components(separatedBy: "//")[1]
        let hostAndEndpoint = url.split(separator: "/", maxSplits: 1).map { String($0) }
        
        return .init(host: hostAndEndpoint[0], endpoint: hostAndEndpoint[1])
    }
}
