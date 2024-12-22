import SwiftUI

@main
struct Whitehack_ToolsApp: App {
    @StateObject private var characterStore = CharacterStore()
    @StateObject private var importViewModel = CharacterImportViewModel()
    
    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            CharacterListView()
                .frame(minWidth: 375, idealWidth: 500, maxWidth: .infinity, minHeight: 600)
                .environmentObject(characterStore)
                .environmentObject(importViewModel)
            #else
            NavigationView {
                CharacterListView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(characterStore)
            .environmentObject(importViewModel)
            #endif
        }
        #if os(macOS)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
        #endif
    }
}
