import SwiftUI

struct CharacterFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var characterStore: CharacterStore
    
    // If character is nil, we're creating a new character
    // If character is provided, we're editing an existing one
    var character: Character?
    
    @State private var name: String
    @State private var characterClass: String
    @State private var level: Int
    @State private var hitPoints: Int
    @State private var notes: String
    
    init(characterStore: CharacterStore, character: Character? = nil) {
        self.characterStore = characterStore
        self.character = character
        
        // Initialize state properties
        _name = State(initialValue: character?.name ?? "")
        _characterClass = State(initialValue: character?.characterClass ?? "")
        _level = State(initialValue: character?.level ?? 1)
        _hitPoints = State(initialValue: character?.hitPoints ?? 0)
        _notes = State(initialValue: character?.notes ?? "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Name", text: $name)
                    TextField("Class", text: $characterClass)
                    Stepper("Level: \(level)", value: $level, in: 1...20)
                    Stepper("Hit Points: \(hitPoints)", value: $hitPoints, in: 0...100)
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle(character == nil ? "New Character" : "Edit Character")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updatedCharacter = Character(
                            id: character?.id ?? UUID(),
                            name: name,
                            characterClass: characterClass,
                            level: level,
                            hitPoints: hitPoints,
                            notes: notes
                        )
                        
                        if character != nil {
                            characterStore.updateCharacter(updatedCharacter)
                        } else {
                            characterStore.addCharacter(updatedCharacter)
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}
