import SwiftUI
import PhosphorSwift

struct FormCharacterGroupsSection: View {
    @Binding var speciesGroup: String
    @Binding var vocationGroup: String
    @Binding var affiliationGroups: [String]
    @Binding var newAffiliationGroup: String
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    @Binding var selectedAttribute: String
    @Binding var newAttributeGroup: String
    @Binding var isSpeciesGroupAdded: Bool
    @Binding var isVocationGroupAdded: Bool
    @Binding var useCustomAttributes: Bool
    @Binding var customAttributes: [CustomAttribute]
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    private let defaultAttributes = ["Strength", "Agility", "Toughness", "Intelligence", "Willpower", "Charisma"]
    
    private var availableGroups: [String] {
        var groups: [String] = []
        if isSpeciesGroupAdded, !speciesGroup.isEmpty {
            groups.append(speciesGroup)
        }
        if isVocationGroupAdded, !vocationGroup.isEmpty {
            groups.append(vocationGroup)
        }
        groups.append(contentsOf: affiliationGroups)
        return groups
    }
    
    private var availableAttributes: [String] {
        if useCustomAttributes {
            return customAttributes.map { $0.name }
        } else {
            return defaultAttributes
        }
    }
    
    private var filteredAttributeGroupPairs: [AttributeGroupPair] {
        if useCustomAttributes {
            let customAttributeNames = customAttributes.map { $0.name }
            return attributeGroupPairs.filter { customAttributeNames.contains($0.attribute) }
        } else {
            return attributeGroupPairs.filter { defaultAttributes.contains($0.attribute) }
        }
    }
    
    private func removeSpeciesGroup() {
        withAnimation {
            let oldGroup = speciesGroup
            speciesGroup = ""
            isSpeciesGroupAdded = false
            
            // Remove any attribute group pairs that reference the removed species group
            attributeGroupPairs.removeAll { pair in
                pair.group == oldGroup
            }
        }
    }
    
    private func removeVocationGroup() {
        withAnimation {
            let oldGroup = vocationGroup
            vocationGroup = ""
            isVocationGroupAdded = false
            
            // Remove any attribute group pairs that reference the removed vocation group
            attributeGroupPairs.removeAll { pair in
                pair.group == oldGroup
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Character Groups", icon: Ph.usersThree.bold)
            
            VStack(spacing: 16) {
                FormSpeciesGroupView(
                    speciesGroup: $speciesGroup,
                    isSpeciesGroupAdded: $isSpeciesGroupAdded,
                    attributeGroupPairs: $attributeGroupPairs,
                    focusedField: $focusedField,
                    onRemove: removeSpeciesGroup
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.background)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                FormVocationGroupView(
                    vocationGroup: $vocationGroup,
                    isVocationGroupAdded: $isVocationGroupAdded,
                    attributeGroupPairs: $attributeGroupPairs,
                    focusedField: $focusedField,
                    onRemove: removeVocationGroup
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.background)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                FormAffiliationGroupsView(
                    affiliationGroups: $affiliationGroups,
                    newAffiliationGroup: $newAffiliationGroup,
                    attributeGroupPairs: $attributeGroupPairs
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.background)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                FormAttributeGroupPairsView(
                    attributes: availableAttributes,
                    attributeGroupPairs: $attributeGroupPairs,
                    availableGroups: availableGroups,
                    displayedPairs: filteredAttributeGroupPairs,
                    selectedAttribute: $selectedAttribute,
                    newAttributeGroup: $newAttributeGroup
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.background)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            .padding(.vertical, 8)
        }
    }
}
