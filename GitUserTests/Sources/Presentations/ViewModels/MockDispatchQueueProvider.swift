//
//  MockDispatchQueueProvider.swift
//  DataTests
//
//  Created by Long Do on 01/01/2025.
//

import Foundation
@testable import GitUser

class MockDispatchQueueProvider: DispatchQueueProvider {
    var backgroundQueue: DispatchQueue = .main
    var mainQueue: DispatchQueue = .main
}
