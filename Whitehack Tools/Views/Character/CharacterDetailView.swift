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

struct AttributeCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
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

        return ZStack(alignment: .topLeading) {
            ForEach(Array(self.content.enumerated()), id: \.offset) { index, item in
                item
                    .alignmentGuide(.leading) { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
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
