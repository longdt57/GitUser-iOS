//
//  FollowerFormatter.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

enum FollowerFormatter {
    static func formatLargeNumber(value: Int, max: Int = 100) -> String {
        return value > max ? "\(max)+" : "\(value)"
    }
}
