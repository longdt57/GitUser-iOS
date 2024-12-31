//
//  StringExtension.swift
// iOS MVVM
//
//  Created by Do, LongThanh | MDSD on 2024/11/25.
//


import Foundation
import UIKit

public extension Optional where Wrapped == String {
    
    func orEmpty() -> String {
        return self ?? ""
    }

    func ifNil(defaultValue: () -> String) -> String {
        return self ?? defaultValue()
    }
    
    func ifNilOrBlank(defaultValue: () -> String) -> String {
        return self.isNilOrBlank() ? defaultValue() : self!
    }

    func isNilOrEmpty() -> Bool {
        return self?.isEmpty ?? true
    }
    
    func isNilOrBlank() -> Bool {
        return self?.isBlank() ?? true
    }

}

public extension String {
    
    func isBlank() -> Bool {
        return self.filter { !" ".contains($0) } == ""
    }
    
    func ifEmpty(defaultValue: () -> String) -> String {
        if (self.isEmpty) {
            return defaultValue()
        } else {
            return self
        }
    }
    
    func ifBlank(defaultValue: () -> String) -> String {
        if (self.isBlank()) {
            return defaultValue()
        } else {
            return self
        }
    }
    
    func toIntOrDefault(_ defaultValue: Int) -> Int {
        return Int(self) ?? defaultValue
    }
    
    func toBool() -> Bool {
        return (self as NSString).boolValue
    }
    
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
