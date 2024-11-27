import SwiftUI
import PhosphorSwift

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
    @State private var isAddingNew = false
    @State private var selectedWeaponName: String?
    @State private var editingNewWeapon: Weapon?
    
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
                        isAddingNew = true
                    }) {
                        Label("Add Your First Weapon", systemImage: "plus.circle.fill")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                if isAddingNew {
                    if let weapon = editingNewWeapon {
                        WeaponEditRow(weapon: weapon, onSave: { newWeapon in
                            weapons.append(newWeapon)
                            isAddingNew = false
                            editingNewWeapon = nil
                            selectedWeaponName = nil
                        }, onCancel: {
                            isAddingNew = false
                            editingNewWeapon = nil
                            selectedWeaponName = nil
                        })
                    } else {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Select Weapon")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            
                            Picker("", selection: $selectedWeaponName) {
                                Text("Select a Weapon").tag(String?.none)
                                ForEach(WeaponData.weapons, id: \.["name"]) { weapon in
                                    Text(weapon["name"] ?? "").tag(weapon["name"] as String?)
                                }
                                Text("Custom Weapon").tag("custom" as String?)
                            }
                            .onChange(of: selectedWeaponName) { newValue in
                                if newValue == "custom" {
                                    editingNewWeapon = Weapon()
                                } else if let weaponName = newValue,
                                          let weaponData = WeaponData.weapons.first(where: { $0["name"] == weaponName }) {
                                    editingNewWeapon = Weapon.fromData(weaponData)
                                }
                            }
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    isAddingNew = false
                                    editingNewWeapon = nil
                                    selectedWeaponName = nil
                                }) {
                                    Text("Cancel")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                ForEach(weapons) { weapon in
                    if editingWeaponId == weapon.id {
                        WeaponEditRow(weapon: weapon, onSave: { updatedWeapon in
                            if let index = weapons.firstIndex(where: { $0.id == weapon.id }) {
                                weapons[index] = updatedWeapon
                            }
                            editingWeaponId = nil
                        }, onCancel: {
                            editingWeaponId = nil
                        })
                    } else {
                        WeaponRow(weapon: weapon, onDelete: { weapon in
                            if let index = weapons.firstIndex(where: { $0.id == weapon.id }) {
                                weapons.remove(at: index)
                            }
                        }, onEdit: {
                            editingWeaponId = weapon.id
                        })
                    }
                }
                .onDelete(perform: nil)
                
                if !isAddingNew {
                    Button(action: {
                        isAddingNew = true
                    }) {
                        Label("Add Another Weapon", systemImage: "plus.circle.fill")
                    }
                }
            }
        } header: {
            if !weapons.isEmpty {
                Label("Weapons", systemImage: "shield.lefthalf.filled")
            }
        }
    }
}

