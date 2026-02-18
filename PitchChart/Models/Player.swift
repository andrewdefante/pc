//
//  Player.swift
//  PitchChart
//
//  Created by Andrew Defante on 2/17/26.
//

import Foundation
import SwiftData

@Model
final class Player {
    var id: UUID
    var name: String
    var number: String
    var season: String
    var teamId: UUID

    @Relationship(deleteRule: .nullify, inverse: \Pitch.player)
    var pitches: [Pitch] = []

    init(name: String, number: String, season: String, teamId: UUID) {
        self.id = UUID()
        self.name = name
        self.number = number
        self.season = season
        self.teamId = teamId
    }
}
