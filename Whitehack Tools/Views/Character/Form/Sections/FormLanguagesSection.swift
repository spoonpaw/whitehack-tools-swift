import SwiftUI

struct FormLanguagesSection: View {
    @Binding var languages: [String]
    @Binding var newLanguage: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    @State private var isAddingLanguage = false
    @State private var editingLanguage: String? = nil
    @State private var tempLanguage = ""
    
    var body: some View {
        Section(header: Text("Languages").font(.headline)) {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Languages")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Spacer()
                        if !isAddingLanguage {
                            Button {
                                isAddingLanguage = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    
                    if isAddingLanguage {
                        HStack {
                            TextField("Add Language", text: $newLanguage)
                                .textInputAutocapitalization(.words)
                                .focused($focusedField, equals: .newLanguage)
                                .textFieldStyle(.roundedBorder)
                            
                            Button {
                                newLanguage = ""
                                isAddingLanguage = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Button {
                                addLanguage()
                                isAddingLanguage = false
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .disabled(newLanguage.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                    }
                    
                    if !languages.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(languages, id: \.self) { language in
                                HStack {
                                    if editingLanguage == language {
                                        HStack {
                                            TextField("Edit Language", text: $tempLanguage)
                                                .textInputAutocapitalization(.words)
                                                .textFieldStyle(.roundedBorder)
                                            
                                            Button {
                                                editingLanguage = nil
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .imageScale(.medium)
                                                    .symbolRenderingMode(.hierarchical)
                                                    .foregroundColor(.red)
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                            
                                            Button {
                                                updateLanguage(language)
                                            } label: {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .imageScale(.medium)
                                                    .symbolRenderingMode(.hierarchical)
                                                    .foregroundColor(.green)
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                            .disabled(tempLanguage.trimmingCharacters(in: .whitespaces).isEmpty)
                                        }
                                    } else {
                                        Text(language)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        HStack(spacing: 12) {
                                            Button {
                                                editingLanguage = language
                                                tempLanguage = language
                                            } label: {
                                                Image(systemName: "pencil.circle.fill")
                                                    .imageScale(.medium)
                                                    .symbolRenderingMode(.hierarchical)
                                                    .foregroundColor(.blue)
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                            
                                            Button {
                                                withAnimation {
                                                    removeLanguage(language)
                                                }
                                            } label: {
                                                Image(systemName: "trash.circle.fill")
                                                    .imageScale(.medium)
                                                    .symbolRenderingMode(.hierarchical)
                                                    .foregroundColor(.red)
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                        }
                                    }
                                }
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private func addLanguage() {
        let trimmed = newLanguage.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        withAnimation {
            languages.append(trimmed)
            newLanguage = ""
            focusedField = nil
        }
    }
    
    private func updateLanguage(_ oldLanguage: String) {
        let trimmed = tempLanguage.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        withAnimation {
            if let index = languages.firstIndex(of: oldLanguage) {
                languages[index] = trimmed
            }
            editingLanguage = nil
        }
    }
    
    private func removeLanguage(_ language: String) {
        withAnimation {
            languages.removeAll { $0 == language }
        }
    }
}
