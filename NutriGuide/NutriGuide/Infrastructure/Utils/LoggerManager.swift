import Foundation

// MARK: - Logger Protocol
/// 日志记录协议
protocol LoggerProtocol {
    func verbose(_ message: String, file: String, function: String, line: Int)
    func debug(_ message: String, file: String, function: String, line: Int)
    func info(_ message: String, file: String, function: String, line: Int)
    func warning(_ message: String, file: String, function: String, line: Int)
    func error(_ message: String, file: String, function: String, line: Int)
}

// MARK: - LoggerProtocol 默认参数扩展
extension LoggerProtocol {
    func verbose(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        verbose(message, file: file, function: function, line: line)
    }

    func debug(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        debug(message, file: file, function: function, line: line)
    }

    func info(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        info(message, file: file, function: function, line: line)
    }

    func warning(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        warning(message, file: file, function: function, line: line)
    }

    func error(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        error(message, file: file, function: function, line: line)
    }
}

// MARK: - Logger Manager Protocol
/// 日志管理器协议
protocol LoggerManagerProtocol {
    func logger(for category: String) -> LoggerProtocol
    var `default`: LoggerProtocol { get }
}

// MARK: - Log Level
/// 日志级别
enum LogLevel: Int, CaseIterable {
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4

    var emoji: String {
        switch self {
        case .verbose: return "⚪️"
        case .debug: return "🔵"
        case .info: return "🟢"
        case .warning: return "🟡"
        case .error: return "🔴"
        }
    }

    var description: String {
        switch self {
        case .verbose: return "VERBOSE"
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        }
    }
}

// MARK: - Simple Logger Implementation
/// 简单的日志实现
class SimpleLogger: LoggerProtocol {
    private let category: String
    private let enableLogging: Bool

    init(category: String, enableLogging: Bool = true) {
        self.category = category
        self.enableLogging = enableLogging
    }

    func verbose(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(.verbose, message, file: file, function: function, line: line)
    }

    func debug(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(.debug, message, file: file, function: function, line: line)
    }

    func info(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(.info, message, file: file, function: function, line: line)
    }

    func warning(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(.warning, message, file: file, function: function, line: line)
    }

    func error(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(.error, message, file: file, function: function, line: line)
    }

    private func log(
        _ level: LogLevel, _ message: String, file: String, function: String, line: Int
    ) {
        guard enableLogging else { return }

        let filename = (file as NSString).lastPathComponent
        let timestamp = DateFormatter.logFormatter.string(from: Date())

        print(
            "\(timestamp) \(level.emoji) [\(category)] \(filename).\(function):\(line) - \(message)"
        )
    }
}

// MARK: - Logger Manager Implementation
/// 日志管理器实现
class LoggerManager: LoggerManagerProtocol {
    private var loggers: [String: LoggerProtocol] = [:]
    private let defaultLogger: LoggerProtocol
    private let enableLogging: Bool

    init(enableLogging: Bool = true) {
        self.enableLogging = enableLogging
        self.defaultLogger = SimpleLogger(category: "Default", enableLogging: enableLogging)
    }

    /// 获取指定类别的日志记录器
    func logger(for category: String) -> LoggerProtocol {
        if let existingLogger = loggers[category] {
            return existingLogger
        }

        let newLogger = SimpleLogger(category: category, enableLogging: enableLogging)
        loggers[category] = newLogger
        return newLogger
    }

    /// 获取默认日志记录器
    var `default`: LoggerProtocol {
        return defaultLogger
    }
}

// MARK: - Global Log Functions
/// 全局日志函数，便于使用
func log(
    _ level: LogLevel, _ message: String, category: String = "General", file: String = #file,
    function: String = #function, line: Int = #line
) {
    // 简单的控制台输出
    let filename = (file as NSString).lastPathComponent
    let timestamp = DateFormatter.logFormatter.string(from: Date())
    print("\(timestamp) \(level.emoji) [\(category)] \(filename).\(function):\(line) - \(message)")
}

// MARK: - Convenience Log Functions
func logVerbose(
    _ message: String, category: String = "General", file: String = #file,
    function: String = #function, line: Int = #line
) {
    log(.verbose, message, category: category, file: file, function: function, line: line)
}

func logDebug(
    _ message: String, category: String = "General", file: String = #file,
    function: String = #function, line: Int = #line
) {
    log(.debug, message, category: category, file: file, function: function, line: line)
}

func logInfo(
    _ message: String, category: String = "General", file: String = #file,
    function: String = #function, line: Int = #line
) {
    log(.info, message, category: category, file: file, function: function, line: line)
}

func logWarning(
    _ message: String, category: String = "General", file: String = #file,
    function: String = #function, line: Int = #line
) {
    log(.warning, message, category: category, file: file, function: function, line: line)
}

func logError(
    _ message: String, category: String = "General", file: String = #file,
    function: String = #function, line: Int = #line
) {
    log(.error, message, category: category, file: file, function: function, line: line)
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    fileprivate static let logFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}
