// CombatStatsSection.swift
import SwiftUI

struct FormCombatStatsSection: View {
    @Binding var currentHP: String
    @Binding var maxHP: String
    @Binding var defenseValue: String
    @Binding var movement: String
    @Binding var saveColor: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        Section(header: Text("Combat Stats").font(.headline)) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Current HP")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack(spacing: 8) {
                    // Minus button
                    Button(action: {
                        if let value = Int(currentHP) {
                            currentHP = String(max(-999, value - 1))
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    TextField("Enter current HP", text: $currentHP)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .currentHP)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .onChange(of: currentHP) { newValue in
                            let filtered = newValue.filter { "-0123456789".contains($0) }
                            // Only allow one minus sign at the start
                            if filtered.filter({ $0 == "-" }).count > 1 {
                                currentHP = String(filtered.prefix(1)) + filtered.dropFirst().filter { $0 != "-" }
                            } else if filtered != newValue {
                                currentHP = filtered
                            }
                            validateAndCorrectCurrentHP()
                        }
                    
                    // Plus button
                    Button(action: {
                        if let value = Int(currentHP) {
                            let newValue = value + 1
                            if let maxValue = Int(maxHP), newValue <= maxValue {
                                currentHP = String(newValue)
                            }
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Max HP")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("(min: 1)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                TextField("Enter max HP", text: $maxHP)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .maxHP)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: maxHP) { newValue in
                        // Only allow numbers
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            maxHP = filtered
                        }
                        
                        // Don't allow ridiculously large numbers
                        if filtered.count > 3 {
                            maxHP = String(filtered.prefix(3))
                        }
                    }
                    .onSubmit {
                        validateAndCorrectMaxHP()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification)) { _ in
                        validateAndCorrectMaxHP()
                    }
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
                Text("Save Color")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter save color", text: $saveColor)
                    .focused($focusedField, equals: .saveColor)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
    
    private func validateAndCorrectMaxHP() {
        if let intValue = Int(maxHP) {
            if intValue < 1 {
                maxHP = "1"
            }
            
            // If maxHP is lowered, ensure currentHP doesn't exceed it
            if let currentValue = Int(currentHP), currentValue > intValue {
                currentHP = maxHP
            }
        } else if maxHP.isEmpty {
            maxHP = "1"
        }
    }
    
    private func validateAndCorrectCurrentHP() {
        if let currentValue = Int(currentHP) {
            // Don't allow ridiculously large numbers
            if abs(currentValue) > 999 {
                currentHP = String(currentValue > 0 ? 999 : -999)
            }
            
            // Don't exceed maxHP
            if let maxValue = Int(maxHP), currentValue > maxValue {
                currentHP = maxHP
            }
        } else if currentHP.isEmpty {
            currentHP = "0"
        }
    }
}
