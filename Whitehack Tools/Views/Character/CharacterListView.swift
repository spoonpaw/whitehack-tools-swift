import SwiftUI
import PhosphorSwift

struct CharacterListView: View {
    @StateObject private var characterStore = CharacterStore()
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(characterStore.characters) { character in
                    ZStack {
                        NavigationLink(destination: CharacterDetailView(character: character, characterStore: characterStore)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        CharacterRowView(character: character)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .onDelete(perform: characterStore.deleteCharacter)
            }
            .navigationTitle("Characters")
            .toolbar {
                Button(action: { showingAddSheet = true }) {
                    Label("Add Character", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                NavigationView {
                    CharacterFormView(characterStore: characterStore)
                }
            }
        }
    }
}

struct CharacterRowView: View {
    let character: PlayerCharacter
    @Environment(\.colorScheme) var colorScheme
    
    private var classColor: Color {
        switch character.characterClass {
        case .strong: 
            // Deep crimson - represents raw power, blood, and physical might
            return Color(red: 0.698, green: 0.132, blue: 0.195)
        case .wise: 
            // Ethereal azure - mystical wisdom, divine insight, celestial knowledge
            return Color(red: 0.408, green: 0.616, blue: 0.851)
        case .deft: 
            // Twilight violet - shadows, agility, mystique
            return Color(red: 0.475, green: 0.298, blue: 0.635)
        case .brave: 
            // Burnished bronze - valor, heroic spirit, ancient warrior traditions
            return Color(red: 0.804, green: 0.498, blue: 0.196)
        case .clever: 
            // Emerald sage - cunning intellect, growth, innovation
            return Color(red: 0.216, green: 0.545, blue: 0.373)
        case .fortunate: 
            // Royal amethyst - nobility, destiny, supernatural luck
            return Color(red: 0.557, green: 0.267, blue: 0.678)
        }
    }
    
    private var classIcon: Image {
        switch character.characterClass {
        case .strong: return Ph.barbell.bold
        case .wise: return Ph.sparkle.bold
        case .deft: return Ph.arrowsOutCardinal.bold
        case .brave: return Ph.shield.bold
        case .clever: return Ph.lightbulb.bold
        case .fortunate: return Ph.crown.bold
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Class Icon Circle
            ZStack {
                Circle()
                    .fill(classColor.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                classIcon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(classColor)
                    .frame(width: 24, height: 24)
            }
            
            // Character Info
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                HStack(spacing: 8) {
                    // Class Badge
                    Text(character.characterClass.rawValue)
                        .font(.caption.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(classColor.opacity(0.15))
                        .foregroundColor(classColor)
                        .clipShape(Capsule())
                    
                    // Level Badge
                    Text("Level \(character.level)")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.secondary.opacity(0.15))
                        .clipShape(Capsule())
                }
                
                if let species = character.speciesGroup {
                    HStack(spacing: 4) {
                        Ph.dna.bold
                            .frame(width: 12, height: 12)
                            .foregroundColor(.secondary)
                        Text(species)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let vocation = character.vocationGroup {
                    HStack(spacing: 4) {
                        Ph.briefcase.bold
                            .frame(width: 12, height: 12)
                            .foregroundColor(.secondary)
                        Text(vocation)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            // Arrow indicator
            Ph.caretRight.bold
                .frame(width: 16, height: 16)
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}
