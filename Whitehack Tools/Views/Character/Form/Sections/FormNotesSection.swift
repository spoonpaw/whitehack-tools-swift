// FormNotesSection.swift
import SwiftUI
import PhosphorSwift

struct FormNotesSection: View {
    @Binding var notes: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        Section(header: HStack(spacing: 8) {
            Ph.note.bold
                .frame(width: 20, height: 20)
            Text("Notes")
        }
        .font(.headline)) {
            TextEditor(text: $notes)
                .frame(minHeight: 100)
                .focused($focusedField, equals: .notes)
        }
    }
}
