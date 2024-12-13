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
            HStack(spacing: 8) {
                ForEach(DetailTab.allCases, id: \.id) { tab in
                    TabButton(
                        title: tab.title,
                        icon: tab.icon,
                        isSelected: selection == tab
                    ) {
                        withAnimation {
                            selection = tab
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, alignment: .center)
        }
        .frame(height: 60)
    }
}

public struct TabButton: View {
    let title: String
    let icon: Image
    let isSelected: Bool
    let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                IconFrame(icon: icon, color: isSelected ? .accentColor : .secondary)
                Text(title)
                    .font(.footnote)
                    .foregroundColor(isSelected ? .primary : .secondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            #if os(iOS)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color(uiColor: .secondarySystemBackground) : .clear)
            )
            #else
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color(nsColor: .controlBackgroundColor) : .clear)
            )
            #endif
            .frame(maxWidth: .infinity)
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
            
            ScrollView {
                if let character = character {
                    VStack(spacing: 0) {
                        switch selectedTab {
                        case .info:
                            VStack(spacing: 32) {
                                VStack(alignment: .leading, spacing: 12) {
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
                                
                                DetailWiseMiracleSection(character: character)
                                    .padding(.horizontal, 16)
                                
                                DetailAdditionalInfoSection(character: character)
                                    .padding(.horizontal, 16)
                                
                                DetailNotesSection(character: character)
                                    .padding(.horizontal, 16)
                            }
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
                            }
                            .padding()
                        }
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    ProgressView()
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
private struct BasicInfoTabView: View {
    let character: PlayerCharacter
    
    var body: some View {
        VStack(spacing: 16) {
            DetailHeaderSection(character: character)
            DetailStatsSection(character: character)
            DetailFortunateSection(character: character)
            DetailGroupsSection(character: character)
            DetailLanguagesSection(character: character)
            DetailDeftAttunementSection(character: character)
            DetailWiseMiracleSection(character: character)
            DetailAdditionalInfoSection(character: character)
        }
        .padding(.horizontal)
    }
}
