import SwiftUI

struct CharacterListView: View {
    @StateObject private var characterStore = CharacterStore()
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(characterStore.characters) { character in
                    NavigationLink(destination: CharacterDetailView(character: character, characterStore: characterStore)) {
                        CharacterRowView(character: character)
                    }
                }
                .onDelete(perform: characterStore.deleteCharacter)
            }
            .navigationTitle("Characters")
            .toolbar {
                Button(action: { showingAddSheet = true }) {
                    Label("Add Character", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                CharacterFormView(characterStore: characterStore)
            }
        }
    }
}

struct CharacterRowView: View {
    let character: Character
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(character.name)
                .font(.headline)
            Text("\(character.characterClass) - Level \(character.level)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    CharacterListView()
}
