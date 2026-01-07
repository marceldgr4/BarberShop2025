import Foundation

final class CacheManager {
    static let shared = CacheManager()
    
    private let memoryCache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("AppCache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        memoryCache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    func set<T: Codable>(_ value: T, forKey key: String, policy: CachePolicy = .medium) {
        let entry = CacheEntry(value: value, timestamp: Date(), expirationInterval: policy.expirationInterval)
        
        if let data = try? JSONEncoder().encode(entry) {
            memoryCache.setObject(data as NSData, forKey: key as NSString)
            let fileURL = cacheDirectory.appendingPathComponent(key.toSafeFilename())
            try? data.write(to: fileURL)
        }
    }
    
    func get<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        // 1. Intentar memoria
        if let data = memoryCache.object(forKey: key as NSString) as Data?,
           let entry = try? JSONDecoder().decode(CacheEntry<T>.self, from: data),
           !entry.isExpired {
            return entry.value
        }
        
        // 2. Intentar disco
        let fileURL = cacheDirectory.appendingPathComponent(key.toSafeFilename())
        if let data = try? Data(contentsOf: fileURL),
           let entry = try? JSONDecoder().decode(CacheEntry<T>.self, from: data) {
            if !entry.isExpired {
                if let encodedData = try? JSONEncoder().encode(entry) {
                    memoryCache.setObject(encodedData as NSData, forKey: key as NSString)
                }
                return entry.value
            } else {
                remove(forKey: key)
            }
        }
        return nil
    }
    
    func remove(forKey key: String) {
        memoryCache.removeObject(forKey: key as NSString)
        let fileURL = cacheDirectory.appendingPathComponent(key.toSafeFilename())
        try? fileManager.removeItem(at: fileURL)
    }
    
    func clearAll() {
        memoryCache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
}

private extension String {
    func toSafeFilename() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? self
    }
}
