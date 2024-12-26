import SwiftUI
import PhosphorSwift
#if os(iOS)
import UIKit
#else
import AppKit
#endif

struct WeaponEditRow: View {
    @Environment(\.dismiss) private var dismiss
    
    let onSave: (Weapon) -> Void
    let onCancel: () -> Void
    
    let weapon: Weapon
    
    // Basic Properties
    @State private var name: String
    @State private var damage: String
    @State private var weight: String
    @State private var range: String
    @State private var rateOfFire: String
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
    
    // Focus state for text fields
    @FocusState private var focusedField: CharacterFormView.Field?
    
    // Button state tracking
    @State private var isProcessingAction = false
    
    // Initialize with a weapon
    init(weapon: Weapon, onSave: @escaping (Weapon) -> Void, onCancel: @escaping () -> Void) {
        self.weapon = weapon
        
        self.onSave = onSave
        self.onCancel = onCancel
        
        // Initialize state properties
        _name = State(initialValue: weapon.name)
        _damage = State(initialValue: weapon.damage)
        _weight = State(initialValue: weapon.weight)
        _range = State(initialValue: weapon.range)
        _rateOfFire = State(initialValue: weapon.rateOfFire)
        _special = State(initialValue: weapon.special)
        _isEquipped = State(initialValue: weapon.isEquipped)
        _isStashed = State(initialValue: weapon.isStashed)
        _isMagical = State(initialValue: weapon.isMagical)
        _isCursed = State(initialValue: weapon.isCursed)
        _bonus = State(initialValue: weapon.bonus)
        _quantity = State(initialValue: weapon.quantity)
        _isBonus = State(initialValue: weapon.bonus >= 0)
        _bonusString = State(initialValue: "\(abs(weapon.bonus))")
        _quantityString = State(initialValue: "\(weapon.quantity)")
    }
    
    private func getWeightDisplayText(_ weight: String) -> String {
        switch weight {
        case "No size": return "No size (100/slot)"
        case "Minor": return "Minor (2/slot)"
        case "Regular": return "Regular (1 slot)"
        case "Heavy": return "Heavy (2 slots)"
        default: return weight
        }
    }
    
    private func validateAndUpdateQuantity() {
        if let newValue = Int(quantityString) {
            quantity = max(1, newValue)  // Just ensure it's at least 1
        }
        // Always update string to match actual quantity
        quantityString = "\(quantity)"
    }
    
    private func validateQuantityInput(_ input: String) {
        // Only ensure it's a valid number and at least 1
        if let newValue = Int(input) {
            if newValue < 1 {
                quantityString = "1"
                quantity = 1
            } else {
                quantity = newValue  // Update the actual quantity value
            }
        } else if !input.isEmpty {
            // If not a valid number and not empty, revert to previous value
            quantityString = "\(quantity)"
        }
    }
    
