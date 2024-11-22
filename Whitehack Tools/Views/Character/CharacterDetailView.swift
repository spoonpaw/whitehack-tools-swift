import SwiftUI
import PhosphorSwift

struct CharacterDetailView: View {
    let character: PlayerCharacter
    @ObservedObject var characterStore: CharacterStore
    @State private var showingEditSheet = false

    var body: some View {
        List {
            // MARK: - Character Header
            Section {
                VStack(spacing: 8) {
                    Text(character.name)
                        .font(.title)
                        .fontWeight(.bold)

                    HStack(spacing: 16) {
                        StatPill(label: "Level", value: "\(character.level)")
                        StatPill(label: "Class", value: character.characterClass.rawValue)
                        StatPill(label: "XP", value: "\(character.experience)")
                    }

                    // Health Bar
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Health")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HealthBar(current: character.currentHP, max: character.maxHP)
                    }
                }
                .padding(.vertical, 8)
            }

            // MARK: - Attributes Section
            Section(header: SectionHeader(title: "Attributes", icon: Ph.user.bold)) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    AttributeCard(label: "Strength", value: character.strength)
                    AttributeCard(label: "Agility", value: character.agility)
                    AttributeCard(label: "Toughness", value: character.toughness)
                    AttributeCard(label: "Intelligence", value: character.intelligence)
                    AttributeCard(label: "Willpower", value: character.willpower)
                    AttributeCard(label: "Charisma", value: character.charisma)
                }
                .padding(.vertical, 8)
            }

            // MARK: - Combat Stats Section
            Section(header: SectionHeader(title: "Combat Stats", icon: Ph.shield.bold)) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    StatCard(label: "Attack", value: "\(character.attackValue)", icon: Ph.sword.bold)
                    StatCard(label: "Defense", value: "\(character.defenseValue)", icon: Ph.shield.bold)
                    StatCard(label: "Movement", value: "\(character.movement) ft", icon: Ph.personSimpleRun.bold)
                    StatCard(label: "Save", value: "\(character.saveValue)\(character.saveColor.isEmpty ? "" : " (\(character.saveColor))")", icon: Ph.diceFive.bold)
                }
                .padding(.vertical, 8)
            }

            // MARK: - Groups Section
            Section(header: SectionHeader(title: "Character Groups", icon: Ph.users.bold)) {
                // Species & Vocation
                HStack(spacing: 16) {
                    GroupPill(label: "Species", value: character.speciesGroup ?? "None")
                    GroupPill(label: "Vocation", value: character.vocationGroup ?? "None")
                }
                .padding(.vertical, 4)

                // Affiliation Groups
                if !character.affiliationGroups.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Affiliations")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        FlowLayout(spacing: 8, content: character.affiliationGroups.map { group in
                            AnyView(
                                Text(group)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(12)
                            )
                        })
                    }
                    .padding(.vertical, 4)
                }

                // Attribute-Group Pairs
                if !character.attributeGroupPairs.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Attribute Specializations")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        ForEach(character.attributeGroupPairs) { pair in
                            HStack {
                                Text(pair.attribute)
                                    .fontWeight(.medium)
                                Text("•")
                                    .foregroundColor(.secondary)
                                Text(pair.group)
                            }
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            // MARK: - Languages Section
            Section(header: SectionHeader(title: "Languages", icon: Ph.chatText.bold)) {
                FlowLayout(spacing: 8, content: character.languages.map { language in
                    AnyView(
                        Text(language)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                    )
                })
                .padding(.vertical, 4)
            }

            // MARK: - Equipment Section
            Section(header: SectionHeader(title: "Equipment", icon: Ph.briefcase.bold)) {
                VStack(alignment: .leading, spacing: 16) {
                    // Encumbrance Bar
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Encumbrance")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        EncumbranceBar(current: character.currentEncumbrance, max: character.maxEncumbrance)
                    }

                    // Coins
                    HStack {
                        Ph.coins.bold
                            .frame(width: 16, height: 16)
                            .foregroundColor(.yellow)
                        Text("\(character.coins) GP")
                            .fontWeight(.medium)
                    }

                    // Inventory
                    if !character.inventory.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Inventory (\(character.inventory.count) items)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            ForEach(character.inventory, id: \.self) { item in
                                HStack {
                                    Ph.circle.fill
                                        .frame(width: 6, height: 6)
                                        .foregroundColor(.secondary)
                                    Text(item)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
            }

            // MARK: - Other Stats Section
            Section(header: SectionHeader(title: "Additional Information", icon: Ph.info.bold)) {
                HStack(spacing: 16) {
                    StatCard(label: "Experience", value: "\(character.experience) XP", icon: Ph.star.bold)
                    StatCard(label: "Corruption", value: "\(character.corruption)", icon: Ph.warning.bold)
                }
                .padding(.vertical, 8)
            }

            // MARK: - Notes Section
            if !character.notes.isEmpty {
                Section(header: SectionHeader(title: "Notes", icon: Ph.note.bold)) {
                    Text(character.notes)
                        .padding(.vertical, 8)
                }
            }
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
        .sheet(isPresented: $showingEditSheet) {
            CharacterFormView(characterStore: characterStore, character: character)
        }
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
    let value: Int

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("\(value)")
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue.opacity(0.1))
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
                .font(.title3)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue.opacity(0.1))
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

struct HealthBar: View {
    let current: Int
    let max: Int

    var healthPercentage: Double {
        max > 0 ? Double(current) / Double(max) : 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.red.opacity(0.2))
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)

                    Rectangle()
                        .fill(Color.red)
                        .frame(width: geometry.size.width * healthPercentage)
                        .cornerRadius(8)
                }
            }
            .frame(height: 12)

            Text("\(current)/\(max) HP")
                .font(.caption)
                .foregroundColor(.secondary)
        }
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
        var lastHeight = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(Array(content.enumerated()), id: \.offset) { index, item in
                item
                    .alignmentGuide(.leading) { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= lastHeight
                            lastHeight = 0
                        }
                        let result = width
                        if index == content.count - 1 {
                            width = 0
                        } else {
                            width -= dimension.width + spacing
                        }
                        return result
                    }
                    .alignmentGuide(.top) { dimension in
                        let result = height
                        if index == content.count - 1 {
                            height = 0
                        }
                        lastHeight = dimension.height
                        return result
                    }
            }
        }
    }
}
