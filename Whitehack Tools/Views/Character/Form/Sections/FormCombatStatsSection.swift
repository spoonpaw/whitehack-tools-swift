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
    
    private var currentMaxHP: Int {
        let value = Int(maxHP) ?? 9999
        print("⚔️ [currentMaxHP] maxHP string: \(maxHP), parsed: \(value)")
        return value
    }
    
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
                        
                        NumericTextField(text: $currentHP, field: .currentHP, minValue: -9999, maxValue: currentMaxHP, defaultValue: 0, focusedField: $focusedField)
                            .frame(maxWidth: .infinity)
                            .onChange(of: currentHP) { newValue in
                                print("⚔️ [currentHP onChange] Value changed to: '\(newValue)'")
                                
                                // Allow empty during editing
                                if newValue.isEmpty {
                                    print("⚔️ [currentHP onChange] Empty value during editing")
                                    return
                                }
                                
                                // If we have a valid number, ensure it doesn't exceed maxHP
                                if !maxHP.isEmpty,
                                   let currentValue = Int(newValue),
                                   let maxValue = Int(maxHP) {
                                    print("⚔️ [currentHP onChange] Checking value: \(currentValue) against max: \(maxValue)")
                                    if currentValue > maxValue {
                                        print("⚔️ [currentHP onChange] Value too high, setting to max")
                                        currentHP = maxHP
                                    }
                                }
                            }
                            .onChange(of: focusedField) { newValue in
                                print("⚔️ [currentHP focus] Focus changed from \(String(describing: focusedField)) to \(String(describing: newValue))")
                                print("⚔️ [currentHP focus] Current value: '\(currentHP)', isEmpty: \(currentHP.isEmpty)")
                                
                                // Clean up on focus loss
                                if newValue != .currentHP {
                                    print("⚔️ [currentHP focus] Field lost focus")
                                    if currentHP.isEmpty {
                                        print("⚔️ [currentHP focus] Setting empty field to default: 0")
                                        currentHP = "0"
                                    }
                                    validateAndCorrectCurrentHP()
                                }
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
                                print("\n⚔️ [maxHP onChange] ==================")
                                print("⚔️ [maxHP onChange] Value changed to: '\(newValue)'")
                                print("⚔️ [maxHP onChange] Current HP is: '\(currentHP)'")
                                print("⚔️ [maxHP onChange] Focus is on: \(String(describing: focusedField))")
                                
                                // Allow empty during editing
                                if newValue.isEmpty {
                                    print("⚔️ [maxHP onChange] Empty value during editing, allowing it")
                                    return
                                }
                                
                                // If we have a valid number, ensure currentHP doesn't exceed it
                                if !currentHP.isEmpty,
                                   let maxValue = Int(newValue),
                                   let currentValue = Int(currentHP) {
                                    print("⚔️ [maxHP onChange] Checking currentHP: \(currentValue) against new max: \(maxValue)")
                                    if currentValue > maxValue {
                                        print("⚔️ [maxHP onChange] Current HP too high, adjusting to new max")
                                        currentHP = newValue
                                    }
                                }
                            }
                            .onChange(of: focusedField) { newValue in
                                print("\n⚔️ [maxHP focus] ==================")
                                print("⚔️ [maxHP focus] Focus changed from \(String(describing: focusedField)) to \(String(describing: newValue))")
                                print("⚔️ [maxHP focus] Current maxHP: '\(maxHP)', isEmpty: \(maxHP.isEmpty)")
                                print("⚔️ [maxHP focus] Current HP is: '\(currentHP)'")
                                
                                // Clean up on focus loss
                                if newValue != .maxHP {
                                    print("⚔️ [maxHP focus] Field lost focus")
                                    if maxHP.isEmpty {
                                        print("⚔️ [maxHP focus] Setting empty field to default: 1")
                                        maxHP = "1"
                                    }
                                    
                                    // Ensure currentHP is valid against new maxHP
                                    if let maxValue = Int(maxHP),
                                       let currentValue = Int(currentHP) {
                                        print("⚔️ [maxHP focus] Parsed maxHP: \(maxValue), currentHP: \(currentValue)")
                                        if currentValue > maxValue {
                                            print("⚔️ [maxHP focus] Current HP too high, adjusting to match max")
                                            currentHP = maxHP
                                        }
                                    } else {
                                        print("⚔️ [maxHP focus] Failed to parse either maxHP or currentHP")
                                    }
                                }
                                print("⚔️ [maxHP focus] Final values - maxHP: '\(maxHP)', currentHP: '\(currentHP)'")
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
                            .onChange(of: focusedField) { newValue in
                                print("⚔️ [movement focus] Focus changed from \(String(describing: focusedField)) to \(String(describing: newValue))")
                                print("⚔️ [movement focus] Current value: '\(movement)', isEmpty: \(movement.isEmpty)")
                                if newValue != .movement {  // Field lost focus
                                    if movement.isEmpty {
                                        print("⚔️ [movement focus] Setting empty field to default: 30")
                                        movement = "30"
                                    } else {
                                        validateAndCorrectMovement()
                                    }
                                }
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
        print("⚔️ [validateAndCorrectCurrentHP] START - currentHP: '\(currentHP)', maxHP: '\(maxHP)'")
        
        // Handle empty fields
        if currentHP.isEmpty {
            print("⚔️ [validateAndCorrectCurrentHP] Current HP empty, setting to 0")
            currentHP = "0"
            return
        }
        
        if maxHP.isEmpty {
            print("⚔️ [validateAndCorrectCurrentHP] Max HP empty, using default max of 1")
            maxHP = "1"
        }
        
        // Parse and validate the values
        if let currentValue = Int(currentHP) {
            print("⚔️ [validateAndCorrectCurrentHP] Parsed current value: \(currentValue)")
            
            // First ensure within global bounds
            let boundedValue = max(-9999, min(9999, currentValue))
            if boundedValue != currentValue {
                print("⚔️ [validateAndCorrectCurrentHP] Adjusting to global bounds: \(boundedValue)")
                currentHP = String(boundedValue)
                return
            }
            
            // Remove leading zeros if present
            if currentHP.hasPrefix("0") && currentHP != "0" {
                print("⚔️ [validateAndCorrectCurrentHP] Removing leading zeros from: '\(currentHP)'")
                currentHP = String(currentValue)
                return
            }
            
            // Then check against max HP
            if let maxValue = Int(maxHP) {
                print("⚔️ [validateAndCorrectCurrentHP] Checking against max HP: \(maxValue)")
                if currentValue > maxValue {
                    print("⚔️ [validateAndCorrectCurrentHP] Current HP too high, setting to max: \(maxValue)")
                    currentHP = String(maxValue)
                }
            }
        } else {
            print("⚔️ [validateAndCorrectCurrentHP] Failed to parse current HP, setting to 0")
            currentHP = "0"
        }
        
        print("⚔️ [validateAndCorrectCurrentHP] END - final currentHP: '\(currentHP)'")
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
