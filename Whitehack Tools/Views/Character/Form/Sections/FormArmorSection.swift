import SwiftUI
import PhosphorSwift
#if os(iOS)
import UIKit
#else
import AppKit
#endif

typealias ArmorItem = ArmorData.ArmorItem

struct FormArmorSection: View {
    @Binding var armor: [Armor] {
        didSet {
            logArmorArrayUpdate()
        }
    }
    @State private var editingArmorId: UUID?
    @State private var isAddingNew = false {
        didSet {
            print("🛡️ isAddingNew changed to: \(isAddingNew)")
            if !isAddingNew {
                print("🧹 Cleaning up armor states")
            }
        }
    }
    @State private var editingNewArmor: Armor?
    @State private var selectedArmorName: String? {
        didSet {
            print("🎯 selectedArmorName changed: \(String(describing: oldValue)) -> \(String(describing: selectedArmorName))")
            if selectedArmorName == nil {
                print("⚠️ No armor selected")
            }
        }
    }
    
    private var backgroundColor: Color {
        #if os(iOS)
        return Color(.white)
        #else
        return Color(nsColor: .white)
        #endif
    }
    
    private func logArmorArrayUpdate() {
        print("🛡️ [FormArmorSection] Armor array updated")
        print("🛡️ [FormArmorSection] New count: \(armor.count)")
        let armorDetails = armor.map { "[\($0.name) - DF:\($0.df) Weight:\($0.weight) Shield:\($0.isShield)]" }
        print("🛡️ [FormArmorSection] Items: \(armorDetails.joined(separator: ", "))")
    }
    
    private func logNewArmorCreation(_ newArmor: Armor) {
        print("🛡️ [FormArmorSection] Save action received")
        print("🛡️ [FormArmorSection] New armor: \(newArmor.name)")
        print("🛡️ [FormArmorSection] Properties - DF: \(newArmor.df), Weight: \(newArmor.weight), Shield: \(newArmor.isShield)")
        print("🛡️ [FormArmorSection] Status - Equipped: \(newArmor.isEquipped), Stashed: \(newArmor.isStashed)")
        print("🛡️ [FormArmorSection] Magic - Magical: \(newArmor.isMagical), Cursed: \(newArmor.isCursed), Bonus: \(newArmor.bonus)")
    }
    
    private func logArmorEdit(original: Armor, updated: Armor) {
        print("🛡️ [FormArmorSection] Editing existing armor")
        print("🛡️ [FormArmorSection] Original: \(original.name) -> New: \(updated.name)")
        print("🛡️ [FormArmorSection] DF change: \(original.df) -> \(updated.df)")
        print("🛡️ [FormArmorSection] Weight change: \(original.weight) -> \(updated.weight)")
        print("🛡️ [FormArmorSection] Shield status: \(original.isShield) -> \(updated.isShield)")
        print("🛡️ [FormArmorSection] Equipment status: Equipped(\(original.isEquipped)->\(updated.isEquipped)) Stashed(\(original.isStashed)->\(updated.isStashed))")
        print("🛡️ [FormArmorSection] Magic changes: Magical(\(original.isMagical)->\(updated.isMagical)) Cursed(\(original.isCursed)->\(updated.isCursed)) Bonus(\(original.bonus)->\(updated.bonus))")
    }
    
