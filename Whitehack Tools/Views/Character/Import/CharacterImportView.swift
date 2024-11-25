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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Paste your character data below:")
                    .font(.headline)
                
                TextEditor(text: $importText)
                    .font(.system(.body, design: .monospaced))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                Button(action: importCharacter) {
                    HStack {
                        Ph.arrowDown.bold
                            .frame(width: 20, height: 20)
                        Text("Import Character")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding()
            .navigationTitle("Import Character")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: pasteFromClipboard) {
                        Label("Paste", systemImage: "doc.on.clipboard")
                    }
                }
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func pasteFromClipboard() {
        if let string = UIPasteboard.general.string {
            importText = string
        }
    }
    
    private func importCharacter() {
        guard !importText.isEmpty else {
            showAlert(title: "Error", message: "Please enter character data")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let characterData = Data(importText.utf8)
            let character = try decoder.decode(PlayerCharacter.self, from: characterData)
            characterStore.addCharacter(character)
            showAlert(title: "Success", message: "Character imported successfully!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                dismiss()
            }
        } catch {
            showAlert(title: "Error", message: "Invalid character data format")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}
