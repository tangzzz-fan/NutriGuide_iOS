import Combine
import Foundation

/// 数据加载协议
protocol DataLoadable {
    associatedtype DataType

    /// 加载数据
    func loadData() async throws -> DataType

    /// 是否正在加载
    var isLoading: Bool { get set }
}

/// 刷新协议
protocol Refreshable {
    /// 刷新数据
    func refresh() async

    /// 是否正在刷新
    var isRefreshing: Bool { get set }
}

/// 缓存协议
protocol Cacheable {
    associatedtype CacheKey: Hashable

    /// 缓存键
    var cacheKey: CacheKey { get }

    /// 缓存过期时间
    var cacheExpiration: TimeInterval { get }
}

/// 错误处理协议
protocol ErrorHandleable {
    /// 错误消息
    var errorMessage: String { get set }

    /// 处理错误
    func handleError(_ error: Error)
}

/// 状态管理协议
protocol StatefulViewModel: ObservableObject {
    /// 加载状态
    var isLoading: Bool { get set }

    /// 刷新状态
    var isRefreshing: Bool { get set }

    /// 错误消息
    var errorMessage: String { get set }

    /// 清除错误
    func clearError()
}

/// ViewModel基础协议
protocol ViewModelProtocol: StatefulViewModel, DataLoadable, Refreshable, ErrorHandleable {
    /// 初始化
    func initialize() async

    /// 清理资源
    func cleanup()
}

/// 存储协议
protocol Storable {
    /// 存储类型
    var storageType: StorageType { get }
}

/// 存储类型枚举
enum StorageType {
    case keychain  // 最高安全级别
    case encryptedLocal  // 加密本地存储
    case local  // 普通本地存储
    case memory  // 仅内存存储
}

/// 网络请求协议
protocol NetworkRequestable {
    associatedtype ResponseType: Codable

    /// 执行网络请求
    func request() -> AnyPublisher<ResponseType, Error>
}

/// 本地存储协议
protocol LocalStorageProtocol {
    /// 保存数据
    func save<T: Codable>(_ object: T, forKey key: String) throws

    /// 读取数据
    func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T?

    /// 删除数据
    func remove(forKey key: String) throws

    /// 清空所有数据
    func removeAll() throws
}

/// 安全存储协议
protocol SecureStorageProtocol {
    /// 安全保存数据
    func secureStore<T: Codable>(_ object: T, forKey key: String) throws

    /// 安全读取数据
    func secureLoad<T: Codable>(_ type: T.Type, forKey key: String) throws -> T?

    /// 安全删除数据
    func secureRemove(forKey key: String) throws

    /// 检查数据是否存在
    func exists(forKey key: String) -> Bool
}

/// 缓存管理协议
protocol CacheManagerProtocol {
    /// 缓存数据
    func cache<T: Codable>(_ object: T, forKey key: String, expiration: TimeInterval?)

    /// 获取缓存数据
    func getCached<T: Codable>(_ type: T.Type, forKey key: String) -> T?

    /// 移除缓存
    func removeCache(forKey key: String)

    /// 清空所有缓存
    func clearAllCache()

    /// 检查缓存是否过期
    func isCacheExpired(forKey key: String) -> Bool
}

// MARK: - Default Implementations
extension Cacheable {
    /// 默认缓存过期时间为5分钟
    var cacheExpiration: TimeInterval { 300 }
}

extension StatefulViewModel {
    /// 默认清除错误实现
    func clearError() {
        errorMessage = ""
    }
}

extension ErrorHandleable {
    /// 默认错误处理实现
    mutating func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
    }
}
