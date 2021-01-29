import Foundation

extension URLRequest {
    func cURL() -> String {
        let method = httpMethod.map { "    -X \($0) \\\n" } ?? ""
        
        var headers: String = ""
        allHTTPHeaderFields?.forEach { (key, value) in
            headers += "    -H \'\(key): \(value)\' \\\n"
        }
        
        var data: String = ""
        if let bodyData = httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            data = "    -d \(bodyString) \\\n"
        }
        
        let url = "    \'\(self.url?.absoluteString ?? "")\'"
        
        return "curl -v\\\n" + method + headers + data + url
    }
}
