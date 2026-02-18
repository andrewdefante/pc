//
//  LandingView.swift
//  PitchChart
//
//  Created by Andrew Defante on 2/17/26.
//

import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Text("PitchChart")
                    .font(.largeTitle)
                    .bold()

                NavigationLink("Get Started") {
                    TeamListView()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
