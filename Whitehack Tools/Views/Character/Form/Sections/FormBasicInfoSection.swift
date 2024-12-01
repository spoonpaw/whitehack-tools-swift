// FormBasicInfoSection.swift
import SwiftUI
import PhosphorSwift

struct FormBasicInfoSection: View {
    @Binding var name: String
    @Binding var playerName: String
    @Binding var selectedClass: CharacterClass
    @Binding var level: String
    var focusedField: CharacterFormView.Field?
    @FocusState.Binding var focusBinding: CharacterFormView.Field?

    var body: some View {
        Section(header: SectionHeader(title: "Basic Info", icon: Ph.identificationCard.bold)) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Character Name")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("", text: $name)
                    .textInputAutocapitalization(.words)
                    .focused($focusBinding, equals: .name)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Player Name")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("", text: $playerName)
                    .textInputAutocapitalization(.words)
                    .focused($focusBinding, equals: .playerName)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Level")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter level", text: $level)
                    .keyboardType(.numberPad)
                    .focused($focusBinding, equals: .level)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Class")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Menu {
                    Picker("Class", selection: $selectedClass) {
                        ForEach(CharacterClass.allCases, id: \.self) { characterClass in
                            Text(characterClass.rawValue)
                                .tag(characterClass)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedClass.rawValue)
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundColor(.secondary)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
        }
    }
}
