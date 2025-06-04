import CoreGraphics
import Foundation

// MARK: - App Constants
/// 应用常量
struct AppConstants {

    // MARK: - Application Info
    struct App {
        static let name = "NutriGuide"
        static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.nutriguide.app"
        static let version =
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        static let userAgent = "\(name)-iOS/\(version)"
    }

    // MARK: - Layout Constants
    struct Layout {
        static let defaultPadding: CGFloat = 16.0
        static let smallPadding: CGFloat = 8.0
        static let largePadding: CGFloat = 24.0
        static let extraLargePadding: CGFloat = 32.0

        static let cornerRadius: CGFloat = 12.0
        static let smallCornerRadius: CGFloat = 8.0
        static let largeCornerRadius: CGFloat = 16.0

        static let cardHeight: CGFloat = 200.0
        static let buttonHeight: CGFloat = 50.0
        static let inputFieldHeight: CGFloat = 44.0
        static let tabBarHeight: CGFloat = 83.0

        static let iconSize: CGFloat = 24.0
        static let smallIconSize: CGFloat = 16.0
        static let largeIconSize: CGFloat = 32.0
    }

    // MARK: - Animation Constants
    struct Animation {
        static let defaultDuration: Double = 0.3
        static let shortDuration: Double = 0.15
        static let longDuration: Double = 0.6

        static let springResponse: Double = 0.5
        static let springDamping: Double = 0.8

        static let cardSwipeThreshold: CGFloat = 100.0
        static let cardRotationAngle: Double = 10.0
    }

    // MARK: - Storage Keys
    struct StorageKeys {
        static let userProfile = "user_profile"
        static let userPreferences = "user_preferences"
        static let onboardingCompleted = "onboarding_completed"
        static let lastSyncDate = "last_sync_date"
        static let biometricEnabled = "biometric_enabled"
        static let environmentOverride = "environment_override"
    }

    // MARK: - User Defaults Keys
    struct UserDefaults {
        static let firstLaunch = "first_launch"
        static let appUsageCount = "app_usage_count"
        static let lastAppVersion = "last_app_version"
        static let dailyNotificationEnabled = "daily_notification_enabled"
        static let dataCollectionConsent = "data_collection_consent"
    }

    // MARK: - Feature Flags
    struct FeatureFlags {
        static let enableBiometricAuth = true
        static let enablePushNotifications = true
        static let enableAnalytics = false
        static let enableCrashReporting = true
        static let enableOfflineMode = true
        static let enableDataExport = true
    }

    // MARK: - Runtime Constants
    static var currentEnvironment: Environment {
        return ConfigurationManager.shared.currentEnvironment
    }

    static var isDebugMode: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    static var isProductionEnvironment: Bool {
        return currentEnvironment == .production
    }
}
