import Foundation

class RequestLogInfoViewModel {
    // MARK: - Variables
    let id: String
    let statusCode: Int?
    let title: String
    let host: String
    let timeString: String
    let durationString: String
    let sizeString: String
    
    // MARK: - Init
    init(
      id: String,
      statusCode: Int?,
      title: String,
      host: String,
      timeString: String,
      durationString: String,
      sizeString: String) {
        self.id = id
        self.statusCode = statusCode
        self.title = title
        self.host = host
        self.timeString = timeString
        self.durationString = durationString
        self.sizeString = sizeString
    }
}
