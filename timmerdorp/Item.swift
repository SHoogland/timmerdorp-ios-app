//
//  Item.swift
//  timmerdorp
//
//  Created by Stephan Hoogland on 21/01/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
