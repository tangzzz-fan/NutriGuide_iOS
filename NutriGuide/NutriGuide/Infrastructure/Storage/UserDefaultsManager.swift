import Combine
import Foundation

// MARK: - UserDefaults Storage Protocol
/// UserDefaults存储协议
protocol UserDefaultsStorageProtocol {
    func set<T>(_ value: T, for key: UserDefaultsKey) where T: Codable
    func get<T>(_ type: T.Type, for key: UserDefaultsKey) -> T? where T: Codable
    func remove(for key: UserDefaultsKey)
    func exists(for key: UserDefaultsKey) -> Bool
    func removeAll()

    // 基础类型便捷方法
    func setValue(_ value: Any?, for key: UserDefaultsKey)
    func getString(for key: UserDefaultsKey) -> String?
    func getBool(for key: UserDefaultsKey) -> Bool
    func getInt(for key: UserDefaultsKey) -> Int
    func getDate(for key: UserDefaultsKey) -> Date?
    func setDate(_ date: Date?, for key: UserDefaultsKey)

    // Combine 支持
    func publisher<T: Codable>(for key: UserDefaultsKey, type: T.Type) -> AnyPublisher<T?, Never>
    func boolPublisher(for key: UserDefaultsKey) -> AnyPublisher<Bool, Never>
    func stringPublisher(for key: UserDefaultsKey) -> AnyPublisher<String?, Never>
}

// MARK: - UserDefaults Key Protocol
/// UserDefaults键协议
protocol UserDefaultsKeyProtocol {
    var keyName: String { get }
    var defaultValue: Any? { get }
}

// MARK: - UserDefaults Keys Enum
/// UserDefaults键枚举
enum UserDefaultsKey: String, UserDefaultsKeyProtocol, CaseIterable {
    // MARK: - App State
    case firstLaunch = "first_launch"
    case appUsageCount = "app_usage_count"
    case lastAppVersion = "last_app_version"

    // MARK: - User Preferences
    case dailyNotificationEnabled = "daily_notification_enabled"
    case dataCollectionConsent = "data_collection_consent"
    case biometricEnabled = "biometric_enabled"

    // MARK: - Onboarding & Profile
    case onboardingCompleted = "onboarding_completed"
    case userProfile = "user_profile"
    case userPreferences = "user_preferences"

    // MARK: - Sync & Cache
    case lastSyncDate = "last_sync_date"
    case environmentOverride = "environment_override"

    // MARK: - Theme & UI
    case preferredTheme = "preferred_theme"
    case preferredLanguage = "preferred_language"

    // MARK: - Health & Nutrition
    case heightInCm = "height_in_cm"
    case weightInKg = "weight_in_kg"
    case birthDate = "birth_date"
    case gender = "gender"
    case activityLevel = "activity_level"
    case dietaryRestrictions = "dietary_restrictions"
    case allergies = "allergies"

    // MARK: - App Features
    case nutriScoreEnabled = "nutri_score_enabled"
    case mealReminderEnabled = "meal_reminder_enabled"
    case waterReminderEnabled = "water_reminder_enabled"
    case favoriteRecipes = "favorite_recipes"
    case mealHistory = "meal_history"

    var keyName: String {
        return self.rawValue
    }

    var defaultValue: Any? {
        switch self {
        case .firstLaunch:
            return true
        case .appUsageCount:
            return 0
        case .lastAppVersion:
            return ""
        case .dailyNotificationEnabled, .nutriScoreEnabled:
            return true
        case .dataCollectionConsent, .biometricEnabled, .onboardingCompleted:
            return false
        case .mealReminderEnabled, .waterReminderEnabled:
            return true
        case .userProfile, .userPreferences, .lastSyncDate, .environmentOverride:
            return nil
        case .birthDate:
            return nil
        case .preferredTheme:
            return "system"
        case .preferredLanguage:
            return "zh-Hans"
        case .heightInCm, .weightInKg:
            return 0.0
        case .gender:
            return ""
        case .activityLevel:
            return "moderate"
        case .dietaryRestrictions, .allergies, .favoriteRecipes, .mealHistory:
            return []
        }
    }
}

// MARK: - Property Wrapper for UserDefaults
@propertyWrapper
struct UserDefaultsValue<Value: Codable> {
    private let key: UserDefaultsKey
    private let defaultValue: Value
    private let userDefaults: UserDefaults
    private let shouldEncode: Bool

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(_ key: UserDefaultsKey, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
        self.shouldEncode = !(Value.self is any UserDefaultsCompatible.Type)
    }

    var wrappedValue: Value {
        get {
            guard let value = userDefaults.value(forKey: key.keyName) else {
                return defaultValue
            }

            if shouldEncode {
                guard let data = value as? Data,
                    let decodedValue = try? decoder.decode(Value.self, from: data)
                else {
                    return defaultValue
                }
                return decodedValue
            } else {
                return value as? Value ?? defaultValue
            }
        }
        set {
            if shouldEncode {
                let data = try? encoder.encode(newValue)
                userDefaults.setValue(data, forKey: key.keyName)
            } else {
                userDefaults.setValue(newValue, forKey: key.keyName)
            }
            userDefaults.synchronize()
        }
    }
}

