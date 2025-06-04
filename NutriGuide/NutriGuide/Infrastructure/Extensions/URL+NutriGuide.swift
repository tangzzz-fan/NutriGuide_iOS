//
//  URL+NutriGuide.swift
//  NutriGuide
//
//  Created by 小苹果 on 2025/6/4.
//

import Foundation

public extension URL {
    
    var fileSize: Int {
        let fileResources = try? resourceValues(forKeys: [.fileSizeKey])
        guard let fileSize = fileResources?.fileSize else {
            return 0
        }
        return fileSize
    }
}
