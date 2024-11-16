// BasicInfoSection.swift
import SwiftUI

struct BasicInfoSection: View {
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
                Picker("Class", selection: $selectedClass) {
                    ForEach(CharacterClass.allCases, id: \.self) { characterClass in
                        Text(characterClass.rawValue).tag(characterClass)
                    }
                }
                .pickerStyle(.menu)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Level")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter level", text: $level)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .level)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}
