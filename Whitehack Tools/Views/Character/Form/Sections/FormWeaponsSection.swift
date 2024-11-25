import SwiftUI
import PhosphorSwift

struct FormWeaponsSection: View {
    @Binding var weapons: [Weapon]
    @State private var isAddingWeapon = false
    @State private var editingWeaponIndex: Int? = nil
    @State private var draftWeapon = Weapon(
        id: UUID(),
        name: "",
        damage: "1d6",
        weight: .regular,
        rateOfFire: "1",
        cost: 0,
        special: "",
        isMagical: false,
        magicalBonus: 0
    )
    
    var body: some View {
        Section(header: Text("Weapons").font(.headline)) {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Weapons")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Spacer()
                        if !isAddingWeapon && editingWeaponIndex == nil {
                            Button {
                                isAddingWeapon = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    if isAddingWeapon {
                        WeaponFormView(weapon: $draftWeapon) {
                            print("Saving weapon: \(draftWeapon)")
                            weapons.append(draftWeapon)
                            DispatchQueue.main.async {
                                isAddingWeapon = false
                                draftWeapon = Weapon(
                                    id: UUID(),
                                    name: "",
                                    damage: "1d6",
                                    weight: .regular,
                                    rateOfFire: "1",
                                    cost: 0,
                                    special: "",
                                    isMagical: false,
                                    magicalBonus: 0
                                )
                            }
                        } onCancel: {
                            DispatchQueue.main.async {
                                isAddingWeapon = false
                                draftWeapon = Weapon(
                                    id: UUID(),
                                    name: "",
                                    damage: "1d6",
                                    weight: .regular,
                                    rateOfFire: "1",
                                    cost: 0,
                                    special: "",
                                    isMagical: false,
                                    magicalBonus: 0
                                )
                            }
                        }
                    }
                    
                    if !weapons.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(Array(weapons.enumerated()), id: \.element.id) { index, weapon in
                                if editingWeaponIndex == index {
                                    WeaponFormView(weapon: $weapons[index]) {
                                        print("Saving edited weapon at index \(index)")
                                        DispatchQueue.main.async {
                                            editingWeaponIndex = nil
                                        }
                                    } onCancel: {
                                        DispatchQueue.main.async {
                                            editingWeaponIndex = nil
                                        }
                                    }
                                } else {
                                    WeaponRowView(weapon: weapon) {
                                        editingWeaponIndex = index
                                    } onDelete: {
                                        DispatchQueue.main.async {
                                            weapons.remove(at: index)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct WeaponFormView: View {
    @Binding var weapon: Weapon
    let onSave: () -> Void
    let onCancel: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button {
                    onCancel()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                        .imageScale(.large)
                }
                
                Spacer()
                
                Button {
                    print("Save button pressed. Weapon: \(weapon)")
                    onSave()
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .imageScale(.large)
                }
            }
            .padding(.bottom, 8)
            
            // Name
            VStack(alignment: .leading, spacing: 4) {
                Label("Name", systemImage: "character.cursor.ibeam")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Weapon name", text: $weapon.name)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Damage
            VStack(alignment: .leading, spacing: 4) {
                Label {
                    Text("Damage")
                } icon: {
                    Ph.sword.bold
                        .frame(width: 20, height: 20)
                        .symbolRenderingMode(.hierarchical)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                TextField("e.g., 1d6", text: $weapon.damage)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Weight
            VStack(alignment: .leading, spacing: 4) {
                Label {
                    Text("Weight")
                } icon: {
                    Ph.scales.bold
                        .frame(width: 20, height: 20)
                        .symbolRenderingMode(.hierarchical)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Picker("Weight", selection: $weapon.weight) {
                    ForEach([
                        WeaponWeight.none,
                        .noSize,
                        .minor,
                        .regular,
                        .heavy
                    ], id: \.self) { weight in
                        Text(weight.rawValue)
                            .tag(weight)
                    }
                }
                .pickerStyle(.menu)
            }
            
            // Rate of Fire
            VStack(alignment: .leading, spacing: 4) {
                Label {
                    Text("Rate of Fire")
                } icon: {
                    Ph.timer.bold
                        .frame(width: 20, height: 20)
                        .symbolRenderingMode(.hierarchical)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                TextField("e.g., 1, 1/2", text: $weapon.rateOfFire)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Special Properties
            VStack(alignment: .leading, spacing: 4) {
                Label {
                    Text("Special Properties")
                } icon: {
                    Ph.star.bold
                        .frame(width: 20, height: 20)
                        .symbolRenderingMode(.hierarchical)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                TextField("Special properties or notes", text: $weapon.special)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Magical Properties
            VStack(alignment: .leading, spacing: 4) {
                Label {
                    Text("Magical Properties")
                } icon: {
                    Ph.sparkle.bold
                        .frame(width: 20, height: 20)
                        .symbolRenderingMode(.hierarchical)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Toggle("Is Magical", isOn: $weapon.isMagical)
                    .toggleStyle(.switch)
                
                if weapon.isMagical {
                    Stepper("Magical Bonus: +\(weapon.magicalBonus)", value: $weapon.magicalBonus, in: 1...5)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 2)
    }
}

struct WeaponRowView: View {
    let weapon: Weapon
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(weapon.name.isEmpty ? "Unnamed Weapon" : weapon.name)
                    .font(.subheadline)
                Text("\(weapon.damage) damage")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.red)
                        .imageScale(.large)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
