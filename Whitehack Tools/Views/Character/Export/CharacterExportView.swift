import SwiftUI
import UniformTypeIdentifiers
import PhosphorSwift

#if os(iOS)
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#else
import AppKit
#endif

struct CharacterExportView: View {
    @Environment(\.dismiss) private var dismiss
    let characters: [PlayerCharacter]
    @State private var selectedCharacters: Set<UUID> = []
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isShowingShareSheet = false
    @State private var temporaryFileURL: URL?
    
    private var characterData: String {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let selectedChars = characters.filter { selectedCharacters.contains($0.id) }
            let data = try encoder.encode(selectedChars)
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return "Error encoding character data"
        }
    }
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            VStack(spacing: 20) {
                if characters.isEmpty {
                    Text("No Characters Available")
                        .font(.headline)
                        .foregroundColor(.secondary)
                } else {
                    SelectionHeaderView(
                        selectedCount: selectedCharacters.count,
                        totalCount: characters.count,
                        onSelectAll: selectAll,
                        onDeselectAll: deselectAll
                    )
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(characters) { character in
                                CharacterExportRow(
                                    character: character,
                                    isSelected: selectedCharacters.contains(character.id)
                                )
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
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Export Characters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !characters.isEmpty {
                        Menu {
                            Button(action: copyToClipboard) {
                                Label("Copy to Clipboard", systemImage: "doc.on.clipboard")
                            }
                            Button(action: shareCharacters) {
                                Label("Share...", systemImage: "square.and.arrow.up")
                            }
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .disabled(selectedCharacters.isEmpty)
                    }
                }
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .sheet(isPresented: $isShowingShareSheet, onDismiss: {
                if let fileURL = temporaryFileURL {
                    try? FileManager.default.removeItem(at: fileURL)
                    temporaryFileURL = nil
                }
            }) {
                if let fileURL = temporaryFileURL {
                    ShareSheet(items: [fileURL])
                }
            }
        }
        #else
        VStack(spacing: 20) {
            Text("Export Characters")
                .font(.system(.title2, design: .rounded).weight(.medium))
            
            Spacer()
            
            if characters.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "square.and.arrow.up.trianglebadge.exclamationmark")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    
                    Text("No Characters Available")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Create some characters first before exporting")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(spacing: 16) {
                    SelectionHeaderView(
                        selectedCount: selectedCharacters.count,
                        totalCount: characters.count,
                        onSelectAll: selectAll,
                        onDeselectAll: deselectAll
                    )
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(characters) { character in
                                CharacterExportRow(
                                    character: character,
                                    isSelected: selectedCharacters.contains(character.id)
                                )
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
                        .padding(.horizontal)
                    }
                    
                    if !selectedCharacters.isEmpty {
                        HStack(spacing: 12) {
                            HStack {
                                Spacer()
                                Button("Copy to Clipboard") {
                                    copyToClipboard()
                                }
                                .keyboardShortcut("c", modifiers: [.command])
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            
                            HStack {
                                Spacer()
                                Button("Save As...") {
                                    shareCharacters()
                                }
                                .keyboardShortcut("s", modifiers: [.command])
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            
            Button("Close") {
                dismiss()
            }
            .keyboardShortcut(.escape)
        }
        .padding(20)
        .frame(width: 400, height: 500)
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        #endif
    }
    
    private func selectAll() {
        withAnimation {
            selectedCharacters = Set(characters.map { $0.id })
        }
    }
    
    private func deselectAll() {
        withAnimation {
            selectedCharacters = []
        }
    }
    
    private func copyToClipboard() {
        #if os(iOS)
        UIPasteboard.general.string = characterData
        #else
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(characterData, forType: .string)
        #endif
        
        alertTitle = "Success"
        alertMessage = "Character data copied to clipboard"
        showingAlert = true
    }
    
    private func shareCharacters() {
        #if os(iOS)
        guard let fileURL = createTemporaryFile() else {
            alertTitle = "Error"
            alertMessage = "Failed to create export file"
            showingAlert = true
            return
        }
        temporaryFileURL = fileURL
        isShowingShareSheet = true
        #else
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.json]
        panel.nameFieldStringValue = "characters.json"
        
        panel.begin { result in
            if result == .OK, let url = panel.url {
                do {
                    try characterData.write(to: url, atomically: true, encoding: .utf8)
                    alertTitle = "Success"
                    alertMessage = "Characters saved successfully"
                } catch {
                    alertTitle = "Error"
                    alertMessage = "Failed to save characters: \(error.localizedDescription)"
                }
                showingAlert = true
            }
        }
        #endif
    }
    
    private func createTemporaryFile() -> URL? {
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let fileName = "characters.json"
        let fileURL = temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try characterData.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error creating temporary file: \(error.localizedDescription)")
            return nil
        }
    }
}

struct CharacterExportRow: View {
    let character: PlayerCharacter
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 22))
                .foregroundColor(isSelected ? .accentColor : .secondary)
                .frame(width: 24)
            
            CharacterClassIcon(characterClass: character.characterClass)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                
                Text(character.characterClass.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
        .contentShape(Rectangle())
    }
}

struct CharacterClassIcon: View {
    let characterClass: CharacterClass
    
    private var classColor: Color {
        switch characterClass {
        case .strong: 
            return Color(red: 0.698, green: 0.132, blue: 0.195)
        case .wise: 
            return Color(red: 0.408, green: 0.616, blue: 0.851)
        case .deft: 
            return Color(red: 0.475, green: 0.298, blue: 0.635)
        case .brave: 
            return Color(red: 0.804, green: 0.498, blue: 0.196)
        case .clever: 
            return Color(red: 0.216, green: 0.545, blue: 0.373)
        case .fortunate: 
            return Color(red: 0.557, green: 0.267, blue: 0.678)
        }
    }
    
    private var classIcon: Image {
        switch characterClass {
        case .strong: return Ph.barbell.bold
        case .wise: return Ph.sparkle.bold
        case .deft: return Ph.arrowsOutCardinal.bold
        case .brave: return Ph.shield.bold
        case .clever: return Ph.lightbulb.bold
        case .fortunate: return Ph.crownSimple.bold
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(classColor.opacity(0.15))
            
            classIcon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(classColor)
                .frame(width: 24, height: 24)
        }
    }
}
