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
    var atBatNumber: Int
    var atBatPitchNumber: Int
    var pitchType: String
    var velocity: Int?
    var isStrike: Bool
    var result: String
    var zone: Int
    var count: String
    var inning: Int
    var paResult: String?
    var outsRecorded: Int
    var timestamp: Date

    var player: Player?
    var game: Game?

    init(
        pitchNumber: Int,
        atBatNumber: Int,
        atBatPitchNumber: Int,
        pitchType: String,
        velocity: Int? = nil,
        isStrike: Bool,
        result: String,
        zone: Int,
        count: String,
        inning: Int,
        paResult: String? = nil,
        outsRecorded: Int = 0,
        timestamp: Date = .now
    ) {
        self.id = UUID()
        self.pitchNumber = pitchNumber
        self.atBatNumber = atBatNumber
        self.atBatPitchNumber = atBatPitchNumber
        self.pitchType = pitchType
        self.velocity = velocity
        self.isStrike = isStrike
        self.result = result
        self.zone = zone
        self.count = count
        self.inning = inning
        self.paResult = paResult
        self.outsRecorded = outsRecorded
        self.timestamp = timestamp
    }
}
