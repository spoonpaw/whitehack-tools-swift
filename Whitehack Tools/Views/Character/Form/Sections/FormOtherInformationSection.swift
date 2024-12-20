// FormOtherInformationSection.swift
import SwiftUI
import PhosphorSwift

struct FormOtherInformationSection: View {
    @Binding var experience: String
    @Binding var corruption: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            SectionHeader(title: "Other Information", icon: Ph.info.bold)
            
            // Content
            VStack(spacing: 16) {
                Group {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Experience (XP)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        NumericTextField(text: $experience, field: .experience, minValue: 0, maxValue: 999999999, focusedField: $focusedField)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Corruption")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        NumericTextField(text: $corruption, field: .corruption, minValue: 0, maxValue: 999999999, focusedField: $focusedField)
                            .textFieldStyle(.roundedBorder)
                    }
                }
            }
        }
    }
}
