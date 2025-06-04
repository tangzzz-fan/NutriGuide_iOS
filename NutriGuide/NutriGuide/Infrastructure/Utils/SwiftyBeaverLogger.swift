import Foundation
import os.log

// MARK: - SwiftyBeaver Integration Instructions
/*
 要集成SwiftyBeaver，请按以下步骤操作：

 1. 在Xcode中添加SwiftyBeaver依赖：
    - File -> Add Package Dependencies
    - 输入URL: https://github.com/SwiftyBeaver/SwiftyBeaver.git
    - 选择版本并添加到项目

 2. 在LoggerManager.swift文件中添加导入：
    import SwiftyBeaver

 3. 创建SwiftyBeaverLogger类（在LoggerManager.swift中）：

    class SwiftyBeaverLogger: LoggerProtocol {
        private let logger = SwiftyBeaver.self

        init(subsystem: String, category: String) {
            setupDestinations()
        }

        private func setupDestinations() {
            let console = ConsoleDestination()
            console.format = "$DHH:mm:ss$d $L $N.$F:$l - $M"
            console.levelColor.verbose = "⚪️ "
            console.levelColor.debug = "🔵 "
            console.levelColor.info = "🟢 "
            console.levelColor.warning = "🟡 "
            console.levelColor.error = "🔴 "

            let file = FileDestination()
            file.logFileURL = URL(fileURLWithPath: "/tmp/nutriguide.log")
            file.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $L $N.$F:$l - $M"

            logger.addDestination(console)

            // 根据环境配置文件日志
            let config = ConfigurationManager.shared
            if config.currentEnvironment != .production {
                logger.addDestination(file)
            }
        }

        func verbose(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
            logger.verbose(message, file, function, line: line)
        }

        func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
            logger.debug(message, file, function, line: line)
        }

        func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
            logger.info(message, file, function, line: line)
        }

        func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
            logger.warning(message, file, function, line: line)
        }

        func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
            logger.error(message, file, function, line: line)
        }
    }

 4. 更新LoggerManager使用SwiftyBeaverLogger：
    private init() {
        self.defaultLogger = SwiftyBeaverLogger(subsystem: "com.nutriguide.app", category: "Default")
    }

    func logger(for category: String) -> LoggerProtocol {
        if let existingLogger = loggers[category] {
            return existingLogger
        }

        let newLogger = SwiftyBeaverLogger(subsystem: "com.nutriguide.app", category: category)
        loggers[category] = newLogger
        return newLogger
    }

 5. 在ConfigurationManager中使用SwiftyBeaver：
    private let logger: LoggerProtocol

    private init() {
        self.logger = LoggerManager.shared.logger(for: "Configuration")
        // ... 其他初始化代码
    }

 6. 删除此文件，因为所有代码都应该在LoggerManager.swift中
 */
