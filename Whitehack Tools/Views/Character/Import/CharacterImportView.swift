import SwiftUI
import UniformTypeIdentifiers
#if os(iOS)
import UIKit
#else
import AppKit
#endif

extension Color {
    static var systemBackground: Color {
        #if os(iOS)
        return Color(UIColor.systemBackground)
        #else
        return Color(NSColor.windowBackgroundColor)
        #endif
    }
}

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
        print("📝 Setting import text, length: \(text.count)")
        importText = text
        previewCharacters()
    }
    
    func reset() {
        importText = ""
        showingAlert = false
        alertTitle = ""
        alertMessage = ""
        showingFilePicker = false
        decodedCharacters = []
        selectedCharacters = []
        showingPreview = false
    }
    
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
    
    func selectAll() {
        selectedCharacters = Set(decodedCharacters.map { $0.id })
    }
    
    func importSelectedCharacters() -> [PlayerCharacter] {
        return decodedCharacters.filter { selectedCharacters.contains($0.id) }
    }
    
    func removeCharacter(_ character: PlayerCharacter) {
        decodedCharacters.removeAll(where: { $0.id == character.id })
    }
    
    func handleIncomingFile(url: URL) {
        print("📂 Attempting to handle incoming file: \(url)")
        print("📂 URL path components: \(url.pathComponents)")
        
        do {
            let data = try String(contentsOf: url)
            print("📄 Successfully read file contents, length: \(data.count)")
            print("📄 First 100 chars of content: \(String(data.prefix(100)))")
            setImportText(data)
            print("📝 Set import text and attempting preview")
            
            // Force the view to show preview mode
            DispatchQueue.main.async {
                print("🔄 Setting showingPreview to true")
                self.showingPreview = true
                print("✅ Current state - showingPreview: \(self.showingPreview), characters: \(self.decodedCharacters.count)")
            }
        } catch {
            print("❌ Failed to read file contents: \(error)")
            showAlert(title: "Error", message: "Could not read file contents: \(error.localizedDescription)")
        }
    }
    
    func previewCharacters() {
        print("🔍 Starting preview characters")
        guard !importText.isEmpty else {
            print("⚠️ Import text is empty")
            return
        }
        
        do {
            if let data = importText.data(using: .utf8) {
                print("✅ Successfully converted text to data")
                do {
                    // Try to decode as array first
                    decodedCharacters = try JSONDecoder().decode([PlayerCharacter].self, from: data)
                    print("✅ Successfully decoded array of characters: \(decodedCharacters.count)")
                    showingPreview = true
                    print("✅ Set showingPreview to true")
                    return
                } catch {
                    print("⚠️ Failed to decode as array, trying single character: \(error)")
                    // If array decode fails, try single character
                    do {
                        let character = try JSONDecoder().decode(PlayerCharacter.self, from: data)
                        print("✅ Successfully decoded single character")
                        decodedCharacters = [character]
                        showingPreview = true
                        print("✅ Set showingPreview to true")
                        return
                    } catch {
                        print("❌ Failed to decode as single character: \(error)")
                        showAlert(title: "Error", message: "Invalid character data format")
                    }
                }
            } else {
                print("❌ Failed to convert text to data")
            }
            
            throw NSError(domain: "", code: -1)
        } catch {
            print("❌ Preview characters failed: \(error)")
            showAlert(title: "Error", message: "Invalid character data format")
        }
    }
    
    #if os(macOS)
    func showFilePicker() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false
        panel.allowedContentTypes = [.json]
        
        panel.begin { [weak self] result in
            if result == .OK, let url = panel.url {
                do {
                    let data = try String(contentsOf: url)
                    DispatchQueue.main.async {
                        self?.setImportText(data)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: "Could not read file contents")
                    }
                }
            }
        }
    }
    #endif
}

#if os(iOS)
extension CharacterImportViewModel {
    func handleDocumentPicker(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            guard url.startAccessingSecurityScopedResource() else {
                showAlert(title: "Error", message: "Could not access the file")
                return
            }
            defer { url.stopAccessingSecurityScopedResource() }
            
            do {
                let data = try String(contentsOf: url)
                setImportText(data)
            } catch {
                showAlert(title: "Error", message: "Could not read file contents")
            }
        case .failure(let error):
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }
}
#endif

