import SwiftUI
import PhosphorSwift

struct FormLanguagesSection: View {
    @Binding var languages: [String]
    @Binding var newLanguage: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    @State private var isAddingLanguage = false
    @State private var editingLanguage: String? = nil
    @State private var tempLanguage = ""
    
    private var addLanguageButton: some View {
        Button {
            withAnimation(.easeInOut) {
                isAddingLanguage = true
            }
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .imageScale(.medium)
                    .symbolRenderingMode(.hierarchical)
                Text("Add Language")
                    .font(.body)
            }
            .foregroundColor(.blue)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var addLanguageView: some View {
        Group {
            if isAddingLanguage {
                HStack {
                    TextField("Enter new language", text: $newLanguage)
                        .textFieldStyle(.roundedBorder)
                        #if os(iOS)
                        .textInputAutocapitalization(.sentences)
                        #endif
                        .focused($focusedField, equals: .newLanguage)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            newLanguage = ""
                            isAddingLanguage = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Button {
                        withAnimation(.easeInOut) {
                            addLanguage()
                            isAddingLanguage = false
                        }
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.green)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .disabled(newLanguage.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
                .background(Color(nsColor: .windowBackgroundColor))
                .cornerRadius(8)
            }
        }
    }
    
    private var languageListView: some View {
        Group {
            if !languages.isEmpty {
                VStack(spacing: 12) {
                    ForEach(languages, id: \.self) { language in
                        HStack {
                            if editingLanguage == language {
                                TextField("Edit language", text: $tempLanguage)
                                    .textFieldStyle(.roundedBorder)
                                    #if os(iOS)
                                    .textInputAutocapitalization(.words)
                                    #endif
                                    .focused($focusedField, equals: .languageName)
                                    .onAppear { tempLanguage = language }
                                
                                Button {
                                    withAnimation(.easeInOut) {
                                        editingLanguage = nil
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .imageScale(.medium)
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                
                                Button {
                                    withAnimation(.easeInOut) {
                                        updateLanguage(language)
                                    }
                                } label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .imageScale(.medium)
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundColor(.green)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .disabled(tempLanguage.trimmingCharacters(in: .whitespaces).isEmpty)
                            } else {
                                Text(language)
                                    .foregroundColor(.primary)
                                Spacer()
                                Button {
                                    withAnimation(.easeInOut) {
                                        editingLanguage = language
                                        tempLanguage = language
                                    }
                                } label: {
                                    Image(systemName: "pencil.circle.fill")
                                        .imageScale(.medium)
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                
                                Button {
                                    withAnimation(.easeInOut) {
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
                        .padding()
                        .background(Color(nsColor: .windowBackgroundColor))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            SectionHeader(title: "Languages", icon: Ph.scroll.bold)
            
            // Main Card
            VStack(spacing: 16) {
                if !languages.isEmpty {
                    languageListView
                }
                if !isAddingLanguage {
                    addLanguageButton
                } else {
                    addLanguageView
                }
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))
            .cornerRadius(12)
        }
    }
    
    private func addLanguage() {
        let trimmed = newLanguage.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        withAnimation(.easeInOut) {
            languages.append(trimmed)
            newLanguage = ""
            focusedField = nil
        }
    }
    
    private func updateLanguage(_ oldLanguage: String) {
        let trimmed = tempLanguage.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        withAnimation(.easeInOut) {
            if let index = languages.firstIndex(of: oldLanguage) {
                languages[index] = trimmed
            }
            editingLanguage = nil
        }
    }
    
    private func removeLanguage(_ language: String) {
        withAnimation(.easeInOut) {
            languages.removeAll { $0 == language }
        }
    }
}
