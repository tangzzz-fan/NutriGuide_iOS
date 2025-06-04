import SwiftUI

// MARK: - Color Convenience Methods
extension Color {
    /// 创建自定义颜色的便捷方法
    static func nutriColor(red: Double, green: Double, blue: Double, alpha: Double = 1.0) -> Color {
        return Color(red: red / 255, green: green / 255, blue: blue / 255, opacity: alpha)
    }

    /// 获取颜色的十六进制表示
    var hexString: String {
        // 简化的十六进制表示方法
        if self == .nutriGreen500 { return "#4CAF50" }
        if self == .nutriGreen400 { return "#66BB6A" }
        if self == .nutriGreen300 { return "#81C784" }
        if self == .nutriGreen100 { return "#E8F5E9" }
        if self == .nutriGold400 { return "#FFCA28" }
        if self == .nutriOrange400 { return "#FFA726" }
        return "#UNKNOWN"
    }

    /// 备选RGB颜色定义（当资源文件不可用时使用）
    static var nutriGreen500Fallback: Color {
        Color(red: 76 / 255, green: 175 / 255, blue: 80 / 255)
    }
    static var nutriGreen400Fallback: Color {
        Color(red: 102 / 255, green: 187 / 255, blue: 106 / 255)
    }
    static var nutriGreen300Fallback: Color {
        Color(red: 129 / 255, green: 199 / 255, blue: 132 / 255)
    }
    static var nutriGreen100Fallback: Color {
        Color(red: 232 / 255, green: 245 / 255, blue: 233 / 255)
    }
    static var nutriGold400Fallback: Color {
        Color(red: 255 / 255, green: 202 / 255, blue: 40 / 255)
    }
    static var nutriOrange400Fallback: Color {
        Color(red: 255 / 255, green: 167 / 255, blue: 38 / 255)
    }
}
