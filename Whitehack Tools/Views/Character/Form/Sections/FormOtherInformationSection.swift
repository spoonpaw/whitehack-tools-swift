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
                            .onChange(of: focusedField) { newValue in
                                print(" [xp focus] Focus changed from \(String(describing: focusedField)) to \(String(describing: newValue))")
                                print(" [xp focus] Current value: '\(experience)', isEmpty: \(experience.isEmpty)")
                                
                                // Clean up on focus loss
                                if newValue != .experience && experience.isEmpty {
                                    print(" [xp focus] Setting empty field to default: 0")
                                    experience = "0"
                                }
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Corruption")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        NumericTextField(text: $corruption, field: .corruption, minValue: 0, maxValue: 999999999, focusedField: $focusedField)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: focusedField) { newValue in
                                print(" [corruption focus] Focus changed from \(String(describing: focusedField)) to \(String(describing: newValue))")
                                print(" [corruption focus] Current value: '\(corruption)', isEmpty: \(corruption.isEmpty)")
                                
                                // Clean up on focus loss
                                if newValue != .corruption && corruption.isEmpty {
                                    print(" [corruption focus] Setting empty field to default: 0")
                                    corruption = "0"
                                }
                            }
                    }
                }
            }
        }
    }
}
