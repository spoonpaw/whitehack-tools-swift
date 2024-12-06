import SwiftUI
import PhosphorSwift

struct WeaponRow: View {
    let weapon: Weapon
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    private func getWeightDisplayText(_ weight: String) -> String {
        switch weight {
        case "No size": return "No size (100/slot)"
        case "Minor": return "Minor (2/slot)"
        case "Regular": return "Regular (1 slot)"
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
                    Text("Weapon Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text(weapon.name)
                    } icon: {
                        IconFrame(icon: Ph.sword.bold, color: .purple)
                    }
                }
                
                // Damage Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Damage")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text(weapon.damage)
                    } icon: {
                        IconFrame(icon: Ph.target.bold, color: .red)
                    }
                }
                
                // Weight Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Weight")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text(getWeightDisplayText(weapon.weight))
                    } icon: {
                        IconFrame(icon: Ph.scales.bold, color: .blue)
                    }
                }
                
                // Rate of Fire Section
                if !weapon.rateOfFire.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Rate of Fire")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Label {
                            Text(weapon.rateOfFire)
                        } icon: {
                            IconFrame(icon: Ph.timer.bold, color: .orange)
                        }
                    }
                }
                
                // Range Section
                if !weapon.range.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Range")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Label {
                            Text(weapon.range)
                        } icon: {
                            IconFrame(icon: Ph.arrowsOutSimple.bold, color: .green)
                        }
                    }
                }
                
                // Special Section
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
                
                // Quantity Section
                if weapon.quantity > 1 {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Quantity")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Label {
                            Text("\(weapon.quantity)")
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
                
                // Magical Properties Section
                if weapon.isMagical || weapon.isCursed {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Magical Properties")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack(spacing: 16) {
                            if weapon.isMagical {
                                Label {
                                    Text("Magical")
                                } icon: {
                                    IconFrame(icon: Ph.sparkle.bold, color: .purple)
                                }
                            }
                            if weapon.isCursed {
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
                if weapon.bonus != 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(weapon.bonus > 0 ? "Bonus" : "Penalty")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Label {
                            Text("\(abs(weapon.bonus))")
                        } icon: {
                            IconFrame(icon: weapon.bonus > 0 ? Ph.plus.bold : Ph.minus.bold,
                                    color: weapon.bonus > 0 ? .green : .red)
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
        #if os(iOS)
        .background(Color(uiColor: .secondarySystemBackground))
        #else
        .background(Color(nsColor: .controlBackgroundColor))
        #endif
        .cornerRadius(10)
    }
}

struct WeaponEditRow: View {
    @Environment(\.dismiss) private var dismiss
    
    let onSave: (Weapon) -> Void
    let onCancel: () -> Void
    
    let weapon: Weapon  // Add this back
    
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
    
    // Button state tracking
    @State private var isProcessingAction = false
    
    // Initialize with a weapon
    init(weapon: Weapon, onSave: @escaping (Weapon) -> Void, onCancel: @escaping () -> Void) {
        self.weapon = weapon  // Initialize the weapon property
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
    
    @State private var quantityString: String = "1"
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimum = 0
        return formatter
    }()
    
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
            
            // Quantity Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Quantity")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    Label {
                        TextField("", text: $quantityString)
                            .textFieldStyle(.roundedBorder)
                            #if os(iOS)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            #endif
                            .onChange(of: quantityString) { newValue in
                                validateQuantityInput(newValue)
                            }
                            .onSubmit {
                                validateAndUpdateQuantity()
                            }
                            .onChange(of: quantity) { newValue in
                                quantityString = "\(newValue)"
                            }
                    } icon: {
                        IconFrame(icon: Ph.stack.bold, color: .gray)
                    }
                    Spacer()
                    Stepper("", value: $quantity, in: 1...Int.max)  // Allow any positive number
                        .labelsHidden()
                }
            }

            // Status Section
            Section {
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
            } header: {
                Text("Status")
            }
            
            // Magical Properties Section
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
            } header: {
                Text("Magical Properties")
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
                        .textFieldStyle(.roundedBorder)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.leading)
                        #endif
                        .frame(width: 60)
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
            HStack(spacing: 20) {  // Added explicit spacing
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
                .buttonStyle(.borderless)  // Explicit button style
                
                Spacer()
                
                Button {
                    guard !isProcessingAction else { return }
                    isProcessingAction = true
                    print("🟢 Save action starting")
                    let updatedWeapon = Weapon(
                        id: UUID(),
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
                .buttonStyle(.borderless)  // Explicit button style
                .disabled(name.isEmpty || damage.isEmpty)
            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
        .padding()
        #if os(iOS)
        .background(Color(uiColor: .secondarySystemBackground))
        #else
        .background(Color(nsColor: .controlBackgroundColor))
        #endif
        .onAppear {
            // Reset state to match the input weapon
            name = weapon.name
            damage = weapon.damage
            weight = weapon.weight
            range = weapon.range
            rateOfFire = weapon.rateOfFire
            special = weapon.special
            isEquipped = weapon.isEquipped
            isStashed = weapon.isStashed
            isMagical = weapon.isMagical
            isCursed = weapon.isCursed
            bonus = weapon.bonus
            quantity = weapon.quantity
            quantityString = "\(weapon.quantity)"  // Initialize quantityString
            isBonus = weapon.bonus >= 0
            bonusString = "\(abs(weapon.bonus))"
            isProcessingAction = false
            
            print("🎭 WeaponEditRow appeared")
            print("   Name: \(name)")
            print("   Damage: \(damage)")
            print("   Weight: \(weight)")
            print("   Rate of Fire: \(rateOfFire)")
            print("   Range: \(range)")
            print("   Special: \(special)")
            print("   Quantity: \(quantity)")  // Add quantity logging
        }
    }
}

struct CustomWeaponForm: View {
    @Binding var weapons: [Weapon]
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var damage = ""
    @State private var weight = ""
    @State private var rateOfFire = ""
    @State private var special = ""
    @State private var range = ""
    @State private var editingWeapon: Weapon?
    @State private var isMagical = false
    @State private var isCursed = false
    @State private var bonus = 0
    @State private var isEquipped = false
    @State private var isStashed = false
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimum = 0
        return formatter
    }()
    
    private func getWeightDisplayText(_ weight: String) -> String {
        switch weight {
        case "No size": return "No size (100/slot)"
        case "Minor": return "Minor (2/slot)"
        case "Regular": return "Regular (1 slot)"
        case "Heavy": return "Heavy (2 slots)"
        default: return weight
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    ForEach(weapons) { weapon in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(weapon.name)
                                    .font(.headline)
                                Text("Damage: \(weapon.damage)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            HStack(spacing: 12) {
                                Button(action: {
                                    print("📝 Editing weapon: \(weapon.name)")
                                    editingWeapon = weapon
                                    name = weapon.name
                                    damage = weapon.damage
                                    weight = weapon.weight
                                    rateOfFire = weapon.rateOfFire
                                    special = weapon.special
                                    range = weapon.range
                                    isMagical = weapon.isMagical
                                    isCursed = weapon.isCursed
                                    bonus = weapon.bonus
                                    isEquipped = weapon.isEquipped
                                    isStashed = weapon.isStashed
                                }) {
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundColor(.blue)
                                }
                                Button(action: {
                                    print("🚮 Deleting weapon: \(weapon.name)")
                                    if let index = weapons.firstIndex(where: { $0.id == weapon.id }) {
                                        print("🔄 Removing weapon at index: \(index)")
                                        weapons.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "trash.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                } header: {
                    if !weapons.isEmpty {
                        Text("Existing Weapons")
                    }
                }
                
                Section {
                    HStack {
                        IconFrame(icon: Ph.textAa.bold, color: Color.blue)
                        Text("Name")
                            .foregroundStyle(Color.secondary)
                            .font(.caption)
                        TextField("Weapon Name", text: $name)
                    }
                }
                
                Section {
                    HStack {
                        IconFrame(icon: Ph.target.bold, color: Color.red)
                        Text("Damage")
                            .foregroundStyle(Color.secondary)
                            .font(.caption)
                        TextField("e.g., 1d6+1", text: $damage)
                    }
                    
                    HStack {
                        IconFrame(icon: Ph.scales.bold, color: Color.blue)
                        Text("Weight")
                            .foregroundStyle(Color.secondary)
                            .font(.caption)
                        TextField("N, M, R, or H", text: $weight)
                    }
                    
                    HStack {
                        IconFrame(icon: Ph.timer.bold, color: Color.green)
                        Text("Rate of Fire")
                            .foregroundStyle(Color.secondary)
                            .font(.caption)
                        TextField("e.g., 1, 1/2, or -", text: $rateOfFire)
                    }
                    
                    HStack {
                        IconFrame(icon: Ph.arrowsOutSimple.bold, color: Color.purple)
                        Text("Range")
                            .foregroundStyle(Color.secondary)
                            .font(.caption)
                        TextField("e.g., Close, Near, Far", text: $range)
                    }
                } header: {
                    Text("Combat Stats")
                }
                
                Section {
                    // Magical Toggle
                    Label {
                        Toggle("Magical", isOn: $isMagical)
                    } icon: {
                        IconFrame(icon: Ph.sparkle.bold, color: .purple)
                    }
                    
                    // Cursed Toggle
                    Label {
                        Toggle("Cursed", isOn: $isCursed)
                    } icon: {
                        IconFrame(icon: Ph.skull.bold, color: .red)
                    }
                    
                    // Bonus/Penalty
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Modifier")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack {
                            Toggle(isOn: .constant(false)) {
                                Text("Penalty")
                            }
                            .onChange(of: isMagical) { newValue in
                                // bonus = newValue ? -abs(bonus) : abs(bonus)
                            }
                        }
                        HStack {
                            Label {
                                Text("\(abs(bonus))")
                            } icon: {
                                IconFrame(icon: Ph.minus.bold, color: .red)
                            }
                            Spacer()
                            Stepper("", value: .constant(0))
                            .labelsHidden()
                        }
                    }
                } header: {
                    Text("Magical Properties")
                }
                
                Section {
                    HStack {
                        IconFrame(icon: Ph.bagSimple.bold, color: Color.green)
                        Text("Status")
                            .foregroundStyle(Color.secondary)
                            .font(.caption)
                        Toggle(isEquipped ? "Equipped" : "Unequipped", isOn: .constant(false))
                    }
                    
                    HStack {
                        IconFrame(icon: isStashed ? Ph.warehouse.bold : Ph.user.bold, 
                                color: isStashed ? Color.orange : Color.gray)
                        Text("Location")
                            .foregroundStyle(Color.secondary)
                            .font(.caption)
                        Toggle(isStashed ? "Stashed" : "On Person", isOn: .constant(false))
                    }
                } header: {
                    Text("Status")
                }
                
                Section {
                    HStack {
                        IconFrame(icon: Ph.star.bold, color: Color.purple)
                        Text("Special")
                            .foregroundStyle(Color.secondary)
                            .font(.caption)
                        TextField("Special Properties", text: $special)
                    }
                } header: {
                    Text("Special")
                }
            }
            .navigationTitle(editingWeapon == nil ? "Add Weapon" : "Edit Weapon")
            #if os(iOS)
            .navigationBarItems(
                leading: Button("Cancel") {
                    print("❌ Cancel button tapped")
                    isPresented = false
                },
                trailing: Button(editingWeapon == nil ? "Save" : "Update") {
                    print("💾 Save button tapped")
                    if let editingWeapon = editingWeapon {
                        let updatedWeapon = Weapon(
                            id: editingWeapon.id,
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
                            bonus: bonus
                        )
                        if let index = weapons.firstIndex(where: { $0.id == editingWeapon.id }) {
                            print("🔄 Updating weapon at index: \(index)")
                            weapons[index] = updatedWeapon
                        }
                    } else {
                        let newWeapon = Weapon(
                            name: name,
                            damage: damage,
                            weight: weight,
                            range: range,
                            rateOfFire: rateOfFire,
                            special: special,
                            isEquipped: false,
                            isStashed: false,
                            isMagical: isMagical,
                            isCursed: isCursed,
                            bonus: bonus
                        )
                        print("🎯 Created new weapon: \(newWeapon.name)")
                        weapons.append(newWeapon)
                    }
                    isPresented = false
                }
                .disabled(name.isEmpty)
            )
            #else
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        print("❌ Cancel button tapped")
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(editingWeapon == nil ? "Save" : "Update") {
                        print("💾 Save button tapped")
                        if let editingWeapon = editingWeapon {
                            let updatedWeapon = Weapon(
                                id: editingWeapon.id,
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
                                bonus: bonus
                            )
                            if let index = weapons.firstIndex(where: { $0.id == editingWeapon.id }) {
                                print("🔄 Updating weapon at index: \(index)")
                                weapons[index] = updatedWeapon
                            }
                        } else {
                            let newWeapon = Weapon(
                                name: name,
                                damage: damage,
                                weight: weight,
                                range: range,
                                rateOfFire: rateOfFire,
                                special: special,
                                isEquipped: false,
                                isStashed: false,
                                isMagical: isMagical,
                                isCursed: isCursed,
                                bonus: bonus
                            )
                            print("🎯 Created new weapon: \(newWeapon.name)")
                            weapons.append(newWeapon)
                        }
                        isPresented = false
                    }
                    .disabled(name.isEmpty)
                }
            }
            #endif
        }
    }
}

