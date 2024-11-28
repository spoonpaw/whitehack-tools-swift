import SwiftUI
import PhosphorSwift

typealias ArmorItem = ArmorData.ArmorItem

struct FormArmorSection: View {
    @Binding var armor: [Armor]
    @State private var editingArmorId: UUID?
    @State private var isAddingNew = false {
        didSet {
            print("🛡️ isAddingNew changed to: \(isAddingNew)")
            if !isAddingNew {
                print("🧹 Cleaning up armor states")
                selectedArmorName = nil
                editingNewArmor = nil
            }
        }
    }
    @State private var editingNewArmor: Armor? {
        didSet {
            print("🛡️ editingNewArmor changed: \(String(describing: oldValue?.name)) -> \(String(describing: editingNewArmor?.name))")
        }
    }
    @State private var selectedArmorName: String? {
        didSet {
            print("🎯 selectedArmorName changed: \(String(describing: oldValue)) -> \(String(describing: selectedArmorName))")
            if selectedArmorName == nil {
                print("⚠️ No armor selected")
                editingNewArmor = nil
            }
        }
    }
    
    private func createArmorFromSelection(_ armorName: String) {
        print("🎯 Creating armor from selection: \(armorName)")
        
        if armorName == "custom" {
            // Handle custom armor creation
            let armor = Armor(
                id: UUID(),
                name: "",
                df: 0,
                weight: 1,
                special: "",
                quantity: 1,
                isEquipped: false,
                isStashed: false,
                isMagical: false,
                isCursed: false,
                bonus: 0,
                isShield: false
            )
            editingNewArmor = armor
        } else if let armorData = ArmorData.armors.first(where: { $0.name == armorName }) {
            print("📦 Found armor data: \(armorData)")
            let newArmor = Armor(
                id: UUID(),
                name: armorData.name,
                df: armorData.df,
                weight: armorData.weight,
                special: "",
                quantity: 1,
                isEquipped: false,
                isStashed: false,
                isMagical: false,
                isCursed: false,
                bonus: 0,
                isShield: armorData.isShield
            )
            print("🛠️ Created armor:")
            print("   Name: \(newArmor.name)")
            print("   Defense: \(newArmor.df)")
            print("   Weight: \(newArmor.weight)")
            print("   Shield: \(newArmor.isShield)")
            
            withAnimation {
                editingNewArmor = newArmor
            }
        }
    }
    