    private func validateBonusInput(_ input: String) {
        if let newValue = Int(input) {
            // Only allow positive numbers
            let absValue = max(0, abs(newValue))
            bonus = isBonus ? absValue : -absValue
            bonusString = "\(absValue)"
        } else if !input.isEmpty {
            // If not a valid number and not empty, revert to previous value
            bonusString = "\(abs(bonus))"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Name Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Weapon Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    TextField("Weapon Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } icon: {
                    IconFrame(icon: Ph.sword.bold, color: .purple)
                }
            }
            
            // Quantity Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Quantity")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    HStack {
                        NumericTextField(text: $quantityString, field: .weaponQuantity, minValue: 1, maxValue: 99, focusedField: $focusedField)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 60)
                            .focused($focusedField, equals: .weaponQuantity)
                            .onChange(of: focusedField) { newValue in
                                print("🔥 FOCUS CHANGED - current quantity: \(quantity), string: '\(quantityString)'")
                                if newValue != .weaponQuantity && quantityString.isEmpty {  // Field lost focus and is empty
                                    print("🔥 SETTING EMPTY TO 1")
                                    quantityString = "1"
                                    quantity = 1
                                }
                            }
                            .onChange(of: quantityString) { newValue in
                                print("🔥 STRING CHANGED TO: '\(newValue)'")
                                if let value = Int(newValue) {
                                    print("🔥 PARSED INT: \(value)")
                                    quantity = max(1, min(99, value))
                                    print("🔥 SET QUANTITY TO: \(quantity)")
                                }
                            }
                        Stepper("", value: Binding(
                            get: { quantity },
                            set: { newValue in
                                print("🔥 STEPPER SETTING TO: \(newValue)")
                                quantity = newValue
                                quantityString = "\(newValue)"
                            }
                        ), in: 1...99)
                            .labelsHidden()
                    }
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
                    Picker("", selection: $weight) {
                        Text("No size (100/slot)").tag("No size")
                        Text("Minor (2/slot)").tag("Minor")
                        Text("Regular (1 slot)").tag("Regular")
                        Text("Heavy (2 slots)").tag("Heavy")
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                } icon: {
                    IconFrame(icon: Ph.scales.bold, color: .blue)
                }
            }
            
            // Damage Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Damage")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    TextField("Damage (e.g. 1d6+1)", text: $damage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } icon: {
                    IconFrame(icon: Ph.target.bold, color: .red)
                }
            }
            
            // Rate of Fire Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Rate of Fire")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    TextField("Rate of Fire", text: $rateOfFire)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } icon: {
                    IconFrame(icon: Ph.timer.bold, color: .orange)
                }
            }
            
            // Range Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Range")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    TextField("Range", text: $range)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } icon: {
                    IconFrame(icon: Ph.arrowsOutSimple.bold, color: .green)
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
            
            // Status Section
            Section {
                // Equipped Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.bagSimple.bold, color: isEquipped ? .green : .gray)
                    #if os(macOS)
                    Toggle("", isOn: Binding(
                        get: { isEquipped },
                        set: { newValue in
                            isEquipped = newValue
                            if newValue {
                                isStashed = false
                            }
                        }
                    ))
                    .toggleStyle(.switch)
                    .labelsHidden()
                    Text(isEquipped ? "Equipped" : "Unequipped")
                    #else
                    Toggle(isEquipped ? "Equipped" : "Unequipped", isOn: Binding(
                        get: { isEquipped },
                        set: { newValue in
                            isEquipped = newValue
                            if newValue {
                                isStashed = false
                            }
                        }
                    ))
                    #endif
                }
                
                // Stashed Toggle with Icon
                HStack {
                    IconFrame(icon: isStashed ? Ph.warehouse.bold : Ph.user.bold,
                            color: isStashed ? .orange : .gray)
                    #if os(macOS)
                    Toggle("", isOn: Binding(
                        get: { isStashed },
                        set: { newValue in
                            isStashed = newValue
                            if newValue {
                                isEquipped = false
                            }
                        }
                    ))
                    .toggleStyle(.switch)
                    .labelsHidden()
                    Text(isStashed ? "Stashed" : "On Person")
                    #else
                    Toggle(isStashed ? "Stashed" : "On Person", isOn: Binding(
                        get: { isStashed },
                        set: { newValue in
                            isStashed = newValue
                            if newValue {
                                isEquipped = false
                            }
                        }
                    ))
                    #endif
                }
            }
            
            // Properties Section
            Section {
                // Magical Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.sparkle.bold, color: isMagical ? .purple : .gray)
                    #if os(macOS)
                    Toggle("", isOn: $isMagical)
                        .toggleStyle(.switch)
                        .labelsHidden()
                    Text(isMagical ? "Magical" : "Not Magical")
                    #else
                    Toggle(isMagical ? "Magical" : "Not Magical", isOn: $isMagical)
                    #endif
                }
                
                // Cursed Toggle with Icon
                HStack {
                    IconFrame(icon: Ph.skull.bold, color: isCursed ? .red : .gray)
                    #if os(macOS)
                    Toggle("", isOn: $isCursed)
                        .toggleStyle(.switch)
                        .labelsHidden()
                    Text(isCursed ? "Cursed" : "Not Cursed")
                    #else
                    Toggle(isCursed ? "Cursed" : "Not Cursed", isOn: $isCursed)
                    #endif
                }
            }
            
            // Bonus/Penalty Section
            Section {
                // Toggle between Penalty/Bonus (left = penalty/red, right = bonus/green)
                HStack {
                    IconFrame(icon: isBonus ? Ph.plus.bold : Ph.minus.bold,
                            color: isBonus ? .green : .red)
                    #if os(macOS)
                    Toggle("", isOn: $isBonus)
                        .toggleStyle(.switch)
                        .labelsHidden()
                    Text(isBonus ? "Bonus" : "Penalty")
                        .foregroundColor(isBonus ? .green : .red)
                    #else
                    Toggle(isOn: $isBonus) {
                        Text(isBonus ? "Bonus" : "Penalty")
                            .foregroundColor(isBonus ? .green : .red)
                    }
                    #endif
                }
                .onChange(of: isBonus) { newValue in
                    bonus = newValue ? abs(bonus) : -abs(bonus)
                }
                
                // Value Control
                HStack {
                    IconFrame(icon: isBonus ? Ph.plus.bold : Ph.minus.bold,
                            color: isBonus ? .green : .red)
                    NumericTextField(text: $bonusString, field: .weaponBonus, minValue: 0, maxValue: 99, focusedField: $focusedField)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .focused($focusedField, equals: .weaponBonus)
                        .onChange(of: focusedField) { newValue in
                            if newValue != .weaponBonus && bonusString.isEmpty {  // Field lost focus and is empty
                                bonusString = "0"
                                bonus = isBonus ? 0 : 0
                            }
                        }
                        .onChange(of: bonusString) { newValue in
                            print("🔥 BONUS STRING CHANGED TO: '\(newValue)'")
                            if let value = Int(newValue) {
                                print("🔥 PARSED BONUS: \(value)")
                                bonus = isBonus ? value : -value
                                print("🔥 SET BONUS TO: \(bonus)")
                            }
                        }
                    Spacer()
                    Stepper("", value: Binding(
                        get: { abs(bonus) },
                        set: { newValue in
                            print("🔥 BONUS STEPPER SETTING TO: \(newValue)")
                            let value = max(0, min(99, newValue))  // Prevent negative values and cap at 99
                            bonus = isBonus ? value : -value
                            bonusString = "\(value)"
                        }
                    ), in: 0...99)  // Add range constraint
                    .labelsHidden()
                }
            }
            
            Spacer()
            
            // Save/Cancel Buttons
            Divider()
            
            HStack(spacing: 20) {
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
                
                Spacer()
                
                Button {
                    guard !isProcessingAction else { return }
                    isProcessingAction = true
                    print("🟢 Save action starting")
                    
                    let updatedWeapon = Weapon(
                        id: weapon.id,
                        name: name,
                        damage: damage,
                        weight: weight,
                        range: range,
                        rateOfFire: rateOfFire,
                        special: special,
                        isEquipped: isEquipped,
                        isStashed: isStashed,
                        isMagical: isMagical,
                        isCursed: isCursed,
                        bonus: bonus,
                        quantity: quantity
                    )
                    onSave(updatedWeapon)
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
            }
        }
    }
}

