import SwiftUI
#if os(iOS)
import UIKit
#else
import AppKit
#endif

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
    
    func importSelectedCharacters() {
        let selectedChars = decodedCharacters.filter { selectedCharacters.contains($0.id) }
        selectedChars.forEach { character in
            let newCharacter = character.copyWithNewIDs()
            // Add character to character store
        }
    }
}

extension Color {
    static var systemBackground: Color {
        #if os(iOS)
        return Color(UIColor.systemBackground)
        #else
        return Color(NSColor.windowBackgroundColor)
        #endif
    }
}

struct SelectionHeaderView: View {
    let selectedCount: Int
    let totalCount: Int
    let onSelectAll: () -> Void
    let onDeselectAll: () -> Void
    
    var body: some View {
        HStack {
            HStack(spacing: 16) {
                Button(action: onSelectAll) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(selectedCount == totalCount ? .secondary : .accentColor)
                        Text("Select All")
                            .foregroundColor(selectedCount == totalCount ? .secondary : .primary)
                    }
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .disabled(selectedCount == totalCount)
                
                Button(action: onDeselectAll) {
                    HStack(spacing: 8) {
                        Image(systemName: "circle")
                            .font(.system(size: 22))
                            .foregroundColor(selectedCount == 0 ? .secondary : .accentColor)
                        Text("Deselect All")
                            .foregroundColor(selectedCount == 0 ? .secondary : .primary)
                    }
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .disabled(selectedCount == 0)
            }
            Spacer()
        }
        .padding(.bottom, 4)
    }
}

struct ImportOptionsView: View {
    let onFilePickerTap: () -> Void
    let onPasteTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onFilePickerTap) {
                VStack(spacing: 8) {
                    Image(systemName: "doc")
                        .font(.system(size: 24))
                    Text("Choose File")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.systemBackground)
                .cornerRadius(8)
            }
            
            Button(action: onPasteTap) {
                VStack(spacing: 8) {
                    Image(systemName: "doc.on.clipboard")
                        .font(.system(size: 24))
                    Text("Paste")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.systemBackground)
                .cornerRadius(8)
            }
        }
        .padding(.bottom)
    }
}

struct CharacterImportView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var characterStore: CharacterStore
    @EnvironmentObject private var viewModel: CharacterImportViewModel

    func pasteFromClipboard() {
        #if os(iOS)
        if let string = UIPasteboard.general.string {
            viewModel.setImportText(string)
        }
        #else
        if let string = NSPasteboard.general.string(forType: .string) {
            viewModel.setImportText(string)
        }
        #endif
    }
    
    func importSelectedCharacters() {
        viewModel.importSelectedCharacters()
        showSuccess(count: viewModel.selectedCharacters.count)
    }
    
    private func showSuccess(count: Int) {
        viewModel.showAlert(title: "Success", message: "Imported \(count) character\(count == 1 ? "" : "s")")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.showingPreview {
                    SelectionHeaderView(
                        selectedCount: viewModel.selectedCharacters.count,
                        totalCount: viewModel.decodedCharacters.count,
                        onSelectAll: { withAnimation { viewModel.selectAll() } },
                        onDeselectAll: { withAnimation { viewModel.selectedCharacters.removeAll() } }
                    )
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.decodedCharacters) { character in
                                CharacterImportRow(
                                    character: character,
                                    isSelected: viewModel.selectedCharacters.contains(character.id)
                                )
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
                    ImportOptionsView(
                        onFilePickerTap: { viewModel.showingFilePicker = true },
                        onPasteTap: pasteFromClipboard
                    )
                    
                    TextEditor(text: $viewModel.importText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(8)
                        .background(Color.systemBackground)
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.systemBackground)
            .cornerRadius(8)
            .navigationTitle("Import Characters")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
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
                #else
                ToolbarItem(placement: .cancellationAction) {
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
                
                ToolbarItem(placement: .confirmationAction) {
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
                #endif
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
}

struct CharacterImportRow: View {
    let character: PlayerCharacter
    let isSelected: Bool
    
    var vocation: String {
        character.vocationGroup ?? "Unknown"
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
                Text("Level \(character.level) \(vocation)")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 22))
                .foregroundColor(isSelected ? .accentColor : .secondary)
        }
        .padding()
        .background(Color.systemBackground)
        .cornerRadius(8)
    }
}
