// FormBasicInfoSection.swift
import SwiftUI

struct FormBasicInfoSection: View {
    @Binding var name: String
    @Binding var selectedClass: CharacterClass
    @Binding var level: String
    let focusedField: FocusState<CharacterFormView.Field?>.Binding

    var body: some View {
        Section(header: Text("Basic Info").font(.headline)) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter name", text: $name)
                    .textInputAutocapitalization(.words)
                    .focused(focusedField, equals: .name)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Level")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter level", text: $level)
                    .keyboardType(.numberPad)
                    .focused(focusedField, equals: .level)
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
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                }
            }
        }
    }
}
