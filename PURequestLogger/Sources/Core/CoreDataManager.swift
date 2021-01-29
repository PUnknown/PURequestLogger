import Foundation
import CoreData

class CoreDataManager {
    static var sharedInstance: CoreDataManager = CoreDataManager()
    
    // MARK: - Variables
    private var lastError: Error?
    
    private let dbMaxSize: Double = 50 * 1024 * 1024 // 50 megabytes
    private var childContexts: [NSManagedObjectContext] = []
    
    private var persistentContext: NSManagedObjectContext!
    var mainContext: NSManagedObjectContext!
    
    private lazy var dbFilePath: String = {
        let packageName = Bundle.main.bundleIdentifier!.components(separatedBy: ".").last!
        
        var databasePath = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.applicationSupportDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).last!
        databasePath.append("/\(packageName)_requestLogger.sqlite")
        
        return databasePath
    }()
    
    var successLoggingEnabled: Bool = false
    
    // MARK: - Init
    init() {
        let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        initializePersistentStore(with: coordinator)
        
        initializePersistentContext()
        persistentContext.persistentStoreCoordinator = coordinator
        
        mainContext = createChildContext(onPrivateQueue: true)
        logSuccess(message: "Initialized successfully.")
    }
    
    // MARK: - Child Contexts' functionality
    func createChildContext(onPrivateQueue: Bool) -> NSManagedObjectContext {
        let concurrencyType: NSManagedObjectContextConcurrencyType =
            onPrivateQueue ? .privateQueueConcurrencyType : .mainQueueConcurrencyType
        
        let context = NSManagedObjectContext(concurrencyType: concurrencyType)
        //NSMergePolicyType.mergeByPropertyStoreTrumpMergePolicyType
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        context.parent = persistentContext
        
        childContexts.append(context)
        
        return context
    }
    
    func removeChildContext(context: NSManagedObjectContext) {
        guard context != mainContext, let index = childContexts.firstIndex(of: context) else { return }
        
        childContexts[index].parent = nil
        childContexts.remove(at: index)
    }
    
    // MARK: - Saving
    func saveContext(_ context: NSManagedObjectContext, completion: @escaping (Error?) -> Void) {
        guard context.hasChanges else {
            completion(nil)
            return
        }
        
        context.perform { [weak self] in
            guard let sself = self else { return }
            
            do {
                try context.save()
                if sself.persistentContext.hasChanges {
                    sself.persistentContext.perform {
                        do {
                            try sself.persistentContext.save()
                            sself.logSuccess(message: "Successful commit.")
                            completion(nil)
                        } catch {
                            sself.logError(error)
                            completion(error)
                        }
                    }
                } else {
                    completion(nil)
                }
            } catch {
                sself.logError(error)
                completion(error)
            }
        }
    }
    
    // MARK: - Dropping
    open func drop() {
        lastError = nil
        removeAllDBFiles()
        logSuccess(message: "Dropped the database successfully.")
    }
    
    // MARK: - Private
    private func initializePersistentContext() {
        persistentContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        //NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType
        persistentContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
    }
    
    private func initializePersistentStore(with coordinator: NSPersistentStoreCoordinator) {
        cleanUpIfNeeded()
        
        do {
            try FileManager.default.createDirectory(
                at: dbUrl().deletingLastPathComponent(),
                withIntermediateDirectories: true,
                attributes: nil)
        } catch {
            logError(error)
            return
        }
        
        let options: [String: Any] = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true,
            NSSQLitePragmasOption: ["journal_mode": "WAL"]]
        
        do {
            try coordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: dbUrl(),
                options: options)
        } catch {
            logError(error)
            
            let err = error as NSError
            let isMigrationError = err.code == NSMigrationError
                                || err.code == NSMigrationMissingSourceModelError
                                || err.code == NSPersistentStoreIncompatibleVersionHashError
            
            guard isMigrationError, err.domain == NSCocoaErrorDomain else { return }
            
            logError(error, message: "Failed to migrate, gonna clean up and try again.")
            removeAllDBFiles()
            
            do {
                try coordinator.addPersistentStore(
                    ofType: NSSQLiteStoreType,
                    configurationName: nil,
                    at: dbUrl(),
                    options: options)
                print("@CoreDataManager: migrated successfully.")
            } catch {
                logError(error)
                return
            }
        }
    }
    
    private func dbUrl() -> URL {
        return URL(fileURLWithPath: dbFilePath, isDirectory: false)
    }
    
    private func cleanUpIfNeeded() {
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: dbFilePath) else { return }

        let dbCurrentSize = (attrs[FileAttributeKey.size] as! NSNumber).doubleValue
        do {
            if dbMaxSize < dbCurrentSize {
                try FileManager.default.removeItem(atPath: dbFilePath)
                print("@CoreDataManager: I had to remove the database because it's gotten too large.")
            }
        } catch {
            logError(error)
            return
        }
    }
    
    private func removeAllDBFiles() {
        let shmUrl = URL(fileURLWithPath: dbFilePath.appending("-shm"), isDirectory: false)
        let walUrl = URL(fileURLWithPath: dbFilePath.appending("-wal"), isDirectory: false)
        
        try? FileManager.default.removeItem(at: dbUrl())
        try? FileManager.default.removeItem(at: shmUrl)
        try? FileManager.default.removeItem(at: walUrl)
    }
    
    private func logError(_ error: Error, message: String? = nil) {
        lastError = error
        if let msg = message {
            print("@CoreDataManager: \(msg)")
        } else {
            print("@CoreDataManager: an error occured. \(error)")
        }
    }
    
    private func logSuccess(message: String) {
        if successLoggingEnabled && lastError == nil {
            print("@CoreDataManager: \(message)")
        }
    }
}
