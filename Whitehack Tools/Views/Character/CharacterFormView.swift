import SwiftUI

struct CharacterFormView: View {
    init(characterStore: CharacterStore, character: PlayerCharacter? = nil) {
        self.characterStore = characterStore
        self.character = character
    }
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var characterStore: CharacterStore
    let character: PlayerCharacter?
    
    // MARK: - Form Data Model
    // Holds all form state separate from the store
    private class FormData: ObservableObject {
        @Published var name: String = ""
        @Published var selectedClass: CharacterClass = .deft
        @Published var level: String = "1"
        
        // Attributes
        @Published var strength: String = "10"
        @Published var agility: String = "10"
        @Published var toughness: String = "10"
        @Published var intelligence: String = "10"
        @Published var willpower: String = "10"
        @Published var charisma: String = "10"
        
        // Combat Stats
        @Published var currentHP: String = "0"
        @Published var maxHP: String = "0"
        @Published var defenseValue: String = "0"
        @Published var movement: String = "30"
        @Published var saveColor: String = ""
        
        // Groups
        @Published var speciesGroup: String = ""
        @Published var vocationGroup: String = ""
        @Published var affiliationGroups: [String] = []
        @Published var newAffiliationGroup: String = ""
        @Published var attributeGroupPairs: [AttributeGroupPair] = []
        @Published var selectedAttribute: String = "Strength"
        @Published var newAttributeGroup: String = ""
        
        // Other
        @Published var languages: [String] = ["Common"]
        @Published var newLanguage: String = ""
        @Published var notes: String = ""
        @Published var experience: String = "0"
        @Published var corruption: String = "0"
        
        // Equipment
        @Published var inventory: [String] = []
        @Published var newInventoryItem: String = ""
        @Published var coins: String = "0"
        
        // Encumbrance
        @Published var currentEncumbrance: String = "0"
        @Published var maxEncumbrance: String = "15"
        
        // Flags
        @Published var isSpeciesGroupAdded: Bool = false
        @Published var isVocationGroupAdded: Bool = false
        
        // Initialize from character if editing
        func loadFrom(_ character: PlayerCharacter) {
            name = character.name
            selectedClass = character.characterClass
            level = String(character.level)
            
            // Attributes
            strength = String(character.strength)
            agility = String(character.agility)
            toughness = String(character.toughness)
            intelligence = String(character.intelligence)
            willpower = String(character.willpower)
            charisma = String(character.charisma)
            
            // Combat Stats
            currentHP = String(character.currentHP)
            maxHP = String(character.maxHP)
            defenseValue = String(character.defenseValue)
            movement = String(character.movement)
            saveColor = character.saveColor
            
            // Groups
            speciesGroup = character.speciesGroup ?? ""
            vocationGroup = character.vocationGroup ?? ""
            affiliationGroups = character.affiliationGroups
            attributeGroupPairs = character.attributeGroupPairs
            
            // Equipment and Other
            inventory = character.inventory
            coins = String(character.coins)
            currentEncumbrance = String(character.currentEncumbrance)
            maxEncumbrance = String(character.maxEncumbrance)
            languages = character.languages
            notes = character.notes
            experience = String(character.experience)
            corruption = String(character.corruption)
            
            // Update flags
            isSpeciesGroupAdded = !speciesGroup.isEmpty
            isVocationGroupAdded = !vocationGroup.isEmpty
        }
    }
    
    // State object to hold all form data
    @StateObject private var formData = FormData()
    
