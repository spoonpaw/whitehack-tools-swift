import SwiftUI

@main
struct Whitehack_ToolsApp: App {
    @StateObject private var characterStore = CharacterStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CharacterListView()
                    .environmentObject(characterStore)
                Text("Select a character")
                    .foregroundColor(.secondary)
            }
            .navigationViewStyle(.columns)
        }
    }
}
