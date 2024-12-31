//
//  DispatchQueueProvider.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import Foundation

protocol DispatchQueueProvider {
    var backgroundQueue: DispatchQueue { get }
    var mainQueue: DispatchQueue { get }
}
