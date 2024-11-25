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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
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
                
                // Import Button
                Button(action: importCharacters) {
                    HStack {
                        Ph.arrowDown.bold
                            .frame(width: 20, height: 20)
                        Text("Import")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(importText.isEmpty)
            }
            .padding()
            .navigationTitle("Import Characters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
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
    
    private func importCharacters() {
        guard !importText.isEmpty else {
            showAlert(title: "Error", message: "Please enter character data")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let characterData = Data(importText.utf8)
            
            // Try to decode as array first
            if let characters = try? decoder.decode([PlayerCharacter].self, from: characterData) {
                // Create copies with new IDs for each character before adding
                characters.forEach { character in
                    let newCharacter = character.copyWithNewIDs()
                    characterStore.addCharacter(newCharacter)
                }
                showSuccess(count: characters.count)
            }
            // If that fails, try single character
            else if let character = try? decoder.decode(PlayerCharacter.self, from: characterData) {
                let newCharacter = character.copyWithNewIDs()
                characterStore.addCharacter(newCharacter)
                showSuccess(count: 1)
            }
            else {
                throw NSError(domain: "", code: -1)
            }
        } catch {
            showAlert(title: "Error", message: "Invalid character data format")
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
