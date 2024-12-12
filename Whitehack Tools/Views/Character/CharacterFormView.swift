import SwiftUI

struct CharacterFormView: View {
    enum Field: Hashable {
        case name
        case playerName
        case level
        case strength
        case agility
        case toughness
        case intelligence
        case willpower
        case charisma
        case speciesGroup
        case vocationGroup
        case affiliationGroup
        case newAffiliationGroup
        case attributeGroup
        case notes
        case currentEncumbrance
        case maxEncumbrance
        case experience
        case currentHP
        case maxHP
        case defenseValue
        case movement
        case initiative
        case corruption
        case newLanguage
        case languageName
        case saveColor
    }
    
    @ObservedObject var characterStore: CharacterStore
    let characterId: UUID?
    var onComplete: ((UUID?) -> Void)?
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    @StateObject private var formData: FormData
    
    init(characterStore: CharacterStore, characterId: UUID?, onComplete: ((UUID?) -> Void)? = nil) {
        self.characterStore = characterStore
        self.characterId = characterId
        self.onComplete = onComplete
        let character = characterId.flatMap { id in
            characterStore.characters.first { $0.id == id }
        }
        self._formData = StateObject(wrappedValue: FormData(character: character))
    }
    
    var body: some View {
        #if os(macOS)
        ScrollView {
            VStack(spacing: 20) {
                FormBasicInfoSection(
                    name: $formData.name,
                    playerName: $formData.playerName,
                    selectedClass: $formData.selectedClass,
                    level: $formData.level,
                    focusedField: $focusedField
                )
                .frame(maxWidth: .infinity)
                
                FormAttributesSection(
                    useCustomAttributes: $formData.useCustomAttributes,
                    customAttributes: $formData.customAttributes,
                    strength: $formData.strength,
                    agility: $formData.agility,
                    toughness: $formData.toughness,
                    intelligence: $formData.intelligence,
                    willpower: $formData.willpower,
                    charisma: $formData.charisma
                )
                .frame(maxWidth: .infinity)
                
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
                    useCustomAttributes: $formData.useCustomAttributes,
                    customAttributes: $formData.customAttributes,
                    focusedField: $focusedField
                )
                .frame(maxWidth: .infinity)
                
                FormCombatStatsSection(
                    currentHP: $formData.currentHP,
                    maxHP: $formData.maxHP,
                    defenseValue: $formData.defenseValue,
                    movement: $formData.movement,
                    saveColor: $formData.saveColor,
                    focusedField: $focusedField
                )
                .frame(maxWidth: .infinity)
                
                FormWeaponsSection(weapons: $formData.weapons)
                    .frame(maxWidth: .infinity)
                
                FormArmorSection(armor: $formData.armor)
                    .frame(maxWidth: .infinity)
                
                FormEquipmentSection(gear: $formData.gear)
                    .frame(maxWidth: .infinity)
                
                FormEncumbranceSection(
                    currentEncumbrance: $formData.currentEncumbrance,
                    maxEncumbrance: $formData.maxEncumbrance,
                    focusedField: $focusedField
                )
                .frame(maxWidth: .infinity)
                
                FormLanguagesSection(
                    languages: $formData.languages,
                    newLanguage: $formData.newLanguage,
                    focusedField: $focusedField
                )
                .frame(maxWidth: .infinity)
                
                FormOtherInformationSection(
                    experience: $formData.experience,
                    corruption: $formData.corruption,
                    focusedField: $focusedField
                )
                .frame(maxWidth: .infinity)
                
                if formData.selectedClass == .wise {
                    FormWiseMiracleSection(
                        characterClass: formData.selectedClass,
                        level: Int(formData.level) ?? 1,
                        willpower: $formData.willpower,
                        useCustomAttributes: $formData.useCustomAttributes,
                        miracleSlots: $formData.miracleSlots
                    )
                    .frame(maxWidth: .infinity)
                }
                
                FormNotesSection(
                    notes: $formData.notes,
                    focusedField: $focusedField
                )
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .navigationTitle(characterId == nil ? "New Character" : "Edit Character")
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    onComplete?(nil)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    let id = saveCharacter()
                    onComplete?(id)
                }
            }
            #else
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    onComplete?(nil)
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let id = saveCharacter()
                    onComplete?(id)
                }
            }
            #endif
        }
        #else
        Form {
            Section {
                FormBasicInfoSection(
                    name: $formData.name,
                    playerName: $formData.playerName,
                    selectedClass: $formData.selectedClass,
                    level: $formData.level,
                    focusedField: $focusedField
                )
            }
            
            Section {
                FormAttributesSection(
                    useCustomAttributes: $formData.useCustomAttributes,
                    customAttributes: $formData.customAttributes,
                    strength: $formData.strength,
                    agility: $formData.agility,
                    toughness: $formData.toughness,
                    intelligence: $formData.intelligence,
                    willpower: $formData.willpower,
                    charisma: $formData.charisma
                )
            }
            
            Section {
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
                    useCustomAttributes: $formData.useCustomAttributes,
                    customAttributes: $formData.customAttributes,
                    focusedField: $focusedField
                )
            }
            
            Section {
                FormCombatStatsSection(
                    currentHP: $formData.currentHP,
                    maxHP: $formData.maxHP,
                    defenseValue: $formData.defenseValue,
                    movement: $formData.movement,
                    saveColor: $formData.saveColor,
                    focusedField: $focusedField
                )
            }
            
            Section {
                FormWeaponsSection(weapons: $formData.weapons)
            }
            
            Section {
                FormArmorSection(armor: $formData.armor)
            }
            
            Section {
                FormEquipmentSection(gear: $formData.gear)
            }
            
            Section {
                FormEncumbranceSection(
                    currentEncumbrance: $formData.currentEncumbrance,
                    maxEncumbrance: $formData.maxEncumbrance,
                    focusedField: $focusedField
                )
            }
            
            Section {
                FormLanguagesSection(
                    languages: $formData.languages,
                    newLanguage: $formData.newLanguage,
                    focusedField: $focusedField
                )
            }
            
            Section {
                FormOtherInformationSection(
                    experience: $formData.experience,
                    corruption: $formData.corruption,
                    focusedField: $focusedField
                )
            }
            
            if formData.selectedClass == .wise {
                Section {
                    FormWiseMiracleSection(
                        characterClass: formData.selectedClass,
                        level: Int(formData.level) ?? 1,
                        willpower: $formData.willpower,
                        useCustomAttributes: $formData.useCustomAttributes,
                        miracleSlots: $formData.miracleSlots
                    )
                }
            }
            
            Section {
                FormNotesSection(
                    notes: $formData.notes,
                    focusedField: $focusedField
                )
            }
        }
        .navigationTitle(characterId == nil ? "New Character" : "Edit Character")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    onComplete?(nil)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    let id = saveCharacter()
                    onComplete?(id)
                }
            }
        }
        #endif
    }
    
    private func saveCharacter() -> UUID {
        // Create basic info
        var character = PlayerCharacter(
            id: characterId ?? UUID(),
            name: formData.name,
            playerName: formData.playerName,
            characterClass: formData.selectedClass,
            level: Int(formData.level) ?? 1
        )
        
        // Set attributes
        character.useCustomAttributes = formData.useCustomAttributes
        character.customAttributes = formData.customAttributes
        character.strength = Int(formData.strength) ?? 10
        character.agility = Int(formData.agility) ?? 10
        character.toughness = Int(formData.toughness) ?? 10
        character.intelligence = Int(formData.intelligence) ?? 10
        character.willpower = Int(formData.willpower) ?? 10
        character.charisma = Int(formData.charisma) ?? 10
        
        // Set combat stats
        character.currentHP = Int(formData.currentHP) ?? 0
        character.maxHP = Int(formData.maxHP) ?? 0
        character.defenseValue = Int(formData.defenseValue) ?? 0
        character.movement = Int(formData.movement) ?? 0
        character.saveColor = formData.saveColor
        character.maxEncumbrance = Int(formData.maxEncumbrance) ?? 15
        
        // Set groups
        character.speciesGroup = formData.speciesGroup
        character.vocationGroup = formData.vocationGroup
        character.affiliationGroups = formData.affiliationGroups
        character.attributeGroupPairs = formData.attributeGroupPairs
        
        // Set additional info
        character.languages = formData.languages
        character.notes = formData.notes
        character.experience = Int(formData.experience) ?? 0
        character.corruption = Int(formData.corruption) ?? 0
        
        // Set wise-specific info
        character.wiseMiracleSlots = formData.miracleSlots
        
        character.weapons = formData.weapons
        character.armor = formData.armor
        character.gear = formData.gear
        
        if characterId != nil {
            characterStore.updateCharacter(character)
        } else {
            characterStore.addCharacter(character)
        }
        
        return character.id
    }
}

