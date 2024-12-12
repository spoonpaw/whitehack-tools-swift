import SwiftUI

struct FormSpeciesGroupView: View {
    @Binding var speciesGroup: String
    @Binding var isSpeciesGroupAdded: Bool
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    var onRemove: () -> Void
    
    @State private var isAddingSpecies = false
    @State private var newSpeciesText = ""
    @State private var isEditing = false
    @State private var tempSpeciesText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Species Group")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            if isAddingSpecies {
                HStack {
                    TextField("Add Species Group", text: $newSpeciesText)
                        #if os(iOS)
                        .textInputAutocapitalization(.words)
                        #endif
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
                            .foregroundColor(.secondary)
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
            } else if isSpeciesGroupAdded {
                HStack {
                    if isEditing {
                        TextField("Edit Species Group", text: $tempSpeciesText)
                            #if os(iOS)
                            .textInputAutocapitalization(.words)
                            #endif
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .speciesGroup)
                        
                        HStack(spacing: 12) {
                            Button {
                                withAnimation(.easeInOut) {
                                    isEditing = false
                                    tempSpeciesText = ""
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
                                    tempSpeciesText = ""
                                }
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    } else {
                        Text(speciesGroup)
                            .font(.title3)
                        Spacer()
                        HStack(spacing: 12) {
                            Button {
                                withAnimation(.easeInOut) {
                                    isEditing = true
                                    tempSpeciesText = speciesGroup
                                }
                            } label: {
                                Image(systemName: "pencil.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.blue)
                            }
                            
                            Button {
                                withAnimation(.easeInOut) {
                                    onRemove()
                                }
                            } label: {
                                Image(systemName: "trash.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.red)
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            } else {
                Button {
                    withAnimation(.easeInOut) {
                        isAddingSpecies = true
                        newSpeciesText = ""
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                        Text("Add Species Group")
                    }
                    .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}
