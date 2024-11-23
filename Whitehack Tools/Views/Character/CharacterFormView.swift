import SwiftUI

struct CharacterFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var characterStore: CharacterStore
    let character: PlayerCharacter?
    
    // MARK: - Form Data Model
    // Holds all form state separate from the store
    @StateObject private var formData = FormData()
    @FocusState private var focusedField: Field?
    
    init(characterStore: CharacterStore, character: PlayerCharacter? = nil) {
        self.characterStore = characterStore
        self.character = character
    }
    
    // MARK: - Form Fields
    enum Field: Hashable {
        case name, level
        case strength, agility, toughness, intelligence, willpower, charisma
        case currentHP, maxHP, defenseValue, movement, saveColor
        case speciesGroup, vocationGroup, newAffiliationGroup
        case newLanguage
        case newInventoryItem, coins
        case currentEncumbrance, maxEncumbrance
        case notes
        case experience, corruption
        case selectedAttribute, newAttributeGroup
        case attunementName
    }
    
    var body: some View {
        Form(content: {
            FormBasicInfoSection(
                name: $formData.name,
                selectedClass: $formData.selectedClass,
                level: $formData.level,
                focusedField: $focusedField
            )
            FormAttributesSection(
                strength: $formData.strength,
                agility: $formData.agility,
                toughness: $formData.toughness,
                intelligence: $formData.intelligence,
                willpower: $formData.willpower,
                charisma: $formData.charisma,
                focusedField: $focusedField
            )
            FormCharacterGroupsSection(
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
            FormCombatStatsSection(
                currentHP: $formData.currentHP,
                maxHP: $formData.maxHP,
                defenseValue: $formData.defenseValue,
                movement: $formData.movement,
                saveColor: $formData.saveColor,
                focusedField: $focusedField
            )
            FormLanguagesSection(
                languages: $formData.languages,
                newLanguage: $formData.newLanguage,
                focusedField: $focusedField
            )
            FormEquipmentSection(
                inventory: $formData.inventory,
                newInventoryItem: $formData.newInventoryItem,
                coins: $formData.coins,
                focusedField: $focusedField
            )
            FormEncumbranceSection(
                currentEncumbrance: $formData.currentEncumbrance,
                maxEncumbrance: $formData.maxEncumbrance,
                focusedField: $focusedField
            )
            FormOtherInformationSection(
                experience: $formData.experience,
                corruption: $formData.corruption,
                focusedField: $focusedField
            )
            FormDeftAttunementSection(
                characterClass: formData.selectedClass,
                level: Int(formData.level) ?? 1,
                attunementSlots: $formData.attunementSlots,
                hasUsedAttunementToday: $formData.hasUsedAttunementToday
            )
            FormStrongCombatSection(
                characterClass: formData.selectedClass,
                level: Int(formData.level) ?? 1,
                currentConflictLoot: $formData.currentConflictLoot,
                strongCombatOptions: $formData.strongCombatOptions
            )
            FormWiseMiracleSection(
                characterClass: formData.selectedClass,
                level: Int(formData.level) ?? 1,
                willpower: Int(formData.willpower) ?? 10,
                miracleSlots: $formData.wiseMiracleSlots
            )
            FormNotesSection(
                notes: $formData.notes,
                focusedField: $focusedField
            )
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveCharacter()
                    dismiss()
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear {
            if let character = character {
                loadCharacter(character)
            }
        }
    }
    
    // MARK: - Helper Functions
    private func loadCharacter(_ character: PlayerCharacter) {
        formData.name = character.name
        formData.selectedClass = character.characterClass
        formData.level = String(character.level)
        
        formData.strength = String(character.strength)
        formData.agility = String(character.agility)
        formData.toughness = String(character.toughness)
        formData.intelligence = String(character.intelligence)
        formData.willpower = String(character.willpower)
        formData.charisma = String(character.charisma)
        
        formData.currentHP = String(character.currentHP)
        formData.maxHP = String(character.maxHP)
        formData.defenseValue = String(character.defenseValue)
        formData.movement = String(character.movement)
        formData.saveColor = character.saveColor
        
        formData.speciesGroup = character.speciesGroup ?? ""
        formData.vocationGroup = character.vocationGroup ?? ""
        formData.affiliationGroups = character.affiliationGroups
        formData.attributeGroupPairs = character.attributeGroupPairs
        
        formData.languages = character.languages
        
        formData.inventory = character.inventory
        formData.coins = String(character.coins)
        
        formData.currentEncumbrance = String(character.currentEncumbrance)
        formData.maxEncumbrance = String(character.maxEncumbrance)
        
        formData.notes = character.notes
        
        formData.experience = String(character.experience)
        formData.corruption = String(character.corruption)
        
        formData.attunementSlots = character.attunementSlots
        formData.hasUsedAttunementToday = character.hasUsedAttunementToday
        
        formData.currentConflictLoot = character.currentConflictLoot
        formData.strongCombatOptions = character.strongCombatOptions
        formData.wiseMiracleSlots = character.wiseMiracleSlots
    }
    
    private func saveCharacter() {
        var newCharacter = PlayerCharacter(id: character?.id ?? UUID())
        newCharacter.name = formData.name
        newCharacter.characterClass = formData.selectedClass
        newCharacter.level = Int(formData.level) ?? 1
        
        // Attributes
        newCharacter.strength = Int(formData.strength) ?? 10
        newCharacter.agility = Int(formData.agility) ?? 10
        newCharacter.toughness = Int(formData.toughness) ?? 10
        newCharacter.intelligence = Int(formData.intelligence) ?? 10
        newCharacter.willpower = Int(formData.willpower) ?? 10
        newCharacter.charisma = Int(formData.charisma) ?? 10
        
        // Combat Stats
        newCharacter.currentHP = Int(formData.currentHP) ?? 0
        newCharacter.maxHP = Int(formData.maxHP) ?? 0
        newCharacter.defenseValue = Int(formData.defenseValue) ?? 10
        newCharacter.movement = Int(formData.movement) ?? 30
        newCharacter.saveColor = formData.saveColor
        
        // Groups
        newCharacter.speciesGroup = formData.speciesGroup.trimmingCharacters(in: .whitespaces)
        newCharacter.vocationGroup = formData.vocationGroup.trimmingCharacters(in: .whitespaces)
        newCharacter.affiliationGroups = formData.affiliationGroups
        newCharacter.attributeGroupPairs = formData.attributeGroupPairs
        
        // Languages
        newCharacter.languages = formData.languages
        
        // Equipment
        newCharacter.inventory = formData.inventory
        newCharacter.coins = Int(formData.coins) ?? 0
        
        // Encumbrance
        newCharacter.currentEncumbrance = Int(formData.currentEncumbrance) ?? 0
        newCharacter.maxEncumbrance = Int(formData.maxEncumbrance) ?? 0
        
        // Notes
        newCharacter.notes = formData.notes
        
        // Additional Info
        newCharacter.experience = Int(formData.experience) ?? 0
        newCharacter.corruption = Int(formData.corruption) ?? 0
        
        newCharacter.attunementSlots = formData.attunementSlots
        newCharacter.hasUsedAttunementToday = formData.hasUsedAttunementToday
        
        newCharacter.currentConflictLoot = formData.currentConflictLoot
        newCharacter.strongCombatOptions = formData.strongCombatOptions
        newCharacter.wiseMiracleSlots = formData.wiseMiracleSlots
        
        if character != nil {
            characterStore.updateCharacter(newCharacter)
        } else {
            characterStore.addCharacter(newCharacter)
        }
        dismiss()
    }
}

// MARK: - Form Data Model
private class FormData: ObservableObject {
    @Published var name = ""
    @Published var selectedClass: CharacterClass = .deft
    @Published var level = "1"
    
    @Published var strength = "10"
    @Published var agility = "10"
    @Published var toughness = "10"
    @Published var intelligence = "10"
    @Published var willpower = "10"
    @Published var charisma = "10"
    
    @Published var currentHP = "1"
    @Published var maxHP = "0"
    @Published var defenseValue = "10"
    @Published var movement = "30"
    @Published var saveColor = ""
    
    @Published var speciesGroup = ""
    @Published var vocationGroup = ""
    @Published var affiliationGroups: [String] = []
    @Published var newAffiliationGroup = ""
    @Published var attributeGroupPairs: [AttributeGroupPair] = []
    @Published var selectedAttribute: String = ""
    @Published var newAttributeGroup = ""
    @Published var isSpeciesGroupAdded = false
    @Published var isVocationGroupAdded = false
    
    @Published var languages: [String] = ["Common"]
    @Published var newLanguage = ""
    
    @Published var inventory: [String] = []
    @Published var newInventoryItem = ""
    @Published var coins = "0"
    
    @Published var currentEncumbrance = "0"
    @Published var maxEncumbrance = "15"
    
    @Published var notes = ""
    
    @Published var experience = "0"
    @Published var corruption = "0"
    
    // Initialize with empty attunement slots based on level and class
    @Published var attunementSlots: [AttunementSlot] = []
    @Published var hasUsedAttunementToday: Bool = false
    
    // Strong Class Specific Properties
    @Published var currentConflictLoot: ConflictLoot?
    @Published var strongCombatOptions = StrongCombatOptions()
    
    // Wise Class Specific Properties
    @Published var wiseMiracleSlots: [WiseMiracleSlot] = []
    
    init() {
        // Initialize slots based on class
        if selectedClass == .deft {
            let availableSlots = AdvancementTables.shared.stats(for: selectedClass, at: Int(level) ?? 1).slots
            attunementSlots = Array(repeating: AttunementSlot(), count: availableSlots)
        } else if selectedClass == .wise {
            let availableSlots = AdvancementTables.shared.stats(for: selectedClass, at: Int(level) ?? 1).slots
            wiseMiracleSlots = Array(repeating: WiseMiracleSlot(), count: availableSlots)
        }
    }
}
