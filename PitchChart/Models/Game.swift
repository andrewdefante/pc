//
//  Game.swift
//  PitchChart
//
//  Created by Andrew Defante on 1/6/26.
//

import Foundation
import SwiftData

@Model
final class Game {
    var id: UUID
    var date: Date
    var opponent: String?
    var location: String?

    init(
        date: Date = .now,
        opponent: String? = nil,
        location: String? = nil
    ) {
        self.id = UUID()
        self.date = date
        self.opponent = opponent
        self.location = location
    }
}
