import SwiftUI
import PhosphorSwift

struct FormLanguagesSection: View {
    @Binding var languages: [String]
    @Binding var newLanguage: String
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    @State private var isAddingLanguage = false
    @State private var editingLanguage: String? = nil
    @State private var tempLanguage = ""
    
    private var headerView: some View {
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
        }
    }

    private func languageEditView(_ language: String) -> some View {
        HStack {
            TextField("Edit Language", text: $tempLanguage)
                #if os(iOS)
                .textInputAutocapitalization(.words)
                #endif
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .languageName)
            
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
    }

    private func languageDisplayView(_ language: String) -> some View {
        HStack {
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

    private var languageListView: some View {
        Group {
            if !languages.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(languages, id: \.self) { language in
                        HStack {
                            if editingLanguage == language {
                                languageEditView(language)
                            } else {
                                languageDisplayView(language)
                            }
                        }
                        .padding(10)
                        .background({
                            #if os(iOS)
                            Color(uiColor: .systemGray6)
                            #else
                            Color(nsColor: .windowBackgroundColor)
                            #endif
                        }())
                        .cornerRadius(8)
                    }
                }
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            SectionHeader(title: "Languages", icon: Ph.scroll.bold)
            
            // Content
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    headerView
                    addLanguageView
                    languageListView
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
