// LanguagesSection.swift
import SwiftUI

struct LanguagesSection: View {
    @Binding var languages: [String]
    @Binding var newLanguage: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    var body: some View {
        Section(header: Text("Languages").font(.headline)) {
            HStack {
                TextField("Add Language", text: $newLanguage)
                    .textInputAutocapitalization(.words)
                    .focused($focusedField, equals: .newLanguage)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        withAnimation {
                            addLanguage()
                        }
                    }
                
                Button {
                    withAnimation {
                        addLanguage()
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(newLanguage.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
                }
                .buttonStyle(.borderless)
                .disabled(newLanguage.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            
            if !languages.isEmpty {
                ForEach(languages, id: \.self) { language in
                    HStack {
                        Text(language)
                        Spacer()
                        if language != "Common" {
                            Button {
                                withAnimation {
                                    removeLanguage(language)
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
            }
        }
    }
    
    private func addLanguage() {
        let trimmed = newLanguage.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        languages.append(trimmed)
        newLanguage = ""
        focusedField = nil
    }
    
    private func removeLanguage(_ language: String) {
        languages.removeAll { $0 == language }
    }
}
