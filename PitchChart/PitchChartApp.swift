//
//  PitchChartApp.swift
//  PitchChart
//

import SwiftUI
import SwiftData

@main
struct PitchChartApp: App {
    var body: some Scene {
        WindowGroup {
            LandingView()
        }
        .modelContainer(for: [Team.self, Game.self, Player.self, Pitch.self])
    }
}