// MARK: - UserDefaults Compatible Types
/// 标记 UserDefaults 兼容的基础类型
protocol UserDefaultsCompatible {}
extension String: UserDefaultsCompatible {}
extension Int: UserDefaultsCompatible {}
extension Bool: UserDefaultsCompatible {}
extension Float: UserDefaultsCompatible {}
extension Double: UserDefaultsCompatible {}
extension Date: UserDefaultsCompatible {}
extension Data: UserDefaultsCompatible {}
extension Array: UserDefaultsCompatible where Element: UserDefaultsCompatible {}
extension Dictionary: UserDefaultsCompatible
where Key: UserDefaultsCompatible, Value: UserDefaultsCompatible {}

// MARK: - Simple Logger for UserDefaults (避免循环依赖)
private struct UserDefaultsLogger {
    private let category: String

    init(category: String) {
        self.category = category
    }

    func info(_ message: String) {
        print("🟢 [\(category)] \(message)")
    }

    func debug(_ message: String) {
        print("🔵 [\(category)] \(message)")
    }

    func warning(_ message: String) {
        print("🟡 [\(category)] \(message)")
    }

    func error(_ message: String) {
        print("🔴 [\(category)] \(message)")
    }
}

// MARK: - UserDefaults Manager Implementation
/// UserDefaults管理器实现
class UserDefaultsManager: UserDefaultsStorageProtocol, ObservableObject {
    private let userDefaults: UserDefaults
    private let logger: UserDefaultsLogger

    // 发布值变化的Publishers
    @Published private var valueDidChange = false
    private var cancellables = Set<AnyCancellable>()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.logger = UserDefaultsLogger(category: "UserDefaultsManager")

        logger.info("UserDefaultsManager initialized")
    }

    // MARK: - Generic Storage Methods

    /// 存储Codable值
    func set<T>(_ value: T, for key: UserDefaultsKey) where T: Codable {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(value)
            userDefaults.set(data, forKey: key.keyName)
            logger.debug("Stored value for key: \(key.keyName)")
            notifyValueChanged()
        } catch {
            logger.error("Failed to encode value for key \(key.keyName): \(error)")
        }
    }

    /// 获取Codable值
    func get<T>(_ type: T.Type, for key: UserDefaultsKey) -> T? where T: Codable {
        guard let data = userDefaults.data(forKey: key.keyName) else {
            logger.debug("No data found for key: \(key.keyName)")
            return getDefaultValue(type, for: key)
        }

        do {
            let decoder = JSONDecoder()
            let value = try decoder.decode(type, from: data)
            logger.debug("Retrieved value for key: \(key.keyName)")
            return value
        } catch {
            logger.error("Failed to decode value for key \(key.keyName): \(error)")
            return getDefaultValue(type, for: key)
        }
    }

    /// 删除指定键的值
    func remove(for key: UserDefaultsKey) {
        userDefaults.removeObject(forKey: key.keyName)
        logger.debug("Removed value for key: \(key.keyName)")
        notifyValueChanged()
    }

    /// 检查键是否存在
    func exists(for key: UserDefaultsKey) -> Bool {
        return userDefaults.object(forKey: key.keyName) != nil
    }

    /// 清除所有应用相关的UserDefaults
    func removeAll() {
        UserDefaultsKey.allCases.forEach { key in
            userDefaults.removeObject(forKey: key.keyName)
        }
        logger.warning("Removed all UserDefaults values")
        notifyValueChanged()
    }

    // MARK: - Convenience Methods for Basic Types

    /// 存储基础类型值
    func setValue(_ value: Any?, for key: UserDefaultsKey) {
        userDefaults.set(value, forKey: key.keyName)
        logger.debug("Stored basic value for key: \(key.keyName)")
        notifyValueChanged()
    }

    /// 获取String值
    func getString(for key: UserDefaultsKey) -> String? {
        return userDefaults.string(forKey: key.keyName) ?? key.defaultValue as? String
    }

    /// 获取Bool值
    func getBool(for key: UserDefaultsKey) -> Bool {
        if exists(for: key) {
            return userDefaults.bool(forKey: key.keyName)
        }
        return key.defaultValue as? Bool ?? false
    }

    /// 获取Int值
    func getInt(for key: UserDefaultsKey) -> Int {
        if exists(for: key) {
            return userDefaults.integer(forKey: key.keyName)
        }
        return key.defaultValue as? Int ?? 0
    }

    /// 获取Date值
    func getDate(for key: UserDefaultsKey) -> Date? {
        return userDefaults.object(forKey: key.keyName) as? Date
    }

    /// 设置Date值
    func setDate(_ date: Date?, for key: UserDefaultsKey) {
        userDefaults.set(date, forKey: key.keyName)
        logger.debug("Stored date for key: \(key.keyName)")
        notifyValueChanged()
    }

    // MARK: - Private Helper Methods

    private func getDefaultValue<T>(_ type: T.Type, for key: UserDefaultsKey) -> T? {
        return key.defaultValue as? T
    }

    private func notifyValueChanged() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.valueDidChange.toggle()
        }
    }
}

