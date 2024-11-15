import SwiftUI

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
            Section(header: SectionHeader(title: "Attributes", systemImage: "person.fill")) {
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
            Section(header: SectionHeader(title: "Combat Stats", systemImage: "shield.fill")) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    StatCard(label: "Attack", value: "\(character.attackValue)", systemImage: "sword.circle")
                    StatCard(label: "Defense", value: "\(character.defenseValue)", systemImage: "shield.circle")
                    StatCard(label: "Movement", value: "\(character.movement) ft", systemImage: "figure.walk")
                    StatCard(label: "Save", value: "\(character.saveValue)", systemImage: "dice")
                }
                .padding(.vertical, 8)
            }
            
            // MARK: - Groups Section
            Section(header: SectionHeader(title: "Character Groups", systemImage: "person.3.fill")) {
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
                        
                        FlowLayout(spacing: 8) {
                            ForEach(character.affiliationGroups, id: \.self) { group in
                                Text(group)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(12)
                            }
                        }
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
            Section(header: SectionHeader(title: "Languages", systemImage: "text.bubble.fill")) {
                FlowLayout(spacing: 8) {
                    ForEach(character.languages, id: \.self) { language in
                        Text(language)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding(.vertical, 4)
            }
            
            // MARK: - Equipment Section
            Section(header: SectionHeader(title: "Equipment", systemImage: "bag.fill")) {
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
                        Image(systemName: "coins.fill")
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
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 6))
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
            Section(header: SectionHeader(title: "Additional Information", systemImage: "info.circle.fill")) {
                HStack(spacing: 16) {
                    StatCard(label: "Experience", value: "\(character.experience) XP", systemImage: "star.fill")
                    StatCard(label: "Corruption", value: "\(character.corruption)", systemImage: "exclamationmark.triangle.fill")
                }
                .padding(.vertical, 8)
            }
            
            // MARK: - Notes Section
            if !character.notes.isEmpty {
                Section(header: SectionHeader(title: "Notes", systemImage: "note.text")) {
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
    let systemImage: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
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
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Image(systemName: systemImage)
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
        Double(current) / Double(max)
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
        Double(current) / Double(max)
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

struct FlowLayout: Layout {
    let spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                    y: bounds.minY + result.positions[index].y),
                         proposal: ProposedViewSize(result.sizes[index]))
        }
    }
    
    struct FlowResult {
        var positions: [CGPoint]
        var sizes: [CGSize]
        var size: CGSize
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            positions = []
            sizes = []
            
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            var maxWidth: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                sizes.append(size)
                
                if currentX + size.width > maxWidth {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
                maxWidth = max(maxWidth, currentX)
            }
            
            size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}
