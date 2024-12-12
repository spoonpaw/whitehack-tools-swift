// FormNotesSection.swift
import SwiftUI
import PhosphorSwift

struct FormNotesSection: View {
    @Binding var notes: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            SectionHeader(title: "Notes", icon: Ph.notepad.bold)
            
            // Content
            VStack(spacing: 16) {
                TextEditor(text: $notes)
                    .frame(minHeight: 100)
                    .focused($focusedField, equals: .notes)
            }
        }
    }
}
