// NotesSection.swift
import SwiftUI

struct NotesSection: View {
    @Binding var notes: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        Section(header: Text("Notes").font(.headline)) {
            TextEditor(text: $notes)
                .frame(minHeight: 100)
                .focused($focusedField, equals: .notes)
        }
    }
}