struct WeaponPickerView: View {
    @Binding var isPresented: Bool
    @Binding var isAddingNew: Bool
    let showCustomWeapon: () -> Void
    @Binding var weapons: [Weapon]
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: {
                        print("🎨 Creating custom weapon")
                        isPresented = false
                        showCustomWeapon()
                    }) {
                        Label {
                            VStack(alignment: .leading) {
                                Text("Create Custom Weapon")
                                    .font(.headline)
                                Text("Define your own weapon stats")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        } icon: {
                            Image(systemName: "pencil.and.list.clipboard")
                                .foregroundStyle(Color.blue)
                        }
                    }
                }
                
                Section {
                    ForEach(WeaponData.weapons, id: \.["name"]) { weaponData in
                        Button(action: {
                            print("📦 Adding weapon: \(weaponData["name"] ?? "")")
                            weapons.append(Weapon.fromData(weaponData))
                            isPresented = false
                            isAddingNew = false
                        }) {
                            WeaponDataRow(weaponData: weaponData)
                        }
                    }
                } header: {
                    Text("Standard Weapons")
                }
            }
            .navigationTitle("Add Weapon")
            #if os(iOS)
            .navigationBarItems(
                leading: Button("Cancel") {
                    print("❌ Cancel button tapped")
                    isPresented = false
                    isAddingNew = false
                }
            )
            #else
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        print("❌ Cancel button tapped")
                        isPresented = false
                        isAddingNew = false
                    }
                }
            }
            #endif
        }
    }
}

