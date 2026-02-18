//
//  Team.swift
//  PitchChart
//
//  Created by Andrew Defante on 2/17/26.
//

import Foundation
import SwiftData

@Model
final class Team {
    var id: UUID
    var name: String
    var season: String
    var createdAt: Date

    init(name: String, season: String) {
        self.id = UUID()
        self.name = name
        self.season = season
        self.createdAt = Date()
    }
}
