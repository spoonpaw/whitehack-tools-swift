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
                        WeaponEditRow(weapon: Weapon()) { newWeapon in
                            weapons.append(newWeapon)
                            isAddingNew = false
                            isCustomWeapon = false
                        }
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
                                        cost: Int(weaponData["cost"] ?? "") ?? 0,
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
                        WeaponEditRow(weapon: weapon) { updatedWeapon in
                            if let index = weapons.firstIndex(where: { $0.id == weapon.id }) {
                                weapons[index] = updatedWeapon
                            }
                            editingWeaponId = nil
                        }
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
        HStack {
            VStack(alignment: .leading) {
                Text(weapon.name)
                    .font(.headline)
                HStack {
                    Text(weapon.damage)
                    Text(weapon.weight)
                    if weapon.rateOfFire != "-" {
                        Text("RoF: \(weapon.rateOfFire)")
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                if !weapon.special.isEmpty {
                    Text(weapon.special)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            HStack(spacing: 12) {
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.blue)
                }
                Button(action: { onDelete(weapon) }) {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct WeaponEditRow: View {
    let weapon: Weapon
    let onSave: (Weapon) -> Void
    
    @State private var name: String
    @State private var damage: String
    @State private var weight: String
    @State private var rateOfFire: String
    @State private var cost: String
    @State private var special: String
    
    init(weapon: Weapon, onSave: @escaping (Weapon) -> Void) {
        self.weapon = weapon
        self.onSave = onSave
        _name = State(initialValue: weapon.name)
        _damage = State(initialValue: weapon.damage)
        _weight = State(initialValue: weapon.weight)
        _rateOfFire = State(initialValue: weapon.rateOfFire)
        _cost = State(initialValue: String(weapon.cost))
        _special = State(initialValue: weapon.special)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                IconFrame(icon: Ph.textAa.bold, color: .blue)
                TextField("Name", text: $name)
            }
            
            HStack {
                IconFrame(icon: Ph.target.bold, color: .red)
                TextField("Damage", text: $damage)
            }
            
            HStack {
                IconFrame(icon: Ph.scales.bold, color: .blue)
                TextField("Weight", text: $weight)
            }
            
            HStack {
                IconFrame(icon: Ph.timer.bold, color: .green)
                TextField("Rate of Fire", text: $rateOfFire)
            }
            
            HStack {
                IconFrame(icon: Ph.coins.bold, color: .yellow)
                TextField("Cost", text: $cost)
                    .keyboardType(.numberPad)
            }
            
            HStack {
                IconFrame(icon: Ph.star.bold, color: .purple)
                TextField("Special", text: $special)
            }
            
            HStack {
                Button(action: {
                    let updatedWeapon = Weapon(
                        name: name,
                        damage: damage,
                        weight: weight,
                        rateOfFire: rateOfFire,
                        cost: Int(cost) ?? 0,
                        special: special
                    )
                    onSave(updatedWeapon)
                }) {
                    Text("Save")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical, 8)
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
        VStack(alignment: .leading, spacing: 4) {
            Text(weaponData["name"] ?? "")
                .font(.headline)
            
            HStack(spacing: 12) {
                Label {
                    Text(weaponData["damage"] ?? "")
                } icon: {
                    IconFrame(icon: Ph.target.bold, color: Color.red)
                }
                
                Label {
                    Text(weaponData["weight"] ?? "")
                } icon: {
                    IconFrame(icon: Ph.scales.bold, color: Color.blue)
                }
                
                if weaponData["rateOfFire"] != "-" {
                    Label {
                        Text("RoF: \(weaponData["rateOfFire"] ?? "")")
                    } icon: {
                        IconFrame(icon: Ph.timer.bold, color: Color.green)
                    }
                }
            }
            .font(.caption)
            
            if let special = weaponData["special"], !special.isEmpty {
                Label {
                    Text(special)
                        .italic()
                } icon: {
                    IconFrame(icon: Ph.star.bold, color: Color.purple)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct CustomWeaponForm: View {
    @Binding var weapons: [Weapon]
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var damage = ""
    @State private var weight = ""
    @State private var rateOfFire = ""
    @State private var cost = ""
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
                                    cost = "\(weapon.cost)"
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
                        IconFrame(icon: Ph.coins.bold, color: Color.yellow)
                        Text("Cost")
                            .foregroundStyle(Color.secondary)
                            .font(.caption)
                        TextField("GP", text: $cost)
                            .keyboardType(.numberPad)
                    }
                } header: {
                    Text("Cost")
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
                        cost: Int(cost) ?? 0,
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