    var body: some View {
        Section {
            if armor.isEmpty && !isAddingNew {
                VStack(spacing: 12) {
                    Image(systemName: "shield.slash")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    
                    Text("No Armor")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        print("📱 Add First Armor tapped")
                        withAnimation {
                            isAddingNew = true
                        }
                    }) {
                        Label("Add Your First Armor", systemImage: "plus.circle.fill")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                if isAddingNew {
                    if let editingArmor = editingNewArmor {
                        ArmorEditRow(armor: editingArmor) { newArmor in
                            print("🟢 [FormArmorSection] Save action received for: \(newArmor.name)")
                            armor.append(newArmor)
                            print("✅ [FormArmorSection] Armor added to array")
                            withAnimation {
                                print("🔄 [FormArmorSection] Resetting form state after save")
                                isAddingNew = false
                            }
                        } onCancel: {
                            print("🔴 [FormArmorSection] Cancel action received")
                            withAnimation {
                                print("🔄 [FormArmorSection] Resetting form state after cancel")
                                selectedArmorName = nil
                                editingNewArmor = nil
                                isAddingNew = false
                            }
                        }
                        .id("\(editingArmor.id)-\(editingArmorId != nil)")  // Force view recreation when editing starts/stops
                    } else {
                        VStack(spacing: 12) {
                            Text("Select Armor Type")
                                .font(.headline)
                            
                            Picker("Select Armor", selection: $selectedArmorName) {
                                Text("Select an Armor").tag(nil as String?)
                                ForEach(ArmorData.armors.map { $0.name }.sorted(), id: \.self) { name in
                                    Text(name).tag(name as String?)
                                }
                                Text("Custom Armor").tag("custom" as String?)
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .onChange(of: selectedArmorName) { newValue in
                                if let armorName = newValue {
                                    createArmorFromSelection(armorName)
                                }
                            }
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    print("❌ Cancel button tapped")
                                    withAnimation {
                                        isAddingNew = false
                                    }
                                }) {
                                    Text("Cancel")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                ForEach(armor) { armorItem in
                    Group {
                        if editingArmorId == armorItem.id {
                            ArmorEditRow(armor: armorItem) { updatedArmor in
                                print("💾 Saving updated armor: \(updatedArmor.name)")
                                if let index = armor.firstIndex(where: { $0.id == armorItem.id }) {
                                    print("🔄 Updating armor at index: \(index)")
                                    armor[index] = updatedArmor
                                }
                                editingArmorId = nil
                            } onCancel: {
                                print("❌ Canceling armor edit - reverting to original state")
                                editingArmorId = nil
                            }
                            .id("\(armorItem.id)-\(editingArmorId != nil)")  // Force view recreation when editing starts/stops
                        } else {
                            ArmorRow(armor: armorItem,
                                onEdit: {
                                    print("✏️ Starting edit for armor: \(armorItem.name)")
                                    editingArmorId = armorItem.id
                                },
                                onDelete: {
                                    armor.removeAll(where: { $0.id == armorItem.id })
                                }
                            )
                        }
                    }
                }
                
                if !isAddingNew {
                    Button(action: {
                        print("🔄 Adding new armor")
                        withAnimation {
                            isAddingNew = true
                        }
                    }) {
                        Label("Add Another Armor", systemImage: "plus.circle.fill")
                    }
                }
            }
        } header: {
            Label("Armor", systemImage: "shield.lefthalf.filled")
        }
    }
}

struct ArmorDataRow: View {
    let armorData: ArmorItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label {
                    Text(armorData.name)
                        .font(.headline)
                } icon: {
                    IconFrame(icon: armorData.isShield ? Ph.shieldCheck.bold : Ph.shield.bold, color: .blue)
                }
                
                Spacer()
                
                Text(armorData.isShield ? "+\(armorData.df)" : "\(armorData.df)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Label {
                Text("\(armorData.weight) slot\(armorData.weight == 1 ? "" : "s")")
                    .font(.subheadline)
            } icon: {
                IconFrame(icon: Ph.scales.bold, color: .blue)
            }
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct CustomArmorForm: View {
    @Binding var armor: [Armor]
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var df = 0
    @State private var weight = 1
    @State private var special = ""
    @State private var quantity = 1
    @State private var isEquipped = false
    @State private var isStashed = false
    @State private var isMagical = false
    @State private var isCursed = false
    @State private var bonus = 0
    @State private var isShield = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Name Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Defense Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Defense")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    TextField("Defense", value: $df, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    Stepper("", value: $df, in: 1...Int.max)
                        .labelsHidden()
                }
            }
            
            // Weight Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Weight")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    TextField("Weight", value: $weight, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    Stepper("", value: $weight, in: 0...Int.max)
                        .labelsHidden()
                }
            }
            
            // Special Properties
            VStack(alignment: .leading, spacing: 4) {
                Text("Special Properties")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Special Properties", text: $special)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Toggles Section
            VStack(alignment: .leading, spacing: 8) {
                Toggle(isOn: $isEquipped) {
                    Label {
                        Text(isEquipped ? "Equipped" : "Unequipped")
                    } icon: {
                        IconFrame(icon: Ph.bagSimple.bold, color: isEquipped ? .green : .gray)
                    }
                }
                
                Toggle(isOn: $isStashed) {
                    Label {
                        Text(isStashed ? "Stashed" : "Not Stashed")
                    } icon: {
                        IconFrame(icon: Ph.vault.bold, color: isStashed ? .orange : .gray)
                    }
                }
                
                Toggle(isOn: $isMagical) {
                    Label {
                        Text("Magical")
                    } icon: {
                        IconFrame(icon: Ph.sparkle.bold, color: isMagical ? .purple : .gray)
                    }
                }
                
                Toggle(isOn: $isCursed) {
                    Label {
                        Text("Cursed")
                    } icon: {
                        IconFrame(icon: Ph.skull.bold, color: isCursed ? .red : .gray)
                    }
                }
                
                Toggle(isOn: $isShield) {
                    Label {
                        Text("Shield")
                    } icon: {
                        IconFrame(icon: Ph.shield.bold, color: isShield ? .blue : .gray)
                    }
                }
            }
            
            // Quantity Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Quantity")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    TextField("Quantity", value: $quantity, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    Stepper("", value: $quantity, in: 1...Int.max)
                        .labelsHidden()
                }
            }
            
            // Bonus Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Bonus/Penalty")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    TextField("Bonus", value: $bonus, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    Stepper("", value: $bonus)
                        .labelsHidden()
                }
            }
            
            Spacer()
            
            // Save/Cancel Buttons
            HStack(spacing: 20) {
                Button {
                    isPresented = false
                } label: {
                    Label {
                        Text("Cancel")
                            .fontWeight(.medium)
                    } icon: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .foregroundColor(.red)
                }
                .buttonStyle(.borderless)
                
                Spacer()
                
                Button {
                    let newArmor = Armor(
                        id: UUID(),
                        name: name,
                        df: df,
                        weight: weight,
                        special: special,
                        quantity: quantity,
                        isEquipped: isEquipped,
                        isStashed: isStashed,
                        isMagical: isMagical,
                        isCursed: isCursed,
                        bonus: bonus,
                        isShield: isShield
                    )
                    armor.append(newArmor)
                    isPresented = false
                } label: {
                    Label {
                        Text("Save")
                            .fontWeight(.medium)
                    } icon: {
                        Image(systemName: "checkmark.circle.fill")
                    }
                    .foregroundColor(.blue)
                }
                .buttonStyle(.borderless)
                .disabled(name.isEmpty)
            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
        .padding()
    }
}