private class FormData: ObservableObject {
    @Published var name: String
    @Published var playerName: String
    @Published var level: String
    @Published var selectedClass: CharacterClass
    
    // Attributes
    @Published var useCustomAttributes: Bool
    @Published var customAttributes: [CustomAttribute]
    @Published var strength: String
    @Published var agility: String
    @Published var toughness: String
    @Published var intelligence: String
    @Published var willpower: String
    @Published var charisma: String
    
    // Combat Stats
    @Published var currentHP: String
    @Published var maxHP: String
    @Published var defenseValue: String
    @Published var movement: String
    @Published var saveColor: String
    @Published var currentEncumbrance: String
    @Published var maxEncumbrance: String
    @Published var experience: String
    @Published var corruption: String
    
    // Groups
    @Published var speciesGroup: String
    @Published var vocationGroup: String
    @Published var affiliationGroups: [String]
    @Published var newAffiliationGroup: String
    @Published var attributeGroupPairs: [AttributeGroupPair]
    @Published var selectedAttribute: String
    @Published var newAttributeGroup: String
    @Published var isSpeciesGroupAdded: Bool
    @Published var isVocationGroupAdded: Bool
    
    // Additional Info
    @Published var languages: [String]
    @Published var newLanguage: String
    @Published var notes: String
    
