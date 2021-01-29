import Foundation
import CoreData

@objc(RequestLogInfoManaged)
class RequestLogInfoManaged: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RequestLogInfoManaged> {
        return NSFetchRequest<RequestLogInfoManaged>(entityName: "RequestLogInfoManaged")
    }

    @NSManaged public var id: String
    @NSManaged public var request: String
    @NSManaged public var response: String?
    @NSManaged public var error: String?
}