struct IconFrame<Icon: View>: View {
    let icon: Icon
    var color: Color = .blue
    
    var body: some View {
        icon
            .frame(width: 24, height: 24)
            .foregroundStyle(color)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(color.opacity(0.1))
            )
    }
}

struct WeaponRow: View {
    let weapon: Weapon
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    private var displayName: String {
        weapon.name.isEmpty ? "-" : weapon.name
    }
    
    private var displayDamage: String {
        weapon.damage.isEmpty ? "-" : weapon.damage
    }
    
    private var displayRange: String {
        weapon.range.isEmpty ? "-" : weapon.range
    }
    
    private var displayRateOfFire: String {
        weapon.rateOfFire.isEmpty ? "-" : weapon.rateOfFire
    }
    
    private var displayWeight: String {
        switch weapon.weight {
        case "": return "-"
        case "No size": return "No size (100/slot)"
        case "Minor": return "Minor (2/slot)"
        case "Regular": return "Regular (1 slot)"
        case "Heavy": return "Heavy (2 slots)"
        default: return weapon.weight
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                // Name Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Weapon Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text(displayName)
                    } icon: {
                        IconFrame(icon: Ph.sword.bold, color: .purple)
                    }
                }
                
                // Quantity Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Quantity")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text("\(weapon.quantity)")
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
                        Text(displayWeight)
                    } icon: {
                        IconFrame(icon: Ph.scales.bold, color: .blue)
                    }
                }
                
                // Damage Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Damage")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text(displayDamage)
                    } icon: {
                        IconFrame(icon: Ph.target.bold, color: .red)
                    }
                }
                
                // Rate of Fire Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Rate of Fire")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text(displayRateOfFire)
                    } icon: {
                        IconFrame(icon: Ph.clock.bold, color: .orange)
                    }
                }
                
                // Range Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Range")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text(displayRange)
                    } icon: {
                        IconFrame(icon: Ph.arrowsOutSimple.bold, color: .green)
                    }
                }
                
                // Special Properties Section
                if !weapon.special.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Special Properties")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Label {
                            Text(weapon.special)
                        } icon: {
                            IconFrame(icon: Ph.star.bold, color: .yellow)
                        }
                    }
                }
            }
            
            // Status Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Status")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack(spacing: 16) {
                    Label {
                        Text(weapon.isEquipped ? "Equipped" : "Unequipped")
                    } icon: {
                        IconFrame(icon: Ph.bagSimple.bold, color: weapon.isEquipped ? .green : .gray)
                    }
                    
                    Label {
                        Text(weapon.isStashed ? "Stashed" : "On Person")
                    } icon: {
                        IconFrame(icon: weapon.isStashed ? Ph.warehouse.bold : Ph.user.bold,
                                color: weapon.isStashed ? .orange : .gray)
                    }
                }
            }
            
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
    }
}

