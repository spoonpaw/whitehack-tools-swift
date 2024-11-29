import SwiftUI

struct CharacterFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var characterStore: CharacterStore
    let characterId: UUID?  // Change to optional ID
    
    private var character: PlayerCharacter? {
        guard let id = characterId else { return nil }
        return characterStore.characters.first(where: { $0.id == id })
    }
    
    // MARK: - Form Data Model
    // Holds all form state separate from the store
    @StateObject private var formData: FormData
    @FocusState private var focusedField: Field?
    
    init(characterStore: CharacterStore, characterId: UUID? = nil) {
        self.characterStore = characterStore
        self.characterId = characterId
        
        // Initialize formData with character from store
        let character = characterId.flatMap { id in
            characterStore.characters.first(where: { $0.id == id })
        }
        _formData = StateObject(wrappedValue: FormData(character: character))
    }
    
    // MARK: - Form Fields
    enum Field: Hashable {
        case name, playerName, level
        case strength, agility, toughness, intelligence, willpower, charisma
        case currentHP, maxHP, defenseValue, movement, saveColor
        case speciesGroup, vocationGroup, newAffiliationGroup
        case newLanguage
        case newGearItem, coins
        case currentEncumbrance, maxEncumbrance
        case notes
        case experience, corruption
        case selectedAttribute, newAttributeGroup
        case attunementName
        case weaponName, weaponDamage, weaponRateOfFire, weaponCost, weaponSpecial
        case armorName, armorCost
    }
    
    var body: some View {
        Form(content: {
            FormBasicInfoSection(
                name: $formData.name,
                playerName: $formData.playerName,
                selectedClass: $formData.selectedClass,
                level: $formData.level,
                focusedField: focusedField,
                focusBinding: $focusedField
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
            FormWeaponsSection(weapons: $formData.weapons)
            FormArmorSection(armor: $formData.armor)
            FormLanguagesSection(
                languages: $formData.languages,
                newLanguage: $formData.newLanguage,
                focusedField: $focusedField
            )
            FormGoldSection(
                coinsOnHand: $formData.coinsOnHand,
                stashedCoins: $formData.stashedCoins
            )
            FormEquipmentSection(gear: $formData.gear)
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
            FormBraveQuirksSection(
                characterClass: formData.selectedClass,
                level: Int(formData.level) ?? 1,
                braveQuirkOptions: $formData.braveQuirkOptions,
                comebackDice: $formData.comebackDice,
                hasUsedSayNo: $formData.hasUsedSayNo
            )
            FormCleverKnacksSection(
                characterClass: formData.selectedClass,
                level: Int(formData.level) ?? 1,
                cleverKnackOptions: $formData.cleverKnackOptions
            )
            if formData.selectedClass == .fortunate {
                FormFortunateSection(
                    characterClass: formData.selectedClass,
                    level: Int(formData.level) ?? 1,
                    fortunateOptions: $formData.fortunateOptions
                )
            }
            FormOtherInformationSection(
                experience: $formData.experience,
                corruption: $formData.corruption,
                focusedField: $focusedField
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
                Button("Save All") {
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
        formData.playerName = character.playerName
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
        formData.isSpeciesGroupAdded = character.speciesGroup != nil && !character.speciesGroup!.isEmpty
        formData.isVocationGroupAdded = character.vocationGroup != nil && !character.vocationGroup!.isEmpty
        formData.affiliationGroups = character.affiliationGroups
        formData.attributeGroupPairs = character.attributeGroupPairs
        
        formData.languages = character.languages
        
        formData.gear = character.gear
        formData.coinsOnHand = character.coinsOnHand
        formData.stashedCoins = character.stashedCoins
        formData.maxEncumbrance = String(character.maxEncumbrance)
        
        formData.notes = character.notes
        
        formData.experience = String(character.experience)
        formData.corruption = String(character.corruption)
        
        formData.attunementSlots = character.attunementSlots
        formData.hasUsedAttunementToday = character.hasUsedAttunementToday
        
        formData.currentConflictLoot = character.currentConflictLoot
        formData.strongCombatOptions = character.strongCombatOptions
        formData.wiseMiracleSlots = character.wiseMiracleSlots
        formData.braveQuirkOptions = character.braveQuirkOptions
        formData.comebackDice = character.comebackDice
        formData.hasUsedSayNo = character.hasUsedSayNo
        formData.cleverKnackOptions = character.cleverKnackOptions
        formData.fortunateOptions = character.fortunateOptions
        
        formData.weapons = character.weapons
        formData.armor = character.armor
    }
    
    private func saveCharacter() {
        print("\n💾 [CHARACTER FORM] Starting character save")
        print("💾 [CHARACTER FORM] Creating new character object")
        
        let newCharacter = PlayerCharacter(id: character?.id ?? UUID())
        print("💾 [CHARACTER FORM] Character ID: \(newCharacter.id)")
        
        // Basic Info
        newCharacter.name = formData.name
        newCharacter.playerName = formData.playerName
        newCharacter.characterClass = formData.selectedClass
        newCharacter.level = Int(formData.level) ?? 1
        print("💾 [CHARACTER FORM] Basic Info - Name: \(newCharacter.name), Class: \(newCharacter.characterClass), Level: \(newCharacter.level)")
        
        // Attributes
        newCharacter.strength = Int(formData.strength) ?? 10
        newCharacter.agility = Int(formData.agility) ?? 10
        newCharacter.toughness = Int(formData.toughness) ?? 10
        newCharacter.intelligence = Int(formData.intelligence) ?? 10
        newCharacter.willpower = Int(formData.willpower) ?? 10
        newCharacter.charisma = Int(formData.charisma) ?? 10
        print("💾 [CHARACTER FORM] Attributes set - STR:\(newCharacter.strength) AGI:\(newCharacter.agility) TOU:\(newCharacter.toughness) INT:\(newCharacter.intelligence) WIL:\(newCharacter.willpower) CHA:\(newCharacter.charisma)")
        
        // Combat Stats
        newCharacter.currentHP = Int(formData.currentHP) ?? 0
        newCharacter.maxHP = Int(formData.maxHP) ?? 0
        newCharacter.defenseValue = Int(formData.defenseValue) ?? 0
        newCharacter.movement = Int(formData.movement) ?? 30
        newCharacter.saveColor = formData.saveColor
        print("💾 [CHARACTER FORM] Combat Stats - HP:\(newCharacter.currentHP)/\(newCharacter.maxHP) DV:\(newCharacter.defenseValue) MV:\(newCharacter.movement)")
        
        // Groups
        newCharacter.speciesGroup = formData.speciesGroup.trimmingCharacters(in: .whitespaces)
        newCharacter.vocationGroup = formData.vocationGroup.trimmingCharacters(in: .whitespaces)
        newCharacter.affiliationGroups = formData.affiliationGroups
        newCharacter.attributeGroupPairs = formData.attributeGroupPairs
        print("💾 [CHARACTER FORM] Groups - Species:\(newCharacter.speciesGroup ?? "none") Vocation:\(newCharacter.vocationGroup ?? "none") Affiliations:\(newCharacter.affiliationGroups.count)")
        
        // Equipment
        print("\n💾 [CHARACTER FORM] Setting equipment")
        print("💾 [CHARACTER FORM] Weapons before assignment: \(formData.weapons.count)")
        print("💾 [CHARACTER FORM] Armor before assignment: \(formData.armor.count)")
        for (index, armor) in formData.armor.enumerated() {
            print("💾 [CHARACTER FORM] Pre-save Armor \(index): \(armor.name) - DF:\(armor.df) Weight:\(armor.weight) Shield:\(armor.isShield)")
        }
        
        newCharacter.weapons = formData.weapons
        newCharacter.armor = formData.armor
        print("💾 [CHARACTER FORM] Weapons count after assignment: \(newCharacter.weapons.count)")
        print("💾 [CHARACTER FORM] Armor count after assignment: \(newCharacter.armor.count)")
        for (index, armor) in newCharacter.armor.enumerated() {
            print("💾 [CHARACTER FORM] Post-save Armor \(index): \(armor.name) - DF:\(armor.df) Weight:\(armor.weight) Shield:\(armor.isShield)")
        }
        
        newCharacter.gear = formData.gear
        newCharacter.coinsOnHand = formData.coinsOnHand
        newCharacter.stashedCoins = formData.stashedCoins
        newCharacter.maxEncumbrance = Int(formData.maxEncumbrance) ?? 15
        print("💾 [CHARACTER FORM] Gear count: \(formData.gear.count), Coins On Hand: \(newCharacter.coinsOnHand), Stashed Coins: \(newCharacter.stashedCoins), Max Encumbrance: \(newCharacter.maxEncumbrance)")
        
        // Class Features
        newCharacter.attunementSlots = formData.attunementSlots
        newCharacter.hasUsedAttunementToday = formData.hasUsedAttunementToday
        newCharacter.currentConflictLoot = formData.currentConflictLoot
        newCharacter.strongCombatOptions = formData.strongCombatOptions
        newCharacter.wiseMiracleSlots = formData.wiseMiracleSlots
        newCharacter.braveQuirkOptions = formData.braveQuirkOptions
        newCharacter.comebackDice = formData.comebackDice
        newCharacter.hasUsedSayNo = formData.hasUsedSayNo
        newCharacter.cleverKnackOptions = formData.cleverKnackOptions
        newCharacter.fortunateOptions = formData.fortunateOptions
        print("💾 [CHARACTER FORM] Class features set")
        
        // Save to store
        print("\n💾 [CHARACTER FORM] Saving to character store")
        if character != nil {
            print("💾 [CHARACTER FORM] Updating existing character")
            characterStore.updateCharacter(newCharacter)
        } else {
            print("💾 [CHARACTER FORM] Adding new character")
            characterStore.addCharacter(newCharacter)
        }
        print("💾 [CHARACTER FORM] Save complete")
        
        dismiss()
    }
}

// MARK: - Form Data Model
private class FormData: ObservableObject {
    @Published private var _name = ""
    @Published var playerName = ""
    @Published var selectedClass: CharacterClass = .deft
    @Published var level = "1"
    
    @Published var strength = "10"
    @Published var agility = "10"
    @Published var toughness = "10"
    @Published var intelligence = "10"
    @Published var willpower = "10" {
        didSet {
            updateWiseMiracleSlots()
        }
    }
    @Published var charisma = "10"
    
    @Published var currentHP = "1"
    @Published var maxHP = "1"
    @Published var defenseValue = "0"
    @Published var movement = "30"
    @Published var saveColor = ""
    
    @Published private var _speciesGroup = ""
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
    
    @Published var gear: [Gear] = []
    @Published var coinsOnHand = 0
    @Published var stashedCoins = 0
    @Published var maxEncumbrance = "15"
    
    @Published var notes = ""
    
    @Published var experience = "0"
    @Published var corruption = "0"
    
    // Initialize with empty attunement slots based on level and class
    @Published var attunementSlots: [AttunementSlot] = []
    @Published var hasUsedAttunementToday: Bool = false
    
    // Strong Class Specific Properties
    @Published var currentConflictLoot: ConflictLoot? = nil
    @Published var strongCombatOptions = StrongCombatOptions()
    
    // Wise Class Specific Properties
    @Published var wiseMiracleSlots: [WiseMiracleSlot] = []
    
    // Brave Class Specific Properties
    @Published var braveQuirkOptions = BraveQuirkOptions()
    @Published var comebackDice = 0
    @Published var hasUsedSayNo = false
    
    // Clever Class Specific Properties
    @Published var cleverKnackOptions = CleverKnackOptions()
    
    // Fortunate Class Specific Properties
    @Published var fortunateOptions = FortunateOptions()
    
    @Published var weapons: [Weapon] = []
    @Published var armor: [Armor] = []
    
    var name: String {
        get { _name }
        set { _name = trimWhitespace(newValue) }
    }
    
    var speciesGroup: String {
        get { _speciesGroup }
        set { _speciesGroup = trimWhitespace(newValue) }
    }
    
    private func trimWhitespace(_ string: String) -> String {
        return string.trimmingCharacters(in: .whitespaces)
    }
    
    private func updateWiseMiracleSlots() {
        print("\n🧙‍♂️ [FORM VIEW] Updating wise miracle slots...")
        if selectedClass == .wise {
            print("🧙‍♂️ [FORM VIEW] Character is Wise, proceeding with update")
            
            let willpowerValue = Int(willpower) ?? 0
            print("🧙‍♂️ [FORM VIEW] Current willpower: \(willpowerValue)")
            
            let extraMiracles: Int
            if willpowerValue >= 16 {
                print("🧙‍♂️ [FORM VIEW] Willpower >= 16, adding 2 extra miracles")
                extraMiracles = 2
            } else if willpowerValue >= 14 {
                print("🧙‍♂️ [FORM VIEW] Willpower >= 14, adding 1 extra miracle")
                extraMiracles = 1
            } else {
                print("🧙‍♂️ [FORM VIEW] Willpower < 14, no extra miracles")
                extraMiracles = 0
            }
            
            if !wiseMiracleSlots.isEmpty {
                print("\n🧙‍♂️ [FORM VIEW] Updating slots...")
                // Update slot 0's base miracles
                let baseMiracleCount = 2 + extraMiracles
                print("🧙‍♂️ [FORM VIEW] Slot 0 should have \(baseMiracleCount) base miracles")
                print("🧙‍♂️ [FORM VIEW] Current base miracles: \(wiseMiracleSlots[0].baseMiracles.count)")
                
                while wiseMiracleSlots[0].baseMiracles.count < baseMiracleCount {
                    print("🧙‍♂️ [FORM VIEW] Adding base miracle to slot 0")
                    wiseMiracleSlots[0].baseMiracles.append(WiseMiracle(isAdditional: false))
                }
                if wiseMiracleSlots[0].baseMiracles.count > baseMiracleCount {
                    print("🧙‍♂️ [FORM VIEW] Removing excess base miracles from slot 0")
                    wiseMiracleSlots[0].baseMiracles = Array(wiseMiracleSlots[0].baseMiracles.prefix(baseMiracleCount))
                }
                
                // Ensure other slots have exactly 2 base miracles
                for index in 1..<wiseMiracleSlots.count {
                    print("\n🧙‍♂️ [FORM VIEW] Updating slot \(index)...")
                    print("🧙‍♂️ [FORM VIEW] Current base miracles: \(wiseMiracleSlots[index].baseMiracles.count)")
                    
                    while wiseMiracleSlots[index].baseMiracles.count < 2 {
                        print("🧙‍♂️ [FORM VIEW] Adding base miracle to slot \(index)")
                        wiseMiracleSlots[index].baseMiracles.append(WiseMiracle(isAdditional: false))
                    }
                    if wiseMiracleSlots[index].baseMiracles.count > 2 {
                        print("🧙‍♂️ [FORM VIEW] Removing excess base miracles from slot \(index)")
                        wiseMiracleSlots[index].baseMiracles = Array(wiseMiracleSlots[index].baseMiracles.prefix(2))
                    }
                    print("🧙‍♂️ [FORM VIEW] Slot \(index) final base miracles: \(wiseMiracleSlots[index].baseMiracles.count)")
                }
            } else {
                print("🧙‍♂️ [FORM VIEW] No miracle slots to update!")
            }
        } else {
            print("🧙‍♂️ [FORM VIEW] Character is not Wise, skipping update")
        }
    }
    
    init(character: PlayerCharacter? = nil) {
        // Initialize slots based on class
        if selectedClass == .deft {
            let availableSlots = AdvancementTables.shared.stats(for: selectedClass, at: Int(level) ?? 1).slots
            attunementSlots = Array(repeating: AttunementSlot(), count: availableSlots)
        } else if selectedClass == .wise {
            let availableSlots = AdvancementTables.shared.stats(for: selectedClass, at: Int(level) ?? 1).slots
            wiseMiracleSlots = Array(repeating: WiseMiracleSlot(), count: availableSlots)
            updateWiseMiracleSlots()
        }
        
        if let character = character {
            self.fortunateOptions = character.fortunateOptions
        }
    }
}