struct ArmorEditRow: View {
    @Environment(\.dismiss) private var dismiss
    
    let armor: Armor
    let onSave: (Armor) -> Void
    let onCancel: () -> Void
    
    // Basic Properties
    @State private var name: String
    @State private var df: Int
    @State private var weight: Int
    @State private var special: String
    @State private var quantity: Int
    @State private var isEquipped: Bool
    @State private var isStashed: Bool
    @State private var isMagical: Bool
    @State private var isCursed: Bool
    @State private var bonus: Int
    @State private var isShield: Bool
    @State private var isBonus: Bool
    @State private var bonusString: String
    @State private var quantityString: String
    @State private var weightString: String
    
    // Button state tracking
    @State private var isProcessingAction = false
    
    // Initialize with an armor
    init(armor: Armor, onSave: @escaping (Armor) -> Void, onCancel: @escaping () -> Void) {
        self.armor = armor
        self.onSave = onSave
        self.onCancel = onCancel
        
        // Initialize state properties
        _name = State(initialValue: armor.name)
        _df = State(initialValue: armor.df)
        _weight = State(initialValue: armor.weight)
        _weightString = State(initialValue: "\(armor.weight)")
        _special = State(initialValue: armor.special)
        _quantity = State(initialValue: armor.quantity)
        _isEquipped = State(initialValue: armor.isEquipped)
        _isStashed = State(initialValue: armor.isStashed)
        _isMagical = State(initialValue: armor.isMagical)
        _isCursed = State(initialValue: armor.isCursed)
        _bonus = State(initialValue: armor.bonus)
        _isShield = State(initialValue: armor.isShield)
        _isBonus = State(initialValue: armor.bonus >= 0)
        _bonusString = State(initialValue: "\(abs(armor.bonus))")
        _quantityString = State(initialValue: "\(armor.quantity)")
    }
    
    private func validateQuantityInput(_ input: String) {
        if let newValue = Int(input) {
            if newValue < 1 {
                quantityString = "1"
                quantity = 1
            } else {
                quantity = newValue
            }
        } else if !input.isEmpty {
            quantityString = "\(quantity)"
        }
    }
    
    private func validateBonusInput(_ input: String) {
        if let newValue = Int(input) {
            let absValue = max(0, abs(newValue))
            bonus = isBonus ? absValue : -absValue
            bonusString = "\(absValue)"
        } else if !input.isEmpty {
            bonusString = "\(abs(bonus))"
        }
    }
    