struct WeaponDataRow: View {
    let weaponData: [String: String]
    
    private func getWeightDisplayText(_ weight: String) -> String {
        switch weight {
        case "No size": return "No size (100/slot)"
        case "Minor": return "Minor (2/slot)"
        case "Regular": return "Regular (1 slot)"
        case "Heavy": return "Heavy (2 slots)"
        default: return weight
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Weapon Name
            Text(weaponData["name"] ?? "")
                .font(.headline)
            
            // Combat Stats
            VStack(alignment: .leading, spacing: 4) {
                Text("Combat Statistics")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 16) {
                    // Damage
                    Label {
                        Text("Damage: \(weaponData["damage"] ?? "")")
                    } icon: {
                        IconFrame(icon: Ph.target.bold, color: Color.red)
                    }
                    
                    // Weight
                    Label {
                        Text("Weight: \(getWeightDisplayText(weaponData["weight"] ?? ""))")
                    } icon: {
                        IconFrame(icon: Ph.scales.bold, color: Color.blue)
                    }
                    
                    // Rate of Fire
                    if weaponData["rateOfFire"] != "-" {
                        Label {
                            Text("Rate of Fire: \(weaponData["rateOfFire"] ?? "")")
                        } icon: {
                            IconFrame(icon: Ph.timer.bold, color: Color.green)
                        }
                    }
                    
                    // Range
                    Label {
                        Text("Range: \(weaponData["range"] ?? "")")
                    } icon: {
                        IconFrame(icon: Ph.arrowsOutSimple.bold, color: Color.purple)
                    }
                }
                .font(.caption)
            }
            
            // Special Properties
            if let special = weaponData["special"], !special.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Special Properties")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Label {
                        Text(special)
                    } icon: {
                        IconFrame(icon: Ph.star.bold, color: Color.purple)
                    }
                    .font(.caption)
                }
            }
        }
        .padding(.vertical, 8)
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

