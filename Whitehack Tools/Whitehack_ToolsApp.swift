import SwiftUI

@main
struct Whitehack_ToolsApp: App {
    @StateObject private var characterStore = CharacterStore()
    @State private var showingImportSheet = false
    @StateObject private var importViewModel = CharacterImportViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CharacterListView()
                    .environmentObject(characterStore)
                    .environmentObject(importViewModel)
                Text("Select a character")
                    .foregroundColor(.secondary)
            }
            .navigationViewStyle(.columns)
            .sheet(isPresented: $showingImportSheet) {
                CharacterImportView(characterStore: characterStore)
                    .environmentObject(importViewModel)
            }
            .onOpenURL { url in
                do {
                    let data = try String(contentsOf: url)
                    importViewModel.setImportText(data)
                    showingImportSheet = true
                } catch {
                    print("Error reading file: \(error)")
                }
            }
        }
    }
}
