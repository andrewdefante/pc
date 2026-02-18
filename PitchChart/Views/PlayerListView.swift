//
//  PlayerListView.swift
//  PitchChart
//
//  Created by Andrew Defante on 2/17/26.
//

import SwiftUI

struct PlayerListView: View {

    let teamName: String
    let gameName: String

    @State private var players = ["#12 Smith", "#22 Johnson"]
    @State private var newPlayerName = ""

    var body: some View {
        VStack {
            List {
                ForEach(players, id: \.self) { player in
                    NavigationLink(player) {
                        PitchEntryView()
                    }
                }
            }

            HStack {
                TextField("New Pitcher", text: $newPlayerName)
                    .textFieldStyle(.roundedBorder)

                Button("Add") {
                    guard !newPlayerName.isEmpty else { return }
                    players.append(newPlayerName)
                    newPlayerName = ""
                }
            }
            .padding()
        }
        .navigationTitle(gameName)
    }
}
