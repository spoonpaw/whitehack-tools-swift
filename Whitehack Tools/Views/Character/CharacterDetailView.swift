import SwiftUI
import PhosphorSwift

struct CharacterDetailView: View {
    let characterId: UUID
    @ObservedObject var characterStore: CharacterStore
    @State private var showingEditSheet = false
    @State private var refreshTrigger = false
    @Environment(\.presentationMode) var presentationMode
    
    private var character: PlayerCharacter? {
        characterStore.characters.first(where: { $0.id == characterId })
    }
    
    var body: some View {
        Group {
            if let character = character {
                List {
                    DetailHeaderSection(character: character)
                    DetailStatsSection(character: character)
                    DetailCombatSection(character: character)
                    DetailWeaponsSection(weapons: character.weapons)
                    DetailArmorSection(armor: character.armor, totalDefenseValue: character.totalDefenseValue)
                    DetailGroupsSection(character: character)
                    DetailLanguagesSection(character: character)
                    DetailGoldSection(character: character)
                    DetailEncumbranceSection(character: character)
                    DetailEquipmentSection(character: character)
                    DetailDeftAttunementSection(character: character)
                    DetailStrongCombatSection(character: character)
                    DetailWiseMiracleSection(character: character)
                    DetailBraveQuirksSection(characterClass: character.characterClass,
                                           level: character.level,
                                           braveQuirkOptions: character.braveQuirkOptions,
                                           comebackDice: character.comebackDice,
                                           hasUsedSayNo: character.hasUsedSayNo)
                    DetailCleverKnacksSection(characterClass: character.characterClass,
                                           level: character.level,
                                           cleverKnackOptions: character.cleverKnackOptions)
                    if character.characterClass == .fortunate {
                        DetailFortunateSection(character: character)
                    }
                    DetailAdditionalInfoSection(character: character)
                    DetailNotesSection(character: character)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button(action: {
                        showingEditSheet = true
                    }) {
                        Text("Edit")
                    }
                }
            } else {
                // Character was deleted
                Text("Character no longer exists")
                    .onAppear {
                        print(" [CHARACTER DETAIL] Character \(characterId) no longer exists, dismissing view")
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationView {
                CharacterFormView(characterStore: characterStore, characterId: characterId)
            }
        }
        .onChange(of: showingEditSheet) { newValue in
            if !newValue {  // Sheet was dismissed
                print(" [CHARACTER DETAIL] Sheet dismissed, triggering view refresh")
                refreshTrigger.toggle()  // Force view refresh
            }
        }
        .id(refreshTrigger)  // Force view to recreate when trigger changes
    }
}

// MARK: - Helper Views

struct SectionHeader: View {
    let title: String
    let icon: Image

    var body: some View {
        HStack(spacing: 8) {
            icon
                .frame(width: 20, height: 20)
            Text(title)
        }
        .font(.headline)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct AttributeCard: View, Equatable {
    let label: String
    let value: String
    let description: String
    let icon: Image
    
    static func == (lhs: AttributeCard, rhs: AttributeCard) -> Bool {
        lhs.label == rhs.label &&
        lhs.value == rhs.value &&
        lhs.description == rhs.description
    }
    
    init(label: String, value: String, icon: Image, description: String = "") {
        self.label = label
        self.value = value
        self.description = description
        self.icon = icon
    }

    var body: some View {
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
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        print("📏 AttributeCard '\(label)' initial size - Width: \(geometry.size.width), Height: \(geometry.size.height)")
                    }
                    .onChange(of: geometry.size) { newSize in
                        print("📐 AttributeCard '\(label)' size changed - Width: \(newSize.width), Height: \(newSize.height)")
                    }
            }
        )
    }
}

struct StatCard: View {
    let label: String
    let value: String
    let icon: Image

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                icon
                    .frame(width: 16, height: 16)
                Text(label)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)

            Text(value)
                .font(.title2)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SaveCard: View {
    let value: Int
    let color: String
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Ph.diceFive.bold
                    .frame(width: 16, height: 16)
                Text("Save")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            VStack(spacing: 2) {
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(.medium)
                
                if !color.isEmpty {
                    Text(color.capitalized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(12)
    }
}

struct StatPill: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

struct GroupPill: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(12)
    }
}

struct EncumbranceBar: View {
    let current: Int
    let max: Int

    var encumbrancePercentage: Double {
        max > 0 ? Double(current) / Double(max) : 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)

                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: geometry.size.width * encumbrancePercentage)
                        .cornerRadius(8)
                }
            }
            .frame(height: 12)

            Text("\(current)/\(max)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct FlowLayout: View {
    let spacing: CGFloat
    let content: [AnyView]

    init(spacing: CGFloat, content: [AnyView]) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        let size = geometry.size

        return ZStack(alignment: .topLeading) {
            ForEach(Array(self.content.enumerated()), id: \.offset) { index, item in
                item
                    .alignmentGuide(.leading) { dimension in
                        if abs(width - dimension.width) > size.width {
                            width = 0
                            height -= dimension.height + spacing
                        }
                        let result = width
                        if index == content.count - 1 {
                            width = 0
                        } else {
                            width -= dimension.width + spacing
                        }
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        if index == content.count - 1 {
                            height = 0
                        }
                        return result
                    }
            }
        }
    }
}
