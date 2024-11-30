import SwiftUI
import UniformTypeIdentifiers
import PhosphorSwift

class CharacterImportViewModel: ObservableObject {
    @Published var importText = ""
    @Published var showingAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var showingFilePicker = false
    @Published var decodedCharacters: [PlayerCharacter] = []
    @Published var selectedCharacters: Set<UUID> = []
    @Published var showingPreview = false
    
    func setImportText(_ text: String) {
        importText = text
        previewCharacters()
    }
    
    func previewCharacters() {
        guard !importText.isEmpty else { return }
        
        do {
            if let data = importText.data(using: .utf8) {
                do {
                    // Try to decode as array first
                    decodedCharacters = try JSONDecoder().decode([PlayerCharacter].self, from: data)
                    showingPreview = true
                    return
                } catch {
                    // If array decode fails, try single character
                    do {
                        let character = try JSONDecoder().decode(PlayerCharacter.self, from: data)
                        decodedCharacters = [character]
                        showingPreview = true
                        return
                    } catch {
                        showAlert(title: "Error", message: "Invalid character data format")
                    }
                }
            }
            
            throw NSError(domain: "", code: -1)
        } catch {
            showAlert(title: "Error", message: "Invalid character data format")
        }
    }
    
    func reset() {
        importText = ""
        decodedCharacters = []
        selectedCharacters.removeAll()
        showingPreview = false
        showingAlert = false
    }
    
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
    
    func selectAll() {
        selectedCharacters = Set(decodedCharacters.map { $0.id })
    }
}

struct CharacterImportView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var characterStore: CharacterStore
    @EnvironmentObject private var viewModel: CharacterImportViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.showingPreview {
                    // Selection Header
                    HStack {
                        HStack(spacing: 16) {
                            Button(action: { withAnimation { viewModel.selectAll() } }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(viewModel.selectedCharacters.count == viewModel.decodedCharacters.count ? .secondary : .accentColor)
                                    Text("Select All")
                                        .foregroundColor(viewModel.selectedCharacters.count == viewModel.decodedCharacters.count ? .secondary : .primary)
                                }
                                .font(.system(.body, design: .rounded).weight(.medium))
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .disabled(viewModel.selectedCharacters.count == viewModel.decodedCharacters.count)
                            
                            Button(action: { withAnimation { viewModel.selectedCharacters.removeAll() } }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "circle")
                                        .font(.system(size: 22))
                                        .foregroundColor(viewModel.selectedCharacters.isEmpty ? .secondary : .accentColor)
                                    Text("Deselect All")
                                        .foregroundColor(viewModel.selectedCharacters.isEmpty ? .secondary : .primary)
                                }
                                .font(.system(.body, design: .rounded).weight(.medium))
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .disabled(viewModel.selectedCharacters.isEmpty)
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 4)
                    
                    // Character List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.decodedCharacters) { character in
                                CharacterImportRow(character: character, isSelected: viewModel.selectedCharacters.contains(character.id))
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation {
                                            if viewModel.selectedCharacters.contains(character.id) {
                                                viewModel.selectedCharacters.remove(character.id)
                                            } else {
                                                viewModel.selectedCharacters.insert(character.id)
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    // Import Options
                    HStack(spacing: 16) {
                        Button(action: { viewModel.showingFilePicker = true }) {
                            VStack(spacing: 8) {
                                Image(systemName: "doc")
                                    .font(.system(size: 24))
                                Text("Choose File")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        Button(action: pasteFromClipboard) {
                            VStack(spacing: 8) {
                                Image(systemName: "doc.on.clipboard")
                                    .font(.system(size: 24))
                                Text("Paste")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.bottom)
                    
                    // Text Editor
                    TextEditor(text: $viewModel.importText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Import Characters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.showingPreview {
                        Button("Back") {
                            withAnimation {
                                viewModel.reset()
                            }
                        }
                    } else {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.showingPreview ? importSelectedCharacters : viewModel.previewCharacters) {
                        if viewModel.showingPreview {
                            Text("Import")
                                .bold()
                        } else {
                            Text("Preview")
                                .bold()
                        }
                    }
                    .disabled(viewModel.importText.isEmpty || (viewModel.showingPreview && viewModel.selectedCharacters.isEmpty))
                }
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
            .fileImporter(
                isPresented: $viewModel.showingFilePicker,
                allowedContentTypes: [.json, .text],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    guard let url = urls.first else { return }
                    
                    do {
                        viewModel.setImportText(try String(contentsOf: url))
                    } catch {
                        print("File picker error: \(error.localizedDescription)")
                        viewModel.showAlert(title: "Error", message: "Could not import file: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("File picker error: \(error.localizedDescription)")
                    viewModel.showAlert(title: "Error", message: "Could not import file: \(error.localizedDescription)")
                }
            }
        }
        .onAppear {
            if !viewModel.importText.isEmpty {
                viewModel.previewCharacters()
            }
        }
        .onDisappear {
            viewModel.reset()
        }
    }
    
    private func pasteFromClipboard() {
        if let string = UIPasteboard.general.string {
            viewModel.setImportText(string)
        }
    }
    
    private func importSelectedCharacters() {
        let selectedChars = viewModel.decodedCharacters.filter { viewModel.selectedCharacters.contains($0.id) }
        selectedChars.forEach { character in
            let newCharacter = character.copyWithNewIDs()
            characterStore.addCharacter(newCharacter)
        }
        showSuccess(count: selectedChars.count)
    }
    
    private func showSuccess(count: Int) {
        viewModel.showAlert(title: "Success", message: "Imported \(count) character\(count == 1 ? "" : "s")")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
}

struct CharacterImportRow: View {
    let character: PlayerCharacter
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                Text("\(character.characterClass.rawValue) - Level \(character.level)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .blue : .secondary)
                .font(.title2)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
