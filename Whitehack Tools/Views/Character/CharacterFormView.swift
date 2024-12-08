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
        let newCharacter = PlayerCharacter(
            id: characterId ?? UUID(),
            name: formData.name,
            playerName: formData.playerName,
            characterClass: formData.selectedClass,
            level: Int(formData.level) ?? 1,
            useCustomAttributes: formData.useCustomAttributes,
            customAttributes: formData.customAttributes,
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
            speciesGroup: formData.isSpeciesGroupAdded ? formData.speciesGroup : nil,
            vocationGroup: formData.isVocationGroupAdded ? formData.vocationGroup : nil,
            affiliationGroups: formData.affiliationGroups,
            attributeGroupPairs: formData.attributeGroupPairs.map { pair in
                AttributeGroupPair(attribute: pair.attribute, group: pair.group)
            },
            languages: formData.languages,
            notes: formData.notes,
            experience: Int(formData.experience) ?? 0,
            maxEncumbrance: Int(formData.maxEncumbrance) ?? 15
        )
        
        if characterId != nil {
            characterStore.updateCharacter(newCharacter)
        } else {
            characterStore.addCharacter(newCharacter)
        }
        
        return newCharacter.id
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
