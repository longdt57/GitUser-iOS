//
//  DefaultDispatchQueueProvider.swift
//  Git Users
//
//  Created by Long Do on 31/12/2024.
//

import Foundation

class DefaultDispatchQueueProvider: DispatchQueueProvider {
    var backgroundQueue: DispatchQueue {
        DispatchQueue.global(qos: .userInitiated) // Background queue for tasks
    }

    var mainQueue: DispatchQueue {
        DispatchQueue.main // Main queue for UI updates
    }
}
