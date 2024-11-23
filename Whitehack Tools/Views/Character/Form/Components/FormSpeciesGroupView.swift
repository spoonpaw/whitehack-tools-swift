import SwiftUI

struct FormSpeciesGroupView: View {
    @Binding var speciesGroup: String
    @Binding var isSpeciesGroupAdded: Bool
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    @State private var isAddingSpecies = false
    @State private var newSpeciesText = ""
    @State private var isEditing = false
    @State private var tempSpeciesText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Species Group")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
                if !isSpeciesGroupAdded && !isAddingSpecies {
                    Button {
                        withAnimation(.easeInOut) {
                            isAddingSpecies = true
                            newSpeciesText = ""
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            if isAddingSpecies {
                HStack {
                    TextField("Add Species Group", text: $newSpeciesText)
                        .textInputAutocapitalization(.words)
                        .focused($focusedField, equals: .speciesGroup)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            newSpeciesText = ""
                            isAddingSpecies = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Button {
                        withAnimation(.easeInOut) {
                            let trimmed = newSpeciesText.trimmingCharacters(in: .whitespaces)
                            if !trimmed.isEmpty {
                                speciesGroup = trimmed
                                isSpeciesGroupAdded = true
                            }
                            newSpeciesText = ""
                            isAddingSpecies = false
                        }
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.green)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            if isSpeciesGroupAdded {
                HStack {
                    if isEditing {
                        TextField("Edit Species Group", text: $tempSpeciesText)
                            .textFieldStyle(.roundedBorder)
                            .onAppear { tempSpeciesText = speciesGroup }
                        
                        Button {
                            withAnimation(.easeInOut) {
                                isEditing = false
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.medium)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button {
                            withAnimation(.easeInOut) {
                                let trimmed = tempSpeciesText.trimmingCharacters(in: .whitespaces)
                                if !trimmed.isEmpty {
                                    // Update any attribute pairs that were using the old group name
                                    attributeGroupPairs = attributeGroupPairs.map { pair in
                                        if pair.group == speciesGroup {
                                            return AttributeGroupPair(attribute: pair.attribute, group: trimmed)
                                        }
                                        return pair
                                    }
                                    speciesGroup = trimmed
                                }
                                isEditing = false
                            }
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.medium)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.green)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    } else {
                        Text(speciesGroup)
                            .foregroundColor(.primary)
                        Spacer()
                        Button {
                            withAnimation(.easeInOut) {
                                isEditing = true
                            }
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .imageScale(.medium)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Button {
                            withAnimation(.easeInOut) {
                                // Remove any attribute pairs associated with this group
                                attributeGroupPairs.removeAll { $0.group == speciesGroup }
                                speciesGroup = ""
                                isSpeciesGroupAdded = false
                            }
                        } label: {
                            Image(systemName: "trash.circle.fill")
                                .imageScale(.medium)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
    }
}
