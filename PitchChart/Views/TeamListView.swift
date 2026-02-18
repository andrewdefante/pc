//
//  TeamListView.swift
//  PitchChart
//
//  Created by Andrew Defante on 2/17/26.
//

import SwiftUI

struct TeamListView: View {

    @State private var teams = ["Varsity 2025", "JV 2025"]
    @State private var newTeamName = ""

    var body: some View {
        VStack {
            List {
                ForEach(teams, id: \.self) { team in
                    NavigationLink(team) {
                        GameListView(teamName: team)
                    }
                }
            }

            HStack {
                TextField("New Team Name", text: $newTeamName)
                    .textFieldStyle(.roundedBorder)

                Button("Add") {
                    guard !newTeamName.isEmpty else { return }
                    teams.append(newTeamName)
                    newTeamName = ""
                }
            }
            .padding()
        }
        .navigationTitle("Teams")
    }
}
