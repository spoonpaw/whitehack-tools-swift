// FormOtherInformationSection.swift
import SwiftUI
import PhosphorSwift

struct FormOtherInformationSection: View {
    @Binding var experience: String
    @Binding var corruption: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        Section(header: HStack(spacing: 8) {
            Ph.info.bold
                .frame(width: 20, height: 20)
            Text("Additional Information")
        }
        .font(.headline)) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Experience (XP)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter experience", text: $experience)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .experience)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Corruption")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter corruption", text: $corruption)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .corruption)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}
