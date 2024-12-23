import SwiftUI
import PhosphorSwift

// MARK: - Shared Components
public struct SectionHeader: View {
    let title: String
    let icon: Image

    public var body: some View {
        HStack(spacing: 8) {
            icon
                .frame(width: 20, height: 20)
            Text(title)
        }
        .font(.headline)
        .frame(maxWidth: .infinity)
    }
}

public struct TabPicker: View {
    @Binding var selection: DetailTab
    
    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 12) {
                ForEach(DetailTab.allCases, id: \.id) { tab in
                    TabButton(
                        title: tab.title,
                        icon: tab.icon,
                        isSelected: selection == tab
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selection = tab
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, alignment: .center)
            .padding(.vertical, 12)
        }
        .frame(height: 84)
    }
}

public struct TabButton: View {
    let title: String
    let icon: Image
    let isSelected: Bool
    let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                IconFrame(icon: icon, color: isSelected ? .accentColor : .secondary)
                Text(title)
                    .font(.footnote)
                    .fontWeight(isSelected ? .medium : .regular)
                    .foregroundColor(isSelected ? .primary : .secondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isSelected ? Color.accentColor.opacity(0.2) : Color.clear, lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Tab Enum
public enum DetailTab: String, CaseIterable, Identifiable {
    case info, combat, equipment
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .info: return "Info"
        case .combat: return "Combat"
        case .equipment: return "Equipment"
        }
    }
    
    public var icon: Image {
        switch self {
        case .info: return Image(systemName: "info.circle")
        case .combat: return Image(systemName: "shield")
        case .equipment: return Image(systemName: "bag")
        }
    }
}

// MARK: - Character Detail View
struct CharacterDetailView: View {
    let characterId: UUID
    @ObservedObject var characterStore: CharacterStore
    @State private var refreshTrigger = false
    @State private var selectedTab: DetailTab
    @Binding var currentView: CharacterListView.CurrentView
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    init(characterId: UUID, characterStore: CharacterStore, selectedTab: DetailTab = .info, currentView: Binding<CharacterListView.CurrentView>) {
        self.characterId = characterId
        self.characterStore = characterStore
        self._selectedTab = State(initialValue: selectedTab)
        self._currentView = currentView
    }

    private var character: PlayerCharacter? {
        characterStore.characters.first(where: { $0.id == characterId })
    }
    
    private var mainBackgroundColor: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemGroupedBackground)
        #else
        return Color(nsColor: .windowBackgroundColor)
        #endif
    }

    private func getAttributeDescription(_ value: Int) -> String {
        if value >= 16 {
            return "Exceptional (+2)"
        } else if value >= 13 {
            return "Above Average (+1)"
        } else if value >= 8 {
            return "Average"
        } else if value >= 6 {
            return "Below Average (-1)"
        } else {
            return "Poor (-2)"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabPicker(selection: $selectedTab)
                .padding(.horizontal)
                .background(.background)
                .overlay(
                    Divider()
                        .opacity(0.5), 
                    alignment: .bottom
                )
            
            ScrollView {
                ScrollViewReader { proxy in
                    if let character = character {
                        VStack(spacing: 0) {
                            Color.clear
                                .frame(height: 0)
                                .id("scroll-to-top")
                            
                            switch selectedTab {
                            case .info:
                                InfoTabView(character: character)
                                    .padding(.vertical, 16)
                            case .combat:
                                DetailCombatSection(character: character)
                                    .padding()
                            case .equipment:
                                VStack(spacing: 32) {
                                    DetailWeaponsSection(weapons: character.weapons)
                                    DetailArmorSection(armor: character.armor, totalDefenseValue: character.defenseValue)
                                    DetailEquipmentSection(character: character)
                                    DetailGoldSection(character: character)
                                    DetailEncumbranceSection(character: character)
                                }
                                .padding()
                            }
                        }
                        .onChange(of: selectedTab) { _ in
                            withAnimation {
                                proxy.scrollTo("scroll-to-top", anchor: .top)
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            #if os(macOS)
            .background(.white)
            #endif
            .navigationTitle("Character Details")
            .frame(maxWidth: .infinity)
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        currentView = .list
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        currentView = .form(characterId, selectedTab: FormTab(rawValue: selectedTab.rawValue) ?? .info)
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
                #else
                ToolbarItem(placement: .automatic) {
                    Button {
                        currentView = .list
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                    }
                }
                
                ToolbarItem(placement: .automatic) {
                    Button {
                        currentView = .form(characterId, selectedTab: FormTab(rawValue: selectedTab.rawValue) ?? .info)
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
                #endif
            }
        }
    }
}

// MARK: - Tab Views
private struct InfoTabView: View {
    let character: PlayerCharacter
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 4) {
                SectionHeader(title: "Basic Info", icon: Ph.userCircle.bold)
                    .padding(.horizontal, 16)
                DetailHeaderSection(character: character)
                    .padding(.horizontal, 16)
            }
            
            DetailStatsSection(character: character)
                .padding(.horizontal, 16)
            
            DetailGroupsSection(character: character)
                .padding(.horizontal, 16)
            
            DetailLanguagesSection(character: character)
                .padding(.horizontal, 16)
            
            if character.characterClass == .deft {
                DetailDeftAttunementSection(character: character)
                    .padding(.horizontal, 16)
            }
            
            if character.characterClass == .strong {
                DetailStrongCombatSection(character: character)
                    .padding(.horizontal, 16)
            }
            
            if character.characterClass == .wise {
                DetailWiseMiracleSection(character: character)
                    .padding(.horizontal, 16)
            }
            
            if character.characterClass == .brave {
                DetailBraveQuirksSection(character: character)
                    .padding(.horizontal, 16)
            }
            
            if character.characterClass == .clever {
                DetailCleverKnacksSection(
                    characterClass: character.characterClass,
                    level: character.level,
                    cleverKnackOptions: character.cleverKnackOptions
                )
                .padding(.horizontal, 16)
            }
            
            if character.characterClass == .fortunate {
                DetailFortunateSection(character: character)
                    .padding(.horizontal, 16)
            }
            
            DetailAdditionalInfoSection(character: character)
                .padding(.horizontal, 16)
            
            DetailNotesSection(character: character)
                .padding(.horizontal, 16)
        }
    }
}
