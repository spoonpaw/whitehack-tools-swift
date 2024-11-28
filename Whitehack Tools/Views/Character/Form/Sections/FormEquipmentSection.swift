import SwiftUI
import PhosphorSwift

struct FormEquipmentSection: View {
    @Binding var gear: [Gear]
    @Binding var coins: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    @State private var isAddingItem = false
    @State private var editingItemId: UUID? = nil
    @State private var tempGear = Gear()
    
    var body: some View {
        Section(header: Text("Equipment").font(.headline)) {
            VStack(spacing: 16) {
                // Gear Items
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Gear")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Spacer()
                        if !isAddingItem {
                            Button {
                                isAddingItem = true
                                tempGear = Gear()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    
                    if isAddingItem {
                        GearEditForm(gear: $tempGear) {
                            withAnimation {
                                gear.append(tempGear)
                                isAddingItem = false
                            }
                        } onCancel: {
                            withAnimation {
                                isAddingItem = false
                            }
                        }
                    }
                    
                    ForEach(gear) { item in
                        if editingItemId == item.id {
                            GearEditForm(gear: Binding(
                                get: { tempGear },
                                set: { tempGear = $0 }
                            )) {
                                withAnimation {
                                    if let index = gear.firstIndex(where: { $0.id == item.id }) {
                                        gear[index] = tempGear
                                    }
                                    editingItemId = nil
                                }
                            } onCancel: {
                                withAnimation {
                                    editingItemId = nil
                                }
                            }
                        } else {
                            GearRow(gear: item) {
                                tempGear = item
                                editingItemId = item.id
                            } onDelete: {
                                withAnimation {
                                    gear.removeAll { $0.id == item.id }
                                }
                            }
                        }
                    }
                }
                
                // Coins
                VStack(alignment: .leading, spacing: 8) {
                    Text("Coins (GP)")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    TextField("0", text: $coins)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct GearRow: View {
    let gear: Gear
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name and Properties Row
            HStack {
                Text(gear.name)
                    .fontWeight(.medium)
                Spacer()
                if gear.isEquipped {
                    Text("Equipped")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                }
                if gear.isStashed {
                    Text("Stashed")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            // Weight and Quantity
            HStack {
                Label {
                    Text(gear.weight)
                } icon: {
                    Ph.scales.bold
                        .foregroundColor(.blue)
                }
                Spacer()
                if gear.quantity > 1 {
                    Label {
                        Text("x\(gear.quantity)")
                    } icon: {
                        Ph.stack.bold
                            .foregroundColor(.orange)
                    }
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            // Special Properties
            if !gear.special.isEmpty {
                Text(gear.special)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Magical/Cursed Indicators
            if gear.isMagical || gear.isCursed {
                HStack(spacing: 8) {
                    if gear.isMagical {
                        Label {
                            Text("Magical")
                        } icon: {
                            Ph.sparkle.bold
                                .foregroundColor(.purple)
                        }
                    }
                    if gear.isCursed {
                        Label {
                            Text("Cursed")
                        } icon: {
                            Ph.skull.bold
                                .foregroundColor(.red)
                        }
                    }
                }
                .font(.caption)
            }
            
            // Edit/Delete Buttons
            HStack {
                Spacer()
                Button(action: onEdit) {
                    Label("Edit", systemImage: "pencil")
                }
                .buttonStyle(.borderless)
                Button(action: onDelete) {
                    Label("Delete", systemImage: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(.borderless)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

struct GearEditForm: View {
    @Binding var gear: Gear
    let onSave: () -> Void
    let onCancel: () -> Void
    
    private let weightOptions = ["No size", "Minor", "Regular", "Heavy"]
    
    var body: some View {
        VStack(spacing: 16) {
            // Name
            TextField("Name", text: $gear.name)
                .textFieldStyle(.roundedBorder)
            
            // Weight
            Picker("Weight", selection: $gear.weight) {
                ForEach(weightOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            
            // Special Properties
            TextField("Special Properties", text: $gear.special)
                .textFieldStyle(.roundedBorder)
            
            // Quantity
            Stepper("Quantity: \(gear.quantity)", value: $gear.quantity, in: 1...99)
            
            // Toggles
            Toggle("Equipped", isOn: $gear.isEquipped)
            Toggle("Stashed", isOn: $gear.isStashed)
            Toggle("Magical", isOn: $gear.isMagical)
            Toggle("Cursed", isOn: $gear.isCursed)
            
            // Save/Cancel Buttons
            HStack {
                Button("Cancel", action: onCancel)
                    .foregroundColor(.red)
                Spacer()
                Button("Save", action: onSave)
                    .disabled(gear.name.isEmpty)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}
