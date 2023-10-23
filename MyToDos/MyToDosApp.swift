import SwiftUI

@main
struct MyToDosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(DataStore())
        }
    }
}
