// EncumbranceSection.swift
import SwiftUI
import PhosphorSwift

struct FormEncumbranceSection: View {
    @Binding var currentEncumbrance: String
    @Binding var maxEncumbrance: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 5) {
                Text("Current Encumbrance")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter current encumbrance", text: $currentEncumbrance)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
                    .focused($focusedField, equals: .currentEncumbrance)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Max Encumbrance")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter max encumbrance", text: $maxEncumbrance)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
                    .focused($focusedField, equals: .maxEncumbrance)
                    .textFieldStyle(.roundedBorder)
            }
        } header: {
            HStack(spacing: 8) {
                Ph.package.bold
                    .frame(width: 20, height: 20)
                Text("Encumbrance")
                    .font(.headline)
            }
        }
    }
}
