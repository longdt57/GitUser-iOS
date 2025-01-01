//
//  FollowerFormatter.swift
//  Git Users
//
//  Created by Long Do on 31/12/2024.
//

enum FollowerFormatter {
    static func formatLargeNumber(value: Int, max: Int = 100) -> String {
        value > max ? "\(max)+" : "\(value)"
    }
}
