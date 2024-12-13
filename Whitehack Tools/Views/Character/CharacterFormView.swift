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
                VStack(spacing: 16) {
                    switch selectedTab {
                    case .info:
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
                            
                            FormLanguagesSection(
                                languages: $formData.languages,
                                newLanguage: $formData.newLanguage,
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
                            
                            if formData.selectedClass == .deft {
                                FormDeftAttunementSection(
                                    characterClass: formData.selectedClass,
                                    level: Int(formData.level) ?? 1,
                                    attunementSlots: $formData.attunementSlots
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
                    case .combat:
                        FormCombatStatsSection(
                            currentHP: $formData.currentHP,
                            maxHP: $formData.maxHP,
                            movement: $formData.movement,
                            saveColor: $formData.saveColor,
                            focusedField: $focusedField
                        )
                        .frame(maxWidth: .infinity)
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
                .padding(.top, 16)
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
                VStack(spacing: 16) {
                    switch selectedTab {
                    case .info:
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
                            
                            FormLanguagesSection(
                                languages: $formData.languages,
                                newLanguage: $formData.newLanguage,
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
                            
                            if formData.selectedClass == .deft {
                                FormDeftAttunementSection(
                                    characterClass: formData.selectedClass,
                                    level: Int(formData.level) ?? 1,
                                    attunementSlots: $formData.attunementSlots
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
                    case .combat:
                        FormCombatStatsSection(
                            currentHP: $formData.currentHP,
                            maxHP: $formData.maxHP,
                            movement: $formData.movement,
                            saveColor: $formData.saveColor,
                            focusedField: $focusedField
                        )
                        .frame(maxWidth: .infinity)
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
                .padding(.top, 16)
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
        // Create basic info
        var character = PlayerCharacter(
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
            movement: Int(formData.movement) ?? 30,
            saveColor: formData.saveColor,
            speciesGroup: formData.speciesGroup,
            vocationGroup: formData.vocationGroup,
            affiliationGroups: formData.affiliationGroups,
            attributeGroupPairs: formData.attributeGroupPairs,
            attunementSlots: formData.attunementSlots,
            wiseMiracleSlots: formData.miracleSlots,
            languages: formData.languages, notes: formData.notes,
            experience: Int(formData.experience) ?? 0,
            corruption: Int(formData.corruption) ?? 0,
            coinsOnHand: formData.coinsOnHand, stashedCoins: formData.stashedCoins, gear: formData.gear, weapons: formData.weapons,
            armor: formData.armor
        )
        
        // Update additional properties
        
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
    
    // Deft
    @Published var attunementSlots: [AttunementSlot]
    
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
    @Published var movement: String
    @Published var saveColor: String
    
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
    @Published var experience: String
    @Published var corruption: String
    @Published var miracleSlots: [WiseMiracleSlot]
    
    @Published var weapons: [Weapon]
    @Published var armor: [Armor]
    @Published var gear: [Gear]
    @Published var coinsOnHand: Int
    @Published var stashedCoins: Int
    
    @Published var notes: String
    
    init(character: PlayerCharacter? = nil) {
        self.name = character?.name ?? ""
        self.playerName = character?.playerName ?? ""
        self.level = "\(character?.level ?? 1)"
        self.selectedClass = character?.characterClass ?? .deft
        
        // Deft
        self.attunementSlots = character?.attunementSlots ?? []
        
        // Attributes
        self.useCustomAttributes = character?.useCustomAttributes ?? false
        self.customAttributes = character?.customAttributes ?? []
        self.strength = character?.strength.description ?? "10"
        self.agility = character?.agility.description ?? "10"
        self.toughness = character?.toughness.description ?? "10"
        self.intelligence = character?.intelligence.description ?? "10"
        self.willpower = character?.willpower.description ?? "10"
        self.charisma = character?.charisma.description ?? "10"
        self.currentHP = character?.currentHP.description ?? "0"
        self.maxHP = character?.maxHP.description ?? "0"
        self.movement = character?.movement.description ?? "30"
        self.saveColor = character?.saveColor ?? ""
        self.speciesGroup = character?.speciesGroup ?? ""
        self.vocationGroup = character?.vocationGroup ?? ""
        self.affiliationGroups = character?.affiliationGroups ?? []
        self.newAffiliationGroup = ""
        self.attributeGroupPairs = character?.attributeGroupPairs ?? []
        self.selectedAttribute = ""
        self.newAttributeGroup = ""
        self.isSpeciesGroupAdded = !((character?.speciesGroup ?? "").isEmpty)
        self.isVocationGroupAdded = !((character?.vocationGroup ?? "").isEmpty)
        self.notes = character?.notes ?? ""
        self.languages = character?.languages ?? []
        self.newLanguage = ""
        self.experience = character?.experience.description ?? "0"
        self.corruption = character?.corruption.description ?? "0"
        
        self.miracleSlots = character?.wiseMiracleSlots ?? []
        
        self.weapons = character?.weapons ?? []
        self.armor = character?.armor ?? []
        self.gear = character?.gear ?? []
        self.coinsOnHand = character?.coinsOnHand ?? 0
        self.stashedCoins = character?.stashedCoins ?? 0
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
