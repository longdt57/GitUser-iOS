//
//  MockDispatchQueueProvider.swift
//  DataTests
//
//  Created by Long Do on 01/01/2025.
//  Copyright © 2025 Nimble. All rights reserved.
//

import Foundation
@testable import GitUser

class MockDispatchQueueProvider: DispatchQueueProvider {
    var backgroundQueue: DispatchQueue = .init(label: "background")
    var mainQueue: DispatchQueue = .main
}
