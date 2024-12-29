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
    
    private var characterData: Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let selectedChars = characters.filter { selectedCharacters.contains($0.id) }
            return try encoder.encode(selectedChars)
        } catch {
            return nil
        }
    }
    
    private func createTemporaryFile() -> URL? {
        guard let data = characterData else { return nil }
        
        let temporaryDirectoryURL = FileManager.default.temporaryDirectory
        let fileName = "characters_\(Date().timeIntervalSince1970).json"
        let fileURL = temporaryDirectoryURL.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error creating temporary file: \(error)")
            return nil
        }
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
        copyToClipboard(String(data: characterData ?? Data(), encoding: .utf8) ?? "")
    }
    
    private func copyToClipboard(_ text: String) {
        #if os(iOS)
        UIPasteboard.general.string = text
        #else
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
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
        // On macOS, we'll just copy to clipboard since sharing isn't as standardized
        copyToClipboard(String(data: characterData ?? Data(), encoding: .utf8) ?? "")
        #endif
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Selection Header
                HStack {
                    HStack(spacing: 16) {
                        Button(action: selectAll) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(selectedCharacters.count == characters.count ? .secondary : .accentColor)
                                Text("Select All")
                                    .foregroundColor(selectedCharacters.count == characters.count ? .secondary : .primary)
                            }
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .disabled(selectedCharacters.count == characters.count)
                        
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
                    ForEach(characters) { character in
                        CharacterExportRow(character: character, isSelected: selectedCharacters.contains(character.id))
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
                
                // Action Bar
                if !selectedCharacters.isEmpty {
                    HStack(spacing: 20) {
                        Button(action: copyToClipboard) {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: shareCharacters) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        .buttonStyle(.plain)
                    }
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .foregroundColor(.accentColor)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                }
            }
            .navigationTitle("Export Characters")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                #else
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                #endif
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            #if os(iOS)
            .sheet(isPresented: $isShowingShareSheet) {
                if let fileURL = temporaryFileURL {
                    try? FileManager.default.removeItem(at: fileURL)
                    temporaryFileURL = nil
                }
            } content: {
                if let fileURL = temporaryFileURL {
                    ShareSheet(items: [fileURL])
                }
            }
            #endif
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
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
