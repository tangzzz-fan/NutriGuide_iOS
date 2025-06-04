import Foundation
import os.log

// MARK: - Logger Protocol
/// 日志记录协议
protocol LoggerProtocol {
    func verbose(_ message: String, file: String, function: String, line: Int)
    func debug(_ message: String, file: String, function: String, line: Int)
    func info(_ message: String, file: String, function: String, line: Int)
    func warning(_ message: String, file: String, function: String, line: Int)
    func error(_ message: String, file: String, function: String, line: Int)
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

// MARK: - OS Logger Implementation
/// 基于os.log的日志实现
class OSLogger: LoggerProtocol {
    private let logger: Logger

    init(subsystem: String, category: String) {
        self.logger = Logger(subsystem: subsystem, category: category)
    }

    func verbose(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        logger.debug("⚪️ VERBOSE: \(message) - \(function):\(line)")
    }

    func debug(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        logger.debug("🔵 DEBUG: \(message) - \(function):\(line)")
    }

    func info(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        logger.info("🟢 INFO: \(message) - \(function):\(line)")
    }

    func warning(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        logger.warning("🟡 WARNING: \(message) - \(function):\(line)")
    }

    func error(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        logger.error("🔴 ERROR: \(message) - \(function):\(line)")
    }
}

// MARK: - Logger Manager
/// 日志管理器
class LoggerManager {
    static let shared = LoggerManager()

    private var loggers: [String: LoggerProtocol] = [:]
    private let defaultLogger: LoggerProtocol

    private init() {
        self.defaultLogger = OSLogger(subsystem: "com.nutriguide.app", category: "Default")
    }

    /// 获取指定类别的日志记录器
    func logger(for category: String) -> LoggerProtocol {
        if let existingLogger = loggers[category] {
            return existingLogger
        }

        let newLogger = OSLogger(subsystem: "com.nutriguide.app", category: category)
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
    let logger = LoggerManager.shared.logger(for: category)

    switch level {
    case .verbose:
        logger.verbose(message, file: file, function: function, line: line)
    case .debug:
        logger.debug(message, file: file, function: function, line: line)
    case .info:
        logger.info(message, file: file, function: function, line: line)
    case .warning:
        logger.warning(message, file: file, function: function, line: line)
    case .error:
        logger.error(message, file: file, function: function, line: line)
    }
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

// MARK: - SwiftyBeaver Integration (Future)
/*
 TODO: 当SwiftyBeaver依赖添加后，可以创建SwiftyBeaverLogger类：

 import SwiftyBeaver

 class SwiftyBeaverLogger: LoggerProtocol {
     private let logger = SwiftyBeaver.self

     init() {
         setupDestinations()
     }

     private func setupDestinations() {
         let console = ConsoleDestination()
         console.format = "$DHH:mm:ss$d $L $N.$F:$l - $M"
         // ... 其他配置
         logger.addDestination(console)
     }

     // 实现LoggerProtocol方法...
 }
 */
