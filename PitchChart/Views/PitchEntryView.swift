//
//  PitchEntryView.swift
//  PitchChart
//
//  Created by Andrew Defante on 1/6/26.
//

import SwiftUI
import SwiftData

// MARK: - Enums
enum PitchResultType {
    case strike
    case ball
    case inPlay
}

enum StrikeType {
    case taken
    case whiff
    case foul
}

enum InPlayType {
    case hit
    case out
    case error
    case other
}

struct PitchEntryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Pitch.pitchNumber, order: .forward) var pitches: [Pitch]

    // MARK: - Counters
    @State private var totalPitchNumber: Int = 1
    @State private var atBatNumber: Int = 1
    @State private var atBatPitchNumber: Int = 1
    @State private var outs: Int = 0

    // MARK: - Inputs
    @State private var velocity: String = ""
    @State private var pitchType: String = ""
    @State private var pitchResultType: PitchResultType? = nil
    @State private var strikeType: StrikeType? = nil
    @State private var inPlayType: InPlayType? = nil
    @State private var defensivePosition: String = ""
    @State private var location: String = ""

    @State private var savedMessage: String = ""
    @State private var showCurrentAtBat: Bool = true

    let pitchTypes = ["Fastball", "Slider", "Changeup"]
    let locationGrid = ["TL","TM","TR","ML","MM","MR","BL","BM","BR"]
    let defensivePositions = ["1B","2B","3B","SS","LF","CF","RF","C","P"]

    // Pitches to display based on toggle
    var displayedPitches: [Pitch] {
        if showCurrentAtBat {
            return pitches.filter { $0.atBatNumber == atBatNumber }
        } else {
            return pitches
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {

                // MARK: - Top Bar: Counters
                HStack {
                    Text("Total Pitch #: \(totalPitchNumber)")
                    Spacer()
                    Text("At-Bat #: \(atBatNumber)")
                    Spacer()
                    Text("At-Bat Pitch #: \(atBatPitchNumber)")
                    Spacer()
                    Text("Outs: \(outs)")
                }
                .font(.headline)

                // MARK: - End At-Bat & End Inning Buttons
                HStack(spacing: 10) {
                    Button("End At-Bat") {
                        atBatPitchNumber = 1
                        atBatNumber += 1
                        savedMessage = "At-Bat ended"
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    Button("End Inning") {
                        atBatPitchNumber = 1
                        atBatNumber = 1
                        outs = 0
                        savedMessage = "Inning ended"
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }

                Divider()

                // MARK: - Scrollable Pitch List
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Recorded Pitches (\(showCurrentAtBat ? "Current At-Bat" : "Entire Game"))")
                            .font(.headline)
                        Spacer()
                        Toggle("", isOn: $showCurrentAtBat)
                            .labelsHidden()
                    }

                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 5) { // LazyVStack allows scrolling
                            ForEach(displayedPitches, id: \.id) { pitch in
                                VStack(alignment: .leading) {
                                    Text("Pitch #\(pitch.pitchNumber) (At-Bat: \(pitch.atBatPitchNumber))").bold()
                                    Text("Type: \(pitch.pitchType)  Velocity: \(pitch.velocity ?? 0)")
                                    Text("Outcome: \(pitch.outcome ?? "-")  Location: \(pitch.location)")
                                }
                                .padding(5)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(6)
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                    .frame(height: 200) // Fixed height ensures scrolling
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)
                }

                Divider()

                // MARK: - Pitch Entry Form
                ScrollView {
                    VStack(spacing: 15) {

                        // Velocity
                        TextField("Velocity", text: $velocity)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)

                        // Pitch Type Buttons
                        Text("Pitch Type")
                            .font(.subheadline)
                        HStack {
                            ForEach(pitchTypes, id: \.self) { type in
                                Button(type) { pitchType = type }
                                    .padding(8)
                                    .background(pitchType == type ? Color.blue : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }

                        // Pitch Result Buttons
                        Text("Pitch Result")
                            .font(.subheadline)
                        HStack {
                            Button("Strike") { pitchResultType = .strike; strikeType = nil; inPlayType = nil }
                                .padding(8)
                                .background(pitchResultType == .strike ? Color.blue : Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            Button("Ball") { pitchResultType = .ball; strikeType = nil; inPlayType = nil }
                                .padding(8)
                                .background(pitchResultType == .ball ? Color.blue : Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            Button("In-Play") { pitchResultType = .inPlay; strikeType = nil }
                                .padding(8)
                                .background(pitchResultType == .inPlay ? Color.blue : Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }

                        // Strike sub-options
                        if pitchResultType == .strike {
                            HStack {
                                Button("Taken") { strikeType = .taken }
                                    .padding(6)
                                    .background(strikeType == .taken ? Color.green : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                                Button("Whiff") { strikeType = .whiff }
                                    .padding(6)
                                    .background(strikeType == .whiff ? Color.green : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                                Button("Foul") { strikeType = .foul }
                                    .padding(6)
                                    .background(strikeType == .foul ? Color.green : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                            }
                        }

                        // In-Play sub-options
                        if pitchResultType == .inPlay {
                            HStack {
                                Button("Hit") { inPlayType = .hit }
                                    .padding(6)
                                    .background(inPlayType == .hit ? Color.green : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                                Button("Out") {
                                    inPlayType = .out
                                    outs += 1
                                }
                                .padding(6)
                                .background(inPlayType == .out ? Color.green : Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(6)
                                Button("Error") { inPlayType = .error }
                                    .padding(6)
                                    .background(inPlayType == .error ? Color.green : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                                Button("Other") { inPlayType = .other }
                                    .padding(6)
                                    .background(inPlayType == .other ? Color.green : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                            }

                            if inPlayType == .other {
                                Picker("Defensive Position", selection: $defensivePosition) {
                                    ForEach(defensivePositions, id: \.self) { pos in
                                        Text(pos)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                        }

                        // Location Grid
                        Text("Location")
                            .font(.subheadline)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                            ForEach(locationGrid, id: \.self) { loc in
                                Button(loc) { location = loc }
                                    .padding(10)
                                    .background(location == loc ? Color.blue : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                            }
                        }

                        // Save Button
                        Button("Save Pitch") { savePitch() }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)

                        // Saved message
                        if !savedMessage.isEmpty {
                            Text(savedMessage)
                                .foregroundColor(.green)
                                .bold()
                        }
                    }
                    .padding(.vertical)
                }

            }
            .padding()
            .navigationTitle("Pitch Entry")
        }
    }

    // MARK: - Outcome Description
    private var outcomeDescription: String {
        switch pitchResultType {
            case .strike:
                if let strike = strikeType {
                    switch strike {
                        case .taken: return "Taken Strike"
                        case .whiff: return "Whiff"
                        case .foul: return "Foul Ball"
                    }
                }
            case .ball: return "Ball"
            case .inPlay:
                if let play = inPlayType {
                    switch play {
                        case .hit: return "Hit"
                        case .out: return "Out"
                        case .error: return "Error"
                        case .other: return "Other (\(defensivePosition))"
                    }
                }
            case .none: return ""
        }
        return ""
    }

    // MARK: - Save Pitch
    private func savePitch() {
        let veloInt = Int(velocity)
        let newPitch = Pitch(
            pitchNumber: totalPitchNumber,
            atBatNumber: atBatNumber,
            atBatPitchNumber: atBatPitchNumber,
            pitchType: pitchType,
            velocity: veloInt,
            isStrike: (pitchResultType == .strike),
            outcome: outcomeDescription,
            location: location
        )
        context.insert(newPitch)

        do {
            try context.save()
            savedMessage = "Pitch saved!"
            clearFields()
            totalPitchNumber += 1
            atBatPitchNumber += 1
        } catch {
            savedMessage = "Error saving pitch: \(error.localizedDescription)"
        }
    }

    // MARK: - Clear Fields
    private func clearFields() {
        velocity = ""
        pitchType = ""
        pitchResultType = nil
        strikeType = nil
        inPlayType = nil
        defensivePosition = ""
        location = ""
    }
}

#Preview {
    PitchEntryView()
        .modelContainer(for: Pitch.self)
}
