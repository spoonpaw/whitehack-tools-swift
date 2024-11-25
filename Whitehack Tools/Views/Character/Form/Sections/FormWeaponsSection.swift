import SwiftUI
import PhosphorSwift

struct FormWeaponsSection: View {
    @Binding var weapons: [Weapon]
    @State private var isAddingWeapon = false
    @State private var editingWeaponIndex: Int? = nil
    @State private var newWeapon = Weapon(
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
                // Weapons List
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Weapons")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Spacer()
                        if !isAddingWeapon {
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
                        WeaponFormView(weapon: $newWeapon) {
                            weapons.append(newWeapon)
                            isAddingWeapon = false
                            newWeapon = Weapon(
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
                    
                    if !weapons.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(Array(weapons.enumerated()), id: \.element.id) { index, weapon in
                                if editingWeaponIndex == index {
                                    WeaponFormView(weapon: $weapons[index]) {
                                        editingWeaponIndex = nil
                                    }
                                } else {
                                    WeaponRowView(weapon: weapon) {
                                        editingWeaponIndex = index
                                    } onDelete: {
                                        weapons.remove(at: index)
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
            
            // Save Button
            Button(action: onSave) {
                Text("Save Weapon")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)
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
                Text(weapon.name)
                    .font(.headline)
                
                HStack(spacing: 12) {
                    Label(weapon.damage, systemImage: "burst.fill")
                        .font(.caption)
                    
                    Label(weapon.weight.rawValue, systemImage: "scalemass.fill")
                        .font(.caption)
                    
                    if !weapon.rateOfFire.isEmpty {
                        Label(weapon.rateOfFire, systemImage: "timer")
                            .font(.caption)
                    }
                }
                
                if !weapon.special.isEmpty {
                    Text(weapon.special)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if weapon.isMagical {
                    Text("+\(weapon.magicalBonus) Magical")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle.fill")
                        .imageScale(.large)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.blue)
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .imageScale(.large)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 2)
    }
}
