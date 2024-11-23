import SwiftUI

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
    
    // Helper computed property to get all available groups
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

    var body: some View {
        Section(header: Text("Group Associations").font(.headline)) {
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
                    attributeGroupPairs: $attributeGroupPairs,
                    focusedField: $focusedField
                )
                
                FormAttributeGroupPairsView(
                    attributeGroupPairs: $attributeGroupPairs,
                    selectedAttribute: $selectedAttribute,
                    newAttributeGroup: $newAttributeGroup,
                    availableGroups: availableGroups,
                    focusedField: $focusedField
                )
            }
            .padding(.vertical, 8)
        }
    }
}
