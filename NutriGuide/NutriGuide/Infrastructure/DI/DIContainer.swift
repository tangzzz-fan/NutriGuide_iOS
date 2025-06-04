import Foundation

// MARK: - Dependency Injection Container
/// 依赖注入容器
class DIContainer {
    static let shared = DIContainer()

    private var dependencies: [String: Any] = [:]

    private init() {
        registerDependencies()
    }

    /// 解析依赖
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let resolved = dependencies[key] as? T else {
            fatalError("Failed to resolve \(type)")
        }
        return resolved
    }

    /// 可选解析依赖
    func resolveOptional<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        return dependencies[key] as? T
    }

    /// 注册依赖
    private func register<T>(_ type: T.Type, instance: T) {
        let key = String(describing: type)
        dependencies[key] = instance
    }

    // MARK: - Private Methods
    private func registerDependencies() {
        // 注册配置管理器
        let configManager = ConfigurationManager()
        register(ConfigurationManagerProtocol.self, instance: configManager)

        // 注册日志管理器
        let loggerManager = LoggerManager(enableLogging: configManager.enableLogging)
        register(LoggerManagerProtocol.self, instance: loggerManager)

        // 注册默认日志记录器
        let defaultLogger = loggerManager.logger(for: "Default")
        register(LoggerProtocol.self, instance: defaultLogger)

        // 注册 UserDefaults 管理器
        let userDefaultsManager = UserDefaultsManager()
        register(UserDefaultsStorageProtocol.self, instance: userDefaultsManager)
    }
}

// MARK: - Convenience Extension
extension DIContainer {
    /// 便捷解析方法
    static func resolve<T>(_ type: T.Type) -> T {
        return shared.resolve(type)
    }

    /// 便捷可选解析方法
    static func resolveOptional<T>(_ type: T.Type) -> T? {
        return shared.resolveOptional(type)
    }
}