    @Published var miracleSlots: [WiseMiracleSlot]
    
    @Published var weapons: [Weapon]
    @Published var armor: [Armor]
    @Published var gear: [Gear]
    
    init(character: PlayerCharacter? = nil) {
        self.name = character?.name ?? ""
        self.playerName = character?.playerName ?? ""
        self.level = character?.level.description ?? "1"
        self.selectedClass = character?.characterClass ?? .deft
        
        // Attributes
        self.useCustomAttributes = character?.useCustomAttributes ?? false
        self.customAttributes = character?.customAttributes ?? []
        self.strength = character?.strength.description ?? "10"
        self.agility = character?.agility.description ?? "10"
        self.toughness = character?.toughness.description ?? "10"
        self.intelligence = character?.intelligence.description ?? "10"
        self.willpower = character?.willpower.description ?? "10"
        self.charisma = character?.charisma.description ?? "10"
        
        // Combat Stats
        self.currentHP = character?.currentHP.description ?? ""
        self.maxHP = character?.maxHP.description ?? ""
        self.defenseValue = character?.defenseValue.description ?? ""
        self.movement = character?.movement.description ?? ""
        self.saveColor = character?.saveColor ?? ""
        self.currentEncumbrance = character?.currentEncumbrance.description ?? ""
        self.maxEncumbrance = character?.maxEncumbrance.description ?? ""
        self.experience = character?.experience.description ?? ""
        self.corruption = character?.corruption.description ?? ""
        
        // Groups
        self.speciesGroup = character?.speciesGroup ?? ""
        self.vocationGroup = character?.vocationGroup ?? ""
        self.affiliationGroups = character?.affiliationGroups ?? []
        self.newAffiliationGroup = ""
        self.attributeGroupPairs = character?.attributeGroupPairs.map { pair in
            AttributeGroupPair(id: UUID(), attribute: pair.attribute, group: pair.group)
        } ?? []
        self.selectedAttribute = ""
        self.newAttributeGroup = ""
        self.isSpeciesGroupAdded = character?.speciesGroup != nil
        self.isVocationGroupAdded = character?.vocationGroup != nil
        
        // Additional Info
        self.languages = character?.languages ?? []
        self.newLanguage = ""
        self.notes = character?.notes ?? ""
        
        self.miracleSlots = character?.wiseMiracleSlots ?? []
        
        self.weapons = character?.weapons ?? []
        self.armor = character?.armor ?? []
        self.gear = character?.gear ?? []
    }
}

private struct AttributeRowView: View {
    let name: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text(value)
                .monospacedDigit()
            HStack(spacing: 20) {
                Button {
                    if let current = Int(value), current > 3 {
                        value = String(current - 1)
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
                
                Button {
                    if let current = Int(value), current < 18 {
                        value = String(current + 1)
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
    }
}
