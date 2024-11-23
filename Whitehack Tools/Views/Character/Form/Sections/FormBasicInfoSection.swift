// FormBasicInfoSection.swift
import SwiftUI

struct FormBasicInfoSection: View {
    @Binding var name: String
    @Binding var selectedClass: CharacterClass
    @Binding var level: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        Section(header: Text("Basic Info").font(.headline)) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter name", text: $name)
                    .textInputAutocapitalization(.words)
                    .focused($focusedField, equals: .name)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Class")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    Menu {
                        Picker("", selection: $selectedClass) {
                            ForEach([
                                CharacterClass.deft,
                                CharacterClass.strong,
                                CharacterClass.wise,
                                CharacterClass.brave,
                                CharacterClass.clever,
                                CharacterClass.fortunate
                            ], id: \.self) { characterClass in
                                Text(characterClass.rawValue).tag(characterClass)
                            }
                        }
                        .pickerStyle(.inline)
                        .labelsHidden()
                    } label: {
                        HStack {
                            Text(selectedClass.rawValue)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.up.chevron.down")
                                .foregroundColor(.secondary)
                                .imageScale(.small)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Level")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("(1-10)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                TextField("Level", text: $level)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .level)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: level) { newValue in
                        // Only allow numbers
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            level = filtered
                        }
                        
                        // Don't allow more than 2 digits
                        if filtered.count > 2 {
                            level = String(filtered.prefix(2))
                        }
                    }
                    .onSubmit {
                        validateAndCorrectLevel()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification)) { _ in
                        validateAndCorrectLevel()
                    }
            }
        }
    }
    
    private func validateAndCorrectLevel() {
        if let intValue = Int(level) {
            if intValue < 1 {
                level = "1"
            } else if intValue > 10 {
                level = "10"
            }
        } else if level.isEmpty {
            level = "1"
        }
    }
}