    private func validateWeightInput(_ input: String) {
        if let newValue = Int(input) {
            if newValue < 0 {
                weightString = "0"
                weight = 0
            } else {
                weight = newValue
            }
        } else if !input.isEmpty {
            weightString = "\(weight)"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Name Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Armor Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    TextField("Armor Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } icon: {
                    IconFrame(icon: armor.isShield ? Ph.shieldCheck.bold : Ph.shield.bold, 
                            color: armor.isShield ? .blue : .purple)
                }
            }
            
            // Defense Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Defense")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    HStack {
                        TextField("Defense", value: $df, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        Stepper("", value: $df, in: 1...Int.max)
                            .labelsHidden()
                    }
                } icon: {
                    IconFrame(icon: Ph.shieldChevron.bold, color: .blue)
                }
            }
            
            // Weight Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Weight (Slots)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    HStack {
                        TextField("Weight", text: $weightString)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .onChange(of: weightString) { newValue in
                                validateWeightInput(newValue)
                            }
                        Stepper("", value: $weight, in: 0...Int.max) { _ in
                            weightString = "\(weight)"
                        }
                        .labelsHidden()
                    }
                } icon: {
                    IconFrame(icon: Ph.scales.bold, color: .orange)
                }
            }
            
            // Special Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Special Properties")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    TextField("Special Properties", text: $special)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } icon: {
                    IconFrame(icon: Ph.star.bold, color: .yellow)
                }
            }
            
            // Quantity Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Quantity")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    HStack {
                        TextField("Quantity", text: $quantityString)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .onChange(of: quantityString) { newValue in
                                validateQuantityInput(newValue)
                            }
                        Stepper("", value: $quantity, in: 1...Int.max) { _ in
                            quantityString = "\(quantity)"
                        }
                        .labelsHidden()
                    }
                } icon: {
                    IconFrame(icon: Ph.stack.bold, color: .gray)
                }
            }
            
            // Status Section
            VStack(alignment: .leading, spacing: 8) {
                // Shield Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.shieldCheck.bold, color: isShield ? .blue : .gray)
                    Toggle("Shield", isOn: $isShield)
                }
                
                // Equipped Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.bagSimple.bold, color: isEquipped ? .green : .gray)
                    Toggle(isEquipped ? "Equipped" : "Unequipped", isOn: Binding(
                        get: { isEquipped },
                        set: { newValue in
                            print("🔄 Equipped status changed to: \(newValue)")
                            isEquipped = newValue
                            if newValue {
                                isStashed = false
                            }
                        }
                    ))
                }
                
                // Location Toggle with Icon
                HStack {
                    IconFrame(icon: isStashed ? Ph.warehouse.bold : Ph.user.bold, 
                            color: isStashed ? .orange : .gray)
                    Toggle(isStashed ? "Stashed" : "On Person", isOn: Binding(
                        get: { isStashed },
                        set: { newValue in
                            print("🔄 Stashed status changed to: \(newValue)")
                            isStashed = newValue
                            if newValue {
                                isEquipped = false
                            }
                        }
                    ))
                }
            }
            
            // Magical Properties Section
            VStack(alignment: .leading, spacing: 8) {
                // Magical Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.sparkle.bold, color: isMagical ? .purple : .gray)
                    Toggle("Magical", isOn: $isMagical)
                }
                
                // Cursed Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.skull.bold, color: isCursed ? .red : .gray)
                    Toggle("Cursed", isOn: $isCursed)
                }
            }
            
            // Bonus/Penalty Section
            Section {
                // Toggle between Penalty/Bonus (left = penalty/red, right = bonus/green)
                Toggle(isOn: $isBonus) {
                    Text(isBonus ? "Bonus" : "Penalty")
                        .foregroundColor(isBonus ? .green : .red)
                }
                .onChange(of: isBonus) { newValue in
                    bonus = newValue ? abs(bonus) : -abs(bonus)
                }
                
                // Value Control
                HStack {
                    IconFrame(icon: isBonus ? Ph.plus.bold : Ph.minus.bold,
                            color: isBonus ? .green : .red)
                    TextField("", text: $bonusString)
                        .keyboardType(.numberPad)
                        .frame(width: 60)
                        .multilineTextAlignment(.leading)
                        .onChange(of: bonusString) { newValue in
                            validateBonusInput(newValue)
                        }
                        .onChange(of: bonus) { newValue in
                            bonusString = "\(abs(newValue))"
                        }
                    Spacer()
                    Stepper("", value: Binding(
                        get: { abs(bonus) },
                        set: { newValue in
                            let value = max(0, newValue)  // Prevent negative values
                            bonus = isBonus ? value : -value
                        }
                    ), in: 0...Int.max)  // Add range constraint
                    .labelsHidden()
                }
            } header: {
                Text("Bonus/Penalty")
            }
            
            // Save/Cancel Buttons
            HStack(spacing: 20) {  // Match weapon spacing
                Button {
                    guard !isProcessingAction else { return }
                    isProcessingAction = true
                    print("🔴 Cancel action starting")
                    onCancel()
                    DispatchQueue.main.async {
                        isProcessingAction = false
                    }
                } label: {
                    Label {
                        Text("Cancel")
                            .fontWeight(.medium)
                    } icon: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .foregroundColor(.red)
                }
                .buttonStyle(.borderless)
                
                Spacer()
                
                Button {
                    guard !isProcessingAction else { return }
                    isProcessingAction = true
                    print("🟢 Save action starting")
                    
                    let updatedArmor = Armor(
                        id: armor.id,
                        name: name,
                        df: df,
                        weight: weight,
                        special: special,
                        quantity: quantity,
                        isEquipped: isEquipped,
                        isStashed: isStashed,
                        isMagical: isMagical,
                        isCursed: isCursed,
                        bonus: bonus,
                        isShield: isShield
                    )
                    
                    onSave(updatedArmor)
                    DispatchQueue.main.async {
                        isProcessingAction = false
                    }
                } label: {
                    Label {
                        Text("Save")
                            .fontWeight(.medium)
                    } icon: {
                        Image(systemName: "checkmark.circle.fill")
                    }
                    .foregroundColor(.blue)
                }
                .buttonStyle(.borderless)
                .disabled(name.isEmpty || df < 1)
            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
        .padding()
    }
}

