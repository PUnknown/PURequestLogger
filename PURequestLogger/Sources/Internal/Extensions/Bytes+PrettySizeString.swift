import Foundation

typealias Bytes = Int

extension Bytes {
    var prettySizeString: String {
        let bytes = self
        guard bytes >= 1024 else { return "\(bytes) B" }
        
        let kbytes = Double(bytes) / 1024.0
        guard kbytes >= 1024 else { return String(format: "%.1lf KB", kbytes) }
        
        let mbytes = kbytes / 1024.0
        guard mbytes >= 1024 else { return String(format: "%.1lf MB", mbytes) }
        
        return String(format: "%.1lf GB", mbytes / 1024.0)
    }
}
