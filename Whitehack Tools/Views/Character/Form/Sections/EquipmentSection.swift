// EquipmentSection.swift
import SwiftUI

struct EquipmentSection: View {
    @Binding var inventory: [String]
    @Binding var newInventoryItem: String
    @Binding var coins: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        Section(header: Text("Equipment").font(.headline)) {
            HStack {
                TextField("Add Inventory Item", text: $newInventoryItem)
                    .textInputAutocapitalization(.words)
                    .focused($focusedField, equals: .newInventoryItem)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        withAnimation {
                            addInventoryItem()
                        }
                    }
                
                Button {
                    withAnimation {
                        addInventoryItem()
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(newInventoryItem.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
                }
                .buttonStyle(.borderless)
                .disabled(newInventoryItem.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            
            if !inventory.isEmpty {
                ForEach(inventory, id: \.self) { item in
                    HStack {
                        Text(item)
                        Spacer()
                        Button {
                            withAnimation {
                                removeInventoryItem(item)
                            }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Coins (GP)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter coins", text: $coins)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .coins)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
    
    private func addInventoryItem() {
        let trimmed = newInventoryItem.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        inventory.append(trimmed)
        newInventoryItem = ""
        focusedField = nil
    }
    
    private func removeInventoryItem(_ item: String) {
        inventory.removeAll { $0 == item }
    }
}
