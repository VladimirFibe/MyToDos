import SwiftUI
import OSLog

@main
struct MyToDosApp: App {
    let logger = Logger()

    @State private var dataStore = DataStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dataStore)
                .onAppear {
                    logger.info("\(URL.documentsDirectory.path())")
                }
        }
    }
}
