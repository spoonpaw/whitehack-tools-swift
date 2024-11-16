import SwiftUI

struct EquipmentSection: View {
    @Binding var inventory: [String]
    @Binding var newInventoryItem: String
    @Binding var coins: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    @State private var isAddingItem = false
    
    var body: some View {
        Section(header: Text("Equipment").font(.headline)) {
            VStack(spacing: 16) {
                // Inventory Items
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Inventory")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Spacer()
                        if !isAddingItem {
                            Button {
                                isAddingItem = true
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
                        HStack {
                            TextField("Add Inventory Item", text: $newInventoryItem)
                                .textInputAutocapitalization(.words)
                                .focused($focusedField, equals: .newInventoryItem)
                                .textFieldStyle(.roundedBorder)
                            
                            Button {
                                addInventoryItem()
                                isAddingItem = false
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Button {
                                newInventoryItem = ""
                                isAddingItem = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    
                    if !inventory.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(inventory, id: \.self) { item in
                                    HStack {
                                        Text(item)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Button {
                                            withAnimation {
                                                removeInventoryItem(item)
                                            }
                                        } label: {
                                            Image(systemName: "trash.circle.fill")
                                                .imageScale(.medium)
                                                .symbolRenderingMode(.hierarchical)
                                                .foregroundColor(.red)
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                    .padding(10)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .frame(maxHeight: 150)
                    }
                }
                
                // Coins
                VStack(alignment: .leading, spacing: 8) {
                    Text("Coins (GP)")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        TextField("Enter coins", text: $coins)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .coins)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private func addInventoryItem() {
        let trimmed = newInventoryItem.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        withAnimation {
            inventory.append(trimmed)
            newInventoryItem = ""
            focusedField = nil
        }
    }
    
    private func removeInventoryItem(_ item: String) {
        withAnimation {
            inventory.removeAll { $0 == item }
        }
    }
}
