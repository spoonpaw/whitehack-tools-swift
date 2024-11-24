import SwiftUI
import PhosphorSwift

// MARK: - Main View
struct DetailWiseMiracleSection: View {
    let character: PlayerCharacter
    @Environment(\.colorScheme) var colorScheme
    
    private var extraInactiveMiracles: Int {
        guard character.characterClass == .wise && character.level == 1 else { return 0 }
        if character.willpower >= 16 {
            return 2
        } else if character.willpower >= 13 {
            return 1
        }
        return 0
    }
    
    var body: some View {
        if character.characterClass == .wise {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    ClassInfoCard()
                    ClassFeaturesCard()
                    MiracleGuidelinesCard()
                    CostModifiersCard()
                    HPCostReferenceCard()
                    
                    ForEach(Array(character.wiseMiracleSlots.enumerated()), id: \.element.id) { index, slot in
                        MiracleSlotCard(
                            index: index,
                            slot: slot,
                            colorScheme: colorScheme
                        )
                    }
                }
                .padding(.vertical)
            } header: {
                WiseSectionHeader()
            }
        } else {
            EmptyView()
        }
    }
}

// MARK: - Section Header
private struct WiseSectionHeader: View {
    var body: some View {
        Label {
            Text("The Wise")
                .font(.headline)
                .foregroundColor(.primary)
        } icon: {
            Image(systemName: "sparkles")
                .foregroundColor(.yellow)
        }
    }
}

