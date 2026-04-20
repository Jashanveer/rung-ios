//
//  Item.swift
//  forma-ios
//
//  Created by Jashanveer Singh on 4/20/26.
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
