import SwiftUI

struct CharacterGroupsSection: View {
    @Binding var speciesGroup: String
    @Binding var vocationGroup: String
    @Binding var affiliationGroups: [String]
    @Binding var newAffiliationGroup: String
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    @Binding var selectedAttribute: String
    @Binding var newAttributeGroup: String
    @Binding var isSpeciesGroupAdded: Bool
    @Binding var isVocationGroupAdded: Bool
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    @State private var isAddingSpecies = false
    @State private var isAddingVocation = false
    @State private var isAddingAffiliation = false
    @State private var isAddingAttributeGroup = false
    
    var body: some View {
        Section(header: Text("Group Associations").font(.headline)) {
            VStack(spacing: 16) {
                // Species Group
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Species Group")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Spacer()
                        if !isSpeciesGroupAdded && !isAddingSpecies {
                            Button {
                                isAddingSpecies = true
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
                            TextField("Add Species Group", text: $speciesGroup)
                                .textInputAutocapitalization(.words)
                                .focused($focusedField, equals: .speciesGroup)
                                .textFieldStyle(.roundedBorder)
                            
                            Button {
                                addSpeciesGroup()
                                isAddingSpecies = false
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Button {
                                speciesGroup = ""
                                isAddingSpecies = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    
                    if isSpeciesGroupAdded {
                        HStack {
                            Text(speciesGroup)
                                .foregroundColor(.primary)
                            Spacer()
                            Button {
                                withAnimation {
                                    isSpeciesGroupAdded = false
                                    speciesGroup = ""
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
                
                // Vocation Group
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Vocation Group")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Spacer()
                        if !isVocationGroupAdded && !isAddingVocation {
                            Button {
                                isAddingVocation = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    
                    if isAddingVocation {
                        HStack {
                            TextField("Add Vocation Group", text: $vocationGroup)
                                .textInputAutocapitalization(.words)
                                .focused($focusedField, equals: .vocationGroup)
                                .textFieldStyle(.roundedBorder)
                            
                            Button {
                                addVocationGroup()
                                isAddingVocation = false
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Button {
                                vocationGroup = ""
                                isAddingVocation = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    
                    if isVocationGroupAdded {
                        HStack {
                            Text(vocationGroup)
                                .foregroundColor(.primary)
                            Spacer()
                            Button {
                                withAnimation {
                                    isVocationGroupAdded = false
                                    vocationGroup = ""
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
                
                // Affiliation Groups
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Affiliation Groups")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Spacer()
                        if !isAddingAffiliation {
                            Button {
                                isAddingAffiliation = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    
                    if isAddingAffiliation {
                        HStack {
                            TextField("Add Affiliation Group", text: $newAffiliationGroup)
                                .textInputAutocapitalization(.words)
                                .focused($focusedField, equals: .newAffiliationGroup)
                                .textFieldStyle(.roundedBorder)
                            
                            Button {
                                addAffiliationGroup()
                                isAddingAffiliation = false
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Button {
                                newAffiliationGroup = ""
                                isAddingAffiliation = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    
                    if !affiliationGroups.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(affiliationGroups, id: \.self) { group in
                                    HStack {
                                        Text(group)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Button {
                                            withAnimation {
                                                removeAffiliationGroup(group)
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
                
                // Attribute-Group Pairs
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Attribute-Group Pairs")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Spacer()
                        if !isAddingAttributeGroup {
                            Button {
                                isAddingAttributeGroup = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    
                    ForEach(attributeGroupPairs) { pair in
                        HStack {
                            Text(pair.attribute)
                                .font(.system(.body, design: .rounded))
                                .frame(minWidth: 100, alignment: .leading)
                            Text(pair.group)
                                .foregroundColor(.primary)
                            Spacer()
                            Button {
                                withAnimation {
                                    attributeGroupPairs.removeAll { $0.id == pair.id }
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
                    
                    if isAddingAttributeGroup {
                        VStack(alignment: .leading, spacing: 12) {
                            Menu {
                                ForEach(["Strength", "Agility", "Toughness", "Intelligence", "Willpower", "Charisma"], id: \.self) { attribute in
                                    Button(attribute) {
                                        selectedAttribute = attribute
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedAttribute.isEmpty ? "Select Attribute" : selectedAttribute)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.up.chevron.down")
                                        .imageScale(.small)
                                        .foregroundColor(.secondary)
                                }
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            
                            HStack {
                                TextField("Enter group name", text: $newAttributeGroup)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusedField, equals: .newAttributeGroup)
                                
                                Button {
                                    addAttributeGroupPair()
                                    isAddingAttributeGroup = false
                                } label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .imageScale(.large)
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundColor(.green)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                
                                Button {
                                    newAttributeGroup = ""
                                    selectedAttribute = ""
                                    isAddingAttributeGroup = false
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .imageScale(.large)
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private func addSpeciesGroup() {
        let trimmed = speciesGroup.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        withAnimation {
            isSpeciesGroupAdded = true
            focusedField = nil
        }
    }
    
    private func addVocationGroup() {
        let trimmed = vocationGroup.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        withAnimation {
            isVocationGroupAdded = true
            focusedField = nil
        }
    }
    
    private func addAffiliationGroup() {
        let trimmed = newAffiliationGroup.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        withAnimation {
            affiliationGroups.append(trimmed)
            newAffiliationGroup = ""
            focusedField = nil
        }
    }
    
    private func removeAffiliationGroup(_ group: String) {
        withAnimation {
            affiliationGroups.removeAll { $0 == group }
        }
    }
    
    private func addAttributeGroupPair() {
        let trimmed = newAttributeGroup.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty && !selectedAttribute.isEmpty else { return }
        withAnimation {
            attributeGroupPairs.append(AttributeGroupPair(attribute: selectedAttribute, group: trimmed))
            newAttributeGroup = ""
            selectedAttribute = ""
            focusedField = nil
        }
    }
}
