//
//  BoolExtension.swift
// iOS MVVM
//
//  Created by Do, LongThanh | MDSD on 2024/11/25.
//

extension Optional where Wrapped == Bool {

    public var orFalse: Bool {
        return self ?? false
    }
}

extension Bool {
    public func not() -> Bool {
        return !self
    }
}
