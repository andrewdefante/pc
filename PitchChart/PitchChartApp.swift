import SwiftUI
import SwiftData

@main
struct PitchChartApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Pitch.self,
            Item.self  // if you still use Item
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            PitchEntryView()
        }
        .modelContainer(sharedModelContainer)
    }
}
