//
//  Bundle+NutriGuide.swift
//  NutriGuide
//
//  Created by 小苹果 on 2025/6/4.
//

import Foundation

extension Bundle {
    public var appName: String? {
        return infoDictionary?["CFBundleDisplayName"] as? String
    }
    
    public var appVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    public var buildVersion: String {
        return "(\(infoDictionary?["CFBundleVersion"] as? String ?? ""))"
    }

    public var appFullName: String {
        let appName = Bundle.main.appName
        let appVersion = Bundle.main.appVersion
        let buildVersion = Bundle.main.buildVersion
        let fullName = [appName, appVersion, buildVersion].lazy
            .compactMap({ $0 })
            .joined(separator: "_")
        return fullName
    }
}

public struct AppVersion {
    public var major: Int
    public var minor: Int?
    public var patch: Int?
    public var build: String?
    
    public var canonicalMinor: Int {
        return minor ?? 0
    }
    
    public var canonicalPatch: Int {
        return patch ?? 0
    }
    
    public init(major: Int = 0,
                minor: Int? = nil,
                patch: Int? = nil,
                build: String? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.build = build
    }
}

// MARK: - String Conversion

extension AppVersion: CustomStringConvertible {
    public var description: String {
        return [
            "\(major).\(canonicalMinor).\(canonicalPatch)",
            build != nil ? " \(build!)" : ""
            ].joined(separator: "")
    }
}

// MARK: - Equatable

extension AppVersion: Equatable {}

public func == (lhs: AppVersion, rhs: AppVersion) -> Bool {
    let equalMajor = lhs.major == rhs.major
    let equalMinor = lhs.minor == rhs.minor
    let equalPatch = lhs.patch == rhs.patch
    
    return equalMajor && equalMinor && equalPatch
}

func === (lhs: AppVersion, rhs: AppVersion) -> Bool {
    return (lhs == rhs) && (lhs.build == rhs.build)
}

func !== (lhs: AppVersion, rhs: AppVersion) -> Bool {
    return !(lhs === rhs)
}

// MARK: Extension Bundle + AppVersion

extension Bundle {
    enum VersionParserError: Error {
        case missingMinor
        case missingPatch
        case invalidComponents
        case invalidMajor
        case invalidMinor
        case invalidPatch
    }
    
    public var shortAppVersion: AppVersion? {
        return versionFromInfoDicitionary(forKey: "CFBundleShortVersionString")
    }
    
    public var shortAppVersionWithBuildVersion: AppVersion? {
        guard var shortAppVersion = shortAppVersion else {
            return nil
        }
        shortAppVersion.build = buildVersion
        
        return shortAppVersion
    }
    
    private func versionFromInfoDicitionary(forKey key: String) -> AppVersion? {
        guard let bundleVersion = infoDictionary?[key] as? String else {
            return nil
        }
        
        do {
            let components = bundleVersion.components(separatedBy: ".")
            return try parse(components)
        } catch {
            return nil
        }
    }
    
    private func parse(_ components: [String?]) throws -> AppVersion {
        var version = AppVersion()
        
        if components.count != 3 { // major, minor, patch
            throw VersionParserError.invalidComponents
        }
        
        if components[1] == nil {
            throw VersionParserError.missingMinor
        } else if components[2] == nil {
            throw VersionParserError.missingPatch
        }
        
        let majorComponent = components[0]
        let minorComponent = components[1]
        let patchComponent = components[2]
        
        if let major = majorComponent.flatMap({ Int($0) }) {
            version.major = major
        } else {
            throw VersionParserError.invalidMajor
        }
        
        if let minor = minorComponent.flatMap({ Int($0) }) {
            version.minor = minor
        } else if minorComponent != nil {
            throw VersionParserError.invalidMinor
        }
        
        if let patch = patchComponent.flatMap({ Int($0) }) {
            version.patch = patch
        } else if patchComponent != nil {
            throw VersionParserError.invalidPatch
        }
        
        return version
    }
}

