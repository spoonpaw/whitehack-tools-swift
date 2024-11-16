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
    
    // MARK: - Attribute-Group Pairs
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
                Section(header: Text("Basic Info").font(.headline)) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Name")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextField("Enter name", text: $name)
                            .textInputAutocapitalization(.words)
                            .focused($focusedField, equals: .name)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Class")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Picker("Class", selection: $selectedClass) {
                            ForEach(CharacterClass.allCases, id: \.self) { characterClass in
                                Text(characterClass.rawValue).tag(characterClass)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Level")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextField("Enter level", text: $level)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .level)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                
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
                Section(header: Text("Combat Stats").font(.headline)) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Current HP")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextField("Enter current HP", text: $currentHP)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .currentHP)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Max HP")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextField("Enter max HP", text: $maxHP)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .maxHP)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Attack Value")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextField("Enter attack value", text: $attackValue)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .attackValue)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Defense Value")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextField("Enter defense value", text: $defenseValue)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .defenseValue)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Movement")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextField("Enter movement", text: $movement)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .movement)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Save Value")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextField("Enter save value", text: $saveValue)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .saveValue)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                
                // MARK: Group Associations Section
                Section(header: Text("Group Associations").font(.headline)) {
                    // Species Group
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Species Group")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack {
                            TextField("Add Species Group", text: $speciesGroup)
                                .textInputAutocapitalization(.words)
                                .focused($focusedField, equals: .speciesGroup)
                                .textFieldStyle(.roundedBorder)
                            
                            if !isSpeciesGroupAdded && !speciesGroup.trimmingCharacters(in: .whitespaces).isEmpty {
                                Button {
                                    withAnimation {
                                        addSpeciesGroup()
                                    }
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                        
                        if isSpeciesGroupAdded {
                            Text(speciesGroup)
                                .foregroundColor(.gray)
                                .padding(.vertical, 2)
                        }
                    }
                    
                    // Vocation Group
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Vocation Group")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack {
                            TextField("Add Vocation Group", text: $vocationGroup)
                                .textInputAutocapitalization(.words)
                                .focused($focusedField, equals: .vocationGroup)
                                .textFieldStyle(.roundedBorder)
                            
                            if !isVocationGroupAdded && !vocationGroup.trimmingCharacters(in: .whitespaces).isEmpty {
                                Button {
                                    withAnimation {
                                        addVocationGroup()
                                    }
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                        
                        if isVocationGroupAdded {
                            Text(vocationGroup)
                                .foregroundColor(.gray)
                                .padding(.vertical, 2)
                        }
                    }
                    
                    // Affiliation Groups
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Affiliation Groups")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack {
                            TextField("Add Affiliation Group", text: $newAffiliationGroup)
                                .textInputAutocapitalization(.words)
                                .focused($focusedField, equals: .newAffiliationGroup)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit {
                                    withAnimation {
                                        addAffiliationGroup()
                                    }
                                }
                            
                            Button {
                                withAnimation {
                                    addAffiliationGroup()
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(newAffiliationGroup.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
                            }
                            .buttonStyle(.borderless)
                            .disabled(newAffiliationGroup.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                        
                        if !affiliationGroups.isEmpty {
                            ScrollView {
                                VStack(alignment: .leading, spacing: 10) {
                                    ForEach(affiliationGroups, id: \.self) { group in
                                        HStack {
                                            Text(group)
                                            Spacer()
                                            Button {
                                                withAnimation {
                                                    removeAffiliationGroup(group)
                                                }
                                            } label: {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.red)
                                            }
                                            .buttonStyle(.borderless)
                                        }
                                    }
                                }
                            }
                            .frame(maxHeight: 150)
                        }
                    }
                    
                    // Attribute-Group Pairs
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Attribute-Group Pairs")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        ForEach(attributeGroupPairs) { pair in
                            HStack {
                                Text(pair.attribute)
                                    .frame(width: 100, alignment: .leading)
                                Text(pair.group)
                                Spacer()
                                Button {
                                    withAnimation {
                                        attributeGroupPairs.removeAll { $0.id == pair.id }
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.borderless)
                            }
                            .padding(.vertical, 2)
                        }
                        
                        Divider()
                            .padding(.vertical, 5)
                        
                        HStack {
                            Picker("Attribute", selection: $selectedAttribute) {
                                Text("Strength").tag("Strength")
                                Text("Agility").tag("Agility")
                                Text("Toughness").tag("Toughness")
                                Text("Intelligence").tag("Intelligence")
                                Text("Willpower").tag("Willpower")
                                Text("Charisma").tag("Charisma")
                            }
                            .pickerStyle(.menu)
                            .frame(width: 120)
                            
                            TextField("Group", text: $newAttributeGroup)
                                .textFieldStyle(.roundedBorder)
                                .focused($focusedField, equals: .newAttributeGroup)
                                .onSubmit {
                                    withAnimation {
                                        addAttributeGroupPair()
                                    }
                                }
                            
                            Button {
                                withAnimation {
                                    addAttributeGroupPair()
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(newAttributeGroup.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
                            }
                            .buttonStyle(.borderless)
                            .disabled(newAttributeGroup.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                    }
                }
                
                // MARK: Languages Section
                Section(header: Text("Languages").font(.headline)) {
                    HStack {
                        TextField("Add Language", text: $newLanguage)
                            .textInputAutocapitalization(.words)
                            .focused($focusedField, equals: .newLanguage)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit {
                                withAnimation {
                                    addLanguage()
                                }
                            }
                        
                        Button {
                            withAnimation {
                                addLanguage()
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(newLanguage.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
                                                        }
                                                        .buttonStyle(.borderless)
                                                        .disabled(newLanguage.trimmingCharacters(in: .whitespaces).isEmpty)
                                                    }
                                                    
                                                    if !languages.isEmpty {
                                                        ForEach(languages, id: \.self) { language in
                                                            HStack {
                                                                Text(language)
                                                                Spacer()
                                                                if language != "Common" {
                                                                    Button {
                                                                        withAnimation {
                                                                            removeLanguage(language)
                                                                        }
                                                                    } label: {
                                                                        Image(systemName: "trash")
                                                                            .foregroundColor(.red)
                                                                    }
                                                                    .buttonStyle(.borderless)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                // MARK: Equipment Section
                                                Section(header: Text("Equipment").font(.headline)) {
                                                    HStack {
                                                        TextField("Add Inventory Item", text: $newInventoryItem)
                                                            .textInputAutocapitalization(.words)
                                                            .focused($focusedField, equals: .newInventoryItem)
                                                            .textFieldStyle(.roundedBorder)
                                                            .onSubmit {
                                                                withAnimation {
                                                                    addInventoryItem()
                                                                }
                                                            }
                                                        
                                                        Button {
                                                            withAnimation {
                                                                addInventoryItem()
                                                            }
                                                        } label: {
                                                            Image(systemName: "plus.circle.fill")
                                                                .foregroundColor(newInventoryItem.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
                                                        }
                                                        .buttonStyle(.borderless)
                                                        .disabled(newInventoryItem.trimmingCharacters(in: .whitespaces).isEmpty)
                                                    }
                                                    
                                                    if !inventory.isEmpty {
                                                        ForEach(inventory, id: \.self) { item in
                                                            HStack {
                                                                Text(item)
                                                                Spacer()
                                                                Button {
                                                                    withAnimation {
                                                                        removeInventoryItem(item)
                                                                    }
                                                                } label: {
                                                                    Image(systemName: "trash")
                                                                        .foregroundColor(.red)
                                                                }
                                                                .buttonStyle(.borderless)
                                                            }
                                                        }
                                                    }
                                                    
                                                    VStack(alignment: .leading, spacing: 5) {
                                                        Text("Coins (GP)")
                                                            .font(.subheadline)
                                                            .foregroundColor(.secondary)
                                                        TextField("Enter coins", text: $coins)
                                                            .keyboardType(.numberPad)
                                                            .focused($focusedField, equals: .coins)
                                                            .textFieldStyle(.roundedBorder)
                                                    }
                                                }
                                                
                                                // MARK: Encumbrance Section
                                                Section(header: Text("Encumbrance").font(.headline)) {
                                                    VStack(alignment: .leading, spacing: 5) {
                                                        Text("Current Encumbrance")
                                                            .font(.subheadline)
                                                            .foregroundColor(.secondary)
                                                        TextField("Enter current encumbrance", text: $currentEncumbrance)
                                                            .keyboardType(.numberPad)
                                                            .focused($focusedField, equals: .currentEncumbrance)
                                                            .textFieldStyle(.roundedBorder)
                                                    }
                                                    
                                                    VStack(alignment: .leading, spacing: 5) {
                                                        Text("Max Encumbrance")
                                                            .font(.subheadline)
                                                            .foregroundColor(.secondary)
                                                        TextField("Enter max encumbrance", text: $maxEncumbrance)
                                                            .keyboardType(.numberPad)
                                                            .focused($focusedField, equals: .maxEncumbrance)
                                                            .textFieldStyle(.roundedBorder)
                                                    }
                                                }
                                                
                                                // MARK: Notes Section
                                                Section(header: Text("Notes").font(.headline)) {
                                                    TextEditor(text: $notes)
                                                        .frame(minHeight: 100)
                                                        .focused($focusedField, equals: .notes)
                                                }
                                                
                                                // MARK: Other Information Section
                                                Section(header: Text("Other Information").font(.headline)) {
                                                    VStack(alignment: .leading, spacing: 5) {
                                                        Text("Experience (XP)")
                                                            .font(.subheadline)
                                                            .foregroundColor(.secondary)
                                                        TextField("Enter experience", text: $experience)
                                                            .keyboardType(.numberPad)
                                                            .focused($focusedField, equals: .experience)
                                                            .textFieldStyle(.roundedBorder)
                                                    }
                                                    
                                                    VStack(alignment: .leading, spacing: 5) {
                                                        Text("Corruption")
                                                            .font(.subheadline)
                                                            .foregroundColor(.secondary)
                                                        TextField("Enter corruption", text: $corruption)
                                                            .keyboardType(.numberPad)
                                                            .focused($focusedField, equals: .corruption)
                                                            .textFieldStyle(.roundedBorder)
                                                    }
                                                }
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

                                // MARK: - Helper Methods
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
                                    
                                    private func addSpeciesGroup() {
                                        let trimmed = speciesGroup.trimmingCharacters(in: .whitespaces)
                                        guard !trimmed.isEmpty else { return }
                                        isSpeciesGroupAdded = true
                                        focusedField = nil
                                    }
                                    
                                    private func addVocationGroup() {
                                        let trimmed = vocationGroup.trimmingCharacters(in: .whitespaces)
                                        guard !trimmed.isEmpty else { return }
                                        isVocationGroupAdded = true
                                        focusedField = nil
                                    }
                                    
                                    private func addAffiliationGroup() {
                                        let trimmed = newAffiliationGroup.trimmingCharacters(in: .whitespaces)
                                        guard !trimmed.isEmpty else { return }
                                        affiliationGroups.append(trimmed)
                                        newAffiliationGroup = ""
                                        focusedField = nil
                                    }
                                    
                                    private func removeAffiliationGroup(_ group: String) {
                                        affiliationGroups.removeAll { $0 == group }
                                    }
                                    
                                    private func addAttributeGroupPair() {
                                        let trimmed = newAttributeGroup.trimmingCharacters(in: .whitespaces)
                                        guard !trimmed.isEmpty else { return }
                                        attributeGroupPairs.append(AttributeGroupPair(attribute: selectedAttribute, group: trimmed))
                                        newAttributeGroup = ""
                                        focusedField = nil
                                    }
                                    
                                    private func addLanguage() {
                                        let trimmed = newLanguage.trimmingCharacters(in: .whitespaces)
                                        guard !trimmed.isEmpty else { return }
                                        languages.append(trimmed)
                                        newLanguage = ""
                                        focusedField = nil
                                    }
                                    
                                    private func removeLanguage(_ language: String) {
                                        languages.removeAll { $0 == language }
                                    }
                                    
                                    private func addInventoryItem() {
                                        let trimmed = newInventoryItem.trimmingCharacters(in: .whitespaces)
                                        guard !trimmed.isEmpty else { return }
                                        inventory.append(trimmed)
                                        newInventoryItem = ""
                                        focusedField = nil
                                    }
                                    
                                    private func removeInventoryItem(_ item: String) {
                                        inventory.removeAll { $0 == item }
                                    }
                                }

                                // MARK: - AttributeEditor Helper View
                                struct AttributeEditor: View {
                                    let label: String
                                    @Binding var value: String
                                    let range: ClosedRange<Int>
                                    let focusedField: CharacterFormView.Field?
                                    let field: CharacterFormView.Field
                                    let focusBinding: FocusState<CharacterFormView.Field?>.Binding
                                    
                                    var body: some View {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(label)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            TextField("Enter \(label.lowercased())", text: $value)
                                                .keyboardType(.numberPad)
                                                .onReceive(value.publisher.collect()) { newValue in
                                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                                    if filtered != newValue {
                                                        self.value = String(filtered)
                                                    }
                                                }
                                                .focused(focusBinding, equals: field)
                                                .textFieldStyle(.roundedBorder)
                                        }
                                    }
                                }