struct FormWeaponsSection: View {
    @Binding var weapons: [Weapon]
    @State private var editingWeaponId: UUID?
    @State private var isAddingNew = false {
        didSet {
            print("🔄 isAddingNew changed: \(oldValue) -> \(isAddingNew)")
            if !isAddingNew {
                print("🧹 Cleaning up weapon states")
                selectedWeaponName = nil
                editingNewWeapon = nil
            }
        }
    }
    @State private var selectedWeaponName: String? {
        didSet {
            print("🎯 selectedWeaponName changed: \(String(describing: oldValue)) -> \(String(describing: selectedWeaponName))")
            if selectedWeaponName == nil {
                print("⚠️ No weapon selected")
                editingNewWeapon = nil
            }
        }
    }
    @State private var editingNewWeapon: Weapon? {
        didSet {
            print("⚔️ editingNewWeapon changed: \(String(describing: oldValue?.name)) -> \(String(describing: editingNewWeapon?.name))")
        }
    }
    
    private func createWeaponFromSelection(_ weaponName: String) {
        print("🎯 Creating weapon from selection: \(weaponName)")
        
        if weaponName == "custom" {
            // Handle custom weapon creation
            let weapon = Weapon(
                id: UUID(),
                name: "",
                damage: "",
                weight: "",
                range: "",
                rateOfFire: "",
                special: "",
                isEquipped: false,
                isStashed: false,
                isMagical: false,
                isCursed: false,
                bonus: 0,
                quantity: 1
            )
            editingNewWeapon = weapon
        } else if let weaponData = WeaponData.weapons.first(where: { $0["name"] == weaponName }) {
            print("📦 Found weapon data: \(weaponData)")
            let weapon = Weapon(
                id: UUID(),
                name: weaponName,
                damage: weaponData["damage"] ?? "",
                weight: weaponData["weight"] ?? "",
                range: weaponData["range"] ?? "",
                rateOfFire: weaponData["rateOfFire"] ?? "",
                special: weaponData["special"] ?? "",
                isEquipped: false,
                isStashed: false,
                isMagical: false,
                isCursed: false,
                bonus: 0,
                quantity: 1
            )
            print("🛠️ Created weapon:")
            print("   Name: \(weapon.name)")
            print("   Damage: \(weapon.damage)")
            print("   Weight: \(weapon.weight)")
            print("   Rate of Fire: \(weapon.rateOfFire)")
            print("   Range: \(weapon.range)")
            print("   Special: \(weapon.special)")
            
            withAnimation {
                editingNewWeapon = weapon
            }
        }
    }
    
