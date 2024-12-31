//
//  BoolExtension.swift
// iOS MVVM
//
//  Created by Do, LongThanh | MDSD on 2024/11/25.
//


public extension Optional where Wrapped == Bool {

    public var orFalse: Bool {
        return self ?? false
    }

}

public extension Bool {
    public func not() -> Bool {
        return !self
    }
}
