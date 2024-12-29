import SwiftUI
import UniformTypeIdentifiers
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
    
    func dismissAlert() {
        showingAlert = false
    }
    
    func addCharacter(_ character: PlayerCharacter) {
        decodedCharacters.append(character)
    }
    
    func removeCharacter(_ character: PlayerCharacter) {
        decodedCharacters.removeAll(where: { $0.id == character.id })
    }
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

struct CharacterImportView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var characterStore: CharacterStore
    @StateObject private var viewModel = CharacterImportViewModel()
    
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
                }
                #endif
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
            .sheet(isPresented: $viewModel.showingFilePicker) {
                DocumentPickerView(viewModel: viewModel)
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
        #else
        VStack {
            if viewModel.showingPreview {
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
                            dismiss()
                        }
                        .keyboardShortcut(.escape)
                        
                        Spacer()
                        
                        Button("Import") {
                            importSelectedCharacters()
                        }
                        .keyboardShortcut(.return)
                        .disabled(viewModel.selectedCharacters.isEmpty)
                    }
                    .padding(.top)
                }
                .padding()
                .frame(width: 400, height: 500)
            } else {
                ImportOptionsView(viewModel: viewModel)
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showingAlert) {
            Button("OK", role: .cancel) { }
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

#if os(iOS)
struct DocumentPickerView: UIViewControllerRepresentable {
    let viewModel: CharacterImportViewModel
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.json])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let viewModel: CharacterImportViewModel
        
        init(viewModel: CharacterImportViewModel) {
            self.viewModel = viewModel
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            viewModel.handleDocumentPicker(result: .success(url))
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            viewModel.showingFilePicker = false
        }
    }
}
#endif
