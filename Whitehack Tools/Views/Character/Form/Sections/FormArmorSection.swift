import SwiftUI
import PhosphorSwift

struct FormArmorSection: View {
    @Binding var armor: [Armor]
    @State private var isAddingArmor = false
    @State private var editingArmorIndex: Int? = nil
    @State private var newArmor = Armor(
        id: UUID(),
        name: "",
        df: "0",
        weight: "",
        special: "",
        quantity: 1,
        isEquipped: false,
        isStashed: false,
        isMagical: false,
        isCursed: false,
        bonus: 0
    )
    
    var body: some View {
        Section(header: Text("Armor").font(.headline)) {
            VStack(spacing: 16) {
                // Armor List
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Armor")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Spacer()
                        if !isAddingArmor {
                            Button {
                                isAddingArmor = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    if isAddingArmor {
                        ArmorFormView(armor: $newArmor) {
                            armor.append(newArmor)
                            isAddingArmor = false
                            newArmor = Armor(
                                id: UUID(),
                                name: "",
                                df: "0",
                                weight: "",
                                special: "",
                                quantity: 1,
                                isEquipped: false,
                                isStashed: false,
                                isMagical: false,
                                isCursed: false,
                                bonus: 0
                            )
                        }
                    }
                    
                    if !armor.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(Array(armor.enumerated()), id: \.element.id) { index, armorItem in
                                if editingArmorIndex == index {
                                    ArmorFormView(armor: $armor[index]) {
                                        editingArmorIndex = nil
                                    }
                                } else {
                                    ArmorRowView(armor: armorItem) {
                                        editingArmorIndex = index
                                    } onDelete: {
                                        armor.remove(at: index)
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

struct ArmorFormView: View {
    @Binding var armor: Armor
    let onSave: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            TextField("Name", text: $armor.name)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                TextField("Defense Factor", text: $armor.df)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Weight", text: $armor.weight)
                    .textFieldStyle(.roundedBorder)
            }
            
            TextField("Special Properties", text: $armor.special)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Stepper("Quantity: \(armor.quantity)", value: $armor.quantity, in: 1...99)
            }
            
            HStack {
                Toggle("Equipped", isOn: $armor.isEquipped)
                Toggle("Stashed", isOn: $armor.isStashed)
            }
            
            HStack {
                Toggle("Magical", isOn: $armor.isMagical)
                Toggle("Cursed", isOn: $armor.isCursed)
            }
            
            if armor.isMagical {
                Stepper("Bonus: \(armor.bonus > 0 ? "+" : "")\(armor.bonus)", value: $armor.bonus, in: -6...6)
            }
            
            Button("Save") {
                onSave()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 2)
    }
}

struct ArmorRowView: View {
    let armor: Armor
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(armor.name)
                        .font(.headline)
                    
                    if armor.isMagical {
                        Text(armor.bonus > 0 ? "+\(armor.bonus)" : "\(armor.bonus)")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
                
                HStack(spacing: 12) {
                    Label("DF: \(armor.df)", systemImage: "shield.fill")
                        .font(.caption)
                    
                    Text(armor.weight)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if !armor.special.isEmpty {
                    Text(armor.special)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if armor.quantity > 1 {
                    Text("Quantity: \(armor.quantity)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    if armor.isEquipped {
                        Text("Equipped")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    if armor.isStashed {
                        Text("Stashed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    if armor.isCursed {
                        Text("Cursed")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
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
