//
//  GameListView 2.swift
//  PitchChart
//
//  Created by Andrew Defante on 2/17/26.
//


import SwiftUI

struct GameListView: View {

    let teamName: String
    @State private var games = ["vs Lincoln", "vs Roosevelt"]
    @State private var newGameName = ""

    var body: some View {
        VStack {
            List {
                ForEach(games, id: \.self) { game in
                    NavigationLink(game) {
                        PlayerListView(teamName: teamName, gameName: game)
                    }
                }
            }

            HStack {
                TextField("New Game", text: $newGameName)
                    .textFieldStyle(.roundedBorder)

                Button("Add") {
                    guard !newGameName.isEmpty else { return }
                    games.append(newGameName)
                    newGameName = ""
                }
            }
            .padding()
        }
        .navigationTitle(teamName)
    }
}
