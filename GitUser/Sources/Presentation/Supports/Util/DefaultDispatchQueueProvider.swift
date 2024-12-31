//
//  DispatchQueueProviderImpl.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import Foundation

class DefaultDispatchQueueProvider: DispatchQueueProvider {
    var backgroundQueue: DispatchQueue {
        return DispatchQueue.global(qos: .userInitiated) // Background queue for tasks
    }
    
    var mainQueue: DispatchQueue {
        return DispatchQueue.main // Main queue for UI updates
    }
}

