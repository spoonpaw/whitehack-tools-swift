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
    }
}

public struct StatCard: View, Equatable {
    let label: String
    let value: String
    let icon: AnyView
    @Environment(\.colorScheme) private var colorScheme

    private var backgroundColor: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemGroupedBackground)
        #else
        return Color(nsColor: .windowBackgroundColor)
        #endif
    }

    public static func == (lhs: StatCard, rhs: StatCard) -> Bool {
        lhs.label == rhs.label &&
        lhs.value == rhs.value
    }
    
    public init(label: String, value: String, icon: AnyView) {
        self.label = label
        self.value = value
        self.icon = icon
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 8) {
            icon
                .frame(width: 24, height: 24)
                .foregroundColor(.accentColor)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
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

// MARK: - Tab Picker
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
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color(uiColor: .secondarySystemBackground) : .clear)
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Character Detail View
struct CharacterDetailView: View {
    let characterId: UUID
    @ObservedObject var characterStore: CharacterStore
    @State private var refreshTrigger = false
    @State private var selectedTab: DetailTab = .info
    @Binding var currentView: CharacterListView.CurrentView
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
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
        ScrollView {
            if let character = character {
                VStack(spacing: 16) {
                    TabPicker(selection: $selectedTab)
                        .padding(.horizontal)
                    
                    switch selectedTab {
                    case .info:
                        // Basic Info Section
                        Section(header: SectionHeader(title: "Basic Info", icon: Ph.userCircle.bold)) {
                            DetailHeaderSection(character: character)
                        }
                        
                        DetailStatsSection(character: character)
                        
                        DetailGroupsSection(character: character)
                        
                        DetailWiseMiracleSection(character: character)
                        
                    case .combat:
                        DetailCombatSection(character: character)
                        
                    case .equipment:
                        DetailEquipmentSection(character: character)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            } else {
                Text("Character not found")
                    .foregroundColor(.secondary)
            }
        }
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
                    currentView = .form(characterId)
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
                    currentView = .form(characterId)
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }
            #endif
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
            DetailDeftAttunementSection(character: character)
            DetailWiseMiracleSection(character: character)
            DetailGroupsSection(character: character)
            DetailLanguagesSection(character: character)
            DetailAdditionalInfoSection(character: character)
        }
        .padding(.horizontal)
    }
}