    private func createArmorFromSelection(_ armorName: String) {
        print("🎯 Creating armor from selection: \(armorName)")
        
        if armorName == "custom" {
            // Handle custom armor creation
            editingNewArmor = Armor(
                id: UUID(),
                name: "",
                df: 0,
                weight: 0,
                special: "",
                quantity: 1,
                isEquipped: false,
                isStashed: false,
                isMagical: false,
                isCursed: false,
                bonus: 0,
                isShield: false
            )
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
        VStack(spacing: 0) {
            // Armor list
            if !armor.isEmpty {
                VStack(spacing: 12) {
                    ForEach(armor) { armorItem in
                        Group {
                            if editingArmorId == armorItem.id {
                                ArmorEditRow(armor: armorItem) { updatedArmor in
                                    logArmorEdit(original: armorItem, updated: updatedArmor)
                                    if let index = armor.firstIndex(where: { $0.id == armorItem.id }) {
                                        withAnimation {
                                            armor[index] = updatedArmor
                                            editingArmorId = nil
                                            print("🛡️ [FormArmorSection] Updated armor at index \(index)")
                                        }
                                    }
                                } onCancel: {
                                    print("🛡️ [FormArmorSection] Edit cancelled for \(armorItem.name)")
                                    withAnimation {
                                        editingArmorId = nil
                                    }
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
                        .padding(.bottom, 4)
                    }
                }
            } else if !isAddingNew && editingNewArmor == nil {
                VStack(spacing: 8) {
                    IconFrame(icon: Ph.prohibit.bold, color: .gray)
                    Text("No Armor")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
                .padding(.bottom, 8)
            }
            
            if let newArmor = editingNewArmor {
                ArmorEditRow(armor: newArmor) { updatedArmor in
                    logNewArmorCreation(updatedArmor)
                    withAnimation {
                        armor.append(updatedArmor)
                        editingNewArmor = nil
                    }
                } onCancel: {
                    withAnimation {
                        editingNewArmor = nil
                    }
                }
            }
            
            if isAddingNew {
                VStack(spacing: 8) {
                    Menu {
                        ForEach(ArmorData.armors, id: \.name) { armorData in
                            Button(armorData.name) {
                                armor.append(Armor(
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
                                ))
                                isAddingNew = false
                            }
                        }
                        
                        Divider()
                        
                        Button("Custom Armor") {
                            editingNewArmor = Armor(
                                id: UUID(),
                                name: "",
                                df: 0,
                                weight: 0,
                                special: "",
                                quantity: 1,
                                isEquipped: false,
                                isStashed: false,
                                isMagical: false,
                                isCursed: false,
                                bonus: 0,
                                isShield: false
                            )
                            isAddingNew = false
                        }
                    } label: {
                        HStack {
                            Text("Select Armor")
                                .padding(.horizontal, 8)
                        }
                        .frame(maxWidth: .infinity, minHeight: 32)
                    }
                    .menuStyle(.borderlessButton)
                    .background(backgroundColor)
                    .cornerRadius(4)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .padding(.horizontal, 16)
                    
                    Button(action: {
                        isAddingNew = false
                    }) {
                        Label("Cancel", systemImage: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
                .padding(.vertical, 12)
            } else {
                Button(action: { isAddingNew = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text(armor.isEmpty ? "Add Your First Armor" : "Add Armor")
                    }
                    .foregroundColor(.blue)
                }
                .padding(.top, 16)
                .padding(.bottom, 8)
            }
            
            // Add armor button - only show when not adding new and not editing
            // if !isAddingNew && editingNewArmor == nil {
            //     Button {
            //         isAddingNew = true
            //     } label: {
            //         Label(armor.isEmpty ? "Add Your First Armor" : "Add Another Armor", systemImage: "plus.circle.fill")
            //             .foregroundColor(.accentColor)
            //     }
            //     .padding(.horizontal)
            // }
        }
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
                    Text(armor.name.isEmpty ? "-" : armor.name)
                        .font(.headline)
                }
                
                // Quantity Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Quantity")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text("\(armor.quantity)")
                    } icon: {
                        IconFrame(icon: Ph.stack.bold, color: .green)
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
                    HStack(spacing: 12) {
                        if armor.isEquipped {
                            Label {
                                Text("Equipped")
                            } icon: {
                                IconFrame(icon: Ph.bagSimple.bold, color: .green)
                            }
                        }
                        
                        if armor.isStashed {
                            Label {
                                Text("Stashed")
                            } icon: {
                                IconFrame(icon: Ph.warehouse.bold, color: .orange)
                            }
                        }
                        
                        if armor.isShield {
                            Label {
                                Text("Shield")
                            } icon: {
                                IconFrame(icon: Ph.shield.bold, color: .blue)
                            }
                        }
                    }
                }
                
                // Magic Properties Section
                if armor.isMagical || armor.isCursed || armor.bonus != 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Magic Properties")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack(spacing: 12) {
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
                            
                            if armor.bonus != 0 {
                                Label {
                                    Text("\(armor.bonus > 0 ? "+" : "")\(armor.bonus)")
                                } icon: {
                                    IconFrame(icon: armor.bonus > 0 ? Ph.plus.bold : Ph.minus.bold,
                                            color: armor.bonus > 0 ? .green : .red)
                                }
                            }
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
            .padding(.top, 4)
        }
        .groupCardStyle()
        .padding(.bottom, 4)
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
    @State private var isShield: Bool
    @State private var isBonus: Bool
    
    // String representations for numeric fields
    @State private var quantityString: String
    @State private var dfString: String
    @State private var weightString: String
    @State private var bonusString: String
    
    // Focus state for text fields
    @FocusState private var focusedField: CharacterFormView.Field?
    
    // Button state tracking
    @State private var isProcessingAction = false
    
    init(armor: Armor, onSave: @escaping (Armor) -> Void, onCancel: @escaping () -> Void) {
        self.armor = armor
        self.onSave = onSave
        self.onCancel = onCancel
        
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
        _isShield = State(initialValue: armor.isShield)
        _isBonus = State(initialValue: armor.bonus >= 0)
        
        _quantityString = State(initialValue: "\(armor.quantity)")
        _dfString = State(initialValue: "\(armor.df)")
        _weightString = State(initialValue: "\(armor.weight)")
        _bonusString = State(initialValue: "\(abs(armor.bonus))")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Name Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Armor Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Armor Name", text: $name)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Quantity Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Quantity")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    HStack {
                        NumericTextField(text: $quantityString, field: .armorQuantity, minValue: 1, maxValue: 99, focusedField: $focusedField)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 60)
                            .onChange(of: quantityString) { newValue in
                                if let value = Int(newValue) {
                                    quantity = max(1, min(99, value))
                                }
                                quantityString = "\(quantity)"
                            }
                        Stepper("", value: $quantity, in: 1...99)
                            .labelsHidden()
                            .onChange(of: quantity) { newValue in
                                quantityString = "\(newValue)"
                            }
                    }
                } icon: {
                    IconFrame(icon: Ph.stack.bold, color: .green)
                }
            }
            
            // Defense Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Defense")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    HStack {
                        NumericTextField(text: $dfString, field: .armorDefense, minValue: 0, maxValue: 99, focusedField: $focusedField)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 60)
                            .onChange(of: dfString) { newValue in
                                if let value = Int(newValue) {
                                    df = max(0, min(99, value))
                                }
                                dfString = "\(df)"
                            }
                        Stepper("", value: $df, in: 0...99)
                            .labelsHidden()
                            .onChange(of: df) { newValue in
                                dfString = "\(newValue)"
                            }
                    }
                } icon: {
                    IconFrame(icon: Ph.shield.bold, color: .blue)
                }
            }
            
            // Weight Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Weight")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    HStack {
                        NumericTextField(text: $weightString, field: .armorDefense, minValue: 0, maxValue: 99, focusedField: $focusedField)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 60)
                            .onChange(of: weightString) { newValue in
                                if let value = Int(newValue) {
                                    weight = max(0, min(99, value))
                                }
                                weightString = "\(weight)"
                            }
                        Stepper("", value: $weight, in: 0...99)
                            .labelsHidden()
                            .onChange(of: weight) { newValue in
                                weightString = "\(newValue)"
                            }
                    }
                } icon: {
                    IconFrame(icon: Ph.scales.bold, color: .blue)
                }
            }
            
            // Special Properties Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Special Properties")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Special Properties", text: $special)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Status Section
            Section {
                // Equipped Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.bagSimple.bold, color: isEquipped ? .green : .gray)
                    Toggle(isEquipped ? "Equipped" : "Unequipped", isOn: $isEquipped)
                }
                .onChange(of: isEquipped) { newValue in
                    if newValue {
                        isStashed = false
                    }
                }
                
                // Stashed Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.package.bold, color: isStashed ? .brown : .gray)
                    Toggle(isStashed ? "Stashed" : "", isOn: $isStashed)
                }
                .onChange(of: isStashed) { newValue in
                    if newValue {
                        isEquipped = false
                    }
                }
                
                // Shield Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.shield.bold, color: isShield ? .blue : .gray)
                    Toggle(isShield ? "Shield" : "Armor", isOn: $isShield)
                }
            }
            
            // Magic Properties Section
            Section {
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
                
                // Bonus/Penalty Toggle and Value
                HStack {
                    IconFrame(icon: isBonus ? Ph.plus.bold : Ph.minus.bold,
                            color: isBonus ? .green : .red)
                    Toggle(isBonus ? "Bonus" : "Penalty", isOn: $isBonus)
                        .onChange(of: isBonus) { newValue in
                            bonus = newValue ? abs(bonus) : -abs(bonus)
                        }
                }
                
                // Value Control
                HStack {
                    NumericTextField(text: $bonusString, field: .armorBonus, minValue: 0, maxValue: 99, focusedField: $focusedField)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .onChange(of: bonusString) { newValue in
                            if let value = Int(newValue) {
                                let absValue = abs(value)
                                bonus = isBonus ? absValue : -absValue
                            }
                            bonusString = "\(abs(bonus))"
                        }
                    Spacer()
                    Stepper("", value: Binding(
                        get: { abs(bonus) },
                        set: { newValue in
                            let value = max(0, min(99, newValue))
                            bonus = isBonus ? value : -value
                            bonusString = "\(value)"
                        }
                    ), in: 0...99)
                    .labelsHidden()
                }
            }
            
            Spacer()
            
            // Save/Cancel Buttons
            Divider()
            
            HStack(spacing: 20) {
                Button {
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
                
                Spacer()
                
                Button {
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
            }
            .padding(.top, 4)
        }
        .groupCardStyle()
        .padding(.bottom, 4)
    }
}

private extension View {
    func groupCardStyle() -> some View {
        self
            .padding()
            .background(.background)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)  // Subtle shadow for depth
    }
}
