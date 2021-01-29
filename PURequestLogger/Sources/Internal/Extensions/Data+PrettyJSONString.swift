import Foundation

extension Data {
    var prettyJSONString: String? {
        guard let json = try? JSONSerialization.jsonObject(with: self, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
              let prettyString = String(data: prettyData, encoding: .utf8) else { return nil }
        
        return prettyString
    }
}
