import SwiftUI
import PhosphorSwift

struct FormCharacterGroupsSection: View {
    @Binding var speciesGroup: String
    @Binding var vocationGroup: String
    @Binding var affiliationGroups: [String]
    @Binding var newAffiliationGroup: String
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    @Binding var isSpeciesGroupAdded: Bool
    @Binding var isVocationGroupAdded: Bool
    @Binding var useCustomAttributes: Bool
    @Binding var customAttributes: [CustomAttribute]
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    // Track previous values for group updates
    @State private var previousSpeciesGroup: String = ""
    @State private var previousVocationGroup: String = ""
    
    private let defaultAttributes = ["Strength", "Agility", "Toughness", "Intelligence", "Willpower", "Charisma"]
    
    private var availableGroups: [String] {
        var groups: [String] = []
        if !speciesGroup.isEmpty { groups.append(speciesGroup) }
        if !vocationGroup.isEmpty { groups.append(vocationGroup) }
        groups.append(contentsOf: affiliationGroups)
        return groups
    }
    
    private var availableAttributes: [String] {
        if useCustomAttributes {
            return customAttributes
                .map { $0.name }
                .filter { !$0.isEmpty }
        } else {
            return defaultAttributes
        }
    }
    
    private var filteredAttributeGroupPairs: [AttributeGroupPair] {
        attributeGroupPairs.filter { pair in
            availableAttributes.contains(pair.attribute) && availableGroups.contains(pair.group)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Character Groups", icon: Ph.usersThree.bold)
            
            VStack(spacing: 16) {
                // Species Group
                VStack(alignment: .leading, spacing: 8) {
                    Text("Species Group")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    if !isSpeciesGroupAdded {
                        Button {
                            withAnimation(.easeInOut) {
                                isSpeciesGroupAdded = true
                            }
                        } label: {
                            HStack {
                                Text("Add Species Group")
                                    .foregroundColor(.blue)
                                Spacer()
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.medium)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(.background)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    } else {
                        HStack {
                            TextField("Species Group", text: $speciesGroup)
                                #if os(iOS)
                                .textInputAutocapitalization(.words)
                                #endif
                                .textFieldStyle(.roundedBorder)
                                .onAppear {
                                    previousSpeciesGroup = speciesGroup
                                }
                                .onChange(of: speciesGroup) { newValue in
                                    attributeGroupPairs = attributeGroupPairs.map { pair in
                                        if pair.group == previousSpeciesGroup {
                                            return AttributeGroupPair(attribute: pair.attribute, group: newValue)
                                        }
                                        return pair
                                    }
                                    previousSpeciesGroup = newValue
                                }
                            
                            Button {
                                withAnimation(.easeInOut) {
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
                        .padding(12)
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
                
                // Vocation Group
                VStack(alignment: .leading, spacing: 8) {
                    Text("Vocation Group")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    if !isVocationGroupAdded {
                        Button {
                            withAnimation(.easeInOut) {
                                isVocationGroupAdded = true
                            }
                        } label: {
                            HStack {
                                Text("Add Vocation Group")
                                    .foregroundColor(.blue)
                                Spacer()
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.medium)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(.background)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    } else {
                        HStack {
                            TextField("Vocation Group", text: $vocationGroup)
                                #if os(iOS)
                                .textInputAutocapitalization(.words)
                                #endif
                                .textFieldStyle(.roundedBorder)
                                .onAppear {
                                    previousVocationGroup = vocationGroup
                                }
                                .onChange(of: vocationGroup) { newValue in
                                    attributeGroupPairs = attributeGroupPairs.map { pair in
                                        if pair.group == previousVocationGroup {
                                            return AttributeGroupPair(attribute: pair.attribute, group: newValue)
                                        }
                                        return pair
                                    }
                                    previousVocationGroup = newValue
                                }
                            
                            Button {
                                withAnimation(.easeInOut) {
                                    attributeGroupPairs.removeAll { $0.group == vocationGroup }
                                    vocationGroup = ""
                                    isVocationGroupAdded = false
                                }
                            } label: {
                                Image(systemName: "trash.circle.fill")
                                    .imageScale(.medium)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .padding(12)
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
                
                // Affiliation Groups
                VStack(alignment: .leading, spacing: 8) {
                    Text("Affiliation Groups")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    FormAffiliationGroupsView(
                        affiliationGroups: $affiliationGroups,
                        newAffiliationGroup: $newAffiliationGroup,
                        attributeGroupPairs: $attributeGroupPairs,
                        focusedField: $focusedField
                    )
                }
                
                // Attribute Group Pairs
                VStack(alignment: .leading, spacing: 8) {
                    Text("Attribute Groups")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    FormAttributeGroupPairsView(
                        attributes: availableAttributes,
                        attributeGroupPairs: $attributeGroupPairs,
                        availableGroups: availableGroups,
                        displayedPairs: filteredAttributeGroupPairs
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.background)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}
