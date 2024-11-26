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
    @State private var editingWeaponId: String?
    @State private var isAddingNew = false
    @State private var isCustomWeapon = false
    @State private var selectedWeaponName: String?
    
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
                    if isCustomWeapon {
                        WeaponEditRow(weapon: Weapon(), onSave: { newWeapon in
                            weapons.append(newWeapon)
                            isAddingNew = false
                            isCustomWeapon = false
                        }, onCancel: {
                            isAddingNew = false
                            isCustomWeapon = false
                        })
                    } else {
                        VStack {
                            Picker("Select Weapon", selection: $selectedWeaponName) {
                                Text("Select a Weapon").tag(String?.none)
                                ForEach(WeaponData.weapons, id: \.["name"]) { weapon in
                                    Text(weapon["name"] ?? "").tag(weapon["name"] as String?)
                                }
                                Text("Custom Weapon").tag("custom" as String?)
                            }
                            .onChange(of: selectedWeaponName) { newValue in
                                if newValue == "custom" {
                                    isCustomWeapon = true
                                } else if let weaponName = newValue,
                                          let weaponData = WeaponData.weapons.first(where: { $0["name"] == weaponName }) {
                                    let weapon = Weapon(
                                        name: weaponData["name"] ?? "",
                                        damage: weaponData["damage"] ?? "",
                                        weight: weaponData["weight"] ?? "",
                                        rateOfFire: weaponData["rateOfFire"] ?? "",
                                        special: weaponData["special"] ?? ""
                                    )
                                    weapons.append(weapon)
                                    isAddingNew = false
                                    selectedWeaponName = nil
                                }
                            }
                            
                            Button("Cancel") {
                                isAddingNew = false
                                isCustomWeapon = false
                                selectedWeaponName = nil
                            }
                            .foregroundColor(.red)
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
                        isCustomWeapon = false
                        selectedWeaponName = nil
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
            }
            
            Divider()
            
            // Combat Stats Section
            Text("Combat Statistics")
                .font(.subheadline)
                .foregroundColor(.secondary)
            VStack(alignment: .leading, spacing: 8) {
                // Damage
                Label {
                    Text("Damage: \(weapon.damage)")
                } icon: {
                    IconFrame(icon: Ph.target.bold, color: .red)
                }
                .foregroundStyle(.red)
                
                // Weight
                Label {
                    Text("Weight: \(weapon.weight)")
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
                        .font(.system(.caption))
                        .fontWeight(.light)
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
    
    init(weapon: Weapon, onSave: @escaping (Weapon) -> Void, onCancel: @escaping () -> Void) {
        self.weapon = weapon
        self.onSave = onSave
        self.onCancel = onCancel
        _name = State(initialValue: weapon.name)
        _damage = State(initialValue: weapon.damage)
        _weight = State(initialValue: weapon.weight)
        _rateOfFire = State(initialValue: weapon.rateOfFire)
        _special = State(initialValue: weapon.special)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Name Section
            Text("Weapon Name")
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                IconFrame(icon: Ph.textAa.bold, color: .blue)
                TextField("Enter weapon name", text: $name)
            }
            
            Divider()
            
            // Combat Stats Section
            Text("Combat Statistics")
                .font(.subheadline)
                .foregroundColor(.secondary)
            VStack(alignment: .leading, spacing: 8) {
                // Damage
                HStack {
                    IconFrame(icon: Ph.target.bold, color: .red)
                    TextField("Enter damage (e.g., 1d6)", text: $damage)
                }
                
                // Weight
                HStack {
                    IconFrame(icon: Ph.scales.bold, color: .blue)
                    TextField("Enter weight (Negligible/Minor/Regular/Heavy)", text: $weight)
                }
                
                // Rate of Fire
                HStack {
                    IconFrame(icon: Ph.timer.bold, color: .green)
                    TextField("Enter rate of fire (e.g., 1, 1/2, or -)", text: $rateOfFire)
                }
            }
            
            Divider()
            
            // Special Properties Section
            Text("Special Properties")
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                IconFrame(icon: Ph.star.bold, color: .purple)
                TextField("Enter special properties", text: $special)
            }
            
            // Action Buttons
            HStack {
                Spacer()
                
                // Cancel Button
                Button(action: onCancel) {
                    Label {
                        Text("Cancel")
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
                        name: name,
                        damage: damage,
                        weight: weight,
                        rateOfFire: rateOfFire,
                        special: special
                    )
                    onSave(updatedWeapon)
                }) {
                    Label {
                        Text("Save")
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

struct WeaponPickerView: View {
    @Binding var isPresented: Bool
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
                        }) {
                            WeaponDataRow(weaponData: weaponData)
                        }
                    }
                } header: {
                    Text("Standard Weapons")
                }
            }
            .navigationTitle("Add Weapon")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

struct WeaponDataRow: View {
    let weaponData: [String: String]
    
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
                        Text("Weight: \(weaponData["weight"] ?? "")")
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
                            .font(.system(.caption))
                            .fontWeight(.light)
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

struct CustomWeaponForm: View {
    @Binding var weapons: [Weapon]
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var damage = ""
    @State private var weight = ""
    @State private var rateOfFire = ""
    @State private var special = ""
    @State private var editingWeapon: Weapon?
    
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
                } header: {
                    Text("Combat Stats")
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
                    let weapon = Weapon(
                        name: name,
                        damage: damage,
                        weight: weight,
                        rateOfFire: rateOfFire,
                        special: special
                    )
                    if let editingWeapon = editingWeapon,
                       let index = weapons.firstIndex(where: { $0.id == editingWeapon.id }) {
                        weapons[index] = weapon
                    } else {
                        weapons.append(weapon)
                    }
                    isPresented = false
                }
                .disabled(name.isEmpty)
            )
        }
    }
}
