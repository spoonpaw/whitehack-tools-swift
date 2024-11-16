// EncumbranceSection.swift
import SwiftUI

struct EncumbranceSection: View {
    @Binding var currentEncumbrance: String
    @Binding var maxEncumbrance: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        Section(header: Text("Encumbrance").font(.headline)) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Current Encumbrance")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter current encumbrance", text: $currentEncumbrance)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .currentEncumbrance)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Max Encumbrance")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter max encumbrance", text: $maxEncumbrance)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .maxEncumbrance)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}
