import Foundation

public class PURequestInfo {
    let request: URLRequest
    let response: HTTPURLResponse?
    let responseData: Data?
    let error: Error?
    let timeline: Timeline
    
    public init(
      request: URLRequest,
      response: HTTPURLResponse?,
      responseData: Data?,
      error: Error?,
      timeline: Timeline) {
        self.request = request
        self.response = response
        self.responseData = responseData
        self.error = error
        self.timeline = timeline
    }
}

extension PURequestInfo {
    public struct Timeline {
        let requestStartTime: TimeInterval
        let requestDuration: TimeInterval
        let requestCompletedTime: TimeInterval
        
        public init(requestStartTime: TimeInterval, requestDuration: TimeInterval, requestCompletedTime: TimeInterval) {
           self.requestStartTime = requestStartTime
           self.requestDuration = requestDuration
           self.requestCompletedTime = requestCompletedTime
       }
    }
}
