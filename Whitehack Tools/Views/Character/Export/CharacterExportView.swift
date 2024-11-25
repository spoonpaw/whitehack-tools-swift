import SwiftUI
import UniformTypeIdentifiers
import PhosphorSwift

struct CharacterExportView: View {
    @Environment(\.dismiss) private var dismiss
    let characters: [PlayerCharacter]
    @State private var selectedCharacters: Set<UUID> = []
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
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
        UIPasteboard.general.string = characterData
        showAlert(title: "Copied!", message: "\(selectedCharacters.count) characters copied to clipboard")
    }
    
    private func shareCharacters() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return }
        
        // Create a temporary file
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = "whitehack_characters.json"
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        do {
            try characterData.write(to: fileURL, atomically: true, encoding: .utf8)
            
            let activityVC = UIActivityViewController(
                activityItems: [fileURL],
                applicationActivities: nil
            )
            
            if let presenter = window.rootViewController?.presentedViewController ?? window.rootViewController {
                // For iPad
                if let popover = activityVC.popoverPresentationController {
                    popover.sourceView = window
                    popover.sourceRect = CGRect(x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0)
                    popover.permittedArrowDirections = []
                }
                presenter.present(activityVC, animated: true)
            }
        } catch {
            showAlert(title: "Error", message: "Could not create character file for sharing.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
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
                .frame(width: 40, height: 40)
            
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
                .padding(16)
        }
    }
}
