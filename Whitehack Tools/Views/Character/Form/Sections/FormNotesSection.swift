// FormNotesSection.swift
import SwiftUI
import PhosphorSwift

struct FormNotesSection: View {
    @Binding var notes: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            SectionHeader(title: "Notes", icon: Ph.notepad.bold)
            
            // Content
            VStack(spacing: 16) {
                #if os(iOS)
                TextEditor(text: $notes)
                    .frame(minHeight: 100)
                    .focused($focusedField, equals: .notes)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(uiColor: .systemGray4), lineWidth: 1)
                    )
                #else
                TextEditor(text: $notes)
                    .frame(minHeight: 100)
                    .focused($focusedField, equals: .notes)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .shadow(color: Color(nsColor: .shadowColor).opacity(0.1), radius: 2, x: 0, y: 1)
                #endif
            }
        }
    }
}
