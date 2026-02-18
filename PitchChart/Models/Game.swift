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
    var opponent: String
    var location: String?
    var isComplete: Bool

    @Relationship(deleteRule: .cascade, inverse: \Pitch.game)
    var pitches: [Pitch] = []

    var team: Team?

    init(
        date: Date = .now,
        opponent: String,
        location: String? = nil,
        team: Team? = nil
    ) {
        self.id = UUID()
        self.date = date
        self.opponent = opponent
        self.location = location
        self.isComplete = false
    }
}
