// FormOtherInformationSection.swift
import SwiftUI
import PhosphorSwift

struct FormOtherInformationSection: View {
    @Binding var experience: String
    @Binding var corruption: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        Section {
            Group {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Experience (XP)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("Enter experience", text: $experience)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif
                        .focused($focusedField, equals: .experience)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Corruption")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("Enter corruption", text: $corruption)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif
                        .focused($focusedField, equals: .corruption)
                        .textFieldStyle(.roundedBorder)
                }
            }
        } header: {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .frame(width: 20, height: 20)
                Text("Additional Information")
            }
            .font(.headline)
        }
    }
}
