import SwiftUI

struct CharacterFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var characterStore: CharacterStore
    var character: PlayerCharacter?
    
    // MARK: - Basic Info
    @State private var name: String = ""
    @State private var selectedClass: CharacterClass = .deft
    @State private var level: String = "1"
    
    // MARK: - Attributes
    @State private var strength: String = "10"
    @State private var agility: String = "10"
    @State private var toughness: String = "10"
    @State private var intelligence: String = "10"
    @State private var willpower: String = "10"
    @State private var charisma: String = "10"
    
    // MARK: - Combat Stats
    @State private var currentHP: String = "0"
    @State private var maxHP: String = "0"
    @State private var attackValue: String = "10"
    @State private var defenseValue: String = "0"
    @State private var movement: String = "30"
    @State private var saveValue: String = "7"
    
    // MARK: - Groups
    @State private var speciesGroup: String = ""
    @State private var vocationGroup: String = ""
    @State private var affiliationGroups: [String] = []
    @State private var newAffiliationGroup: String = ""
    @State private var attributeGroupPairs: [AttributeGroupPair] = []
    @State private var selectedAttribute: String = "Strength"
    @State private var newAttributeGroup: String = ""
    
    // MARK: - Other
    @State private var languages: [String] = ["Common"]
    @State private var newLanguage: String = ""
    @State private var notes: String = ""
    @State private var experience: String = "0"
    @State private var corruption: String = "0"
    
    // MARK: - Equipment
    @State private var inventory: [String] = []
    @State private var newInventoryItem: String = ""
    @State private var coins: String = "0"
    
    // MARK: - Encumbrance
    @State private var currentEncumbrance: String = "0"
    @State private var maxEncumbrance: String = "15"
    
    // Flags to determine read-only status
    @State private var isSpeciesGroupAdded: Bool = false
    @State private var isVocationGroupAdded: Bool = false
    
    // MARK: - Focus State for Keyboard Management
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
            case name, level
            case strength, agility, toughness, intelligence, willpower, charisma
            case currentHP, maxHP, attackValue, defenseValue, movement, saveValue
            case speciesGroup, vocationGroup, newAffiliationGroup
            case newLanguage, newInventoryItem
            case currentEncumbrance, maxEncumbrance, coins
            case experience, corruption, notes
            case selectedAttribute, newAttributeGroup
        }
        
        var body: some View {
            NavigationStack {
                Form {
                    // MARK: Basic Info Section
                    BasicInfoSection(
                        name: $name,
                        selectedClass: $selectedClass,
                        level: $level,
                        focusedField: $focusedField
                    )
                    
                    // MARK: Attributes Section
                    Section(header: Text("Attributes").font(.headline)) {
                        ForEach([
                            ("Strength", $strength, Field.strength),
                            ("Agility", $agility, Field.agility),
                            ("Toughness", $toughness, Field.toughness),
                            ("Intelligence", $intelligence, Field.intelligence),
                            ("Willpower", $willpower, Field.willpower),
                            ("Charisma", $charisma, Field.charisma)
                        ], id: \.0) { label, binding, field in
                            AttributeEditor(
                                label: label,
                                value: binding,
                                range: 3...18,
                                focusedField: focusedField,
                                field: field,
                                focusBinding: $focusedField
                            )
                        }
                    }
                    
                    // MARK: Combat Stats Section
                    CombatStatsSection(
                        currentHP: $currentHP,
                        maxHP: $maxHP,
                        attackValue: $attackValue,
                        defenseValue: $defenseValue,
                        movement: $movement,
                        saveValue: $saveValue,
                        focusedField: $focusedField
                    )
                    
                    // MARK: Group Associations Section
                    CharacterGroupsSection(
                        speciesGroup: $speciesGroup,
                        vocationGroup: $vocationGroup,
                        affiliationGroups: $affiliationGroups,
                        newAffiliationGroup: $newAffiliationGroup,
                        attributeGroupPairs: $attributeGroupPairs,
                        selectedAttribute: $selectedAttribute,
                        newAttributeGroup: $newAttributeGroup,
                        isSpeciesGroupAdded: $isSpeciesGroupAdded,
                        isVocationGroupAdded: $isVocationGroupAdded,
                        focusedField: $focusedField
                    )
                    
                    // MARK: Languages Section
                    LanguagesSection(
                        languages: $languages,
                        newLanguage: $newLanguage,
                        focusedField: $focusedField
                    )
                    
                    // MARK: Equipment Section
                    EquipmentSection(
                        inventory: $inventory,
                        newInventoryItem: $newInventoryItem,
                        coins: $coins,
                        focusedField: $focusedField
                    )
                    
                    // MARK: Encumbrance Section
                    EncumbranceSection(
                        currentEncumbrance: $currentEncumbrance,
                        maxEncumbrance: $maxEncumbrance,
                        focusedField: $focusedField
                    )
                    
                    // MARK: Notes Section
                    NotesSection(
                        notes: $notes,
                        focusedField: $focusedField
                    )
                    
                    // MARK: Other Information Section
                    OtherInformationSection(
                        experience: $experience,
                        corruption: $corruption,
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
                .onAppear(perform: loadCharacterData)
                .onTapGesture {
                    focusedField = nil
                }
            }
        }
    }

    // Keep the helper methods in the main CharacterFormView
    extension CharacterFormView {
        private func loadCharacterData() {
            guard let character = character else { return }
            
            // Basic Info
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
            attackValue = String(character.attackValue)
            defenseValue = String(character.defenseValue)
            movement = String(character.movement)
            saveValue = String(character.saveValue)
            
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
        
        private func isFormValid() -> Bool {
            guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
                  let levelInt = Int(level), levelInt > 0,
                  let strengthInt = Int(strength), (3...18).contains(strengthInt),
                  let agilityInt = Int(agility), (3...18).contains(agilityInt),
                  let toughnessInt = Int(toughness), (3...18).contains(toughnessInt),
                  let intelligenceInt = Int(intelligence), (3...18).contains(intelligenceInt),
                  let willpowerInt = Int(willpower), (3...18).contains(willpowerInt),
                  let charismaInt = Int(charisma), (3...18).contains(charismaInt),
                  let currentHPInt = Int(currentHP), currentHPInt >= 0,
                  let maxHPInt = Int(maxHP), maxHPInt >= 0,
                  let attackValueInt = Int(attackValue), attackValueInt >= 0,
                  let defenseValueInt = Int(defenseValue), defenseValueInt >= 0,
                  let movementInt = Int(movement), movementInt >= 0,
                  let saveValueInt = Int(saveValue), saveValueInt >= 0
            else {
                return false
            }
            return true
        }
        
        private func saveCharacter() {
            guard isFormValid() else { return }
            
            let newCharacter = PlayerCharacter(
                id: character?.id ?? UUID(),
                name: name.trimmingCharacters(in: .whitespaces),
                characterClass: selectedClass,
                level: Int(level) ?? 1,
                strength: Int(strength) ?? 10,
                agility: Int(agility) ?? 10,
                toughness: Int(toughness) ?? 10,
                intelligence: Int(intelligence) ?? 10,
                willpower: Int(willpower) ?? 10,
                charisma: Int(charisma) ?? 10,
                currentHP: Int(currentHP) ?? 0,
                maxHP: Int(maxHP) ?? 0,
                attackValue: Int(attackValue) ?? 10,
                defenseValue: Int(defenseValue) ?? 0,
                movement: Int(movement) ?? 30,
                saveValue: Int(saveValue) ?? 7,
                speciesGroup: speciesGroup.isEmpty ? nil : speciesGroup.trimmingCharacters(in: .whitespaces),
                vocationGroup: vocationGroup.isEmpty ? nil : vocationGroup.trimmingCharacters(in: .whitespaces),
                affiliationGroups: affiliationGroups,
                attributeGroupPairs: attributeGroupPairs,
                languages: languages,
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
                experience: Int(experience) ?? 0,
                corruption: Int(corruption) ?? 0,
                inventory: inventory,
                currentEncumbrance: Int(currentEncumbrance) ?? 0,
                maxEncumbrance: Int(maxEncumbrance) ?? 15,
                coins: Int(coins) ?? 0
            )
            
            if character != nil {
                characterStore.updateCharacter(newCharacter)
            } else {
                characterStore.addCharacter(newCharacter)
            }
            dismiss()
        }
    }
