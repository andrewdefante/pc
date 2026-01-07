//
//  Pitch.swift
//  PitchChart
//
//  Created by Andrew Defante on 1/6/26.
//

import Foundation
import SwiftData

@Model
final class Pitch {
    var id: UUID
    var pitchNumber: Int
    var atBatNumber: Int   // <--- add this
    var atBatPitchNumber: Int
    var pitchType: String
    var velocity: Int?
    var isStrike: Bool
    var outcome: String?
    var location: String
    var timestamp: Date

    init(
        pitchNumber: Int,
        atBatNumber: Int,           // <--- add this
        atBatPitchNumber: Int,
        pitchType: String,
        velocity: Int? = nil,
        isStrike: Bool,
        outcome: String? = nil,
        location: String,
        timestamp: Date = .now
    ) {
        self.id = UUID()
        self.pitchNumber = pitchNumber
        self.atBatNumber = atBatNumber
        self.atBatPitchNumber = atBatPitchNumber
        self.pitchType = pitchType
        self.velocity = velocity
        self.isStrike = isStrike
        self.outcome = outcome
        self.location = location
        self.timestamp = timestamp
    }
}

