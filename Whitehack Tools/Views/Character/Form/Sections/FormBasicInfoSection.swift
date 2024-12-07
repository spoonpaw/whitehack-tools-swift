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
            VStack(spacing: 16) {
                VStack(alignment: .center, spacing: 5) {
                    Text("Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $name)
                        .focused($focusedField, equals: .name)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("Player Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $playerName)
                        .focused($focusedField, equals: .playerName)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("Level")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $level)
                        .focused($focusedField, equals: .level)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("Character Class")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Picker("", selection: $selectedClass) {
                        ForEach(CharacterClass.allCases, id: \.self) { characterClass in
                            Text(characterClass.rawValue)
                                .tag(characterClass)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        } header: {
            HStack(spacing: 8) {
                Ph.identificationCard.bold
                    .frame(width: 20, height: 20)
                Text("Basic Information")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
    }
}