struct WeaponRow: View {
    let weapon: Weapon
    let onDelete: (Weapon) -> Void
    let onEdit: () -> Void
    
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
            // Name Section
            Text("Weapon Name")
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                IconFrame(icon: Ph.textAa.bold, color: .blue)
                Text(weapon.name)
                    .font(.headline)
                Spacer()
            }
            
            Divider()
            
            // Combat Stats Section
            Text("Combat Statistics")
                .font(.subheadline)
                .foregroundColor(.secondary)
            VStack(alignment: .leading, spacing: 8) {
                // Stashed Status
                Label {
                    Text(weapon.isStashed ? "Stashed" : "On Person")
                } icon: {
                    if weapon.isStashed {
                        IconFrame(icon: Ph.warehouse.bold, color: .orange)
                    } else {
                        IconFrame(icon: Ph.user.bold, color: .gray)
                    }
                }
                .foregroundStyle(weapon.isStashed ? .orange : .gray)
                
                // Equipped Status (only if not stashed)
                if !weapon.isStashed {
                    Label {
                        Text(weapon.isEquipped ? "Currently Equipped" : "Unequipped")
                    } icon: {
                        IconFrame(icon: Ph.bagSimple.bold, color: weapon.isEquipped ? .green : .gray)
                    }
                    .foregroundStyle(weapon.isEquipped ? .green : .gray)
                }
                
                // Magical Status
                if weapon.isMagical {
                    Label {
                        Text("Magical")
                    } icon: {
                        IconFrame(icon: Ph.sparkle.bold, color: .purple)
                    }
                    .foregroundStyle(.purple)
                    
                    // Bonus (if has bonus)
                    if weapon.bonus != 0 {
                        Label {
                            HStack(spacing: 8) {
                                Text(weapon.bonus >= 0 ? "Bonus" : "Penalty")
                                Text("\(abs(weapon.bonus))")
                            }
                        } icon: {
                            IconFrame(icon: Ph.plusMinus.bold, color: .purple)
                        }
                        .foregroundStyle(.purple)
                    }
                }
                
                // Cursed Status
                if weapon.isCursed {
                    Label {
                        Text("Cursed")
                    } icon: {
                        IconFrame(icon: Ph.skull.bold, color: .red)
                    }
                    .foregroundStyle(.red)
                }
                
                // Damage
                Label {
                    Text("Damage: \(weapon.damage)")
                } icon: {
                    IconFrame(icon: Ph.target.bold, color: .red)
                }
                .foregroundStyle(.red)
                
                // Weight
                Label {
                    Text("Weight: \(getWeightDisplayText(weapon.weight))")
                } icon: {
                    IconFrame(icon: Ph.scales.bold, color: .blue)
                }
                .foregroundStyle(.blue)
                
                // Rate of Fire
                if weapon.rateOfFire != "-" {
                    Label {
                        Text("Rate of Fire: \(weapon.rateOfFire)")
                    } icon: {
                        IconFrame(icon: Ph.timer.bold, color: .green)
                    }
                    .foregroundStyle(.green)
                }
                
                // Range
                Label {
                    Text("Range: \(weapon.range)")
                } icon: {
                    IconFrame(icon: Ph.arrowsOutSimple.bold, color: .purple)
                }
                .foregroundStyle(.purple)
            }
            .font(.subheadline)
            
            // Special Properties Section
            if !weapon.special.isEmpty {
                Divider()
                
                Text("Special Properties")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    Text(weapon.special)
                } icon: {
                    IconFrame(icon: Ph.star.bold, color: .purple)
                }
            }
            
            Divider()
            
            // Actions Section
            HStack(spacing: 16) {
                Spacer()
                
                // Edit Button
                Button(action: onEdit) {
                    Label {
                        Text("Edit")
                    } icon: {
                        Image(systemName: "pencil.circle.fill")
                            .imageScale(.medium)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                .foregroundColor(.blue)
                .buttonStyle(BorderlessButtonStyle())
                
                // Delete Button
                Button(action: { onDelete(weapon) }) {
                    Label {
                        Text("Delete")
                    } icon: {
                        Image(systemName: "trash.circle.fill")
                            .imageScale(.medium)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                .foregroundColor(.red)
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

struct WeaponEditRow: View {
    let weapon: Weapon
    let onSave: (Weapon) -> Void
    let onCancel: () -> Void
    
    @State private var name: String
    @State private var damage: String
    @State private var weight: String
    @State private var rateOfFire: String
    @State private var special: String
    @State private var range: String
    @State private var isEquipped: Bool
    @State private var isStashed: Bool
    @State private var isMagical: Bool
    @State private var isCursed: Bool
    @State private var bonus: Int
    
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
    
    init(weapon: Weapon, onSave: @escaping (Weapon) -> Void, onCancel: @escaping () -> Void) {
        self.weapon = weapon
        self.onSave = onSave
        self.onCancel = onCancel
        _name = State(initialValue: weapon.name)
        _damage = State(initialValue: weapon.damage)
        _weight = State(initialValue: weapon.weight)
        _rateOfFire = State(initialValue: weapon.rateOfFire)
        _special = State(initialValue: weapon.special)
        _range = State(initialValue: weapon.range)
        _isEquipped = State(initialValue: weapon.isEquipped)
        _isStashed = State(initialValue: weapon.isStashed)
        _isMagical = State(initialValue: weapon.isMagical)
        _isCursed = State(initialValue: weapon.isCursed)
        _bonus = State(initialValue: weapon.bonus)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Name Section
            Text("Weapon Name")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Label {
                TextField("Enter weapon name", text: $name)
            } icon: {
                IconFrame(icon: Ph.textAa.bold, color: .blue)
            }
            
            Divider()
            
            // Combat Stats Section
            Text("Combat Statistics")
                .font(.subheadline)
                .foregroundColor(.secondary)
            VStack(alignment: .leading, spacing: 8) {
                // Equipped Status
                Label {
                    Toggle(isEquipped ? "Equipped" : "Unequipped", isOn: Binding(
                        get: { isEquipped },
                        set: { newValue in
                            isEquipped = newValue
                            if newValue {
                                isStashed = false
                            }
                        }
                    ))
                } icon: {
                    IconFrame(icon: Ph.bagSimple.bold, color: isEquipped ? .green : .gray)
                }
                .foregroundStyle(isEquipped ? .green : .gray)
                
                // Stashed Status
                Label {
                    Toggle(isStashed ? "Stashed" : "On Person", isOn: Binding(
                        get: { isStashed },
                        set: { newValue in
                            isStashed = newValue
                            if newValue {
                                isEquipped = false
                            }
                        }
                    ))
                } icon: {
                    IconFrame(icon: isStashed ? Ph.warehouse.bold : Ph.user.bold, color: isStashed ? .orange : .gray)
                }
                .foregroundStyle(isStashed ? .orange : .gray)
                
                // Magical Status
                Label {
                    Toggle("Magical", isOn: $isMagical)
                } icon: {
                    IconFrame(icon: Ph.sparkle.bold, color: isMagical ? .purple : .gray)
                }
                .foregroundStyle(isMagical ? .purple : .gray)
                
                // Cursed Status
                Label {
                    Toggle("Cursed", isOn: $isCursed)
                } icon: {
                    IconFrame(icon: Ph.skull.bold, color: isCursed ? .red : .gray)
                }
                .foregroundStyle(isCursed ? .red : .gray)
                
                // Bonus/Penalty
                Label {
                    HStack(spacing: 8) {
                        // Decrease Button
                        Button(action: {
                            bonus -= 1
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundStyle(Color.purple.opacity(0.8))
                        }
                        .buttonStyle(.borderless)
                        
                        // Bonus Display with Toggle
                        HStack(spacing: 2) {
                            Button(action: {
                                bonus = -bonus
                            }) {
                                Text(bonus >= 0 ? "+" : "-")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.purple)
                                    .frame(width: 20)
                            }
                            .buttonStyle(.borderless)
                            
                            Text("\(abs(bonus))")
                                .frame(width: 20, alignment: .leading)
                                .foregroundStyle(Color.purple)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(8)
                        
                        // Increase Button
                        Button(action: {
                            bonus += 1
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(Color.purple.opacity(0.8))
                        }
                        .buttonStyle(.borderless)
                    }
                } icon: {
                    IconFrame(icon: Ph.plusMinus.bold, color: .purple)
                }
                .foregroundStyle(.purple)
                
                // Damage
                Label {
                    VStack(alignment: .leading) {
                        Text("Damage")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("Enter damage (e.g., 1d6)", text: $damage)
                    }
                } icon: {
                    IconFrame(icon: Ph.target.bold, color: .red)
                }
                .foregroundStyle(.red)
                
                // Weight
                Label {
                    VStack(alignment: .leading) {
                        Text("Weight Category")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Menu {
                            Button("No size (100/slot)") { weight = "No size" }
                            Button("Minor (2/slot)") { weight = "Minor" }
                            Button("Regular (1 slot)") { weight = "Regular" }
                            Button("Heavy (2 slots)") { weight = "Heavy" }
                        } label: {
                            Text(weight.isEmpty ? "Select Weight" : getWeightDisplayText(weight))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                } icon: {
                    IconFrame(icon: Ph.scales.bold, color: .blue)
                }
                .foregroundStyle(.blue)
                
                // Range
                Label {
                    VStack(alignment: .leading) {
                        Text("Range")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("Enter range", text: $range)
                    }
                } icon: {
                    IconFrame(icon: Ph.arrowsOutSimple.bold, color: .purple)
                }
                .foregroundStyle(.purple)
                
                // Rate of Fire
                Label {
                    VStack(alignment: .leading) {
                        Text("Rate of Fire")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("Enter rate of fire", text: $rateOfFire)
                    }
                } icon: {
                    IconFrame(icon: Ph.timer.bold, color: .green)
                }
                .foregroundStyle(.green)
            }
            
            Divider()
            
            // Special Properties Section
            Text("Special Properties")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Label {
                VStack(alignment: .leading) {
                    Text("Special Properties")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Enter special properties", text: $special)
                }
            } icon: {
                IconFrame(icon: Ph.star.bold, color: .purple)
            }
            .foregroundStyle(.purple)
            
            Divider()
            
            // Action Buttons
            HStack(spacing: 24) {
                Spacer()
                
                // Cancel Button
                Button(action: onCancel) {
                    Label {
                        Text("Cancel")
                            .padding(.horizontal, 8)
                    } icon: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                .foregroundColor(.red)
                .buttonStyle(BorderlessButtonStyle())
                
                // Save Button
                Button(action: {
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
                        bonus: bonus
                    )
                    onSave(updatedWeapon)
                }) {
                    Label {
                        Text("Save")
                            .padding(.horizontal, 8)
                    } icon: {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                .foregroundColor(.green)
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
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
                                    if let index = weapons.firstIndex(where: { $0.id == weapon.id }) {
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
                    // Magical Status
                    HStack {
                        IconFrame(icon: Ph.sparkle.bold, color: Color.purple)
                        Text("Magical")
                            .foregroundStyle(Color.secondary)
                            .font(.caption)
                        Toggle("Magical", isOn: $isMagical)
                    }
                    
                    // Cursed Status
                    HStack {
                        IconFrame(icon: Ph.skull.bold, color: Color.red)
                        Text("Cursed")
                            .foregroundStyle(Color.secondary)
                            .font(.caption)
                        Toggle("Cursed", isOn: $isCursed)
                    }
                    
                    // Bonus/Penalty
                    HStack {
                        IconFrame(icon: Ph.plusMinus.bold, color: Color.purple)
                        Text(bonus >= 0 ? "Bonus" : "Penalty")
                            .foregroundStyle(Color.secondary)
                            .font(.caption)
                        
                        Spacer()
                        
                        // Bonus Control Group
                        HStack(spacing: 8) {
                            // Decrease Button
                            Button(action: {
                                bonus -= 1
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(Color.purple.opacity(0.8))
                            }
                            .buttonStyle(.borderless)
                            
                            // Bonus Display with Toggle
                            HStack(spacing: 2) {
                                Button(action: {
                                    bonus = -bonus
                                }) {
                                    Text(bonus >= 0 ? "+" : "-")
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.purple)
                                        .frame(width: 20)
                                }
                                .buttonStyle(.borderless)
                                
                                Text("\(abs(bonus))")
                                    .frame(width: 20, alignment: .leading)
                                    .foregroundStyle(Color.purple)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(8)
                            
                            // Increase Button
                            Button(action: {
                                bonus += 1
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(Color.purple.opacity(0.8))
                            }
                            .buttonStyle(.borderless)
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
                        Toggle(isEquipped ? "Equipped" : "Unequipped", isOn: Binding(
                            get: { isEquipped },
                            set: { newValue in
                                isEquipped = newValue
                                if newValue {
                                    isStashed = false
                                }
                            }
                        ))
                    }
                    
                    HStack {
                        IconFrame(icon: isStashed ? Ph.warehouse.bold : Ph.user.bold, color: isStashed ? Color.orange : Color.gray)
                        Text("Location")
                            .foregroundStyle(Color.secondary)
                            .font(.caption)
                        Toggle(isStashed ? "Stashed" : "On Person", isOn: Binding(
                            get: { isStashed },
                            set: { newValue in
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
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button(editingWeapon == nil ? "Save" : "Update") {
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
                        weapons.append(newWeapon)
                    }
                    isPresented = false
                }
                .disabled(name.isEmpty)
            )
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
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                    isAddingNew = false
                }
            )
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
