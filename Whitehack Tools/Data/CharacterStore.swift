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
        characters.remove(atOffsets: offsets)
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
