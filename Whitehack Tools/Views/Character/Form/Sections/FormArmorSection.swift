import SwiftUI
import PhosphorSwift

struct FormArmorSection: View {
    @Binding var armor: [Armor]
    @State private var isAddingArmor = false
    @State private var editingArmorIndex: Int? = nil
    @State private var newArmor = Armor(
        id: UUID(),
        name: "",
        defenseValue: 0,
        cost: 0,
        isMagical: false,
        magicalBonus: 0
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
                                defenseValue: 0,
                                cost: 0,
                                isMagical: false,
                                magicalBonus: 0
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
                Stepper("Defense Value: \(armor.defenseValue)", value: $armor.defenseValue, in: 0...6)
                
                TextField("Cost", value: $armor.cost, format: .number)
                    .textFieldStyle(.roundedBorder)
            }
            
            HStack {
                Toggle("Magical", isOn: $armor.isMagical)
                
                if armor.isMagical {
                    Stepper("Bonus: +\(armor.magicalBonus)", value: $armor.magicalBonus, in: 1...6)
                }
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
                Text(armor.name)
                    .font(.headline)
                
                HStack(spacing: 12) {
                    Label("DF \(armor.defenseValue)", systemImage: "shield.fill")
                        .font(.caption)
                    
                    Text("\(armor.cost) GP")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if armor.isMagical {
                    Text("+\(armor.magicalBonus) Magical")
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
