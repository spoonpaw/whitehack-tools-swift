import SwiftUI
import PhosphorSwift

struct FormSectionHeader: View {
    let title: String
    let icon: Image
    
    var body: some View {
        HStack(spacing: 8) {
            icon
                .frame(width: 20, height: 20)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

struct FormAttributesSection: View {
    @Binding var strength: String
    @Binding var agility: String
    @Binding var toughness: String
    @Binding var intelligence: String
    @Binding var willpower: String
    @Binding var charisma: String
    @FocusState private var focusedField: CharacterFormView.Field?
    
    private let attributeRange = 3...18
    
    var body: some View {
        Section {
            VStack(spacing: 16) {
                AttributeEditor(
                    label: "Strength",
                    value: $strength,
                    range: attributeRange,
                    field: .strength
                )
                
                AttributeEditor(
                    label: "Agility",
                    value: $agility,
                    range: attributeRange,
                    field: .agility
                )
                
                AttributeEditor(
                    label: "Toughness",
                    value: $toughness,
                    range: attributeRange,
                    field: .toughness
                )
                
                AttributeEditor(
                    label: "Intelligence",
                    value: $intelligence,
                    range: attributeRange,
                    field: .intelligence
                )
                
                AttributeEditor(
                    label: "Willpower",
                    value: $willpower,
                    range: attributeRange,
                    field: .willpower
                )
                
                AttributeEditor(
                    label: "Charisma",
                    value: $charisma,
                    range: attributeRange,
                    field: .charisma
                )
            }
            .padding(.vertical, 8)
        } header: {
            HStack(spacing: 8) {
                Ph.barbell.bold
                    .frame(width: 20, height: 20)
                Text("Attributes")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 4)
        }
    }
}
