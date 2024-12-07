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

public struct AttributeCard: View, Equatable {
    let label: String
    let value: String
    let description: String
    let icon: Image
    @Environment(\.colorScheme) private var colorScheme

    private var backgroundColor: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemGroupedBackground)
        #else
        return Color(nsColor: .windowBackgroundColor)
        #endif
    }

    public static func == (lhs: AttributeCard, rhs: AttributeCard) -> Bool {
        lhs.label == rhs.label &&
        lhs.value == rhs.value &&
        lhs.description == rhs.description
    }
    
    public init(label: String, value: String, icon: Image, description: String = "") {
        self.label = label
        self.value = value
        self.description = description
        self.icon = icon
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 8) {
            icon
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .frame(width: 32, height: 32)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            
            Text(label)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            if !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .frame(height: 220.5)  // Force all cards to be the same height
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
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
        }
    }
}

public struct TabButton: View {
    let title: String
    let icon: Image
    let isSelected: Bool
    let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                IconFrame(icon: icon, color: isSelected ? .accentColor : .secondary)
                Text(title)
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
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Character Detail View
struct CharacterDetailView: View {
    let characterId: UUID
    @ObservedObject var characterStore: CharacterStore
    @State private var refreshTrigger = false
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

    var body: some View {
        ScrollView {
            if let character = character {
                VStack(spacing: 24) {
                    // Basic Info Section
                    Section(header: SectionHeader(title: "Basic Info", icon: Ph.userCircle.bold)) {
                        VStack(alignment: .leading, spacing: 16) {
                            // Name and Class
                            VStack(alignment: .leading, spacing: 4) {
                                Text(character.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text(character.characterClass.rawValue)
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Level and HP
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Level")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("\(character.level)")
                                        .font(.body)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("HP")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("\(character.currentHP)/\(character.maxHP)")
                                        .font(.body)
                                }
                            }
                        }
                        .padding()
                        .background(.secondary.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // Attributes Section
                    Section(header: SectionHeader(title: "Attributes", icon: Ph.barbell.bold)) {
                        VStack(spacing: 16) {
                            if character.useCustomAttributes {
                                // Display custom attributes
                                ForEach(character.customAttributes) { attribute in
                                    HStack {
                                        Text(attribute.name)
                                            .font(.headline)
                                            .frame(width: 100, alignment: .leading)
                                        
                                        Text("\(attribute.value)")
                                            .font(.body)
                                            .frame(width: 40)
                                        
                                        let modifier = (attribute.value - 10) / 2
                                        Text("(\(modifier >= 0 ? "+" : "")\(modifier))")
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            } else {
                                // Display default attributes
                                let attributes = [
                                    ("STR", character.strength),
                                    ("DEX", character.agility),
                                    ("CON", character.toughness),
                                    ("INT", character.intelligence),
                                    ("WIS", character.willpower),
                                    ("CHA", character.charisma)
                                ]
                                ForEach(attributes, id: \.0) { attribute, value in
                                    HStack {
                                        Text(attribute)
                                            .font(.headline)
                                            .frame(width: 50, alignment: .leading)
                                        
                                        Text("\(value)")
                                            .font(.body)
                                            .frame(width: 40)
                                        
                                        let modifier = (value - 10) / 2
                                        Text("(\(modifier >= 0 ? "+" : "")\(modifier))")
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(.secondary.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    DetailGroupsSection(character: character)
                    DetailWiseMiracleSection(character: character)
                }
                .frame(maxWidth: 600)
                .padding(.horizontal)
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
