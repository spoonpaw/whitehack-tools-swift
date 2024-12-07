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
                
                Section {
                    FormNotesSection(
                        notes: $formData.notes,
                        focusedField: $focusedField
                    )
                }
            }
            .padding()
        }
        .navigationTitle(characterId == nil ? "New Character" : "Edit Character")
        .toolbar {
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
        let newCharacter = PlayerCharacter(id: characterId ?? UUID())
        newCharacter.name = formData.name
        newCharacter.playerName = formData.playerName
        newCharacter.level = Int(formData.level) ?? 1
        newCharacter.characterClass = formData.selectedClass
        newCharacter.strength = Int(formData.strength) ?? 10
        newCharacter.agility = Int(formData.agility) ?? 10
        newCharacter.toughness = Int(formData.toughness) ?? 10
        newCharacter.intelligence = Int(formData.intelligence) ?? 10
        newCharacter.willpower = Int(formData.willpower) ?? 10
        newCharacter.charisma = Int(formData.charisma) ?? 10
        
        newCharacter.speciesGroup = formData.isSpeciesGroupAdded ? formData.speciesGroup : nil
        newCharacter.vocationGroup = formData.isVocationGroupAdded ? formData.vocationGroup : nil
        newCharacter.affiliationGroups = formData.affiliationGroups
        newCharacter.attributeGroupPairs = formData.attributeGroupPairs.map { pair in
            AttributeGroupPair(attribute: pair.attribute, group: pair.group)
        }
        
        newCharacter.currentHP = Int(formData.currentHP) ?? 0
        newCharacter.maxHP = Int(formData.maxHP) ?? 0
        newCharacter.defenseValue = Int(formData.defenseValue) ?? 0
        newCharacter.movement = Int(formData.movement) ?? 0
        newCharacter.saveColor = formData.saveColor
        // currentEncumbrance is computed from gear
        newCharacter.maxEncumbrance = Int(formData.maxEncumbrance) ?? 0
        newCharacter.experience = Int(formData.experience) ?? 0
        newCharacter.corruption = Int(formData.corruption) ?? 0
        newCharacter.notes = formData.notes
        newCharacter.languages = formData.languages
        
        if characterId != nil {
            characterStore.updateCharacter(newCharacter)
        } else {
            characterStore.addCharacter(newCharacter)
        }
        
        return newCharacter.id
    }
}

private class FormData: ObservableObject {
    @Published var name = ""
    @Published var playerName = ""
    @Published var level = "1"
    @Published var selectedClass: CharacterClass = .deft
    
    @Published var strength = "10"
    @Published var agility = "10"
    @Published var toughness = "10"
    @Published var intelligence = "10"
    @Published var willpower = "10"
    @Published var charisma = "10"
    
    @Published var speciesGroup = ""
    @Published var vocationGroup = ""
    @Published var affiliationGroups: [String] = []
    @Published var newAffiliationGroup = ""
    @Published var attributeGroupPairs: [AttributeGroupPair] = []
    @Published var selectedAttribute = ""
    @Published var newAttributeGroup = ""
    @Published var isSpeciesGroupAdded = false
    @Published var isVocationGroupAdded = false
    
    @Published var currentHP = ""
    @Published var maxHP = ""
    @Published var defenseValue = ""
    @Published var movement = ""
    @Published var saveColor = ""
    @Published var currentEncumbrance = ""
    @Published var maxEncumbrance = ""
    @Published var experience = ""
    @Published var corruption = ""
    @Published var notes = ""
    @Published var languages: [String] = []
    @Published var newLanguage = ""
    
    init(character: PlayerCharacter?) {
        if let character = character {
            name = character.name
            playerName = character.playerName
            level = String(character.level)
            selectedClass = character.characterClass
            strength = String(character.strength)
            agility = String(character.agility)
            toughness = String(character.toughness)
            intelligence = String(character.intelligence)
            willpower = String(character.willpower)
            charisma = String(character.charisma)
            speciesGroup = character.speciesGroup ?? ""
            vocationGroup = character.vocationGroup ?? ""
            affiliationGroups = character.affiliationGroups
            attributeGroupPairs = character.attributeGroupPairs.map { pair in
                AttributeGroupPair(id: UUID(), attribute: pair.attribute, group: pair.group)
            }
            isSpeciesGroupAdded = character.speciesGroup != nil
            isVocationGroupAdded = character.vocationGroup != nil
            currentHP = String(character.currentHP)
            maxHP = String(character.maxHP)
            defenseValue = String(character.defenseValue)
            movement = String(character.movement)
            saveColor = character.saveColor ?? ""
            currentEncumbrance = String(character.currentEncumbrance)
            maxEncumbrance = String(character.maxEncumbrance)
            experience = String(character.experience)
            corruption = String(character.corruption)
            notes = character.notes
            languages = character.languages
        }
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
