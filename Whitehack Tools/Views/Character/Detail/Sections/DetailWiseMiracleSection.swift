import SwiftUI

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
                    // Class Info Card
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Masters of miracles who negotiate with supernatural forces. Whether as cultists, chemists, meta-mathematicians, exorcists, druids, bards, or wizards, they channel powers beyond normal comprehension.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.yellow.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    // Class Features
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "sparkles.square.filled.on.square")
                                .foregroundColor(.yellow)
                            Text("Class Features")
                                .font(.headline)
                            Spacer()
                            Text("\(character.level)")
                                .font(.headline)
                                .padding(8)
                                .background(Color.yellow.opacity(0.2))
                                .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            WiseBenefitRow(text: "Heal supernaturally at 2× natural rate (but need normal healing for non-HP recovery)", icon: "heart.fill", color: .red)
                            WiseBenefitRow(text: "+2 save vs. magick and mind influence", icon: "brain.head.profile", color: .blue)
                            WiseBenefitRow(text: "-2 AV with non-slotted two-handed weapons", icon: "shield.fill", color: .purple)
                            WiseBenefitRow(text: "+2 HP cost when using shields/heavy armor", icon: "shield.lefthalf.filled", color: .orange)
                            WiseBenefitRow(text: "Can slot scroll effects with Intelligence check (if level > HP cost)", icon: "scroll", color: .green)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                    )
                    
                    // Miracle Rules
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "book.closed.fill")
                                .foregroundColor(.yellow)
                            Text("Miracle Guidelines")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "sparkles")
                                .foregroundColor(.yellow)
                        }
                        
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
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                    )
                    
                    // Cost Modifiers
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "plusminus.circle.fill")
                                .foregroundColor(.yellow)
                            Text("Cost Modifiers")
                                .font(.headline)
                            Spacer()
                        }
                        
                        VStack(spacing: 16) {
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
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                    )
                    
                    // HP Cost Reference
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                                .foregroundColor(.yellow)
                            Text("HP Cost Magnitudes")
                                .font(.headline)
                            Spacer()
                        }
                        
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
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                    )
                    
                    // Existing Miracle Slots
                    ForEach(Array(character.wiseMiracleSlots.enumerated()), id: \.element.id) { index, slot in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Slot \(index + 1)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                if index == 0 && extraInactiveMiracles > 0 {
                                    Text("(\(extraInactiveMiracles) extra inactive)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.secondary.opacity(0.2))
                                        .cornerRadius(12)
                                }
                                Spacer()
                                if index == 2 && slot.isMagicItem {
                                    Label("Magic Item", systemImage: "wand.and.stars")
                                        .font(.caption)
                                        .foregroundColor(.yellow)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 4)
                            
                            if index == 2 && slot.isMagicItem {
                                HStack {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.yellow)
                                    Text(slot.magicItemName.isEmpty ? "Empty Magic Item" : slot.magicItemName)
                                        .foregroundColor(.yellow)
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
                            } else {
                                let maxMiracles = index == 0 ? 2 + extraInactiveMiracles : 2
                                ForEach(0..<maxMiracles, id: \.self) { miracleIndex in
                                    if miracleIndex < slot.miracles.count {
                                        miracleView(slot.miracles[miracleIndex])
                                    } else {
                                        emptyMiracleView()
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.primary.opacity(0.05), radius: 2, x: 0, y: 1)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 4)
                    }
                }
            } header: {
                Label {
                    Text("The Wise")
                        .font(.headline)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "sparkles")
                        .foregroundColor(.yellow)
                }
            } footer: {
                VStack(alignment: .leading, spacing: 8) {
                    if character.level == 1 {
                        Text("Level 1 slot gets \(extraInactiveMiracles) extra inactive miracle\(extraInactiveMiracles == 1 ? "" : "s") (Willpower \(character.willpower))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else if character.level == 3 {
                        Text("Level 3 slot can hold a magic item instead of miracles")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("💡 Tip: Miracle costs can be reduced with drawbacks, ingredients, or by detecting energy concentrations")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
            }
        }
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

struct WiseBenefitRow: View {
    let text: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .imageScale(.small)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }
}

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
