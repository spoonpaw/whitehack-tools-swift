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
        VStack(spacing: 16) {
            // Header
            HStack(spacing: 8) {
                Ph.identificationCard.bold
                    .frame(width: 20, height: 20)
                Text("Basic Information")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 4)
            .padding(.top, 16)
            
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
                        .frame(maxWidth: 300)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("Player Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $playerName)
                        .focused($focusedField, equals: .playerName)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("Level")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $level)
                        .focused($focusedField, equals: .level)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
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
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.plain)
                    #else
                    Picker("", selection: $selectedClass) {
                        ForEach(CharacterClass.allCases, id: \.self) { characterClass in
                            Text(characterClass.rawValue)
                                .tag(characterClass)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 300)
                    #endif
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .cornerRadius(10)
    }
}