struct FormWeaponsSection: View {
    @Binding var weapons: [Weapon]
    @State private var isAddingNew = false
    @State private var editingWeapon: Weapon? = nil
    @State private var selectedWeaponName: String? = nil
    
    private var backgroundColor: Color {
        #if os(iOS)
        return Color(.white)
        #else
        return Color(nsColor: .white)
        #endif
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if !weapons.isEmpty {
                ForEach(weapons) { weapon in
                    if editingWeapon?.id == weapon.id {
                        WeaponEditRow(
                            weapon: weapon,
                            onSave: { updatedWeapon in
                                if let index = weapons.firstIndex(where: { $0.id == weapon.id }) {
                                    weapons[index] = updatedWeapon
                                }
                                editingWeapon = nil
                            },
                            onCancel: {
                                editingWeapon = nil
                            }
                        )
                        .padding()
                        .background(.background)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        .padding(.bottom, 16)
                    } else {
                        WeaponRow(weapon: weapon,
                            onEdit: {
                                editingWeapon = weapon
                            },
                            onDelete: {
                                weapons.removeAll(where: { $0.id == weapon.id })
                            }
                        )
                        .padding(.bottom, 16)
                    }
                }
            } else if !isAddingNew && editingWeapon == nil {
                VStack(spacing: 8) {
                    IconFrame(icon: Ph.prohibit.bold, color: .gray)
                    Text("No Weapons")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
                .padding(.bottom, 12)
            }
            
            if let weapon = editingWeapon, !weapons.contains(where: { $0.id == weapon.id }) {
                // This is a new custom weapon being edited
                WeaponEditRow(
                    weapon: weapon,
                    onSave: { newWeapon in
                        weapons.append(newWeapon)
                        editingWeapon = nil
                    },
                    onCancel: {
                        editingWeapon = nil
                    }
                )
                .padding()
                .background(.background)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                .padding(.bottom, 16)
            } else if isAddingNew {
                VStack(spacing: 8) {
                    Menu {
                        ForEach(WeaponData.weapons, id: \.["name"]) { weaponData in
                            Button(weaponData["name"] ?? "") {
                                weapons.append(Weapon.fromData(weaponData))
                                isAddingNew = false
                            }
                        }
                        
                        Divider()
                        
                        Button("Custom Weapon") {
                            var newWeapon = Weapon()
                            newWeapon.weight = "No size"  // Set default weight
                            editingWeapon = newWeapon
                            selectedWeaponName = "custom"
                            isAddingNew = false
                        }
                    } label: {
                        HStack {
                            Text("Select Weapon")
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
                .padding(.vertical, 12)  // Add equal padding to top and bottom
            } else {
                Button(action: { isAddingNew = true }) {
                    Label(weapons.isEmpty ? "Add Your First Weapon" : "Add Another Weapon", 
                          systemImage: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 12)
            }
        }
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