    var body: some View {
        Section {
            if weapons.isEmpty && !isAddingNew {
                VStack(spacing: 12) {
                    Image(systemName: "shield.slash")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    
                    Text("No Weapons")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        print("📱 Add First Weapon tapped")
                        withAnimation {
                            isAddingNew = true
                        }
                    }) {
                        Label("Add Your First Weapon", systemImage: "plus.circle.fill")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                ForEach(weapons) { weapon in
                    if editingWeaponId == weapon.id {
                        Group {
                            WeaponEditRow(weapon: weapon, onSave: { updatedWeapon in
                                print("💾 Saving updated weapon: \(updatedWeapon.name)")
                                if let index = weapons.firstIndex(where: { $0.id == weapon.id }) {
                                    print("🔄 Updating weapon at index: \(index)")
                                    weapons[index] = updatedWeapon
                                }
                                editingWeaponId = nil
                            }, onCancel: {
                                print("❌ Canceling weapon edit - reverting to original state")
                                editingWeaponId = nil
                            })
                            .id("\(weapon.id)-\(editingWeaponId != nil)")  // Force view recreation when editing starts/stops
                        }
                    } else {
                        WeaponRow(weapon: weapon, onEdit: {
                            editingWeaponId = weapon.id
                        }, onDelete: {
                            withAnimation {
                                if let index = weapons.firstIndex(where: { $0.id == weapon.id }) {
                                    print("🔄 Removing weapon at index: \(index)")
                                    weapons.remove(at: index)
                                }
                            }
                        })
                        .buttonStyle(PlainButtonStyle())  // Prevent button-like behavior
                    }
                }
                .onDelete(perform: nil)
                
                if isAddingNew {
                    if let weapon = editingNewWeapon {
                        WeaponEditRow(weapon: weapon, onSave: { newWeapon in
                            print("🟢 [FormWeaponsSection] Save action received for: \(newWeapon.name)")
                            weapons.append(newWeapon)
                            print("✅ [FormWeaponsSection] Weapon added to array")
                            withAnimation {
                                print("🔄 [FormWeaponsSection] Resetting form state after save")
                                isAddingNew = false
                            }
                        }, onCancel: {
                            print("🔴 [FormWeaponsSection] Cancel action received")
                            withAnimation {
                                print("🔄 [FormWeaponsSection] Resetting form state after cancel")
                                selectedWeaponName = nil
                                editingNewWeapon = nil
                                isAddingNew = false
                            }
                        })
                        .id("\(weapon.id)-\(editingWeaponId != nil)")  // Force view recreation when editing starts/stops
                    } else {
                        VStack(spacing: 12) {
                            Text("Select Weapon Type")
                                .font(.headline)
                            
                            Picker("Select Weapon", selection: $selectedWeaponName) {
                                Text("Select a Weapon").tag(nil as String?)
                                ForEach(WeaponData.weapons.map { $0["name"] ?? "" }.sorted(), id: \.self) { name in
                                    Text(name).tag(name as String?)
                                }
                                Text("Custom Weapon").tag("custom" as String?)
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .onChange(of: selectedWeaponName) { newValue in
                                if let weaponName = newValue {
                                    createWeaponFromSelection(weaponName)
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
                
                if !isAddingNew {
                    Button(action: {
                        print("🔄 Adding new weapon")
                        withAnimation {
                            isAddingNew = true
                        }
                    }) {
                        Label("Add Another Weapon", systemImage: "plus.circle.fill")
                    }
                }
            }
        } header: {
            HStack(spacing: 8) {
                Ph.sword.bold
                    .frame(width: 20, height: 20)
                Text("Weapons")
            }
            .font(.headline)
        }
    }
}
