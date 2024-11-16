// CombatStatsSection.swift
import SwiftUI

struct CombatStatsSection: View {
    @Binding var currentHP: String
    @Binding var maxHP: String
    @Binding var attackValue: String
    @Binding var defenseValue: String
    @Binding var movement: String
    @Binding var saveValue: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        Section(header: Text("Combat Stats").font(.headline)) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Current HP")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter current HP", text: $currentHP)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .currentHP)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Max HP")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter max HP", text: $maxHP)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .maxHP)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Attack Value")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter attack value", text: $attackValue)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .attackValue)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Defense Value")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter defense value", text: $defenseValue)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .defenseValue)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Movement")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter movement", text: $movement)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .movement)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Save Value")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter save value", text: $saveValue)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .saveValue)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}
