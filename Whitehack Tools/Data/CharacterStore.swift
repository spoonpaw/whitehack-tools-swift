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
        print(" [CHARACTER STORE] Movement: \(character.movement)")
        print(" [CHARACTER STORE] Using custom attributes: \(character.useCustomAttributes)")
        if character.useCustomAttributes {
            print(" [CHARACTER STORE] Custom attributes:")
            for attr in character.customAttributes {
                print("   - \(attr.name): \(attr.value)")
            }
        }
        print(" [CHARACTER STORE] Armor count: \(character.armor.count)")
        print(" [CHARACTER STORE] Weapon count: \(character.weapons.count)")
        characters.append(character)
        saveCharacters()
    }
    
    func updateCharacter(_ character: PlayerCharacter) {
        print("\n [CHARACTER STORE] Updating existing character")
        print(" [CHARACTER STORE] Character name: \(character.name)")
        print(" [CHARACTER STORE] Character ID: \(character.id)")
        print(" [CHARACTER STORE] Movement: \(character.movement)")
        print(" [CHARACTER STORE] Using custom attributes: \(character.useCustomAttributes)")
        if character.useCustomAttributes {
            print(" [CHARACTER STORE] Custom attributes:")
            for attr in character.customAttributes {
                print("   - \(attr.name): \(attr.value)")
            }
        }
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
        
        // Log movement value for each character before saving
        for character in characters {
            print(" [CHARACTER STORE] Character: \(character.name)")
            print("   Movement: \(character.movement)")
            print("   Using custom attributes: \(character.useCustomAttributes)")
            if character.useCustomAttributes {
                print("   Custom attributes:")
                for attr in character.customAttributes {
                    print("     - \(attr.name): \(attr.value)")
                }
            }
        }
        
        if let encoded = try? JSONEncoder().encode(characters) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
            print(" [CHARACTER STORE] Successfully saved to UserDefaults")
            
            // Verify saved data by decoding
            if let savedData = UserDefaults.standard.data(forKey: saveKey),
               let decoded = try? JSONDecoder().decode([PlayerCharacter].self, from: savedData) {
                print(" [CHARACTER STORE] Verification - Successfully decoded saved data")
                print(" [CHARACTER STORE] Verification - Decoded \(decoded.count) characters")
                
                // Verify custom attributes in decoded data
                for character in decoded {
                    print(" [CHARACTER STORE] Verification - Character: \(character.name)")
                    print("   Movement: \(character.movement)")
                    print("   Using custom attributes: \(character.useCustomAttributes)")
                    if character.useCustomAttributes {
                        print("   Custom attributes:")
                        for attr in character.customAttributes {
                            print("     - \(attr.name): \(attr.value)")
                        }
                    }
                }
            } else {
                print(" [CHARACTER STORE] ERROR: Failed to verify saved data")
            }
        } else {
            print(" [CHARACTER STORE] ERROR: Failed to encode characters")
        }
    }
    
    private func loadCharacters() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([PlayerCharacter].self, from: data) {
            print("\n [CHARACTER STORE] Loading characters from UserDefaults")
            print(" [CHARACTER STORE] Found \(decoded.count) characters")
            
            // Log movement value for loaded characters
            for character in decoded {
                print(" [CHARACTER STORE] Character: \(character.name)")
                print("   Movement: \(character.movement)")
                print("   Using custom attributes: \(character.useCustomAttributes)")
                if character.useCustomAttributes {
                    print("   Custom attributes:")
                    for attr in character.customAttributes {
                        print("     - \(attr.name): \(attr.value)")
                    }
                }
            }
            
            characters = decoded
            
            // Verify custom attributes after assignment
            print("\n [CHARACTER STORE] Verifying loaded characters")
            for character in characters {
                print(" [CHARACTER STORE] Character: \(character.name)")
                print("   Movement: \(character.movement)")
                print("   Using custom attributes: \(character.useCustomAttributes)")
                if character.useCustomAttributes {
                    print("   Custom attributes:")
                    for attr in character.customAttributes {
                        print("     - \(attr.name): \(attr.value)")
                    }
                }
            }
        } else {
            print(" [CHARACTER STORE] No saved characters found or failed to decode")
        }
    }
}
