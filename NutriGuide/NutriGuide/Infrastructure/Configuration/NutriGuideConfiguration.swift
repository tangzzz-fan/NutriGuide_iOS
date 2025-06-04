import Foundation
import SwiftUI

// MARK: - Environment Configuration
/// 应用环境枚举
enum Environment: String, CaseIterable {
    case development = "dev"
    case qa = "qa"
    case production = "prod"

    /// 环境显示名称
    var displayName: String {
        switch self {
        case .development: return "开发环境"
        case .qa: return "测试环境"
        case .production: return "生产环境"
        }
    }

    /// API基础URL
    var baseURL: String {
        switch self {
        case .development: return "http://localhost:3000/v1"
        case .qa: return "https://api-qa.nutriguide.com/v1"
        case .production: return "https://api.nutriguide.com/v1"
        }
    }

    /// 是否启用日志
    var enableLogging: Bool {
        switch self {
        case .development, .qa: return true
        case .production: return false
        }
    }

    /// 请求超时时间
    var requestTimeout: TimeInterval {
        switch self {
        case .development: return 30.0
        case .qa: return 20.0
        case .production: return 15.0
        }
    }

    /// 是否启用加密
    var enableEncryption: Bool {
        switch self {
        case .development: return false  // 开发环境不加密便于调试
        case .qa, .production: return true
        }
    }

    /// 加密密钥名称
    var encryptionKeyName: String {
        switch self {
        case .development: return "DEV_ENCRYPTION_KEY"
        case .qa: return "QA_ENCRYPTION_KEY"
        case .production: return "PROD_ENCRYPTION_KEY"
        }
    }

    /// 缓存过期时间（秒）
    var cacheExpiration: TimeInterval {
        switch self {
        case .development: return 60.0
        case .qa: return 300.0
        case .production: return 600.0
        }
    }
}

// MARK: - Configuration Manager Protocol
/// 配置管理器协议
protocol ConfigurationManagerProtocol: AnyObject {
    var currentEnvironment: Environment { get }
    var baseURL: String { get }
    var encryptionKeyName: String { get }
    var enableLogging: Bool { get }
    var requestTimeout: TimeInterval { get }
    var enableEncryption: Bool { get }
    var cacheExpiration: TimeInterval { get }
    func switchEnvironment(_ environment: Environment)
}

// MARK: - Configuration Manager Implementation
/// 配置管理器实现
class ConfigurationManager: ConfigurationManagerProtocol, ObservableObject {
    @Published private(set) var currentEnvironment: Environment

    init() {
        // 从Info.plist读取环境配置
        guard
            let envString = Bundle.main.object(forInfoDictionaryKey: "APP_ENVIRONMENT") as? String,
            let env = Environment(rawValue: envString)
        else {
            #if DEBUG
                self.currentEnvironment = .development
            #else
                self.currentEnvironment = .production
            #endif
            return
        }
        self.currentEnvironment = env

        print("🟢 App started with environment: \(env.displayName)")
    }

    var baseURL: String {
        if let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String {
            return url
        }
        return currentEnvironment.baseURL
    }

    var encryptionKeyName: String {
        if let keyName = Bundle.main.object(forInfoDictionaryKey: "ENCRYPTION_KEY_NAME") as? String
        {
            return keyName
        }
        return currentEnvironment.encryptionKeyName
    }

    var enableLogging: Bool {
        currentEnvironment.enableLogging
    }

    var requestTimeout: TimeInterval {
        currentEnvironment.requestTimeout
    }

    var enableEncryption: Bool {
        currentEnvironment.enableEncryption
    }

    var cacheExpiration: TimeInterval {
        currentEnvironment.cacheExpiration
    }

    func switchEnvironment(_ environment: Environment) {
        #if DEBUG
            objectWillChange.send()
            currentEnvironment = environment
            print("🟢 Environment switched to: \(environment.displayName)")

            NotificationCenter.default.post(
                name: .environmentDidChange,
                object: environment
            )
        #else
            print("🟡 Environment switching is disabled in production")
        #endif
    }
}

// MARK: - Notification Extensions
extension Notification.Name {
    static let environmentDidChange = Notification.Name("EnvironmentDidChange")
}
