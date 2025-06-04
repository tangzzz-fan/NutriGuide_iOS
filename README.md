# NutriGuide iOS 应用

<p align="center">
  <img src="https://img.shields.io/badge/iOS-14.0+-blue.svg" alt="iOS">
  <img src="https://img.shields.io/badge/Swift-5.9+-orange.svg" alt="Swift">
  <img src="https://img.shields.io/badge/SwiftUI-Yes-green.svg" alt="SwiftUI">
  <img src="https://img.shields.io/badge/Architecture-MVVMC-purple.svg" alt="Architecture">
</p>

> 基于AI的个性化健康膳食管理iOS应用，使用SwiftUI + Combine + Moya + MVVMC架构，遵循Clean Architecture、SOLID原则和面向协议编程(POP)。

## 📖 目录

- [项目概述](#项目概述)
- [技术栈](#技术栈)
- [项目架构](#项目架构)
- [环境要求](#环境要求)
- [快速开始](#快速开始)
- [项目结构](#项目结构)
- [核心功能](#核心功能)
- [开发规范](#开发规范)
- [配置管理](#配置管理)
- [日志系统](#日志系统)
- [存储管理](#存储管理)
- [UI设计系统](#ui设计系统)
- [测试](#测试)
- [部署](#部署)
- [贡献指南](#贡献指南)
- [常见问题](#常见问题)

## 🎯 项目概述

NutriGuide是一款基于AI的个性化健康膳食管理iOS应用，旨在为用户提供：

- **个性化膳食推荐**: 基于用户健康数据和偏好的AI推荐系统
- **营养追踪**: 全面的营养摄入记录和分析
- **健康计划**: 个性化的膳食计划和目标管理
- **数据洞察**: 直观的营养数据可视化和健康趋势分析

## 🛠 技术栈

### 核心技术
- **UI框架**: SwiftUI (iOS 14.0+)
- **响应式编程**: Combine
- **网络层**: Moya + Alamofire
- **架构模式**: MVVMC (Model-View-ViewModel-Coordinator)
- **设计模式**: Clean Architecture + POP (面向协议编程)

### 依赖管理
- **包管理器**: Swift Package Manager
- **依赖注入**: Swinject
- **日志系统**: SwiftyBeaver (准备中)
- **模型编解码**: Codable

### 数据与安全
- **本地存储**: CoreData + UserDefaults
- **安全存储**: Keychain
- **数据加密**: 传输层自动加密
- **生物识别**: Face ID / Touch ID

## 🏗 项目架构

### Clean Architecture + MVVMC

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                   │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐ │
│  │   Views     │ │ ViewModels  │ │    Coordinators     │ │
│  │  (SwiftUI)  │ │  (Combine)  │ │   (Navigation)      │ │
│  └─────────────┘ └─────────────┘ └─────────────────────┘ │
└─────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────┐
│                     Domain Layer                        │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐ │
│  │  Entities   │ │  Use Cases  │ │   Repositories      │ │
│  │ (Business)  │ │ (Business)  │ │   (Protocols)       │ │
│  └─────────────┘ └─────────────┘ └─────────────────────┘ │
└─────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────┐
│                      Data Layer                         │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐ │
│  │   Network   │ │ Repositories│ │      Local          │ │
│  │   (Moya)    │ │(Implementa) │ │   (CoreData)        │ │
│  └─────────────┘ └─────────────┘ └─────────────────────┘ │
└─────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────┐
│                 Infrastructure Layer                    │
│     DI Container │ Configuration │ Utils │ Extensions    │
└─────────────────────────────────────────────────────────┘
```

### 面向协议编程 (POP)

```swift
// 协议优先设计
protocol DataLoadable {
    associatedtype DataType
    func loadData() async throws -> DataType
}

protocol ViewModelProtocol: ObservableObject, DataLoadable, Refreshable {
    var isLoading: Bool { get set }
    var errorMessage: String { get set }
}

// 协议扩展提供默认实现
extension ViewModelProtocol {
    func handleError(_ error: Error) {
        errorMessage = ErrorHandler.handle(error)
    }
}
```

## 📋 环境要求

- **Xcode**: 15.0+
- **iOS Deployment Target**: 14.0+
- **Swift**: 5.9+
- **macOS**: 13.0+ (for development)

## 🚀 快速开始

### 1. 克隆项目
```bash
git clone https://github.com/your-org/nutriguide-ios.git
cd nutriguide-ios
```

### 2. 打开项目
```bash
open NutriGuide.xcodeproj
```

### 3. 配置环境
项目支持多环境配置，在 `Info.plist` 中设置 `APP_ENVIRONMENT`:
- `dev` - 开发环境
- `qa` - 测试环境  
- `prod` - 生产环境

### 4. 安装依赖
项目使用 Swift Package Manager，Xcode会自动下载依赖。如需手动安装：
```
File → Add Package Dependencies
```

### 5. 运行项目
选择目标设备/模拟器，按 `Cmd + R` 运行。

## 📁 项目结构

```
NutriGuide/
├── Application/              # 应用启动和配置
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Presentation/             # 表现层
│   ├── Coordinators/         # 导航协调器
│   ├── Views/               # SwiftUI视图
│   │   ├── Onboarding/
│   │   ├── Home/
│   │   ├── Plan/
│   │   ├── Log/
│   │   ├── Analysis/
│   │   └── Profile/
│   ├── ViewModels/          # 视图模型
│   └── Components/          # 可复用组件
├── Domain/                  # 业务领域层
│   ├── Entities/            # 领域实体
│   ├── UseCases/            # 用例
│   ├── Repositories/        # 仓储协议
│   └── Protocols/           # 协议定义
├── Data/                    # 数据层
│   ├── Network/             # 网络相关
│   │   ├── API/
│   │   ├── Models/
│   │   └── Services/
│   ├── Repositories/        # 仓储实现
│   └── Local/              # 本地存储
│       ├── CoreData/
│       └── UserDefaults/
├── Infrastructure/          # 基础设施
│   ├── DI/                 # 依赖注入
│   ├── Configuration/       # 环境配置
│   ├── Security/           # 安全相关
│   ├── Storage/            # 存储管理
│   ├── Extensions/         # 扩展
│   ├── Utils/              # 工具类
│   └── Constants/          # 常量
└── Resources/              # 资源文件
    ├── Assets.xcassets
    ├── Localizable.strings
    └── Info.plist
```

## 🎨 核心功能

### 主要模块

1. **Onboarding (引导)**
   - 用户画像建立
   - 健康信息收集
   - 饮食偏好设置

2. **Home (首页)**
   - 个性化推荐
   - 营养概览
   - 滑动卡片交互

3. **Plan (计划)**
   - 膳食计划查看
   - 日历视图
   - 计划定制

4. **Log (记录)**
   - 饮食记录
   - 食物搜索
   - 份量选择

5. **Analysis (分析)**
   - 营养数据统计
   - 图表展示
   - 趋势分析

6. **Profile (我的)**
   - 用户设置
   - 偏好管理
   - 数据导出

## 📝 开发规范

### 命名约定
- **文件名**: PascalCase (`HomeViewModel.swift`)
- **类/结构体**: PascalCase (`UserProfile`)
- **变量/函数**: camelCase (`userName`, `loadUserData()`)
- **常量**: camelCase (`maxRetryCount`)
- **协议**: PascalCase + Protocol后缀 (`UserRepositoryProtocol`)

### 文件创建规则
```swift
// Views - 放在对应功能模块目录下
Presentation/Views/Home/HomeView.swift

// ViewModels - 放在对应功能模块目录下  
Presentation/ViewModels/Home/HomeViewModel.swift

// Entities - 放在Domain层
Domain/Entities/UserProfile.swift

// Protocols - 放在Domain层
Domain/Protocols/UserRepositoryProtocol.swift
```

### 架构层级规则
- **Presentation层**: 只能依赖Domain层
- **Domain层**: 不依赖任何其他层，定义所有业务协议
- **Data层**: 只能依赖Domain层
- **Infrastructure层**: 为各层提供基础支撑

## ⚙️ 配置管理

### 环境配置
```swift
// 获取当前环境
let config = ConfigurationManager.shared
print("当前环境: \(config.currentEnvironment.displayName)")
print("API地址: \(config.baseURL)")

// Debug模式下环境切换
#if DEBUG
config.switchEnvironment(.qa)
#endif
```

### 应用常量
```swift
// 布局常量
AppConstants.Layout.defaultPadding // 16.0
AppConstants.Layout.cornerRadius   // 12.0

// 动画常量
AppConstants.Animation.defaultDuration // 0.3
AppConstants.Animation.springResponse  // 0.5
```

## 📊 日志系统

### 当前实现 (os.log)
```swift
// 全局日志函数
logInfo("应用启动", category: "Application")
logError("网络错误", category: "Network")
logDebug("用户操作", category: "UI")

// 通过管理器
let logger = LoggerManager.shared.logger(for: "MyCategory")
logger.info("信息日志")
logger.warning("警告日志")
logger.error("错误日志")
```

### SwiftyBeaver集成 (计划中)
参考 `SwiftyBeaverLogger.swift` 文件中的集成指南。

## 💾 存储管理

### UserDefaults统一管理
```swift
// 基本使用
let userDefaults = UserDefaultsManager.shared

// 应用状态
userDefaults.isFirstLaunch = false
userDefaults.appUsageCount += 1

// 用户偏好
userDefaults.isDailyNotificationEnabled = true
userDefaults.preferredTheme = "dark"

// Codable对象存储
struct UserPreference: Codable {
    let theme: String
    let language: String
}

let preference = UserPreference(theme: "dark", language: "zh-Hans")
userDefaults.set(preference, for: .userPreferences)

// 响应式监听
userDefaults.boolPublisher(for: .dailyNotificationEnabled)
    .sink { isEnabled in
        print("通知设置变更: \(isEnabled)")
    }
    .store(in: &cancellables)
```

### Keychain安全存储
```swift
// 敏感数据使用Keychain
struct HealthProfile: Codable, SecureStorable {
    let height: Double
    let weight: Double
    let medicalConditions: [String]
    
    var storageType: StorageType { .keychain }
}
```

## 🎨 UI设计系统

### 颜色系统
```swift
// 主色系
Color.nutriGreen500    // #4CAF50 主要CTA
Color.nutriGreen400    // #66BB6A 次要强调
Color.nutriGreen300    // #81C784 背景渐变

// 辅助色
Color.nutriGold400     // #FFCA28 谷物、能量
Color.nutriOrange400   // #FFA726 水果、活力

// 中性色
Color.nutriWhite       // #FFFFFF 主要背景
Color.nutriGray700     // #616161 次要文字
Color.nutriBlack       // #212121 主要文字
```

### 字体系统
```swift
// 标题字体
Text("大标题").font(.nutriLargeTitle)    // 34pt, Bold
Text("一级标题").font(.nutriTitle1)      // 28pt, Semibold
Text("二级标题").font(.nutriTitle2)      // 22pt, Semibold

// 正文字体
Text("正文内容").font(.nutriBody)        // 17pt, Regular
Text("强调正文").font(.nutriBodyEmphasized) // 17pt, Medium

// 按钮字体
Text("按钮").font(.nutriButtonLarge)     // 17pt, Semibold
```

### 布局规范
```swift
VStack(spacing: AppConstants.Layout.defaultPadding) {
    // 内容
}
.padding(AppConstants.Layout.defaultPadding)
.background(Color.nutriCardBackground)
.cornerRadius(AppConstants.Layout.cornerRadius)
```

## 🧪 测试

### 单元测试
```swift
// ViewModel测试示例
@testable import NutriGuide
import XCTest
import Combine

final class HomeViewModelTests: XCTestCase {
    func testDataLoading() async throws {
        // Given
        let mockUseCase = MockHomeUseCase()
        let viewModel = HomeViewModel(useCase: mockUseCase)
        
        // When
        let data = try await viewModel.loadData()
        
        // Then
        XCTAssertNotNil(data)
        XCTAssertFalse(viewModel.isLoading)
    }
}
```

### 测试运行
```bash
# 运行所有测试
cmd + U

# 运行特定测试
cmd + shift + U
```

## 🚀 部署

### 构建配置
1. **Development**: 开发版本，启用调试功能
2. **QA**: 测试版本，用于内部测试
3. **Production**: 生产版本，优化性能和安全

### 环境切换
在 `Info.plist` 中配置 `APP_ENVIRONMENT` 键值。

## 🤝 贡献指南

### 开发流程
1. **创建分支**: `git checkout -b feature/new-feature`
2. **开发功能**: 遵循项目规范编写代码
3. **编写测试**: 为新功能添加单元测试
4. **提交代码**: 使用规范的commit message
5. **创建PR**: 详细描述变更内容

### Commit Message规范
```
type(scope): description

# 类型
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式
refactor: 重构
test: 测试相关
chore: 构建过程或辅助工具的变动

# 示例
feat(auth): add biometric authentication
fix(network): resolve timeout issue
docs(readme): update installation guide
```

### 代码审查清单
- [ ] 遵循命名约定
- [ ] 遵循架构层级规则
- [ ] 添加必要的注释
- [ ] 编写或更新测试
- [ ] 确保代码编译无警告
- [ ] 验证功能正常工作

## ❓ 常见问题

### Q: 如何添加新的颜色？
A: 在 `Assets.xcassets` 中创建新的 `.colorset`，然后在 `Color+NutriGuide.swift` 中添加扩展。

### Q: 如何创建新的ViewModel？
A: 继承 `ViewModelProtocol`，使用依赖注入获取UseCase，遵循MVVMC架构。

### Q: 如何处理网络错误？
A: 使用统一的 `ErrorHandler.handle()` 方法，在ViewModel中处理错误并更新UI状态。

### Q: 如何添加新的UserDefaults键？
A: 在 `UserDefaultsKey` 枚举中添加新的case，并设置默认值。

### Q: 如何切换开发环境？
A: Debug模式下可以调用 `ConfigurationManager.shared.switchEnvironment()`。

---

## 📄 许可证

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 团队

- **项目负责人**: [Your Name]
- **iOS开发**: [Team Members]
- **UI/UX设计**: [Design Team]
- **后端开发**: [Backend Team]

## 📞 支持

如有问题，请通过以下方式联系：
- 📧 Email: dev@nutriguide.com
- 💬 Slack: #nutriguide-ios
- 📋 Issues: [GitHub Issues](https://github.com/your-org/nutriguide-ios/issues)

---

> 最后更新：2024年12月 | 版本：v1.0.0 