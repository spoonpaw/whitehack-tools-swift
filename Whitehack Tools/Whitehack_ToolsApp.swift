import SwiftUI

@main
struct Whitehack_ToolsApp: App {
    @StateObject private var characterStore = CharacterStore()
    
    var body: some Scene {
        WindowGroup {
            CharacterListView()
                .environmentObject(characterStore)
        }
    }
}
