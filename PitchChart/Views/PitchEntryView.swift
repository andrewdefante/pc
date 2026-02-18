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
    case strike, ball, inPlay
}

enum StrikeType {
    case taken, whiff, foul
}

enum InPlayType {
    case hit, out, error, other
}

struct PitchEntryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Pitch.pitchNumber, order: .forward) var pitches: [Pitch]

    // MARK: - Counters
    @State private var totalPitchNumber: Int = 1
    @State private var atBatNumber: Int = 1
    @State private var atBatPitchNumber: Int = 1
    @State private var outs: Int = 0
    @State private var currentInning: Int = 1
    @State private var currentCount: String = "0-0"

    // MARK: - Inputs
    @State private var velocity: String = ""
    @State private var pitchType: String = ""
    @State private var pitchResultType: PitchResultType? = nil
    @State private var strikeType: StrikeType? = nil
    @State private var inPlayType: InPlayType? = nil
    @State private var selectedZone: Int = 0

    @State private var savedMessage: String = ""
    @State private var showCurrentAtBat: Bool = true

    let pitchTypes = ["FB", "CB", "SL", "CH", "SPL"]
    let zoneLabels = ["TL","TM","TR","ML","MM","MR","BL","BM","BR"]

    // MARK: - Derived
    var displayedPitches: [Pitch] {
        if showCurrentAtBat {
            return pitches.filter { $0.atBatNumber == atBatNumber }
        } else {
            return pitches
        }
    }

    private var balls: Int {
        let parts = currentCount.split(separator: "-")
        return Int(parts.first ?? "0") ?? 0
    }

    private var strikes: Int {
        let parts = currentCount.split(separator: "-")
        return Int(parts.last ?? "0") ?? 0
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 15) {
            countersBar
            actionButtons
            Divider()
            pitchList
            Divider()
            pitchEntryForm
        }
        .padding()
        .navigationTitle("Pitch Entry")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Counters Bar
    private var countersBar: some View {
        HStack {
            Text("Pitch: \(totalPitchNumber)")
            Spacer()
            Text("Inning: \(currentInning)")
            Spacer()
            Text("Count: \(currentCount)")
            Spacer()
            Text("Outs: \(outs)")
        }
        .font(.headline)
    }

    // MARK: - Action Buttons
    private var actionButtons: some View {
        HStack(spacing: 10) {
            Button("End At-Bat") {
                atBatPitchNumber = 1
                atBatNumber += 1
                currentCount = "0-0"
                savedMessage = "At-Bat ended"
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)

            Button("End Inning") {
                atBatPitchNumber = 1
                atBatNumber += 1
                currentCount = "0-0"
                outs = 0
                currentInning += 1
                savedMessage = "Inning \(currentInning - 1) ended"
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }

    // MARK: - Pitch List
    private var pitchList: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Pitches — \(showCurrentAtBat ? "Current At-Bat" : "Full Game")")
                    .font(.headline)
                Spacer()
                Toggle("", isOn: $showCurrentAtBat)
                    .labelsHidden()
            }

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 5) {
                    ForEach(displayedPitches, id: \.id) { pitch in
                        HStack {
                            Text("#\(pitch.pitchNumber)").bold().frame(width: 35, alignment: .leading)
                            Text(pitch.pitchType).frame(width: 35, alignment: .leading)
                            Text(pitch.result).frame(width: 50, alignment: .leading)
                            Text("Zone \(pitch.zone)").frame(width: 55, alignment: .leading)
                            if let velo = pitch.velocity {
                                Text("\(velo) mph").foregroundColor(.secondary)
                            }
                        }
                        .font(.subheadline)
                        .padding(6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                    }
                }
                .padding(.horizontal, 2)
            }
            .frame(height: 160)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }

    // MARK: - Pitch Entry Form
    private var pitchEntryForm: some View {
        ScrollView {
            VStack(spacing: 15) {
                velocityField
                pitchTypeButtons
                pitchResultButtons
                strikeSubOptions
                inPlaySubOptions
                zoneGrid
                saveButton

                if !savedMessage.isEmpty {
                    Text(savedMessage)
                        .foregroundColor(.green)
                        .bold()
                }
            }
            .padding(.vertical)
        }
    }

    // MARK: - Velocity Field
    private var velocityField: some View {
        TextField("Velocity (optional)", text: $velocity)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.numberPad)
    }

    // MARK: - Pitch Type Buttons
    private var pitchTypeButtons: some View {
        VStack(spacing: 6) {
            Text("Pitch Type").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                ForEach(pitchTypes, id: \.self) { type in
                    Button(type) { pitchType = type }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(pitchType == type ? Color.blue : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }

    // MARK: - Pitch Result Buttons
    private var pitchResultButtons: some View {
        VStack(spacing: 6) {
            Text("Result").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 10) {
                Button("Strike") {
                    pitchResultType = .strike
                    strikeType = nil
                    inPlayType = nil
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(pitchResultType == .strike ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("Ball") {
                    pitchResultType = .ball
                    strikeType = nil
                    inPlayType = nil
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(pitchResultType == .ball ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("In-Play") {
                    pitchResultType = .inPlay
                    strikeType = nil
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(pitchResultType == .inPlay ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
    }

    // MARK: - Strike Sub Options
    private var strikeSubOptions: some View {
        Group {
            if pitchResultType == .strike {
                HStack(spacing: 10) {
                    Button("Taken") { strikeType = .taken }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(strikeType == .taken ? Color.green : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)

                    Button("Whiff") { strikeType = .whiff }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(strikeType == .whiff ? Color.green : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)

                    Button("Foul") { strikeType = .foul }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(strikeType == .foul ? Color.green : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }

    // MARK: - In Play Sub Options
    private var inPlaySubOptions: some View {
        Group {
            if pitchResultType == .inPlay {
                HStack(spacing: 10) {
                    Button("Hit") { inPlayType = .hit }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(inPlayType == .hit ? Color.green : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)

                    Button("Out") {
                        inPlayType = .out
                        outs = min(outs + 1, 3)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(inPlayType == .out ? Color.green : Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    Button("Error") { inPlayType = .error }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(inPlayType == .error ? Color.green : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)

                    Button("Other") { inPlayType = .other }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(inPlayType == .other ? Color.green : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }

    // MARK: - Zone Grid
    private var zoneGrid: some View {
        VStack(spacing: 6) {
            Text("Zone").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                ForEach(0..<9) { index in
                    Button(zoneLabels[index]) {
                        selectedZone = index + 1
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(selectedZone == index + 1 ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(6)
                }
            }
        }
    }

    // MARK: - Save Button
    private var saveButton: some View {
        Button("Save Pitch") {
            savePitch()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(canSave ? Color.green : Color.gray)
        .foregroundColor(.white)
        .cornerRadius(10)
        .disabled(!canSave)
    }

    // MARK: - Validation
    private var canSave: Bool {
        !pitchType.isEmpty && pitchResultType != nil && selectedZone != 0
    }

    // MARK: - Outcome Description
    private var outcomeDescription: String {
        switch pitchResultType {
        case .strike:
            switch strikeType {
            case .taken: return "CS"
            case .whiff: return "WHIFF"
            case .foul: return "FOUL"
            case .none: return "STRIKE"
            }
        case .ball: return "BALL"
        case .inPlay:
            switch inPlayType {
            case .hit: return "HIT"
            case .out: return "OUT"
            case .error: return "ERROR"
            case .other: return "BIP"
            case .none: return "IN-PLAY"
            }
        case .none: return ""
        }
    }

    // MARK: - Update Count
    private func updateCount() {
        var b = balls
        var s = strikes

        switch pitchResultType {
        case .ball:
            b += 1
        case .strike:
            if strikeType != .foul || s < 2 {
                s += 1
            }
        case .inPlay, .none:
            break
        }
        currentCount = "\(b)-\(s)"
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
            result: outcomeDescription,
            zone: selectedZone,
            count: currentCount,
            inning: currentInning
        )
        context.insert(newPitch)

        do {
            try context.save()
            updateCount()
            savedMessage = "Pitch saved!"
            clearFields()
            totalPitchNumber += 1
            atBatPitchNumber += 1
        } catch {
            savedMessage = "Error saving: \(error.localizedDescription)"
        }
    }

    // MARK: - Clear Fields
    private func clearFields() {
        velocity = ""
        pitchType = ""
        pitchResultType = nil
        strikeType = nil
        inPlayType = nil
        selectedZone = 0
    }
}

#Preview {
    PitchEntryView()
        .modelContainer(for: Pitch.self, inMemory: true)
}