// MARK: - Reactive Extensions
extension UserDefaultsManager {
    /// 观察特定键的值变化
    func publisher<T: Codable>(for key: UserDefaultsKey, type: T.Type) -> AnyPublisher<T?, Never> {
        return
            $valueDidChange
            .map { [weak self] _ in
                self?.get(type, for: key)
            }
            .eraseToAnyPublisher()
    }

    /// 观察Bool值变化
    func boolPublisher(for key: UserDefaultsKey) -> AnyPublisher<Bool, Never> {
        return
            $valueDidChange
            .map { [weak self] _ in
                self?.getBool(for: key) ?? false
            }
            .eraseToAnyPublisher()
    }

    /// 观察String值变化
    func stringPublisher(for key: UserDefaultsKey) -> AnyPublisher<String?, Never> {
        return
            $valueDidChange
            .map { [weak self] _ in
                self?.getString(for: key)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - App Specific Convenience Methods
extension UserDefaultsManager {

    // MARK: - App State Management
    var isFirstLaunch: Bool {
        get { getBool(for: .firstLaunch) }
        set { setValue(newValue, for: .firstLaunch) }
    }

    var appUsageCount: Int {
        get { getInt(for: .appUsageCount) }
        set { setValue(newValue, for: .appUsageCount) }
    }

    var lastAppVersion: String? {
        get { getString(for: .lastAppVersion) }
        set { setValue(newValue, for: .lastAppVersion) }
    }

    // MARK: - User Preferences
    var isDailyNotificationEnabled: Bool {
        get { getBool(for: .dailyNotificationEnabled) }
        set { setValue(newValue, for: .dailyNotificationEnabled) }
    }

    var hasDataCollectionConsent: Bool {
        get { getBool(for: .dataCollectionConsent) }
        set { setValue(newValue, for: .dataCollectionConsent) }
    }

    var isBiometricEnabled: Bool {
        get { getBool(for: .biometricEnabled) }
        set { setValue(newValue, for: .biometricEnabled) }
    }

    // MARK: - Onboarding & Profile
    var isOnboardingCompleted: Bool {
        get { getBool(for: .onboardingCompleted) }
        set { setValue(newValue, for: .onboardingCompleted) }
    }

    var lastSyncDate: Date? {
        get { getDate(for: .lastSyncDate) }
        set { setDate(newValue, for: .lastSyncDate) }
    }

    // MARK: - Theme & UI
    var preferredTheme: String {
        get { getString(for: .preferredTheme) ?? "system" }
        set { setValue(newValue, for: .preferredTheme) }
    }

    var preferredLanguage: String {
        get { getString(for: .preferredLanguage) ?? "zh-Hans" }
        set { setValue(newValue, for: .preferredLanguage) }
    }

    // MARK: - Development & Debug
    #if DEBUG
        var environmentOverride: String? {
            get { getString(for: .environmentOverride) }
            set { setValue(newValue, for: .environmentOverride) }
        }
    #endif

    // MARK: - Health & Nutrition Properties
    var heightInCm: Double {
        get { userDefaults.double(forKey: UserDefaultsKey.heightInCm.keyName) }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKey.heightInCm.keyName)
            notifyValueChanged()
        }
    }

    var weightInKg: Double {
        get { userDefaults.double(forKey: UserDefaultsKey.weightInKg.keyName) }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKey.weightInKg.keyName)
            notifyValueChanged()
        }
    }

    var birthDate: Date? {
        get { getDate(for: .birthDate) }
        set { setDate(newValue, for: .birthDate) }
    }

    var gender: String {
        get { getString(for: .gender) ?? "" }
        set { setValue(newValue, for: .gender) }
    }

    var activityLevel: String {
        get { getString(for: .activityLevel) ?? "moderate" }
        set { setValue(newValue, for: .activityLevel) }
    }

    // MARK: - Feature Toggles
    var isNutriScoreEnabled: Bool {
        get { getBool(for: .nutriScoreEnabled) }
        set { setValue(newValue, for: .nutriScoreEnabled) }
    }

    var isMealReminderEnabled: Bool {
        get { getBool(for: .mealReminderEnabled) }
        set { setValue(newValue, for: .mealReminderEnabled) }
    }

    var isWaterReminderEnabled: Bool {
        get { getBool(for: .waterReminderEnabled) }
        set { setValue(newValue, for: .waterReminderEnabled) }
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let userDefaultsDidChange = Notification.Name("UserDefaultsDidChange")
}
