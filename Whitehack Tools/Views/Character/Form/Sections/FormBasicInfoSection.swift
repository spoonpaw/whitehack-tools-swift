// FormBasicInfoSection.swift
import SwiftUI
import PhosphorSwift
#if os(iOS)
import UIKit
#else
import AppKit
#endif

struct FormBasicInfoSection: View {
    @Binding var name: String
    @Binding var playerName: String
    @Binding var selectedClass: CharacterClass
    @Binding var level: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    private var backgroundColor: Color {
        #if os(iOS)
        return Color(UIColor.secondarySystemBackground)
        #else
        return Color(NSColor.windowBackgroundColor)
        #endif
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            SectionHeader(title: "Basic Info", icon: Ph.userCircle.bold)
            
            // Content
            VStack(spacing: 16) {
                VStack(alignment: .center, spacing: 5) {
                    Text("Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $name)
                        .focused($focusedField, equals: .name)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("Player Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $playerName)
                        .focused($focusedField, equals: .playerName)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("Level")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    NumericTextField(text: $level, field: .level, minValue: 1, maxValue: 10, focusedField: $focusedField)
                        .onChange(of: focusedField) { newValue in
                            print(" [level focus] Focus changed from \(String(describing: focusedField)) to \(String(describing: newValue))")
                            print(" [level focus] Current value: '\(level)', isEmpty: \(level.isEmpty)")
                            
                            // Clean up on focus loss
                            if newValue != .level && level.isEmpty {
                                print(" [level focus] Setting empty field to default: 1")
                                level = "1"
                            }
                        }
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("Character Class")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    #if os(iOS)
                    Menu {
                        ForEach(CharacterClass.allCases, id: \.self) { characterClass in
                            Button(characterClass.rawValue) {
                                selectedClass = characterClass
                            }
                        }
                    } label: {
                        TextField("", text: .constant(selectedClass.rawValue))
                            .multilineTextAlignment(.center)
                            .textFieldStyle(.roundedBorder)
                            .disabled(true)
                    }
                    .buttonStyle(.plain)
                    #else
                    Picker("", selection: $selectedClass) {
                        ForEach(CharacterClass.allCases, id: \.self) { characterClass in
                            Text(characterClass.rawValue)
                                .tag(characterClass)
                        }
                    }
                    .pickerStyle(.segmented)
                    #endif
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
    }
}

private extension FormBasicInfoSection {
    // Removed the validateLevel function as it's no longer needed
}
