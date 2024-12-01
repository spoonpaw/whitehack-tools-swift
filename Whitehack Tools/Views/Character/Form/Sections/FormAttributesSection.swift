import SwiftUI
import PhosphorSwift

struct FormAttributesSection: View {
    @Binding var strength: String
    @Binding var agility: String
    @Binding var toughness: String
    @Binding var intelligence: String
    @Binding var willpower: String
    @Binding var charisma: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    private let attributeRange = 3...18
    
    var body: some View {
        Section(header: SectionHeader(title: "Attributes", icon: Ph.gauge.bold)) {
            AttributeEditor(
                label: "Strength",
                value: $strength,
                range: attributeRange,
                focusedField: focusedField,
                field: .strength,
                focusBinding: $focusedField
            )
            
            AttributeEditor(
                label: "Agility",
                value: $agility,
                range: attributeRange,
                focusedField: focusedField,
                field: .agility,
                focusBinding: $focusedField
            )
            
            AttributeEditor(
                label: "Toughness",
                value: $toughness,
                range: attributeRange,
                focusedField: focusedField,
                field: .toughness,
                focusBinding: $focusedField
            )
            
            AttributeEditor(
                label: "Intelligence",
                value: $intelligence,
                range: attributeRange,
                focusedField: focusedField,
                field: .intelligence,
                focusBinding: $focusedField
            )
            
            AttributeEditor(
                label: "Willpower",
                value: $willpower,
                range: attributeRange,
                focusedField: focusedField,
                field: .willpower,
                focusBinding: $focusedField
            )
            
            AttributeEditor(
                label: "Charisma",
                value: $charisma,
                range: attributeRange,
                focusedField: focusedField,
                field: .charisma,
                focusBinding: $focusedField
            )
        }
    }
}