    // MARK: - Focus State
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case name, level
        case strength, agility, toughness, intelligence, willpower, charisma
        case currentHP, maxHP, defenseValue, movement, saveColor
        case speciesGroup, vocationGroup, newAffiliationGroup
        case newLanguage, newInventoryItem
        case currentEncumbrance, maxEncumbrance, coins
        case experience, corruption, notes
        case selectedAttribute, newAttributeGroup
    }
    
    var body: some View {
        NavigationView {
            Form {
                // MARK: Basic Info Section
                BasicInfoSection(
                    name: $formData.name,
                    selectedClass: $formData.selectedClass,
                    level: $formData.level,
                    focusedField: $focusedField
                )
                
                // MARK: Attributes Section
                Section(header: Text("Attributes").font(.headline)) {
                    VStack(spacing: 16) {
                        AttributeEditor(
                            label: "Strength",
                            value: $formData.strength,
                            range: 3...18,
                            focusedField: focusedField,
                            field: .strength,
                            focusBinding: $focusedField
                        )
                        AttributeEditor(
                            label: "Agility",
                            value: $formData.agility,
                            range: 3...18,
                            focusedField: focusedField,
                            field: .agility,
                            focusBinding: $focusedField
                        )
                        AttributeEditor(
                            label: "Toughness",
                            value: $formData.toughness,
                            range: 3...18,
                            focusedField: focusedField,
                            field: .toughness,
                            focusBinding: $focusedField
                        )
                        AttributeEditor(
                            label: "Intelligence",
                            value: $formData.intelligence,
                            range: 3...18,
                            focusedField: focusedField,
                            field: .intelligence,
                            focusBinding: $focusedField
                        )
                        AttributeEditor(
                            label: "Willpower",
                            value: $formData.willpower,
                            range: 3...18,
                            focusedField: focusedField,
                            field: .willpower,
                            focusBinding: $focusedField
                        )
                        AttributeEditor(
                            label: "Charisma",
                            value: $formData.charisma,
                            range: 3...18,
                            focusedField: focusedField,
                            field: .charisma,
                            focusBinding: $focusedField
                        )
                    }
                    .padding(.vertical, 8)
                }
                
                // MARK: Combat Stats Section
                CombatStatsSection(
                    currentHP: $formData.currentHP,
                    maxHP: $formData.maxHP,
                    defenseValue: $formData.defenseValue,
                    movement: $formData.movement,
                    saveColor: $formData.saveColor,
                    focusedField: $focusedField
                )
                
                // MARK: Group Associations Section
                CharacterGroupsSection(
                    speciesGroup: $formData.speciesGroup,
                    vocationGroup: $formData.vocationGroup,
                    affiliationGroups: $formData.affiliationGroups,
                    newAffiliationGroup: $formData.newAffiliationGroup,
                    attributeGroupPairs: $formData.attributeGroupPairs,
                    selectedAttribute: $formData.selectedAttribute,
                    newAttributeGroup: $formData.newAttributeGroup,
                    isSpeciesGroupAdded: $formData.isSpeciesGroupAdded,
                    isVocationGroupAdded: $formData.isVocationGroupAdded,
                    focusedField: $focusedField
                )
                
                // MARK: Languages Section
                LanguagesSection(
                    languages: $formData.languages,
                    newLanguage: $formData.newLanguage,
                    focusedField: $focusedField
                )
                
                // MARK: Equipment Section
                EquipmentSection(
                    inventory: $formData.inventory,
                    newInventoryItem: $formData.newInventoryItem,
                    coins: $formData.coins,
                    focusedField: $focusedField
                )
                
                // MARK: Encumbrance Section
                EncumbranceSection(
                    currentEncumbrance: $formData.currentEncumbrance,
                    maxEncumbrance: $formData.maxEncumbrance,
                    focusedField: $focusedField
                )
                
                // MARK: Notes Section
                NotesSection(
                    notes: $formData.notes,
                    focusedField: $focusedField
                )
                
                // MARK: Other Information Section
                OtherInformationSection(
                    experience: $formData.experience,
                    corruption: $formData.corruption,
                    focusedField: $focusedField
                )
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
                        saveCharacter()
                    }
                    .disabled(!isFormValid())
                }
            }
            .onAppear {
                if let character = character {
                    formData.loadFrom(character)
                }
            }
            .onTapGesture {
                focusedField = nil
            }
        }
    }
    
    private func isFormValid() -> Bool {
        guard !formData.name.trimmingCharacters(in: .whitespaces).isEmpty,
              let levelInt = Int(formData.level), levelInt > 0,
              let strengthInt = Int(formData.strength), (3...18).contains(strengthInt),
              let agilityInt = Int(formData.agility), (3...18).contains(agilityInt),
              let toughnessInt = Int(formData.toughness), (3...18).contains(toughnessInt),
              let intelligenceInt = Int(formData.intelligence), (3...18).contains(intelligenceInt),
              let willpowerInt = Int(formData.willpower), (3...18).contains(willpowerInt),
              let charismaInt = Int(formData.charisma), (3...18).contains(charismaInt),
              let currentHPInt = Int(formData.currentHP),
              let maxHPInt = Int(formData.maxHP), maxHPInt > 0,
              let defenseValueInt = Int(formData.defenseValue), defenseValueInt >= 0,
              let movementInt = Int(formData.movement), movementInt >= 0
        else {
            return false
        }
        return true
    }
    
    private func saveCharacter() {
        guard isFormValid() else { return }
        
        let newCharacter = PlayerCharacter(
            id: character?.id ?? UUID(),
            name: formData.name.trimmingCharacters(in: .whitespaces),
            characterClass: formData.selectedClass,
            level: Int(formData.level) ?? 1,
            strength: Int(formData.strength) ?? 10,
            agility: Int(formData.agility) ?? 10,
            toughness: Int(formData.toughness) ?? 10,
            intelligence: Int(formData.intelligence) ?? 10,
            willpower: Int(formData.willpower) ?? 10,
            charisma: Int(formData.charisma) ?? 10,
            currentHP: Int(formData.currentHP) ?? 0,
            maxHP: Int(formData.maxHP) ?? 0,
            defenseValue: Int(formData.defenseValue) ?? 0,
            movement: Int(formData.movement) ?? 30,
            saveColor: formData.saveColor,
            speciesGroup: formData.speciesGroup.isEmpty ? nil : formData.speciesGroup.trimmingCharacters(in: .whitespaces),
            vocationGroup: formData.vocationGroup.isEmpty ? nil : formData.vocationGroup.trimmingCharacters(in: .whitespaces),
            affiliationGroups: formData.affiliationGroups,
            attributeGroupPairs: formData.attributeGroupPairs,
            languages: formData.languages,
            notes: formData.notes.trimmingCharacters(in: .whitespacesAndNewlines),
            experience: Int(formData.experience) ?? 0,
            corruption: Int(formData.corruption) ?? 0,
            inventory: formData.inventory,
            currentEncumbrance: Int(formData.currentEncumbrance) ?? 0,
            maxEncumbrance: Int(formData.maxEncumbrance) ?? 15,
            coins: Int(formData.coins) ?? 0
        )
        
        // Only touch the store when saving
        if character != nil {
            characterStore.updateCharacter(newCharacter)
        } else {
            characterStore.addCharacter(newCharacter)
        }
        dismiss()
    }
}
