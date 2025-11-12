import SwiftUI
import PhosphorSwift
import Foundation

struct CharacterListView: View {
    @EnvironmentObject private var characterStore: CharacterStore
    @EnvironmentObject private var importViewModel: CharacterImportViewModel
    @Binding var showingImportSheet: Bool
    @State private var showingExportSheet = false
    @State private var showingDeleteConfirmation = false
    @State private var characterToDelete: IndexSet?
    @State private var currentView: CurrentView = .list
    @Environment(\.colorScheme) private var colorScheme
    
    init(showingImportSheet: Binding<Bool>) {
        _showingImportSheet = showingImportSheet
    }
    
    enum CurrentView {
        case list
        case form(UUID?, selectedTab: FormTab = .info)
        case detail(UUID, selectedTab: DetailTab = .info)
        
        static func == (lhs: CurrentView, rhs: CurrentView) -> Bool {
            switch (lhs, rhs) {
            case (.list, .list):
                return true
            case (.form(let id1, _), .form(let id2, _)):
                return id1 == id2
            case (.detail(let id1, _), .detail(let id2, _)):
                return id1 == id2
            default:
                return false
            }
        }
    }
    
    var body: some View {
        Group {
            switch currentView {
            case .list:
                CharacterListContent(
                    showingImportSheet: $showingImportSheet,
                    showingExportSheet: $showingExportSheet,
                    showingDeleteConfirmation: $showingDeleteConfirmation,
                    characterToDelete: $characterToDelete,
                    currentView: $currentView
                )
                .environmentObject(characterStore)
                .environmentObject(importViewModel)
                
            case .form(let characterId, let selectedTab):
                CharacterFormView(
                    characterStore: characterStore,
                    characterId: characterId,
                    onComplete: { savedId, selectedTab in
                        if let id = savedId ?? characterId {
                            currentView = .detail(id, selectedTab: DetailTab(rawValue: selectedTab.rawValue) ?? .info)
                        } else {
                            currentView = .list
                        }
                    },
                    initialTab: selectedTab
                )
                
            case .detail(let characterId, let selectedTab):
                CharacterDetailView(characterId: characterId, characterStore: characterStore, selectedTab: selectedTab, currentView: $currentView)
            }
        }
        .sheet(isPresented: $showingImportSheet) {
            CharacterImportView(characterStore: characterStore, viewModel: importViewModel)
                .environmentObject(importViewModel)
        }
    }
}

private struct CharacterListContent: View {
    @EnvironmentObject private var characterStore: CharacterStore
    @EnvironmentObject private var importViewModel: CharacterImportViewModel
    @Binding var showingImportSheet: Bool
    @Binding var showingExportSheet: Bool
    @Binding var showingDeleteConfirmation: Bool
    @Binding var characterToDelete: IndexSet?
    @Binding var currentView: CharacterListView.CurrentView
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 16) {
                    Button {
                        showingImportSheet = true
                    } label: {
                        Text("Import")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        showingExportSheet = true
                    } label: {
                        Text("Export")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
                
                Button {
                    currentView = .form(nil)
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color.systemBackground)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Characters")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                CharacterList(
                    characterToDelete: $characterToDelete,
                    showingDeleteConfirmation: $showingDeleteConfirmation,
                    currentView: $currentView
                )
                .listStyle(.plain)
            }
        }
        #if os(iOS)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { EmptyView() }
        }
        #endif
        .sheet(isPresented: $showingExportSheet) {
            CharacterExportView(characters: characterStore.characters)
        }
        .alert("Delete Character?", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                if let indexSet = characterToDelete {
                    characterStore.deleteCharacter(at: indexSet)
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

private struct CharacterList: View {
    @EnvironmentObject private var characterStore: CharacterStore
    @Binding var characterToDelete: IndexSet?
    @Binding var showingDeleteConfirmation: Bool
    @Binding var currentView: CharacterListView.CurrentView
    
    var body: some View {
        List {
            ForEach(characterStore.characters) { character in
                CharacterListRow(
                    character: character,
                    characterToDelete: $characterToDelete,
                    showingDeleteConfirmation: $showingDeleteConfirmation,
                    currentView: $currentView
                )
                #if os(macOS)
                .padding(.top, characterStore.characters.first?.id == character.id ? 8 : 0)
                #endif
                #if os(iOS)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        if let index = characterStore.characters.firstIndex(where: { $0.id == character.id }) {
                            characterToDelete = IndexSet([index])
                            showingDeleteConfirmation = true
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                #endif
            }
        }
    }
}

private struct CharacterListRow: View {
    let character: PlayerCharacter
    @Binding var characterToDelete: IndexSet?
    @Binding var showingDeleteConfirmation: Bool
    @Binding var currentView: CharacterListView.CurrentView
    @EnvironmentObject private var characterStore: CharacterStore
    
    var body: some View {
        HStack {
            Button {
                currentView = .detail(character.id, selectedTab: .info)
            } label: {
                CharacterRowView(character: character)
            }
            .buttonStyle(.plain)
            
            #if os(macOS)
            Button {
                if let index = characterStore.characters.firstIndex(where: { $0.id == character.id }) {
                    characterToDelete = IndexSet([index])
                    showingDeleteConfirmation = true
                }
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.system(size: 14))
            }
            .buttonStyle(.plain)
            .padding(.trailing, 8)
            #endif
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

private struct CharacterRowView: View {
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
    
    private var backgroundFillColor: Color {
        if colorScheme == .dark {
            #if os(iOS)
            return Color(uiColor: .systemGray6)
            #else
            return Color(nsColor: .windowBackgroundColor)
            #endif
        } else {
            return .white
        }
    }
    
    var body: some View {
        VStack {
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
                    Text(character.name.isEmpty ? "Unnamed Character" : character.name)
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
                            #if os(iOS)
                            .background(Color(UIColor.tertiarySystemBackground))
                            #else
                            .background(Color(NSColor.controlBackgroundColor))
                            #endif
                            .foregroundColor(.primary)
                            .clipShape(Capsule())
                            #if os(iOS)
                            .overlay(
                                Capsule()
                                    .stroke(Color(UIColor.separator).opacity(0.25), lineWidth: 1)
                            )
                            #else
                            .overlay(
                                Capsule()
                                    .stroke(Color(NSColor.separatorColor).opacity(0.25), lineWidth: 1)
                            )
                            #endif
                    }
                    
                    if let species = character.speciesGroup {
                        HStack(spacing: 4) {
                            Ph.dna.bold
                                .frame(width: 12, height: 12)
                                .foregroundColor(.secondary)
                            Text(species.isEmpty ? "No Species Selected" : species)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if let vocation = character.vocationGroup {
                        HStack(spacing: 4) {
                            Ph.briefcase.bold
                                .frame(width: 12, height: 12)
                                .foregroundColor(.secondary)
                            Text(vocation.isEmpty ? "No Vocation Selected" : vocation)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .background(backgroundFillColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
