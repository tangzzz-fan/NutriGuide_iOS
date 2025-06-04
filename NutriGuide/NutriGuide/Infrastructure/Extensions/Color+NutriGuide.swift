import SwiftUI

// MARK: - Color Convenience Methods
extension Color {
    /// 创建自定义颜色的便捷方法
    static func nutriColor(red: Double, green: Double, blue: Double, alpha: Double = 1.0) -> Color {
        return Color(red: red / 255, green: green / 255, blue: blue / 255, opacity: alpha)
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
