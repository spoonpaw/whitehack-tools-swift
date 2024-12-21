import SwiftUI
import PhosphorSwift

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

struct FormCombatStatsSection: View {
    @Binding var currentHP: String
    @Binding var maxHP: String
    @Binding var movement: String
    @Binding var saveColor: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        Section {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Current HP")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack(spacing: 8) {
                        Button(action: {
                            if let value = Int(currentHP) {
                                currentHP = String(max(-9999, value - 1))
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        NumericTextField(text: $currentHP, field: .currentHP, minValue: -9999, maxValue: Int(maxHP) ?? 9999, focusedField: $focusedField)
                            .frame(maxWidth: .infinity)
                            .onChange(of: currentHP) { newValue in
                                validateAndCorrectCurrentHP()
                            }
                        
                        Button(action: {
                            if let value = Int(currentHP) {
                                let newValue = value + 1
                                if let maxValue = Int(maxHP), newValue <= maxValue {
                                    currentHP = String(min(9999, newValue))
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
                    HStack(spacing: 8) {
                        Button(action: {
                            if let value = Int(maxHP) {
                                maxHP = String(max(1, value - 1))
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        NumericTextField(text: $maxHP, field: .maxHP, minValue: 1, maxValue: 9999, focusedField: $focusedField)
                            .frame(maxWidth: .infinity)
                            .onChange(of: maxHP) { newValue in
                                // When max HP changes, ensure current HP is not higher
                                if let maxValue = Int(newValue) {
                                    if let currentValue = Int(currentHP) {
                                        if currentValue > maxValue {
                                            currentHP = newValue
                                        }
                                    }
                                }
                            }
                        
                        Button(action: {
                            if let value = Int(maxHP) {
                                maxHP = String(value + 1)
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
                        Text("Movement")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("(ft)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    HStack(spacing: 8) {
                        Button(action: {
                            if let value = Int(movement) {
                                movement = String(max(0, value - 1))
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        NumericTextField(text: $movement, field: .movement, minValue: 0, maxValue: 999, focusedField: $focusedField)
                            .frame(maxWidth: .infinity)
                            .onChange(of: movement) { newValue in
                                validateAndCorrectMovement()
                            }
                        
                        Button(action: {
                            if let value = Int(movement) {
                                movement = String(min(999, value + 1))
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
                    Text("Save Color")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("Enter save color", text: $saveColor)
                        .focused($focusedField, equals: .saveColor)
                        .textFieldStyle(.roundedBorder)
                }
            }
        } header: {
            HStack(spacing: 8) {
                Ph.boxingGlove.bold
                    .frame(width: 20, height: 20)
                Text("Combat Stats")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func validateAndCorrectCurrentHP() {
        // Handle empty fields
        if currentHP.isEmpty || maxHP.isEmpty {
            return
        }
        
        // Ensure current HP is not higher than max HP
        if let maxValue = Int(maxHP), let currentValue = Int(currentHP) {
            if currentValue > maxValue {
                currentHP = maxHP
            }
        }
    }
    
    private func validateAndCorrectMovement() {
        if let value = Int(movement) {
            if value < 0 {
                movement = "0"
            } else if value > 999 {
                movement = "999"
            }
        }
    }
}
