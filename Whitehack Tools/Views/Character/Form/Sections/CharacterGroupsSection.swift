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
    
    var body: some View {
        Section(header: Text("Group Associations").font(.headline)) {
            // Species Group
            VStack(alignment: .leading, spacing: 5) {
                Text("Species Group")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    TextField("Add Species Group", text: $speciesGroup)
                        .textInputAutocapitalization(.words)
                        .focused($focusedField, equals: .speciesGroup)
                        .textFieldStyle(.roundedBorder)
                    
                    if !isSpeciesGroupAdded && !speciesGroup.trimmingCharacters(in: .whitespaces).isEmpty {
                        Button {
                            withAnimation {
                                addSpeciesGroup()
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(.borderless)
                    }
                }
                
                if isSpeciesGroupAdded {
                    Text(speciesGroup)
                        .foregroundColor(.gray)
                        .padding(.vertical, 2)
                }
            }
            
            // Vocation Group
            VStack(alignment: .leading, spacing: 5) {
                Text("Vocation Group")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    TextField("Add Vocation Group", text: $vocationGroup)
                        .textInputAutocapitalization(.words)
                        .focused($focusedField, equals: .vocationGroup)
                        .textFieldStyle(.roundedBorder)
                    
                    if !isVocationGroupAdded && !vocationGroup.trimmingCharacters(in: .whitespaces).isEmpty {
                        Button {
                            withAnimation {
                                addVocationGroup()
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(.borderless)
                    }
                }
                
                if isVocationGroupAdded {
                    Text(vocationGroup)
                        .foregroundColor(.gray)
                        .padding(.vertical, 2)
                }
            }
            
            // Affiliation Groups
            VStack(alignment: .leading, spacing: 5) {
                Text("Affiliation Groups")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    TextField("Add Affiliation Group", text: $newAffiliationGroup)
                        .textInputAutocapitalization(.words)
                        .focused($focusedField, equals: .newAffiliationGroup)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            withAnimation {
                                addAffiliationGroup()
                            }
                        }
                    
                    Button {
                        withAnimation {
                            addAffiliationGroup()
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(newAffiliationGroup.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
                    }
                    .buttonStyle(.borderless)
                    .disabled(newAffiliationGroup.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                
                if !affiliationGroups.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(affiliationGroups, id: \.self) { group in
                                HStack {
                                    Text(group)
                                    Spacer()
                                    Button {
                                        withAnimation {
                                            removeAffiliationGroup(group)
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(.borderless)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 150)
                }
            }
            
            // Attribute-Group Pairs
            VStack(alignment: .leading, spacing: 5) {
                Text("Attribute-Group Pairs")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ForEach(attributeGroupPairs) { pair in
                    HStack {
                        Text(pair.attribute)
                            .frame(width: 100, alignment: .leading)
                        Text(pair.group)
                        Spacer()
                        Button {
                            withAnimation {
                                attributeGroupPairs.removeAll { $0.id == pair.id }
                            }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(.vertical, 2)
                }
                
                Divider()
                    .padding(.vertical, 5)
                
                HStack {
                    Picker("Attribute", selection: $selectedAttribute) {
                        Text("Strength").tag("Strength")
                        Text("Agility").tag("Agility")
                        Text("Toughness").tag("Toughness")
                        Text("Intelligence").tag("Intelligence")
                        Text("Willpower").tag("Willpower")
                        Text("Charisma").tag("Charisma")
                    }
                    .pickerStyle(.menu)
                    .frame(width: 120)
                    
                    TextField("Group", text: $newAttributeGroup)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .newAttributeGroup)
                        .onSubmit {
                            withAnimation {
                                addAttributeGroupPair()
                            }
                        }
                    
                    Button {
                        withAnimation {
                            addAttributeGroupPair()
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(newAttributeGroup.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
                    }
                    .buttonStyle(.borderless)
                    .disabled(newAttributeGroup.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func addSpeciesGroup() {
        let trimmed = speciesGroup.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        isSpeciesGroupAdded = true
        focusedField = nil
    }
    
    private func addVocationGroup() {
        let trimmed = vocationGroup.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        isVocationGroupAdded = true
        focusedField = nil
    }
    
    private func addAffiliationGroup() {
        let trimmed = newAffiliationGroup.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        affiliationGroups.append(trimmed)
        newAffiliationGroup = ""
        focusedField = nil
    }
    
    private func removeAffiliationGroup(_ group: String) {
        affiliationGroups.removeAll { $0 == group }
    }
    
    private func addAttributeGroupPair() {
        let trimmed = newAttributeGroup.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        attributeGroupPairs.append(AttributeGroupPair(attribute: selectedAttribute, group: trimmed))
        newAttributeGroup = ""
        focusedField = nil
    }
}
