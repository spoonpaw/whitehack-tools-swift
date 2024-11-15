import SwiftUI

class CharacterStore: ObservableObject {
    @Published var characters: [Character] = []
    
    private let saveKey = "SavedCharacters"
    
    init() {
        loadCharacters()
    }
    
    func addCharacter(_ character: Character) {
        characters.append(character)
        saveCharacters()
    }
    
    func updateCharacter(_ character: Character) {
        if let index = characters.firstIndex(where: { $0.id == character.id }) {
            characters[index] = character
            saveCharacters()
        }
    }
    
    func deleteCharacter(at offsets: IndexSet) {
        characters.remove(atOffsets: offsets)
        saveCharacters()
    }
    
    private func saveCharacters() {
        if let encoded = try? JSONEncoder().encode(characters) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadCharacters() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Character].self, from: data) {
            characters = decoded
        }
    }
}
