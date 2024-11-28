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
    @State private var editingNewArmor: Armor?
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
                            armor.append(newArmor)
                            editingNewArmor = nil
                            isAddingNew = false
                        } onCancel: {
                            editingNewArmor = nil
                            isAddingNew = false
                        }
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
                    ArmorRow(armor: armorItem,
                        onEdit: { editingArmorId = armorItem.id },
                        onDelete: {
                            armor.removeAll(where: { $0.id == armorItem.id })
                        }
                    )
                }
                
                if editingArmorId != nil, let armorToEdit = armor.first(where: { $0.id == editingArmorId }) {
                    ArmorEditRow(armor: armorToEdit) { updatedArmor in
                        if let index = armor.firstIndex(where: { $0.id == armorToEdit.id }) {
                            armor[index] = updatedArmor
                        }
                        editingArmorId = nil
                    } onCancel: {
                        editingArmorId = nil
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
                
                Text(armorData.isShield ? "+\(armorData.df)" : "Defense: \(armorData.df)")
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
                
                if isMagical {
                    Toggle(isOn: $isCursed) {
                        Label {
                            Text("Cursed")
                        } icon: {
                            IconFrame(icon: Ph.skull.bold, color: isCursed ? .red : .gray)
                        }
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
    
    let onSave: (Armor) -> Void
    let onCancel: () -> Void
    let armor: Armor
    
    // Basic Properties
    @State private var name: String
    @State private var df: Int
    @State private var weight: Int
    @State private var special: String
    @State private var isEquipped: Bool
    @State private var isStashed: Bool
    @State private var isMagical: Bool
    @State private var isCursed: Bool
    @State private var bonus: Int
    @State private var quantity: Int
    @State private var isBonus: Bool
    @State private var bonusString: String
    @State private var quantityString: String
    @State private var isShield: Bool
    
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
        _special = State(initialValue: armor.special)
        _isEquipped = State(initialValue: armor.isEquipped)
        _isStashed = State(initialValue: armor.isStashed)
        _isMagical = State(initialValue: armor.isMagical)
        _isCursed = State(initialValue: armor.isCursed)
        _bonus = State(initialValue: armor.bonus)
        _quantity = State(initialValue: armor.quantity)
        _isBonus = State(initialValue: armor.bonus >= 0)
        _bonusString = State(initialValue: "\(abs(armor.bonus))")
        _quantityString = State(initialValue: "\(armor.quantity)")
        _isShield = State(initialValue: armor.isShield)
    }
    
    private func validateAndUpdateQuantity() {
        if let newValue = Int(quantityString) {
            quantity = max(1, newValue)
        }
        quantityString = "\(quantity)"
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
                    IconFrame(icon: Ph.shield.bold, color: .purple)
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
                Text("Weight")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    HStack {
                        TextField("Weight", value: $weight, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        Stepper("", value: $weight, in: 0...Int.max)
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
            
            // Bonus Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Bonus/Penalty")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    Picker("", selection: $isBonus) {
                        Text("+").tag(true)
                        Text("-").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 100)
                    
                    Label {
                        TextField("0", text: $bonusString)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .onChange(of: bonusString) { newValue in
                                validateBonusInput(newValue)
                            }
                    } icon: {
                        IconFrame(icon: Ph.plusMinus.bold, color: isBonus ? .green : .red)
                    }
                }
            }
            
            // Status Section
            Section {
                // Equipped Toggle
                HStack {
                    IconFrame(icon: Ph.bagSimple.bold, color: isEquipped ? .green : .gray)
                    Toggle(isEquipped ? "Equipped" : "Unequipped", isOn: Binding(
                        get: { isEquipped },
                        set: { newValue in
                            withAnimation {
                                isEquipped = newValue
                                if newValue {
                                    isStashed = false
                                }
                            }
                        }
                    ))
                }
                
                // Stashed Toggle
                HStack {
                    IconFrame(icon: Ph.vault.bold, color: isStashed ? .orange : .gray)
                    Toggle(isStashed ? "Stashed" : "On Person", isOn: Binding(
                        get: { isStashed },
                        set: { newValue in
                            withAnimation {
                                isStashed = newValue
                                if newValue {
                                    isEquipped = false
                                }
                            }
                        }
                    ))
                }
                
                // Shield Toggle
                HStack {
                    IconFrame(icon: Ph.shield.bold, color: isShield ? .blue : .gray)
                    Toggle(isShield ? "Shield" : "Not Shield", isOn: $isShield)
                }
                
                // Magical Toggle
                HStack {
                    IconFrame(icon: Ph.sparkle.bold, color: isMagical ? .purple : .gray)
                    Toggle("Magical", isOn: $isMagical)
                }
                
                // Cursed Toggle (only shown if magical)
                if isMagical {
                    HStack {
                        IconFrame(icon: Ph.skull.bold, color: isCursed ? .red : .gray)
                        Toggle("Cursed", isOn: $isCursed)
                    }
                }
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 20) {
                Button {
                    guard !isProcessingAction else { return }
                    isProcessingAction = true
                    print("🔴 Cancel action starting")
                    onCancel()
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
            }
        }
        .padding()
    }
}

struct ArmorRow: View {
    let armor: Armor
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    private func getWeightDisplayText(_ weight: String) -> String {
        switch weight {
        case "Minor": return "Minor (2/slot)"
        case "Light": return "Light (1 slot)"
        case "Heavy": return "Heavy (2 slots)"
        default: return weight
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Content Area
            VStack(alignment: .leading, spacing: 12) {
                // Name Section
                VStack(alignment: .leading, spacing: 4) {
                    Label {
                        Text("Armor Name")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } icon: {
                        IconFrame(icon: Ph.shield.bold, color: .purple)
                    }
                    Label {
                        Text(armor.name)
                    } icon: {
                        IconFrame(icon: Ph.shield.bold, color: .purple)
                    }
                }
                
                // Defense Factor Section
                VStack(alignment: .leading, spacing: 4) {
                    Label {
                        Text("Defense")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } icon: {
                        IconFrame(icon: Ph.shieldChevron.bold, color: .blue)
                    }
                    Label {
                        Text("\(armor.df)")
                    } icon: {
                        IconFrame(icon: Ph.shieldChevron.bold, color: .blue)
                    }
                }
                
                // Weight Section
                VStack(alignment: .leading, spacing: 4) {
                    Label {
                        Text("Weight")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } icon: {
                        IconFrame(icon: Ph.scales.bold, color: .orange)
                    }
                    Label {
                        Text("\(armor.weight)")
                    } icon: {
                        IconFrame(icon: Ph.scales.bold, color: .orange)
                    }
                }
                
                // Special Section
                if !armor.special.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Label {
                            Text("Special Properties")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } icon: {
                            IconFrame(icon: Ph.star.bold, color: .yellow)
                        }
                        Label {
                            Text(armor.special)
                        } icon: {
                            IconFrame(icon: Ph.star.bold, color: .yellow)
                        }
                    }
                }
                
                // Quantity Section
                if armor.quantity > 1 {
                    VStack(alignment: .leading, spacing: 4) {
                        Label {
                            Text("Quantity")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } icon: {
                            IconFrame(icon: Ph.stack.bold, color: .gray)
                        }
                        Label {
                            Text("\(armor.quantity)")
                        } icon: {
                            IconFrame(icon: Ph.stack.bold, color: .gray)
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
                            IconFrame(icon: armor.isStashed ? Ph.vault.bold : Ph.user.bold,
                                    color: armor.isStashed ? .orange : .gray)
                        }
                    }
                }
                
                // Magical Properties Section
                if armor.isMagical || armor.isCursed {
                    VStack(alignment: .leading, spacing: 4) {
                        Label {
                            Text("Magical Properties")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } icon: {
                            IconFrame(icon: Ph.sparkle.bold, color: .purple)
                        }
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
                
                // Bonus/Penalty Section
                if armor.bonus != 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        Label {
                            Text(armor.bonus > 0 ? "Bonus" : "Penalty")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } icon: {
                            IconFrame(icon: armor.bonus > 0 ? Ph.plus.bold : Ph.minus.bold,
                                    color: armor.bonus > 0 ? .green : .red)
                        }
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
            .padding(.horizontal)
            .padding(.top, 4)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
