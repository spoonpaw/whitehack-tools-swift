import SwiftUI

class CharacterStore: ObservableObject {
    @Published private(set) var characters: [PlayerCharacter] = []
    private let saveKey = "SavedCharacters"
    
    init() {
        loadCharacters()
    }
    
    func addCharacter(_ character: PlayerCharacter) {
        print("\n [CHARACTER STORE] Adding new character")
        print(" [CHARACTER STORE] Character name: \(character.name)")
        print(" [CHARACTER STORE] Character ID: \(character.id)")
        print(" [CHARACTER STORE] Armor count: \(character.armor.count)")
        print(" [CHARACTER STORE] Weapon count: \(character.weapons.count)")
        characters.append(character)
        saveCharacters()
    }
    
    func updateCharacter(_ character: PlayerCharacter) {
        print("\n [CHARACTER STORE] Updating existing character")
        print(" [CHARACTER STORE] Character name: \(character.name)")
        print(" [CHARACTER STORE] Character ID: \(character.id)")
        print(" [CHARACTER STORE] Armor count: \(character.armor.count)")
        print(" [CHARACTER STORE] Weapon count: \(character.weapons.count)")
        if let index = characters.firstIndex(where: { $0.id == character.id }) {
            print(" [CHARACTER STORE] Found character at index: \(index)")
            characters[index] = character
            saveCharacters()
        } else {
            print(" [CHARACTER STORE] ERROR: Could not find character with ID: \(character.id)")
        }
    }
    
    func deleteCharacter(at offsets: IndexSet) {
        print("\n [CHARACTER STORE] Deleting character(s)")
        print(" [CHARACTER STORE] Current character count: \(characters.count)")
        print(" [CHARACTER STORE] Offsets to delete: \(offsets)")
        
        // Log characters before deletion
        for (index, character) in characters.enumerated() {
            print(" [CHARACTER STORE] Character \(index): ID=\(character.id), Name=\(character.name)")
        }
        
        // Get IDs of characters being deleted
        let deletedIds = offsets.map { characters[$0].id }
        print(" [CHARACTER STORE] IDs being deleted: \(deletedIds)")
        
        characters.remove(atOffsets: offsets)
        
        // Log characters after deletion
        print(" [CHARACTER STORE] Characters after deletion:")
        for (index, character) in characters.enumerated() {
            print(" [CHARACTER STORE] Character \(index): ID=\(character.id), Name=\(character.name)")
        }
        
        saveCharacters()
    }
    
    private func saveCharacters() {
        print("\n [CHARACTER STORE] Saving all characters")
        print(" [CHARACTER STORE] Total character count: \(characters.count)")
        if let encoded = try? JSONEncoder().encode(characters) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
            print(" [CHARACTER STORE] Successfully saved to UserDefaults")
        } else {
            print(" [CHARACTER STORE] ERROR: Failed to encode characters")
        }
    }
    
    private func loadCharacters() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([PlayerCharacter].self, from: data) {
            characters = decoded
        }
    }
}
