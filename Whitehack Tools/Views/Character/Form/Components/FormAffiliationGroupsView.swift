import SwiftUI

struct HeaderView: View {
    @Binding var isAddingAffiliation: Bool
    
    var body: some View {
        HStack {
            Text("Affiliation Groups")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            Spacer()
            if !isAddingAffiliation {
                Button {
                    withAnimation(.easeInOut) {
                        isAddingAffiliation = true
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
    }
}

struct AddAffiliationView: View {
    @Binding var isAddingAffiliation: Bool
    @Binding var newAffiliationText: String
    @Binding var affiliationGroups: [String]
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        HStack {
            TextField("Add Affiliation Group", text: $newAffiliationText)
                #if os(iOS)
                .textInputAutocapitalization(.words)
                #endif
                .focused($focusedField, equals: .newAffiliationGroup)
                .textFieldStyle(.roundedBorder)
            
            Button {
                withAnimation(.easeInOut) {
                    newAffiliationText = ""
                    isAddingAffiliation = false
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
                    let trimmed = newAffiliationText.trimmingCharacters(in: .whitespaces)
                    if !trimmed.isEmpty {
                        affiliationGroups.append(trimmed)
                    }
                    newAffiliationText = ""
                    isAddingAffiliation = false
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
}

struct AffiliationItemView: View {
    let group: String
    let index: Int
    @Binding var editingAffiliationIndex: Int?
    @Binding var tempAffiliationText: String
    @Binding var affiliationGroups: [String]
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    
    var body: some View {
        HStack {
            if editingAffiliationIndex == index {
                TextField("Edit Affiliation Group", text: $tempAffiliationText)
                    .textFieldStyle(.roundedBorder)
                    .onAppear { tempAffiliationText = group }
                Button {
                    withAnimation(.easeInOut) {
                        editingAffiliationIndex = nil
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
                        let trimmed = tempAffiliationText.trimmingCharacters(in: .whitespaces)
                        if !trimmed.isEmpty {
                            affiliationGroups[index] = trimmed
                            attributeGroupPairs = attributeGroupPairs.map { pair in
                                if pair.group == group {
                                    return AttributeGroupPair(attribute: pair.attribute, group: trimmed)
                                }
                                return pair
                            }
                        }
                        editingAffiliationIndex = nil
                    }
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .imageScale(.medium)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.green)
                }
                .buttonStyle(BorderlessButtonStyle())
            } else {
                Text(group)
                    .foregroundColor(.primary)
                Spacer()
                Button {
                    withAnimation(.easeInOut) {
                        editingAffiliationIndex = index
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
                        attributeGroupPairs.removeAll { $0.group == group }
                        affiliationGroups.removeAll { $0 == group }
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
        .background({
            #if os(iOS)
            Color(uiColor: .systemGray6)
            #else
            Color(nsColor: .windowBackgroundColor)
            #endif
        }())
        .cornerRadius(8)
    }
}

struct FormAffiliationGroupsView: View {
    @Binding var affiliationGroups: [String]
    @Binding var newAffiliationGroup: String
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    @State private var isAddingAffiliation = false
    @State private var editingAffiliationIndex: Int?
    @State private var tempAffiliationText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with Add button
            HStack {
                Text("Affiliation Groups")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
                if !isAddingAffiliation {
                    Button {
                        withAnimation(.easeInOut) {
                            isAddingAffiliation = true
                            focusedField = .newAffiliationGroup
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.medium)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            // Add new affiliation
            if isAddingAffiliation {
                HStack {
                    TextField("Add Affiliation Group", text: $newAffiliationGroup)
                        #if os(iOS)
                        .textInputAutocapitalization(.words)
                        #endif
                        .focused($focusedField, equals: .newAffiliationGroup)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            newAffiliationGroup = ""
                            isAddingAffiliation = false
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
                            let trimmed = newAffiliationGroup.trimmingCharacters(in: .whitespaces)
                            if !trimmed.isEmpty {
                                affiliationGroups.append(trimmed)
                            }
                            newAffiliationGroup = ""
                            isAddingAffiliation = false
                        }
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.medium)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.green)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .disabled(newAffiliationGroup.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            
            // Existing affiliations
            ForEach(Array(affiliationGroups.enumerated()), id: \.offset) { index, affiliation in
                HStack {
                    if editingAffiliationIndex == index {
                        // Edit mode
                        TextField("Edit Affiliation Group", text: $tempAffiliationText)
                            .textFieldStyle(.roundedBorder)
                            .onAppear { tempAffiliationText = affiliation }
                        
                        Button {
                            withAnimation(.easeInOut) {
                                editingAffiliationIndex = nil
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
                                let trimmed = tempAffiliationText.trimmingCharacters(in: .whitespaces)
                                if !trimmed.isEmpty {
                                    affiliationGroups[index] = trimmed
                                    // Update group references in attribute pairs
                                    attributeGroupPairs = attributeGroupPairs.map { pair in
                                        if pair.group == affiliation {
                                            return AttributeGroupPair(attribute: pair.attribute, group: trimmed)
                                        }
                                        return pair
                                    }
                                }
                                editingAffiliationIndex = nil
                            }
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.medium)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.green)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .disabled(tempAffiliationText.trimmingCharacters(in: .whitespaces).isEmpty)
                    } else {
                        // Display mode
                        Text(affiliation)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.easeInOut) {
                                editingAffiliationIndex = index
                                tempAffiliationText = affiliation
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
                                // Remove both the affiliation and any attribute pairs that reference it
                                attributeGroupPairs.removeAll { $0.group == affiliation }
                                affiliationGroups.remove(at: index)
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
                .background({
                    #if os(iOS)
                    Color(uiColor: .systemGray6)
                    #else
                    Color(nsColor: .windowBackgroundColor)
                    #endif
                }())
                .cornerRadius(8)
            }
        }
    }
}
