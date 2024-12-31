//
//  StringExtension.swift
// iOS MVVM
//
//  Created by Do, LongThanh | MDSD on 2024/11/25.
//

import Foundation
import UIKit

extension Optional where Wrapped == String {

    public func orEmpty() -> String {
        return self ?? ""
    }

    public func ifNil(defaultValue: () -> String) -> String {
        return self ?? defaultValue()
    }

    public func ifNilOrBlank(defaultValue: () -> String) -> String {
        return isNilOrBlank() ? defaultValue() : self!
    }

    public func isNilOrEmpty() -> Bool {
        return self?.isEmpty ?? true
    }

    public func isNilOrBlank() -> Bool {
        return self?.isBlank() ?? true
    }
}

extension String {

    public func isBlank() -> Bool {
        return filter { !" ".contains($0) } == ""
    }

    public func ifEmpty(defaultValue: () -> String) -> String {
        if isEmpty {
            return defaultValue()
        } else {
            return self
        }
    }

    public func ifBlank(defaultValue: () -> String) -> String {
        if isBlank() {
            return defaultValue()
        } else {
            return self
        }
    }

    public func toIntOrDefault(_ defaultValue: Int) -> Int {
        return Int(self) ?? defaultValue
    }

    public func toBool() -> Bool {
        return (self as NSString).boolValue
    }

    public func toJSON() -> Any? {
        guard let data = data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
