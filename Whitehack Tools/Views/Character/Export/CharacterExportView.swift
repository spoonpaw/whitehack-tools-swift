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
            List(selection: $selectedCharacters) {
                Section {
                    ForEach(characters) { character in
                        CharacterExportRow(character: character)
                    }
                } header: {
                    Text("Select characters to export")
                }
            }
            .environment(\.editMode, .constant(.active))
            .navigationTitle("Export Characters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: selectAll) {
                            Label("Select All", systemImage: "checkmark.circle")
                        }
                        Button(action: deselectAll) {
                            Label("Deselect All", systemImage: "circle")
                        }
                        Divider()
                        Button(action: copyToClipboard) {
                            Label("Copy to Clipboard", systemImage: "doc.on.doc")
                        }
                        Button(action: shareCharacters) {
                            Label("Share...", systemImage: "square.and.arrow.up")
                        }
                    } label: {
                        if selectedCharacters.isEmpty {
                            Text("Actions")
                        } else {
                            Text("Export (\(selectedCharacters.count))")
                        }
                    }
                    .disabled(selectedCharacters.isEmpty)
                }
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func selectAll() {
        selectedCharacters = Set(characters.map { $0.id })
    }
    
    private func deselectAll() {
        selectedCharacters.removeAll()
    }
    
    private func copyToClipboard() {
        UIPasteboard.general.string = characterData
        showAlert(title: "Success", message: "Character data copied to clipboard!")
    }
    
    private func shareCharacters() {
        let av = UIActivityViewController(
            activityItems: [characterData],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(av, animated: true)
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
    
    var body: some View {
        HStack(spacing: 12) {
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
