//
//  ContentView.swift
//  NutriGuide
//
//  Created by 小苹果 on 2025/6/4.
//

import SwiftUI

struct ContentView: View {
    private let configManager: ConfigurationManagerProtocol

    init() {
        self.configManager = DIContainer.resolve(ConfigurationManagerProtocol.self)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: AppConstants.Layout.largePadding) {
                // 欢迎标题
                VStack(spacing: AppConstants.Layout.smallPadding) {
                    Text("欢迎使用 NutriGuide")
                        .font(.nutriLargeTitle)
                        .foregroundColor(.nutriBlack)

                    Text("您的智能营养伙伴")
                        .font(.nutriSubheadline)
                        .foregroundColor(.nutriGray700)
                }
                .padding(.top, AppConstants.Layout.extraLargePadding)

                Spacer()

                // 环境信息卡片
                #if DEBUG
                    environmentInfoCard
                #endif

                // 功能按钮
                VStack(spacing: AppConstants.Layout.defaultPadding) {
                    primaryButton(
                        title: "开始使用",
                        action: { /* TODO: Navigate to onboarding */  }
                    )

                    secondaryButton(
                        title: "了解更多",
                        action: { /* TODO: Show info */  }
                    )
                }

                Spacer()

                // 版本信息
                VStack(spacing: 4) {
                    Text("版本 \(AppConstants.App.version)")
                        .font(.nutriCaption)
                        .foregroundColor(.nutriGray700)

                    #if DEBUG
                        Text("构建 \(AppConstants.App.build)")
                            .font(.nutriCaption2)
                            .foregroundColor(.nutriGray700)
                    #endif
                }
            }
            .padding(.horizontal, AppConstants.Layout.defaultPadding)
            .background(Color.nutriBackground)
            .navigationBarHidden(true)
        }
    }

    // MARK: - Debug Environment Info Card
    #if DEBUG
        private var environmentInfoCard: some View {
            VStack(alignment: .leading, spacing: AppConstants.Layout.smallPadding) {
                HStack {
                    Circle()
                        .fill(Color.environmentIndicator)
                        .frame(width: 12, height: 12)

                    Text("环境信息")
                        .font(.nutriCardTitle)
                        .foregroundColor(.nutriBlack)

                    Spacer()
                }

                VStack(alignment: .leading, spacing: 4) {
                    infoRow("环境", configManager.currentEnvironment.displayName)
                    infoRow("API地址", configManager.baseURL)
                    infoRow("加密", configManager.enableEncryption ? "启用" : "禁用")
                    infoRow("日志", configManager.enableLogging ? "启用" : "禁用")
                }

                // 环境切换按钮
                HStack {
                    ForEach(Environment.allCases, id: \.self) { environment in
                        Button {
                            configManager.switchEnvironment(environment)
                        } label: {
                            Text(environment.rawValue.uppercased())
                                .font(.nutriCaption)
                                .foregroundColor(
                                    environment == configManager.currentEnvironment
                                        ? .nutriWhite : .nutriGreen500
                                )
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    environment == configManager.currentEnvironment
                                        ? Color.nutriGreen500 : Color.clear
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.nutriGreen500, lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.top, AppConstants.Layout.smallPadding)
            }
            .padding(AppConstants.Layout.defaultPadding)
            .background(Color.nutriCardBackground)
            .cornerRadius(AppConstants.Layout.cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }

        private func infoRow(_ label: String, _ value: String) -> some View {
            HStack {
                Text(label + ":")
                    .font(.nutriFootnote)
                    .foregroundColor(.nutriGray700)

                Spacer()

                Text(value)
                    .font(.nutriFootnote)
                    .foregroundColor(.nutriBlack)
            }
        }
    #endif

    // MARK: - Button Components
    private func primaryButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.nutriButtonLarge)
                .foregroundColor(.nutriWhite)
                .frame(maxWidth: .infinity)
                .frame(height: AppConstants.Layout.buttonHeight)
                .background(Color.nutriGreen500)
                .cornerRadius(AppConstants.Layout.cornerRadius)
        }
    }

    private func secondaryButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.nutriButtonLarge)
                .foregroundColor(.nutriGreen500)
                .frame(maxWidth: .infinity)
                .frame(height: AppConstants.Layout.buttonHeight)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius)
                        .stroke(Color.nutriGreen500, lineWidth: 2)
                )
        }
    }
}

#Preview {
    ContentView()
}
