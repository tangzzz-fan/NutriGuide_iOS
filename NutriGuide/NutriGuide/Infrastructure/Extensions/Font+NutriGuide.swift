import SwiftUI

// MARK: - NutriGuide Font System
extension Font {

    // MARK: - Large Title
    /// 大标题字体 - SF Pro Display, Bold, 34pt
    static let nutriLargeTitle = Font.system(size: 34, weight: .bold, design: .default)

    // MARK: - Titles
    /// 一级标题 - SF Pro Display, Semibold, 28pt
    static let nutriTitle1 = Font.system(size: 28, weight: .semibold, design: .default)
    /// 二级标题 - SF Pro Display, Semibold, 22pt
    static let nutriTitle2 = Font.system(size: 22, weight: .semibold, design: .default)
    /// 三级标题 - SF Pro Display, Semibold, 20pt
    static let nutriTitle3 = Font.system(size: 20, weight: .semibold, design: .default)
    /// 标题 - SF Pro Text, Semibold, 17pt
    static let nutriHeadline = Font.system(size: 17, weight: .semibold, design: .default)

    // MARK: - Body Text
    /// 正文 - SF Pro Text, Regular, 17pt
    static let nutriBody = Font.system(size: 17, weight: .regular, design: .default)
    /// 强调正文 - SF Pro Text, Medium, 17pt
    static let nutriBodyEmphasized = Font.system(size: 17, weight: .medium, design: .default)
    /// 说明文字 - SF Pro Text, Regular, 16pt
    static let nutriCallout = Font.system(size: 16, weight: .regular, design: .default)
    /// 副标题 - SF Pro Text, Regular, 15pt
    static let nutriSubheadline = Font.system(size: 15, weight: .regular, design: .default)
    /// 脚注 - SF Pro Text, Regular, 13pt
    static let nutriFootnote = Font.system(size: 13, weight: .regular, design: .default)
    /// 说明 - SF Pro Text, Regular, 12pt
    static let nutriCaption = Font.system(size: 12, weight: .regular, design: .default)
    /// 小说明 - SF Pro Text, Regular, 11pt
    static let nutriCaption2 = Font.system(size: 11, weight: .regular, design: .default)

    // MARK: - Button Fonts
    /// 大按钮字体 - SF Pro Text, Semibold, 17pt
    static let nutriButtonLarge = Font.system(size: 17, weight: .semibold, design: .default)
    /// 中按钮字体 - SF Pro Text, Medium, 15pt
    static let nutriButtonMedium = Font.system(size: 15, weight: .medium, design: .default)
    /// 小按钮字体 - SF Pro Text, Medium, 13pt
    static let nutriButtonSmall = Font.system(size: 13, weight: .medium, design: .default)

    // MARK: - Specialized Fonts
    /// 导航标题字体 - SF Pro Display, Semibold, 22pt
    static let nutriNavigationTitle = Font.system(size: 22, weight: .semibold, design: .default)
    /// 标签栏字体 - SF Pro Text, Medium, 10pt
    static let nutriTabBarItem = Font.system(size: 10, weight: .medium, design: .default)
    /// 卡片标题字体 - SF Pro Text, Semibold, 18pt
    static let nutriCardTitle = Font.system(size: 18, weight: .semibold, design: .default)
    /// 卡片副标题字体 - SF Pro Text, Regular, 14pt
    static let nutriCardSubtitle = Font.system(size: 14, weight: .regular, design: .default)

    // MARK: - Numbers and Data
    /// 指标值字体 - SF Pro Display, Bold, 24pt
    static let nutriMetricValue = Font.system(size: 24, weight: .bold, design: .monospaced)
    /// 指标单位字体 - SF Pro Text, Regular, 12pt
    static let nutriMetricUnit = Font.system(size: 12, weight: .regular, design: .default)

    // MARK: - Custom Font Weights
    /// 超轻字体
    static let nutriUltraLight = Font.system(size: 17, weight: .ultraLight, design: .default)
    /// 粗体
    static let nutriBold = Font.system(size: 17, weight: .bold, design: .default)
    /// 超粗字体
    static let nutriHeavy = Font.system(size: 17, weight: .heavy, design: .default)
}

// MARK: - Font Convenience Methods
extension Font {
    /// 创建自定义字体的便捷方法
    static func nutriFont(
        size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default
    ) -> Font {
        return Font.system(size: size, weight: weight, design: design)
    }

    /// 创建等宽字体的便捷方法（用于数字显示）
    static func nutriMonospaced(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.system(size: size, weight: weight, design: .monospaced)
    }

    /// 创建圆角字体的便捷方法（用于友好的UI）
    static func nutriRounded(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.system(size: size, weight: weight, design: .rounded)
    }
}
