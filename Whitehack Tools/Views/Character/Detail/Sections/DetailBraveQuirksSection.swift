import SwiftUI
import PhosphorSwift

struct DetailBraveQuirksSection: View {
    let characterClass: CharacterClass
    let level: Int
    let braveQuirkOptions: BraveQuirkOptions
    let comebackDice: Int
    let hasUsedSayNo: Bool
    @Environment(\.colorScheme) var colorScheme
    
    private var availableSlots: Int {
        AdvancementTables.shared.stats(for: characterClass, at: level).slots
    }
    
    var body: some View {
        return Group {
            if characterClass == .brave {
                Section {
                    VStack(alignment: .leading, spacing: 16) {
                        ClassOverviewCard()
                        AttributesCard()
                        ArmorCard()
                        QuirksCard(braveQuirkOptions: braveQuirkOptions, availableSlots: availableSlots)
                        ComebackDiceCard(comebackDice: comebackDice)
                        SayNoPowerCard(hasUsedSayNo: hasUsedSayNo)
                        
                        if hasArmorPenalty {
                            ArmorPenaltyWarning()
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    SectionHeader(title: "The Brave", icon: Image(systemName: "heart.fill"))
                }
            }
        }
    }
    
    private var hasArmorPenalty: Bool {
        // TODO: Add armor check logic when equipment system is implemented
        return false
    }
}

// MARK: - Cards
private struct ClassOverviewCard: View {
    var body: some View {
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "figure.walk.motion")
                    .foregroundColor(.red)
                Text("Class Overview")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            BraveFeatureRow(
                icon: "heart.fill",
                color: .red,
                title: "Unlikely Heroes",
                description: "Failed apprentices, gardeners dreaming of dragons and elves, wannabe bards, or peasants taking up arms against oppression."
            )
            
            BraveFeatureRow(
                icon: "sparkles",
                color: .red,
                title: "Courageous Aura",
                description: "Very perceptive people and creatures will always sense their courageous quality."
            )
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct AttributesCard: View {
    var body: some View {
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.crop.circle.badge.plus")
                    .foregroundColor(.blue)
                Text("Attributes & HP")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            BraveFeatureRow(
                icon: "arrow.up.and.down",
                color: .blue,
                title: "Attribute Adjustments",
                description: "May raise or lower attributes at even levels."
            )
            
            BraveFeatureRow(
                icon: "heart.circle.fill",
                color: .blue,
                title: "HP Advantage",
                description: "Get two rolls for HP at levels 1–3, picking the best roll."
            )
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct ArmorCard: View {
    var body: some View {
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "shield.fill")
                    .foregroundColor(.purple)
                Text("Armor & Weapons")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            BraveFeatureRow(
                icon: "shield.lefthalf.filled",
                color: .purple,
                title: "Armor Restrictions",
                description: "Armor heavier than cloth incurs a -2 penalty to all task rolls."
            )
            
            BraveFeatureRow(
                icon: "bolt.shield.fill",
                color: .purple,
                title: "Weapon Proficiency",
                description: "Can use any weapon without penalty."
            )
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.purple.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct QuirksCard: View {
    let braveQuirkOptions: BraveQuirkOptions
    let availableSlots: Int
    
    private var headerView: some View {
        return HStack {
            Image(systemName: "sparkles")
                .foregroundColor(.yellow)
            Text("Quirks")
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Text("\(braveQuirkOptions.activeQuirks.count)/\(availableSlots)")
                .font(.title3)
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private func emptySlotView(slotIndex: Int) -> some View {
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Empty Slot")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Slot \(slotIndex + 1)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "sparkles")
                    .foregroundColor(.yellow)
            }
            
            Text("Select a quirk to fill this slot")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)
        }
        .padding(12)
        .background({
            #if os(iOS)
            return Color(uiColor: .systemGray6)
            #else
            return Color(nsColor: .windowBackgroundColor)
            #endif
        }())
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(
            color: {
                #if os(iOS)
                Color(uiColor: .systemGray4).opacity(0.3)
                #else
                Color(nsColor: .shadowColor).opacity(0.3)
                #endif
            }(),
            radius: 6,
            x: 0,
            y: 2
        )
    }
    
    private func quirkSlotView(slotIndex: Int) -> some View {
        return Group {
            if let quirk = braveQuirkOptions.getQuirk(at: slotIndex) {
                QuirkCard(
                    quirk: quirk,
                    slotIndex: slotIndex,
                    protectedAlly: braveQuirkOptions.getProtectedAlly(at: slotIndex)
                )
            } else {
                emptySlotView(slotIndex: slotIndex)
            }
        }
    }
    
    var body: some View {
        return VStack(alignment: .leading, spacing: 12) {
            headerView
            
            BraveFeatureRow(
                icon: "star.circle.fill",
                color: .yellow,
                title: "Special Abilities",
                description: "Each slot can hold a special quirk, with eight options to choose from as you level."
            )
            
            ForEach(Array(0..<availableSlots), id: \.self) { (slotIndex: Int) in
                quirkSlotView(slotIndex: slotIndex)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct ComebackDiceCard: View {
    let comebackDice: Int
    
    var body: some View {
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "dice.fill")
                    .foregroundColor(.green)
                Text("Comeback Dice")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text("\(comebackDice)d6")
                    .font(.title2)
                    .foregroundColor(comebackDice > 0 ? .green : .secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(comebackDice > 0 ? Color.green.opacity(0.1) : Color.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            BraveFeatureRow(
                icon: "arrow.clockwise",
                color: .green,
                title: "Gain Dice",
                description: "Gain a d6 when losing an auction, failing a task roll, or failing a save (not attacks)."
            )
            
            BraveFeatureRow(
                icon: "dice.fill",
                color: .green,
                title: "Use Dice",
                description: "Add to any attribute, sv, av, or replace a damage die. Only best die counts if using multiple."
            )
            
            BraveFeatureRow(
                icon: "xmark.diamond.fill",
                color: .green,
                title: "Lose Dice",
                description: "Failed rolls with comeback dice are lost and generate no new ones."
            )
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.green.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct SayNoPowerCard: View {
    let hasUsedSayNo: Bool
    
    var body: some View {
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "hand.raised.fill")
                    .foregroundColor(.red)
                Text("Say No Power")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                HStack(spacing: 12) {
                    Image(systemName: hasUsedSayNo ? "xmark.circle.fill" : "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(hasUsedSayNo ? .red : .green)
                    
                    VStack(alignment: .leading) {
                        Text(hasUsedSayNo ? "Power Used" : "Power Available")
                            .font(.subheadline)
                            .foregroundColor(hasUsedSayNo ? .red : .green)
                        Text(hasUsedSayNo ? "Resets next session" : "Ready to defy fate")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(hasUsedSayNo ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            BraveFeatureRow(
                icon: "xmark.shield.fill",
                color: .red,
                title: "Deny Effects",
                description: "Once per session, deny an enemy's successful attack, miraculous effect, or fear effect."
            )
            
            BraveFeatureRow(
                icon: "person.fill.questionmark",
                color: .red,
                title: "Explain Action",
                description: "Must explain how your character plausibly avoids or resists the effect."
            )
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Helper Views
private struct BraveFeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        return HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 18))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct QuirkCard: View {
    let quirk: BraveQuirk
    let slotIndex: Int
    let protectedAlly: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(quirk.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Slot \(slotIndex + 1)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "sparkles")
                    .foregroundColor(.yellow)
            }
            
            Text(quirk.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)
                .fixedSize(horizontal: false, vertical: true)
            
            if quirk == .protectAlly && !protectedAlly.isEmpty {
                HStack {
                    Image(systemName: "shield.fill")
                        .foregroundColor(.blue)
                    Text("Protected Ally: \(protectedAlly)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding(.top, 4)
            }
        }
        .padding(12)
        .background({
            #if os(iOS)
            return colorScheme == .dark ? Color(uiColor: .systemGray6) : .white
            #else
            return colorScheme == .dark ? Color(nsColor: .windowBackgroundColor) : .white
            #endif
        }())
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: {
            #if os(iOS)
            return Color(uiColor: .systemGray4).opacity(0.3)
            #else
            return Color(nsColor: .shadowColor).opacity(0.3)
            #endif
        }(), radius: 6, x: 0, y: 2)
    }
}

private struct ArmorPenaltyWarning: View {
    var body: some View {
        return HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text("Wearing armor heavier than cloth: -2 penalty to all task rolls")
                .font(.caption)
                .foregroundColor(.red)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.red.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
