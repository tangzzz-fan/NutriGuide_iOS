//
//  NutriGuideApp.swift
//  NutriGuide
//
//  Created by 小苹果 on 2025/6/4.
//

import SwiftUI
import os.log

@main
struct NutriGuideApp: App {
    // 配置管理器
    private let configManager = ConfigurationManager.shared
    private let logger = Logger(subsystem: "com.nutriguide.app", category: "Application")

    init() {
        setupApplication()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    startServices()
                }
                .overlay(alignment: .topTrailing) {
                    #if DEBUG
                        environmentIndicator
                    #endif
                }
        }
    }

    // MARK: - Debug Environment Indicator
    #if DEBUG
        private var environmentIndicator: some View {
            VStack(spacing: 2) {
                Circle()
                    .fill(Color.environmentIndicator)
                    .frame(width: 8, height: 8)

                Text(configManager.currentEnvironment.rawValue.uppercased())
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(Color.environmentIndicator)
            }
            .padding(.top, 50)
            .padding(.trailing, 10)
        }
    #endif

    // MARK: - Private Methods
    private func setupApplication() {
        logger.info("Setting up NutriGuide application")
        logger.info("Current environment: \(configManager.currentEnvironment.displayName)")
        logger.info("API Base URL: \(configManager.baseURL)")
        logger.info("App Version: \(AppConstants.App.version) (\(AppConstants.App.build))")

        #if DEBUG
            logger.info("Debug mode enabled")
            if !AppConstants.isProductionEnvironment {
                logger.info("Non-production environment - additional logging enabled")
            }
        #endif

        // 注册通知观察者
        setupNotificationObservers()
    }

    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            forName: .environmentDidChange,
            object: nil,
            queue: .main
        ) { notification in
            if let environment = notification.object as? Environment {
                logger.info("Environment changed to: \(environment.displayName)")
            }
        }
    }

    private func startServices() {
        Task {
            logger.info("Starting application services")

            // 检查首次启动
            await checkFirstLaunch()

            // 初始化配置检查
            await performConfigurationCheck()

            logger.info("Application services started successfully")
        }
    }

    @MainActor
    private func checkFirstLaunch() async {
        let isFirstLaunch = !UserDefaults.standard.bool(
            forKey: AppConstants.UserDefaults.firstLaunch)

        if isFirstLaunch {
            logger.info("First launch detected")
            UserDefaults.standard.set(true, forKey: AppConstants.UserDefaults.firstLaunch)
            UserDefaults.standard.set(
                AppConstants.App.version, forKey: AppConstants.UserDefaults.lastAppVersion)
        } else {
            let lastVersion =
                UserDefaults.standard.string(forKey: AppConstants.UserDefaults.lastAppVersion)
                ?? "unknown"
            if lastVersion != AppConstants.App.version {
                logger.info(
                    "App updated from version \(lastVersion) to \(AppConstants.App.version)")
                UserDefaults.standard.set(
                    AppConstants.App.version, forKey: AppConstants.UserDefaults.lastAppVersion)
            }
        }

        // 增加使用次数
        let usageCount = UserDefaults.standard.integer(
            forKey: AppConstants.UserDefaults.appUsageCount)
        UserDefaults.standard.set(usageCount + 1, forKey: AppConstants.UserDefaults.appUsageCount)
    }

    private func performConfigurationCheck() async {
        logger.info("Performing configuration check")

        // 验证环境配置
        let environment = configManager.currentEnvironment
        let baseURL = configManager.baseURL
        let enableEncryption = configManager.enableEncryption

        logger.info("Environment: \(environment.displayName)")
        logger.info("Base URL: \(baseURL)")
        logger.info("Encryption enabled: \(enableEncryption)")

        // 在非生产环境下进行额外检查
        if !AppConstants.isProductionEnvironment {
            logger.info("Non-production environment - performing additional checks")

            // 检查调试功能
            if AppConstants.FeatureFlags.enableAnalytics {
                logger.warning("Analytics enabled in non-production environment")
            }
        }
    }
}
