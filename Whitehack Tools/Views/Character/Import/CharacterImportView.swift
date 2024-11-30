import SwiftUI
import UniformTypeIdentifiers
import PhosphorSwift

struct CharacterImportView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var characterStore: CharacterStore
    @State private var importText = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingFilePicker = false
    @State private var decodedCharacters: [PlayerCharacter] = []
    @State private var selectedCharacters: Set<UUID> = []
    @State private var showingPreview = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if showingPreview {
                    // Selection Header
                    HStack {
                        HStack(spacing: 16) {
                            Button(action: selectAll) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(selectedCharacters.count == decodedCharacters.count ? .secondary : .accentColor)
                                    Text("Select All")
                                        .foregroundColor(selectedCharacters.count == decodedCharacters.count ? .secondary : .primary)
                                }
                                .font(.system(.body, design: .rounded).weight(.medium))
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .disabled(selectedCharacters.count == decodedCharacters.count)
                            
                            Button(action: deselectAll) {
                                HStack(spacing: 8) {
                                    Image(systemName: "circle")
                                        .font(.system(size: 22))
                                        .foregroundColor(selectedCharacters.isEmpty ? .secondary : .accentColor)
                                    Text("Deselect All")
                                        .foregroundColor(selectedCharacters.isEmpty ? .secondary : .primary)
                                }
                                .font(.system(.body, design: .rounded).weight(.medium))
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .disabled(selectedCharacters.isEmpty)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        
                        Spacer()
                        
                        if !selectedCharacters.isEmpty {
                            Text("\(selectedCharacters.count) selected")
                                .foregroundColor(.secondary)
                                .font(.subheadline.weight(.medium))
                                .padding(.trailing)
                        }
                    }
                    .background(.thinMaterial)
                    
                    List {
                        ForEach(decodedCharacters) { character in
                            CharacterImportRow(character: character, isSelected: selectedCharacters.contains(character.id))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        if selectedCharacters.contains(character.id) {
                                            selectedCharacters.remove(character.id)
                                        } else {
                                            selectedCharacters.insert(character.id)
                                        }
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                } else {
                    // Import Options
                    HStack(spacing: 16) {
                        Button(action: { showingFilePicker = true }) {
                            VStack(spacing: 8) {
                                Ph.fileText.bold
                                    .frame(width: 32, height: 32)
                                Text("Import File")
                                    .font(.subheadline.weight(.medium))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: pasteFromClipboard) {
                            VStack(spacing: 8) {
                                Ph.clipboard.bold
                                    .frame(width: 32, height: 32)
                                Text("Paste")
                                    .font(.subheadline.weight(.medium))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                    }
                    .foregroundColor(.primary)
                    
                    // Preview Area
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Character Data:")
                            .font(.headline)
                        
                        TextEditor(text: $importText)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                
                // Import/Preview Button
                Button(action: showingPreview ? importSelectedCharacters : previewCharacters) {
                    HStack {
                        if showingPreview {
                            Ph.arrowDown.bold
                                .frame(width: 20, height: 20)
                            Text("Import Selected")
                                .fontWeight(.semibold)
                        } else {
                            Ph.eye.bold
                                .frame(width: 20, height: 20)
                            Text("Preview")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(importText.isEmpty || (showingPreview && selectedCharacters.isEmpty))
            }
            .padding()
            .navigationTitle("Import Characters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(showingPreview ? "Back" : "Cancel") {
                        if showingPreview {
                            showingPreview = false
                            decodedCharacters = []
                            selectedCharacters = []
                        } else {
                            dismiss()
                        }
                    }
                }
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: [.json],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let files):
                    guard let fileURL = files.first else { return }
                    
                    // Start security-scoped resource access
                    guard fileURL.startAccessingSecurityScopedResource() else {
                        showAlert(title: "Error", message: "Permission denied to access file")
                        return
                    }
                    
                    defer {
                        fileURL.stopAccessingSecurityScopedResource()
                    }
                    
                    do {
                        let data = try Data(contentsOf: fileURL)
                        if let jsonString = String(data: data, encoding: .utf8) {
                            importText = jsonString
                        } else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not decode file contents"])
                        }
                    } catch {
                        print("Import error: \(error.localizedDescription)")
                        showAlert(title: "Error", message: "Could not read file: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    print("File picker error: \(error.localizedDescription)")
                    showAlert(title: "Error", message: "Could not import file: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func pasteFromClipboard() {
        if let string = UIPasteboard.general.string {
            importText = string
        }
    }
    
    private func previewCharacters() {
        guard !importText.isEmpty else {
            showAlert(title: "Error", message: "Please enter character data")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let characterData = Data(importText.utf8)
            
            // Try to decode as array first
            if let characters = try? decoder.decode([PlayerCharacter].self, from: characterData) {
                decodedCharacters = characters
                selectedCharacters = Set(characters.map { $0.id }) // Select all by default
                showingPreview = true
            }
            // If that fails, try single character
            else if let character = try? decoder.decode(PlayerCharacter.self, from: characterData) {
                decodedCharacters = [character]
                selectedCharacters = [character.id] // Select the single character
                showingPreview = true
            }
            else {
                throw NSError(domain: "", code: -1)
            }
        } catch {
            showAlert(title: "Error", message: "Invalid character data format")
        }
    }
    
    private func importSelectedCharacters() {
        let selectedChars = decodedCharacters.filter { selectedCharacters.contains($0.id) }
        selectedChars.forEach { character in
            let newCharacter = character.copyWithNewIDs()
            characterStore.addCharacter(newCharacter)
        }
        showSuccess(count: selectedChars.count)
    }
    
    private func selectAll() {
        withAnimation {
            selectedCharacters = Set(decodedCharacters.map { $0.id })
        }
    }
    
    private func deselectAll() {
        withAnimation {
            selectedCharacters = []
        }
    }
    
    private func showSuccess(count: Int) {
        showAlert(title: "Success", message: "\(count) character\(count == 1 ? "" : "s") imported!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}

struct CharacterImportRow: View {
    let character: PlayerCharacter
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 22))
                .foregroundColor(isSelected ? .accentColor : .secondary)
            
            CharacterClassIcon(characterClass: character.characterClass)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                
                Text(character.characterClass.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
