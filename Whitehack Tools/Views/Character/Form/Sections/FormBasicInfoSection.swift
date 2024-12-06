// FormBasicInfoSection.swift
import SwiftUI
import PhosphorSwift

struct FormBasicInfoSection: View {
    @Binding var name: String
    @Binding var playerName: String
    @Binding var selectedClass: CharacterClass
    @Binding var level: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 4) {
                Text("Character Name")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("", text: $name)
                    .textFieldStyle(.roundedBorder)
                    #if os(iOS)
                    .textInputAutocapitalization(.words)
                    #endif
                    .focused($focusedField, equals: .name)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Player Name")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("", text: $playerName)
                    .textFieldStyle(.roundedBorder)
                    #if os(iOS)
                    .textInputAutocapitalization(.words)
                    #endif
                    .focused($focusedField, equals: .playerName)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Level")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter level", text: $level)
                    .textFieldStyle(.roundedBorder)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
                    .focused($focusedField, equals: .level)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Class")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Picker("", selection: $selectedClass) {
                    ForEach(CharacterClass.allCases, id: \.self) { characterClass in
                        Text(characterClass.rawValue)
                            .tag(characterClass)
                    }
                }
                .pickerStyle(.menu)
            }
        } header: {
            HStack(spacing: 8) {
                Ph.identificationCard.bold
                    .frame(width: 20, height: 20)
                Text("Basic Info")
                    .font(.headline)
            }
        }
    }
}
