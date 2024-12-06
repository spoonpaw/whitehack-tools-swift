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
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
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
        ["Strength", "Agility", "Toughness", "Intelligence", "Willpower", "Charisma"]
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
                
                FormVocationGroupView(
                    vocationGroup: $vocationGroup,
                    isVocationGroupAdded: $isVocationGroupAdded,
                    attributeGroupPairs: $attributeGroupPairs,
                    focusedField: $focusedField
                )
                
                FormAffiliationGroupsView(
                    affiliationGroups: $affiliationGroups,
                    newAffiliationGroup: $newAffiliationGroup,
                    attributeGroupPairs: $attributeGroupPairs
                )
                
                FormAttributeGroupPairsView(
                    attributes: availableAttributes,
                    attributeGroupPairs: $attributeGroupPairs,
                    availableGroups: availableGroups
                )
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