// MARK: - Cards
private struct ClassInfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles.square.filled.on.square")
                    .foregroundColor(.yellow)
                Text("Class Overview")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Text("Masters of miracles who negotiate with supernatural forces. Whether as cultists, chemists, meta-mathematicians, exorcists, druids, bards, or wizards, they channel powers beyond normal comprehension.")
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct ClassFeaturesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Class Features")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            WiseMiracleFeatureRow(
                icon: "wand.and.stars",
                color: .yellow,
                title: "Miracles",
                description: "Can perform miracles by spending HP. Each miracle slot can hold multiple miracles, but only one can be active at a time."
            )
            
            WiseMiracleFeatureRow(
                icon: "sparkles",
                color: .yellow,
                title: "Miracle Slots",
                description: "Gain additional miracle slots at higher levels. Level 3 slot can alternatively hold a magic item."
            )
            
            WiseMiracleFeatureRow(
                icon: "brain.head.profile",
                color: .yellow,
                title: "Willpower Bonus",
                description: "High Willpower grants additional inactive miracles in the level 1 slot."
            )
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct MiracleGuidelinesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "book.closed.fill")
                    .foregroundColor(.yellow)
                Text("Miracle Guidelines")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Text("Miracles are governed by the following rules:")
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach([
                    (title: "HP Cost", text: "Cannot attempt miracles with an initial maximum cost > current HP", icon: "heart.fill", color: Color.red),
                    (title: "Level Check", text: "Must save or double cost if HP cost > level", icon: "exclamationmark.triangle.fill", color: Color.orange),
                    (title: "Energy Detection", text: "Save once/day (10min) to reduce magnitude by 1", icon: "bolt.fill", color: Color.yellow),
                    (title: "Crafting", text: "First charge costs 2×, permanent items cost 2× permanent HP", icon: "hammer.fill", color: Color.purple)
                ], id: \.title) { rule in
                    MiracleRuleCard(title: rule.title, text: rule.text, icon: rule.icon, color: rule.color)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct CostModifiersCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "plusminus.circle.fill")
                    .foregroundColor(.yellow)
                Text("Cost Modifiers")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Text("The following factors can modify the cost of a miracle:")
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(alignment: .leading, spacing: 12) {
                // Increased Cost Factors
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.red)
                        Text("Increases Cost")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach([
                            "Peripheral to vocation/wording",
                            "Extra duration/range/area/victims",
                            "No save allowed",
                            "Crafting items (×2 first charge)",
                            "Adding charges (×1 per charge)",
                            "Permanent items (×2 permanent HP)",
                            "Expensive magick type"
                        ], id: \.self) { text in
                            CostModifierRow(text: text, color: .red)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Decreased Cost Factors
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.green)
                        Text("Decreases Cost")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.green.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach([
                            "Close to vocation/wording",
                            "Rare/costly ingredients",
                            "Bad side effects for the Wise",
                            "Wise save (fail negates)",
                            "Boosting but addictive drugs",
                            "Cheap magick type",
                            "Extra casting time",
                            "Time/place requirements"
                        ], id: \.self) { text in
                            CostModifierRow(text: text, color: .green)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct HPCostReferenceCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                    .foregroundColor(.yellow)
                Text("HP Cost Magnitudes")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Text("The following HP cost magnitudes are used for miracles:")
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach([
                    (magnitude: "0", desc: "Trivial/Slotted scroll", examples: "Simple effects with limits", color: Color.green),
                    (magnitude: "1", desc: "Simple magick", examples: "Minor healing, light, unlocking", color: Color.blue),
                    (magnitude: "2", desc: "Standard magick", examples: "Force field, water breathing", color: Color.yellow),
                    (magnitude: "d6", desc: "Major magick", examples: "Teleport, animate dead", color: Color.orange),
                    (magnitude: "2d6", desc: "Powerful magick", examples: "Resurrection, weather control", color: Color.red)
                ], id: \.magnitude) { magnitude in
                    MagnitudeCard(magnitude: magnitude.magnitude, desc: magnitude.desc, examples: magnitude.examples, color: magnitude.color)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct MiracleSlotCard: View {
    let index: Int
    let slot: WiseMiracleSlot
    let colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.yellow)
                Text("Miracle Slot \(index + 1)")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            if index == 2 && slot.isMagicItem {
                magickItemView()
                magickItemInfoView()
            } else {
                ForEach(slot.miracles) { miracle in
                    miracleView(miracle)
                }
                
                if slot.miracles.isEmpty {
                    emptyMiracleView()
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func magickItemView() -> some View {
        HStack(spacing: 12) {
            Image(systemName: "wand.and.stars")
                .foregroundColor(.yellow)
                .imageScale(.large)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(slot.magicItemName.isEmpty ? "Unnamed Magick Item" : slot.magicItemName)
                    .foregroundColor(.primary)
                Text("Special equipment that extends HP by character level")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    private func magickItemInfoView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Magick Item Option")
                .font(.subheadline)
                .foregroundColor(.yellow)
            
            Text("The level 3 slot may hold a magick item—a blackstaff, a talking sword, etc.—instead of miracles. This extends the character's hp by an amount equal to her level. When chosen, any previous wordings tied to the slot are ruined. The slot can only hold a new item if the previous one breaks, which lowers both maximum and current hp.")
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(Color.yellow.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func miracleView(_ miracle: WiseMiracle) -> some View {
        HStack(spacing: 12) {
            Image(systemName: miracle.isActive ? "checkmark.circle.fill" : "circle")
                .foregroundColor(miracle.isActive ? .green : .secondary)
                .imageScale(.large)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(miracle.name.isEmpty ? "Empty Miracle" : miracle.name)
                    .foregroundColor(miracle.isActive ? .primary : .secondary)
                Text(miracle.isActive ? "Prepared for use" : "Requires preparation")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(miracle.isActive ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    private func emptyMiracleView() -> some View {
        HStack(spacing: 12) {
            Image(systemName: "circle")
                .foregroundColor(.secondary)
                .imageScale(.large)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Empty Miracle")
                    .foregroundColor(.secondary)
                Text("No miracle assigned")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
        )
        .padding(.horizontal)
        .opacity(0.5)
    }
}

// MARK: - Feature Row
struct WiseMiracleFeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .imageScale(.medium)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Miracle Rule Card
struct MiracleRuleCard: View {
    let title: String
    let text: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Spacer()
            }
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Cost Modifier Row
struct CostModifierRow: View {
    let text: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Image(systemName: "circle.fill")
                .font(.system(size: 4))
                .foregroundColor(color.opacity(0.5))
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Magnitude Card
struct MagnitudeCard: View {
    let magnitude: String
    let desc: String
    let examples: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Text(magnitude)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(desc)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Text(examples)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