struct ImportOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CharacterImportViewModel
    
    var body: some View {
        #if os(iOS)
        HStack(spacing: 16) {
            Button {
                viewModel.showingFilePicker = true
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "doc")
                        .font(.system(size: 24))
                    Text("Choose File")
                        .font(.system(.body, design: .rounded))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
            
            Button {
                viewModel.setImportText(UIPasteboard.general.string ?? "")
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "doc.on.clipboard")
                        .font(.system(size: 24))
                    Text("Paste")
                        .font(.system(.body, design: .rounded))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
        #else
        VStack(spacing: 20) {
            Text("Import Characters")
                .font(.system(.title2, design: .rounded).weight(.medium))
            
            Text("Choose a file or paste character data\nfrom your clipboard")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            VStack(spacing: 12) {
                Button {
                    viewModel.showFilePicker()
                } label: {
                    HStack {
                        Image(systemName: "doc")
                        Text("Choose File...")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                Button {
                    viewModel.setImportText(NSPasteboard.general.string(forType: .string) ?? "")
                } label: {
                    HStack {
                        Image(systemName: "doc.on.clipboard")
                        Text("Paste from Clipboard")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            Button("Cancel") {
                viewModel.reset()
                dismiss()
            }
            .keyboardShortcut(.escape)
        }
        .padding(24)
        .frame(width: 400, height: 500)
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

struct CharacterImportView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var characterStore: CharacterStore
    @ObservedObject var viewModel: CharacterImportViewModel
    
    func pasteFromClipboard() {
        #if os(iOS)
        guard let string = UIPasteboard.general.string else {
            viewModel.showAlert(title: "Error", message: "No text found in clipboard")
            return
        }
        #else
        guard let string = NSPasteboard.general.string(forType: .string) else {
            viewModel.showAlert(title: "Error", message: "No text found in clipboard")
            return
        }
        #endif
        
        // Try to validate it's JSON first
        guard let data = string.data(using: .utf8),
              let _ = try? JSONSerialization.jsonObject(with: data) else {
            viewModel.showAlert(title: "Error", message: "Clipboard content is not valid JSON")
            return
        }
        
        viewModel.setImportText(string)
    }
    
    func importSelectedCharacters() {
        let selectedChars = viewModel.importSelectedCharacters()
        selectedChars.forEach { character in
            let newCharacter = character.copyWithNewIDs()
            characterStore.addCharacter(newCharacter)
        }
        showSuccess(count: selectedChars.count)
    }
    
    private func showSuccess(count: Int) {
        viewModel.showAlert(title: "Success", message: "Imported \(count) character\(count == 1 ? "" : "s")")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            viewModel.reset()
            dismiss()
        }
    }
    
    var body: some View {
        #if os(iOS)
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
                    ImportOptionsView(viewModel: viewModel)
                    
                    TextEditor(text: $viewModel.importText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
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
                            viewModel.reset()
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
                    .keyboardShortcut(.return)
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
                            viewModel.reset()
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
                    .keyboardShortcut(.return)
                }
                #endif
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showingAlert) {
                Button("OK") {}
            } message: {
                Text(viewModel.alertMessage)
            }
        }
        .onAppear {
            print("🔄 CharacterImportView appeared - showingPreview: \(viewModel.showingPreview), characters: \(viewModel.decodedCharacters.count)")
            if !viewModel.importText.isEmpty {
                print("📝 Found existing import text, previewing characters")
                viewModel.previewCharacters()
            }
        }
        #else
        VStack {
            if viewModel.showingPreview {
                MacImportView(viewModel: viewModel, onImport: importSelectedCharacters)
            } else {
                VStack(spacing: 20) {
                    Text("Import Characters")
                        .font(.system(.title2, design: .rounded).weight(.medium))
                    
                    Text("Choose a file or paste character data\nfrom your clipboard")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Button {
                            viewModel.showFilePicker()
                        } label: {
                            HStack {
                                Image(systemName: "doc")
                                Text("Choose File...")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        
                        Button {
                            viewModel.setImportText(NSPasteboard.general.string(forType: .string) ?? "")
                        } label: {
                            HStack {
                                Image(systemName: "doc.on.clipboard")
                                Text("Paste from Clipboard")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    Button("Cancel") {
                        viewModel.reset()
                        dismiss()
                    }
                    .keyboardShortcut(.escape)
                }
                .padding(24)
                .frame(width: 400, height: 500)
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showingAlert) {
            Button("OK") {}
        } message: {
            Text(viewModel.alertMessage)
        }
        #endif
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
                    .font(.headline)
                
                Text("Level \(character.level) \(vocation)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 24))
            }
        }
        .padding()
        .background(Color.systemBackground)
        .cornerRadius(8)
    }
}

#if os(macOS)
struct MacImportView: View {
    @ObservedObject var viewModel: CharacterImportViewModel
    let onImport: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
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
            
            HStack {
                Button("Cancel") {
                    viewModel.reset()
                }
                .keyboardShortcut(.escape)
                
                Spacer()
                
                Button("Import") {
                    onImport()
                }
                .keyboardShortcut(.return)
                .disabled(viewModel.selectedCharacters.isEmpty)
            }
            .padding(.top)
        }
        .padding()
    }
}
#endif
