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
                    if editingArmorId == armorItem.id {
                        Group {
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
                        }
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
    
    @State private var name = ""
    @State private var df = 1
    @State private var weight = 1
    @State private var special = ""
    @State private var quantity = 1
    @State private var isEquipped = false
    @State private var isStashed = false
    @State private var isMagical = false
    @State private var isCursed = false
    @State private var bonus = 0
    @State private var isShield = false
    @State private var isProcessingAction = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Name Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Armor Name")
                    .font(.subheadline)
                TextField("Enter armor name", text: $name)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Stats Section
            HStack(spacing: 16) {
                // Defense
                VStack(alignment: .leading, spacing: 4) {
                    Text("Defense")
                        .font(.subheadline)
                    TextField("Defense", value: $df, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .frame(width: 80)
                }
                
                // Weight
                VStack(alignment: .leading, spacing: 4) {
                    Text("Weight")
                        .font(.subheadline)
                    TextField("Weight", value: $weight, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .frame(width: 80)
                }
            }
            
            // Special Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Special Properties")
                    .font(.subheadline)
                TextField("Special Properties", text: $special)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Quantity Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Quantity")
                    .font(.subheadline)
                TextField("Quantity", value: $quantity, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .frame(width: 80)
            }
            
            // Status Section
            VStack(alignment: .leading, spacing: 8) {
                // Equipped Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.bagSimple.bold, color: isEquipped ? .green : .gray)
                    Toggle(isEquipped ? "Equipped" : "Unequipped", isOn: Binding(
                        get: { isEquipped },
                        set: { newValue in
                            if newValue && isStashed {
                                isStashed = false
                            }
                            isEquipped = newValue
                        }
                    ))
                }
                
                // Stashed Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.warehouse.bold, color: isStashed ? .orange : .gray)
                    Toggle(isStashed ? "Stashed" : "On Person", isOn: Binding(
                        get: { isStashed },
                        set: { newValue in
                            if newValue && isEquipped {
                                isEquipped = false
                            }
                            isStashed = newValue
                        }
                    ))
                }
                
                // Shield Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.shieldCheck.bold, color: isShield ? .blue : .gray)
                    Toggle("Shield", isOn: $isShield)
                }
            }
            
            // Magical Properties Section
            VStack(alignment: .leading, spacing: 8) {
                // Magical Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.sparkle.bold, color: isMagical ? .purple : .gray)
                    Toggle("Magical", isOn: $isMagical)
                }
                
                if isMagical {
                    // Bonus Section
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Magical Bonus/Penalty")
                            .font(.subheadline)
                        TextField("Bonus", value: $bonus, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                    }
                }
                
                // Cursed Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.skull.bold, color: isCursed ? .red : .gray)
                    Toggle("Cursed", isOn: $isCursed)
                }
            }
            
            Divider()
            
            // Action Buttons
            HStack(spacing: 20) {  // Added explicit spacing
                Button {
                    guard !isProcessingAction else { return }
                    isProcessingAction = true
                    print("🔴 Cancel action starting")
                    onCancel()
                    isProcessingAction = false
                } label: {
                    Label("Cancel", systemImage: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                .buttonStyle(.borderless)
                
                Spacer()
                
                Button {
                    guard !isProcessingAction else { return }
                    isProcessingAction = true
                    print("💾 Save action starting")
                    
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
                    isProcessingAction = false
                } label: {
                    Label("Save", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                .buttonStyle(.borderless)
                .disabled(name.isEmpty || df < 1)
            }
        }
        .padding()
        .onAppear {
            // Reset state to match the input armor
            name = armor.name
            df = armor.df
            weight = armor.weight
            special = armor.special
            quantity = armor.quantity
            isEquipped = armor.isEquipped
            isStashed = armor.isStashed
            isMagical = armor.isMagical
            isCursed = armor.isCursed
            bonus = armor.bonus
            isShield = armor.isShield
        }
    }
}

struct ArmorRow: View {
    let armor: Armor
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    private var magicalPropertyText: String {
        var properties: [String] = []
        if armor.isMagical {
            properties.append("Magical")
            if armor.bonus != 0 {
                properties.append(armor.bonus > 0 ? "+\(armor.bonus)" : "\(armor.bonus)")
            }
        }
        if armor.isCursed { properties.append("Cursed") }
        return properties.joined(separator: ", ")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Content Area
            VStack(alignment: .leading, spacing: 12) {
                // Name Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Armor Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack {
                        if armor.isShield {
                            IconFrame(icon: Ph.shieldCheck.bold, color: .blue)
                        } else {
                            IconFrame(icon: Ph.shield.bold, color: .purple)
                        }
                        Text(armor.name)
                            .font(.headline)
                    }
                }
                
                // Stats Section
                HStack(spacing: 16) {
                    // Defense
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Defense")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(armor.df)")
                            .font(.headline)
                    }
                    
                    // Weight
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Weight")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(armor.weight)")
                            .font(.headline)
                    }
                    
                    // Quantity
                    if armor.quantity > 1 {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Quantity")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(armor.quantity)")
                                .font(.headline)
                        }
                    }
                }
                
                // Special Properties
                if !armor.special.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Special Properties")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(armor.special)
                            .font(.headline)
                    }
                }
                
                // Status Icons
                HStack(spacing: 12) {
                    // Equipped Status
                    IconFrame(icon: Ph.bagSimple.bold, color: armor.isEquipped ? .green : .gray)
                    Text(armor.isEquipped ? "Equipped" : "Unequipped")
                        .foregroundColor(armor.isEquipped ? .green : .gray)
                    
                    // Stashed Status
                    if armor.isStashed {
                        IconFrame(icon: Ph.warehouse.bold, color: .orange)
                        Text("Stashed")
                            .foregroundColor(.orange)
                    }
                }
                
                // Magical Properties Section
                if armor.isMagical || armor.isCursed {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Magical Properties")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(magicalPropertyText)
                            .font(.headline)
                    }
                }
            }
            .allowsHitTesting(false)  // Disable touch interaction for content area only
            
            Divider()
            
            // Action Buttons
            HStack {
                Spacer()
                
                Button(action: onEdit) {
                    Label("Edit", systemImage: "pencil")
                }
                .buttonStyle(.borderless)
                
                Button(action: onDelete) {
                    Label("Delete", systemImage: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(.borderless)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
