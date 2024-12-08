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
    
    var body: some View {
        Section {
            VStack(spacing: 16) {
                FormSpeciesGroupView(
                    speciesGroup: $speciesGroup,
                    isSpeciesGroupAdded: $isSpeciesGroupAdded,
                    attributeGroupPairs: $attributeGroupPairs,
                    focusedField: $focusedField
                )
                .padding()
                .background(.background)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                FormVocationGroupView(
                    vocationGroup: $vocationGroup,
                    isVocationGroupAdded: $isVocationGroupAdded,
                    attributeGroupPairs: $attributeGroupPairs,
                    focusedField: $focusedField
                )
                .padding()
                .background(.background)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                FormAffiliationGroupsView(
                    affiliationGroups: $affiliationGroups,
                    newAffiliationGroup: $newAffiliationGroup,
                    attributeGroupPairs: $attributeGroupPairs
                )
                .padding()
                .background(.background)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                FormAttributeGroupPairsView(
                    attributes: availableAttributes,
                    attributeGroupPairs: $attributeGroupPairs,
                    availableGroups: availableGroups,
                    displayedPairs: filteredAttributeGroupPairs
                )
                .padding()
                .background(.background)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            .padding(.vertical, 8)
        } header: {
            HStack(spacing: 8) {
                Ph.usersThree.bold
                    .frame(width: 20, height: 20)
                Text("Character Groups")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 4)
        }
    }
}
