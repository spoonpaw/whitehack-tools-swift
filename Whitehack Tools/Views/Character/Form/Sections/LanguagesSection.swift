import SwiftUI

struct LanguagesSection: View {
    @Binding var languages: [String]
    @Binding var newLanguage: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    @State private var isAddingLanguage = false
    
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
                                addLanguage()
                                isAddingLanguage = false
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
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
                        }
                    }
                    
                    if !languages.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(languages, id: \.self) { language in
                                    HStack {
                                        Text(language)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        if language != "Common" {
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
                                    .padding(10)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .frame(maxHeight: 150)
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
    
    private func removeLanguage(_ language: String) {
        withAnimation {
            languages.removeAll { $0 == language }
        }
    }
}
