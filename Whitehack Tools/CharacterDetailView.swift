import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    @ObservedObject var characterStore: CharacterStore
    @State private var showingEditSheet = false
    
    var body: some View {
        List {
            Section("Basic Info") {
                Text("Name: \(character.name)")
                Text("Class: \(character.characterClass)")
                Text("Level: \(character.level)")
                Text("Hit Points: \(character.hitPoints)")
            }
            
            Section("Notes") {
                Text(character.notes)
            }
        }
        .navigationTitle(character.name)
        .toolbar {
            Button("Edit") {
                showingEditSheet = true
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            CharacterFormView(characterStore: characterStore, character: character)
        }
    }
}
