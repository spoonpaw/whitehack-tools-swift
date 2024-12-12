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
                                currentHP = String(max(-999, value - 1))
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        TextField("Enter current HP", text: $currentHP)
                            #if os(iOS)
                            .keyboardType(.numberPad)
                            #endif
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
                        
                        TextField("Enter max HP", text: $maxHP)
                            #if os(iOS)
                            .keyboardType(.numberPad)
                            #endif
                            .focused($focusedField, equals: .maxHP)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .onChange(of: maxHP) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    maxHP = filtered
                                }
                                validateAndCorrectMaxHP()
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
                    TextField("Enter movement", text: $movement)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif
                        .focused($focusedField, equals: .movement)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: movement) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                movement = filtered
                            }
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
            }
        }
    }
    
    private func validateAndCorrectMaxHP() {
        if let intValue = Int(maxHP) {
            if intValue < 1 {
                maxHP = "1"
            }
        } else if maxHP.isEmpty {
            maxHP = "1"
        }
    }
    
    private func validateAndCorrectCurrentHP() {
        if let currentValue = Int(currentHP), let maxValue = Int(maxHP) {
            if currentValue > maxValue {
                currentHP = maxHP
            } else if currentValue < -999 {
                currentHP = "-999"
            }
        }
    }
}