struct ArmorRow: View {
    let armor: Armor
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Content Area
            VStack(alignment: .leading, spacing: 12) {
                // Name Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Armor Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text(armor.name)
                    } icon: {
                        IconFrame(icon: armor.isShield ? Ph.shieldCheck.bold : Ph.shield.bold, 
                                color: armor.isShield ? .blue : .purple)
                    }
                }
                
                // Defense Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Defense")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text(armor.isShield ? "+\(armor.df)" : "\(armor.df)")
                    } icon: {
                        IconFrame(icon: Ph.shieldChevron.bold, color: .blue)
                    }
                }
                
                // Weight Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Weight")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text("\(armor.weight) slot\(armor.weight != 1 ? "s" : "")")
                    } icon: {
                        IconFrame(icon: Ph.scales.bold, color: .orange)
                    }
                }
                
                // Special Section
                if !armor.special.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Special Properties")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Label {
                            Text(armor.special)
                        } icon: {
                            IconFrame(icon: Ph.star.bold, color: .yellow)
                        }
                    }
                }
                
                // Status Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Status")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack(spacing: 16) {
                        Label {
                            Text(armor.isEquipped ? "Equipped" : "Unequipped")
                        } icon: {
                            IconFrame(icon: Ph.bagSimple.bold, color: armor.isEquipped ? .green : .gray)
                        }
                        Label {
                            Text(armor.isStashed ? "Stashed" : "On Person")
                        } icon: {
                            IconFrame(icon: armor.isStashed ? Ph.warehouse.bold : Ph.user.bold,
                                    color: armor.isStashed ? .orange : .gray)
                        }
                    }
                }
                
                // Magical Properties Section
                if armor.isMagical || armor.isCursed {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Magical Properties")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack(spacing: 16) {
                            if armor.isMagical {
                                Label {
                                    Text("Magical")
                                } icon: {
                                    IconFrame(icon: Ph.sparkle.bold, color: .purple)
                                }
                            }
                            if armor.isCursed {
                                Label {
                                    Text("Cursed")
                                } icon: {
                                    IconFrame(icon: Ph.skull.bold, color: .red)
                                }
                            }
                        }
                    }
                }
                
                // Bonus Section
                if armor.bonus != 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(armor.bonus > 0 ? "Bonus" : "Penalty")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Label {
                            Text("\(abs(armor.bonus))")
                        } icon: {
                            IconFrame(icon: armor.bonus > 0 ? Ph.plus.bold : Ph.minus.bold,
                                    color: armor.bonus > 0 ? .green : .red)
                        }
                    }
                }
            }
            .allowsHitTesting(false)  // Disable touch interaction for content area only
            
            Divider()
            
            // Action Buttons
            HStack(spacing: 20) {
                Button(action: onEdit) {
                    Label {
                        Text("Edit")
                            .fontWeight(.medium)
                    } icon: {
                        Image(systemName: "pencil.circle.fill")
                    }
                    .foregroundColor(.blue)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Label {
                        Text("Delete")
                            .fontWeight(.medium)
                    } icon: {
                        Image(systemName: "trash.circle.fill")
                    }
                    .foregroundColor(.red)
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
