// MARK: - Form Tab Enum
public enum FormTab: String, CaseIterable, Identifiable {
    case info, combat, equipment
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .info: return "Info"
        case .combat: return "Combat"
        case .equipment: return "Equipment"
        }
    }
    
    public var icon: Image {
        switch self {
        case .info: return Image(systemName: "info.circle")
        case .combat: return Image(systemName: "shield")
        case .equipment: return Image(systemName: "bag")
        }
    }
}

import SwiftUI
import PhosphorSwift

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
        case experience
        case currentHP
        case maxHP
        case movement
        case initiative
        case corruption
        case newLanguage
        case languageName
        case saveColor
        case currentEncumbrance
        case maxEncumbrance
        case weaponQuantity
        case weaponBonus
        case armorQuantity
        case armorDefense
        case armorBonus
    }
    
    @ObservedObject var characterStore: CharacterStore
    let characterId: UUID?
    var onComplete: ((UUID?, FormTab) -> Void)?
    @FocusState private var focusedField: Field?
    @StateObject private var formData: FormData
    @State private var selectedTab: FormTab
    
    init(characterStore: CharacterStore, characterId: UUID?, onComplete: ((UUID?, FormTab) -> Void)? = nil, initialTab: FormTab = .info) {
        self.characterStore = characterStore
        self.characterId = characterId
        self.onComplete = onComplete
        let character = characterId.flatMap { id in
            characterStore.characters.first { $0.id == id }
        }
        self._formData = StateObject(wrappedValue: FormData(character: character))
        self._selectedTab = State(initialValue: initialTab)
    }
    
    var body: some View {
        #if os(macOS)
        VStack(spacing: 0) {
            FormTabPicker(selection: $selectedTab)
                .padding(.horizontal)
                .background(.background)
                .overlay(
                    Divider()
                        .opacity(0.5), 
                    alignment: .bottom
                )
            
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(spacing: 16) {
                        Color.clear
                            .frame(height: 0)
                            .id("scroll-to-top")
                        
                        switch selectedTab {
                        case .info:
                            infoTabView
                        case .combat:
                            combatTabView
                        case .equipment:
                            VStack(spacing: 12) {
                                // Weapons Section
                                VStack(spacing: 12) {
                                    HStack(spacing: 8) {
                                        Ph.sword.bold
                                            .frame(width: 20, height: 20)
                                        Text("Weapons")
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    FormWeaponsSection(weapons: $formData.weapons)
                                        .frame(maxWidth: .infinity)
                                        .groupCardStyle()
                                }
                                .padding(.bottom, 12)
                                
                                // Armor Section
                                VStack(spacing: 12) {
                                    HStack(spacing: 8) {
                                        Ph.shield.bold
                                            .frame(width: 20, height: 20)
                                        Text("Armor")
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    FormArmorSection(armor: $formData.armor)
                                        .frame(maxWidth: .infinity)
                                        .groupCardStyle()
                                }
                                .padding(.bottom, 12)
                                
                                // Equipment Section
                                VStack(spacing: 12) {
                                    HStack(spacing: 8) {
                                        Ph.bagSimple.bold
                                            .frame(width: 20, height: 20)
                                        Text("Equipment")
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    FormEquipmentSection(gear: $formData.gear)
                                        .frame(maxWidth: .infinity)
                                        .groupCardStyle()
                                }
                                .padding(.bottom, 12)
                                
                                // Gold Section
                                VStack(spacing: 12) {
                                    HStack(spacing: 8) {
                                        Ph.coins.bold
                                            .frame(width: 20, height: 20)
                                        Text("Gold")
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    FormGoldSection(coinsOnHand: $formData.coinsOnHand, stashedCoins: $formData.stashedCoins)
                                        .frame(maxWidth: .infinity)
                                        .groupCardStyle()
                                }
                                .padding(.bottom, 12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .onChange(of: selectedTab) { _ in
                        withAnimation {
                            proxy.scrollTo("scroll-to-top", anchor: .top)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(characterId == nil ? "New Character" : "Edit Character")
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    onComplete?(nil, selectedTab)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    let savedId = saveCharacter()
                    onComplete?(savedId, selectedTab)
                }
            }
            #else
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    onComplete?(nil, selectedTab)
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let savedId = saveCharacter()
                    onComplete?(savedId, selectedTab)
                }
            }
            #endif
        }
        #else
        VStack(spacing: 0) {
            FormTabPicker(selection: $selectedTab)
                .padding(.horizontal)
                .background(.background)
                .overlay(
                    Divider()
                        .opacity(0.5), 
                    alignment: .bottom
                )
            
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(spacing: 16) {
                        Color.clear
                            .frame(height: 0)
                            .id("scroll-to-top")
                        
                        switch selectedTab {
                        case .info:
                            infoTabView
                        case .combat:
                            combatTabView
                        case .equipment:
                            VStack(spacing: 12) {
                                // Weapons Section
                                VStack(spacing: 12) {
                                    HStack(spacing: 8) {
                                        Ph.sword.bold
                                            .frame(width: 20, height: 20)
                                        Text("Weapons")
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    FormWeaponsSection(weapons: $formData.weapons)
                                        .frame(maxWidth: .infinity)
                                        .groupCardStyle()
                                }
                                .padding(.bottom, 12)
                                
                                // Armor Section
                                VStack(spacing: 12) {
                                    HStack(spacing: 8) {
                                        Ph.shield.bold
                                            .frame(width: 20, height: 20)
                                        Text("Armor")
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    FormArmorSection(armor: $formData.armor)
                                        .frame(maxWidth: .infinity)
                                        .groupCardStyle()
                                }
                                .padding(.bottom, 12)
                                
                                // Equipment Section
                                VStack(spacing: 12) {
                                    HStack(spacing: 8) {
                                        Ph.bagSimple.bold
                                            .frame(width: 20, height: 20)
                                        Text("Equipment")
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    FormEquipmentSection(gear: $formData.gear)
                                        .frame(maxWidth: .infinity)
                                        .groupCardStyle()
                                }
                                .padding(.bottom, 12)
                                
                                // Gold Section
                                VStack(spacing: 12) {
                                    HStack(spacing: 8) {
                                        Ph.coins.bold
                                            .frame(width: 20, height: 20)
                                        Text("Gold")
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    FormGoldSection(coinsOnHand: $formData.coinsOnHand, stashedCoins: $formData.stashedCoins)
                                        .frame(maxWidth: .infinity)
                                        .groupCardStyle()
                                }
                                .padding(.bottom, 12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .onChange(of: selectedTab) { _ in
                        withAnimation {
                            proxy.scrollTo("scroll-to-top", anchor: .top)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(characterId == nil ? "New Character" : "Edit Character")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    onComplete?(nil, selectedTab)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    let savedId = saveCharacter()
                    onComplete?(savedId, selectedTab)
                }
            }
        }
        #endif
    }
    
    private func saveCharacter() -> UUID {
        print("\n [CHARACTER FORM] Saving character")
        print(" [CHARACTER FORM] Level value in form: \(formData.level)")
        print(" [CHARACTER FORM] Level parsed as Int: \(formData.levelAsInt)")
        print(" [CHARACTER FORM] Movement value in form: \(formData.movement)")
        print(" [CHARACTER FORM] Movement parsed as Int: \(Int(formData.movement) ?? 30)")
        
        // Force commit any active text fields
        focusedField = nil
        
        // Create basic info
        var character = PlayerCharacter(
            id: characterId ?? UUID(),
            name: formData.name,
            playerName: formData.playerName,
            characterClass: formData.selectedClass,
            level: formData.levelAsInt,
            useCustomAttributes: formData.useCustomAttributes,
            customAttributes: formData.customAttributes,
            strength: Int(formData.strength) ?? 10,
            agility: Int(formData.agility) ?? 10,
            toughness: Int(formData.toughness) ?? 10,
            intelligence: Int(formData.intelligence) ?? 10,
            willpower: Int(formData.willpower) ?? 10,
            charisma: Int(formData.charisma) ?? 10,
            currentHP: Int(formData.currentHP) ?? 1,
            maxHP: Int(formData.maxHP) ?? 1,
            _attackValue: 10,
            movement: Int(formData.movement) ?? 30,
            _saveValue: 7,
            saveColor: formData.saveColor,
            speciesGroup: formData.speciesGroup,
            vocationGroup: formData.vocationGroup,
            affiliationGroups: formData.affiliationGroups,
            attributeGroupPairs: formData.attributeGroupPairs,
            attunementSlots: formData.attunementSlots,
            currentConflictLoot: formData.currentConflictLoot,
            strongCombatOptions: formData.strongCombatOptions,
            wiseMiracleSlots: formData.miracleSlots,
            braveQuirkOptions: formData.braveQuirkOptions,
            cleverKnackOptions: formData.cleverKnackOptions,
            fortunateOptions: formData.fortunateOptions,
            comebackDice: formData.comebackDice,
            hasUsedSayNo: formData.hasUsedSayNo,
            languages: formData.languages,
            notes: formData.notes,
            experience: Int(formData.experience) ?? 0,
            corruption: Int(formData.corruption) ?? 0,
            inventory: [],
            maxEncumbrance: 15,
            coinsOnHand: formData.coinsOnHand,
            stashedCoins: formData.stashedCoins,
            gear: formData.gear,
            weapons: formData.weapons,
            armor: formData.armor
        )
        
        // Update additional properties
        
        print(" [CHARACTER FORM] Character movement after creation: \(character.movement)")
        
        if characterId != nil {
            print(" [CHARACTER FORM] Updating existing character")
            characterStore.updateCharacter(character)
        } else {
            print(" [CHARACTER FORM] Adding new character")
            characterStore.addCharacter(character)
        }
        
        return character.id
    }
}

private class FormData: ObservableObject {
    @Published var name: String = ""
    @Published var playerName: String = ""
    @Published var level: String = "1" {
        didSet {
            print("Level changed to: \(level), as int: \(levelAsInt)")
        }
    }
    @Published var selectedClass: CharacterClass = .deft {
        didSet {
            // Initialize class-specific data when class changes
            if selectedClass == .wise && miracleSlots.isEmpty {
                // Create 3 miracle slots with base miracles
                miracleSlots = (0..<3).map { index in
                    var slot = WiseMiracleSlot()
                    // First slot gets 2 base miracles, others get 1
                    let baseMiracleCount = index == 0 ? 2 : 1
                    slot.baseMiracles = (0..<baseMiracleCount).map { _ in
                        WiseMiracle(id: UUID(), name: "", isActive: false, isAdditional: false)
                    }
                    return slot
                }
            } else if selectedClass == .deft && attunementSlots.isEmpty {
                attunementSlots = Array(repeating: AttunementSlot(), count: 3)
            }
        }
    }
    
    // Deft
    @Published var attunementSlots: [AttunementSlot] = []
    
    // Strong
    @Published var strongCombatOptions: StrongCombatOptions = StrongCombatOptions()
    @Published var currentConflictLoot: ConflictLoot?
    
    // Brave
    @Published var braveQuirkOptions: BraveQuirkOptions = BraveQuirkOptions()
    @Published var hasUsedSayNo: Bool = false
    @Published var comebackDice: Int = 0
    
    // Clever
    @Published var cleverKnackOptions: CleverKnackOptions = CleverKnackOptions()
    
    // Attributes
    @Published var useCustomAttributes: Bool = false
    @Published var customAttributes: [CustomAttribute] = []
    @Published var strength: String = "10"
    @Published var agility: String = "10"
    @Published var toughness: String = "10"
    @Published var intelligence: String = "10"
    @Published var willpower: String = "10"
    @Published var charisma: String = "10"
    @Published var currentHP: String = "1"
    @Published var maxHP: String = "1"
    @Published var movement: String = "30" {
        didSet {
            print(" [CHARACTER FORM] Movement changed to: \(movement)")
            // Ensure movement is always between 0 and 99
            if let value = Int(movement) {
                if value < 0 {
                    movement = "0"
                } else if value > 99 {
                    movement = "99"
                }
            }
            print(" [CHARACTER FORM] Movement after validation: \(movement)")
        }
    }
    @Published var saveColor: String = ""
    @Published var speciesGroup: String = ""
    @Published var vocationGroup: String = ""
    @Published var affiliationGroups: [String] = []
    @Published var newAffiliationGroup: String = ""
    @Published var attributeGroupPairs: [AttributeGroupPair] = []
    @Published var isSpeciesGroupAdded: Bool = false
    @Published var isVocationGroupAdded: Bool = false
    
    // Additional Info
    @Published var languages: [String] = []
    @Published var newLanguage: String = ""
    @Published var experience: String = "0"
    @Published var corruption: String = "0"
    @Published var miracleSlots: [WiseMiracleSlot] = []
    
    @Published var weapons: [Weapon] = []
    @Published var armor: [Armor] = []
    @Published var gear: [Gear] = []
    @Published var coinsOnHand: Int = 0
    @Published var stashedCoins: Int = 0
    
    @Published var notes: String = ""
    
    @Published var fortunateOptions = FortunateOptions()
    
    var levelAsInt: Int {
        Int(level) ?? 1
    }
    
    init(character: PlayerCharacter? = nil) {
        print("Initializing FormData with character: \(character?.name ?? "nil")")
        self.name = character?.name ?? ""
        self.playerName = character?.playerName ?? ""
        self.level = "\(character?.level ?? 1)"
        print("Setting level to: \(self.level)")
        self.selectedClass = character?.characterClass ?? .deft
        
        // Deft
        self.attunementSlots = character?.attunementSlots ?? []
        
        // Strong
        self.strongCombatOptions = character?.strongCombatOptions ?? StrongCombatOptions()
        self.currentConflictLoot = character?.currentConflictLoot
        
        // Brave
        self.braveQuirkOptions = character?.braveQuirkOptions ?? BraveQuirkOptions()
        self.hasUsedSayNo = character?.hasUsedSayNo ?? false
        self.comebackDice = character?.comebackDice ?? 0
        
        // Clever
        self.cleverKnackOptions = character?.cleverKnackOptions ?? CleverKnackOptions()
        
        // Attributes
        self.useCustomAttributes = character?.useCustomAttributes ?? false
        self.customAttributes = character?.customAttributes ?? []
        self.strength = "\(character?.strength ?? 10)"
        self.agility = "\(character?.agility ?? 10)"
        self.toughness = "\(character?.toughness ?? 10)"
        self.intelligence = "\(character?.intelligence ?? 10)"
        self.willpower = "\(character?.willpower ?? 10)"
        self.charisma = "\(character?.charisma ?? 10)"
        self.currentHP = "\(character?.currentHP ?? 1)"
        self.maxHP = "\(character?.maxHP ?? 1)"
        self.movement = "\(character?.movement ?? 30)"  // Fixed: Initialize movement with character's value
        self.saveColor = character?.saveColor ?? "black"
        self.speciesGroup = character?.speciesGroup ?? ""
        self.vocationGroup = character?.vocationGroup ?? ""
        self.affiliationGroups = character?.affiliationGroups ?? []
        self.newAffiliationGroup = ""
        self.attributeGroupPairs = character?.attributeGroupPairs ?? []
        self.isSpeciesGroupAdded = !((character?.speciesGroup ?? "").isEmpty)
        self.isVocationGroupAdded = !((character?.vocationGroup ?? "").isEmpty)
        self.notes = character?.notes ?? ""
        self.languages = character?.languages ?? []
        self.newLanguage = ""
        self.experience = "\(character?.experience ?? 0)"
        self.corruption = "\(character?.corruption ?? 0)"
        
        self.miracleSlots = character?.wiseMiracleSlots ?? []
        
        self.weapons = character?.weapons ?? []
        self.armor = character?.armor ?? []
        self.gear = character?.gear ?? []
        self.coinsOnHand = character?.coinsOnHand ?? 0
        self.stashedCoins = character?.stashedCoins ?? 0
        
        // Fortunate
        self.fortunateOptions = character?.fortunateOptions ?? FortunateOptions()
        
        self.notes = character?.notes ?? ""
    }
}

private extension CharacterFormView {
    var infoTabView: some View {
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
                attributeGroupPairs: $formData.attributeGroupPairs,
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
                isSpeciesGroupAdded: $formData.isSpeciesGroupAdded,
                isVocationGroupAdded: $formData.isVocationGroupAdded,
                useCustomAttributes: $formData.useCustomAttributes,
                customAttributes: $formData.customAttributes,
                focusedField: $focusedField
            )
            .frame(maxWidth: .infinity)
            
            FormLanguagesSection(
                languages: $formData.languages,
                newLanguage: $formData.newLanguage,
                focusedField: $focusedField
            )
            .frame(maxWidth: .infinity)
            
            if formData.selectedClass == .wise {
                FormWiseMiracleSection(
                    characterClass: formData.selectedClass,
                    level: formData.levelAsInt,
                    willpower: $formData.willpower,
                    useCustomAttributes: $formData.useCustomAttributes,
                    miracleSlots: $formData.miracleSlots
                )
                .frame(maxWidth: .infinity)
            }
            
            if formData.selectedClass == .deft {
                FormDeftAttunementSection(
                    characterClass: formData.selectedClass,
                    level: formData.levelAsInt,
                    attunementSlots: $formData.attunementSlots
                )
                .frame(maxWidth: .infinity)
            }
            
            if formData.selectedClass == .strong {
                FormStrongCombatSection(
                    characterClass: formData.selectedClass,
                    level: formData.levelAsInt,
                    strongCombatOptions: $formData.strongCombatOptions,
                    currentConflictLoot: $formData.currentConflictLoot
                )
                .frame(maxWidth: .infinity)
            }
            
            if formData.selectedClass == .brave {
                FormBraveQuirksSection(
                    braveQuirkOptions: $formData.braveQuirkOptions,
                    hasUsedSayNo: $formData.hasUsedSayNo,
                    comebackDice: $formData.comebackDice,
                    level: formData.levelAsInt
                )
                .frame(maxWidth: .infinity)
            }
            
            if formData.selectedClass == .clever {
                FormCleverKnacksSection(
                    characterClass: formData.selectedClass,
                    level: formData.levelAsInt,
                    cleverKnackOptions: $formData.cleverKnackOptions
                )
                .frame(maxWidth: .infinity)
            }
            
            if formData.selectedClass == .fortunate {
                FormFortunateSection(
                    characterClass: formData.selectedClass,
                    level: formData.levelAsInt,
                    fortunateOptions: $formData.fortunateOptions
                )
                .frame(maxWidth: .infinity)
            }
            
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
    }
    
    var combatTabView: some View {
        VStack(spacing: 16) {
            FormCombatStatsSection(
                currentHP: $formData.currentHP,
                maxHP: $formData.maxHP,
                movement: $formData.movement,
                saveColor: $formData.saveColor,
                focusedField: $focusedField
            )
            .frame(maxWidth: .infinity)
            
            if formData.selectedClass == .brave {
                FormBraveQuirksSection(
                    braveQuirkOptions: $formData.braveQuirkOptions,
                    hasUsedSayNo: $formData.hasUsedSayNo,
                    comebackDice: $formData.comebackDice,
                    level: formData.levelAsInt
                )
                .frame(maxWidth: .infinity)
                .shadow(
                    color: Color.orange.opacity(0.1),
                    radius: 8,
                    x: 0,
                    y: 4
                )
            }
        }
    }
}

private extension View {
    @ViewBuilder
    func groupCardStyle() -> some View {
        self
            .padding()
            #if os(iOS)
            .background(Color(.secondarySystemBackground))
            #else
            .background(Color(nsColor: .windowBackgroundColor))
            #endif
            .cornerRadius(12)
            .shadow(radius: 2)
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

private struct FormTabPicker: View {
    @Binding var selection: FormTab
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 12) {
                ForEach(FormTab.allCases, id: \.id) { tab in
                    FormTabButton(
                        title: tab.title,
                        icon: tab.icon,
                        isSelected: selection == tab
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selection = tab
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, alignment: .center)
            .padding(.vertical, 12)
        }
        .frame(height: 84)
    }
}

private struct FormTabButton: View {
    let title: String
    let icon: Image
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                IconFrame(icon: icon, color: isSelected ? .accentColor : .secondary)
                Text(title)
                    .font(.footnote)
                    .fontWeight(isSelected ? .medium : .regular)
                    .foregroundColor(isSelected ? .primary : .secondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isSelected ? Color.accentColor.opacity(0.2) : Color.clear, lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
