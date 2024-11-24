import SwiftUI
import PhosphorSwift

struct DetailCleverKnacksSection: View {
    let characterClass: CharacterClass
    let level: Int
    let cleverKnackOptions: CleverKnackOptions
    
    private var availableSlots: Int {
        AdvancementTables.shared.stats(for: characterClass, at: level).slots
    }
    
    var body: some View {
        if characterClass == .clever {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    VocationDescriptionCard()
                    UnorthodoxSolutionCard(hasUsedUnorthodoxBonus: cleverKnackOptions.hasUsedUnorthodoxBonus)
                    InformationGatheringCard()
                    SpecialKnacksCard(
                        activeKnacks: cleverKnackOptions.activeKnacks,
                        slots: cleverKnackOptions.slots,
                        availableSlots: availableSlots
                    )
                    AdvancementOptionsCard()
                    CombatAndSavingThrowsCard()
                }
                .padding(.vertical, 8)
            } header: {
                CleverSectionHeader()
            }
        }
    }
}

// MARK: - Section Header
private struct CleverSectionHeader: View {
    var body: some View {
        Label {
            Text("The Clever")
                .foregroundStyle(.primary)
        } icon: {
            Image(systemName: "brain.head.profile")
                .foregroundStyle(.green)
        }
    }
}

// MARK: - Vocation Description Card
private struct VocationDescriptionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.fill.questionmark")
                    .foregroundStyle(.green)
                Text("Class Overview")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            Text("Clever characters think in different ways. They may not always have a high intelligence score, and they can be ordinary in many respects—in their training, in their physique and in their intuition. But in return, they are often curious, crafty and unafraid of failure. The Clever may for example be investigators, scientists, engineers, pioneers and explorers.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

// MARK: - Unorthodox Solution Card
private struct UnorthodoxSolutionCard: View {
    let hasUsedUnorthodoxBonus: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(.green)
                Text("Unorthodox Solution")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            Text("Once per day, the Clever get a hefty +6 bonus for an unorthodox attempt to solve a non-combat related problem. Out of the box thinking can for example involve odd tools or materials, or apply a strange or at least original method. Further modifications can be applied, usually a negative one to account for the fact that a particular idea also a bit bizarre with some serious drawback.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 8)
            
            DailyPowerStatusView(isAvailable: !hasUsedUnorthodoxBonus)
        }
        .padding(12)
        .background(Color.green.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Information Gathering Card
private struct InformationGatheringCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass.circle.fill")
                    .foregroundStyle(.green)
                Text("Information Gathering")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            Text("The clever treat all successful or critical rolls for clues, information gathering and detection as a pair, meaning that they get something extra out of it. This something is based on a question from the player, but should be:")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(alignment: .leading, spacing: 8) {
                InfoBulletPoint(text: "Within bounds of the situation")
                InfoBulletPoint(text: "Proportionate to the quality of the roll")
                InfoBulletPoint(text: "An addition not surpassing the effect of the regular success")
            }
            .padding(.leading, 8)
            
            Text("For example, a clever character using intelligence to get a clue for a puzzle or to extract information from a book, simply gets a minor additional clue or piece of information, in the direction indicated by the player's question.")
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
        }
        .padding(12)
        .background(Color.green.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Advancement Options Card
private struct AdvancementOptionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "arrow.up.forward.circle.fill")
                    .foregroundStyle(.green)
                Text("Advancement Options")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            Text("The Clever get an extra language from the start. At even levels, they can eschew the raise either for an additional language or for a ritual based on a slottable scroll, in a language the character knows.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(alignment: .leading, spacing: 8) {
                RitualDetailRow(icon: "clock.fill", text: "Casting time: 10 minutes or double scroll time")
                RitualDetailRow(icon: "calendar", text: "One week study time required")
                RitualDetailRow(icon: "hourglass", text: "Can perform each ritual once per day")
                RitualDetailRow(icon: "heart.fill", text: "HP Cost: (Scroll Cost + 1) × 2")
            }
        }
        .padding(12)
        .background(Color.green.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Combat and Saving Throws Card
private struct CombatAndSavingThrowsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "shield.fill")
                    .foregroundStyle(.green)
                Text("Combat & Saving Throws")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                BonusRow(icon: "eye.fill", text: "+2 to saves vs. illusions")
                BonusRow(icon: "star.fill", text: "+2 to vocation-related appraisal")
                BonusRow(icon: "shield.lefthalf.filled", text: "Can use any armor")
                BonusRow(icon: "bolt.fill", text: "2 AV with heavy weapons")
            }
        }
        .padding(12)
        .background(Color.green.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Helper Views
private struct DailyPowerStatusView: View {
    let isAvailable: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isAvailable ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(isAvailable ? .green : .red)
            Text(isAvailable ? "Daily power available" : "Daily power has been used")
                .font(.subheadline)
                .foregroundStyle(isAvailable ? .green : .red)
        }
    }
}

private struct InfoBulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "circle.fill")
                .font(.system(size: 6))
                .foregroundStyle(.green)
                .padding(.top, 6)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct RitualDetailRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(.green)
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct BonusRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(.green)
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Special Knacks Card
private struct SpecialKnacksCard: View {
    let activeKnacks: [CleverKnack]
    let slots: [CleverKnackSlot]
    let availableSlots: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "gearshape.2.fill")
                    .foregroundStyle(.green)
                Text("Special Knacks")
                    .font(.headline)
                Spacer()
                Text("\(activeKnacks.count)/\(availableSlots)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "brain")
                    .foregroundStyle(.green)
                    .imageScale(.large)
                Text("Your analytical mind develops specialized techniques as you advance. Each knack represents mastery over a particular domain of clever thinking.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)
            
            ForEach(0..<availableSlots, id: \.self) { slotIndex in
                if slotIndex < slots.count, let knack = slots[slotIndex].knack {
                    KnackCard(
                        knack: knack,
                        slotIndex: slotIndex,
                        hasUsedCombatDie: slots[slotIndex].hasUsedCombatDie
                    )
                } else {
                    EmptyKnackCard(slotIndex: slotIndex)
                }
            }
        }
        .padding(.top, 8)
    }
}

struct EmptyKnackCard: View {
    let slotIndex: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Empty Slot")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .italic()
                Spacer()
                Text("Slot \(slotIndex + 1)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text("No knack selected for this slot")
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
            
            HStack {
                Image(systemName: "circle")
                    .foregroundColor(.secondary)
                Text("Available")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color.green.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Class Benefits Card
private struct ClassBenefitsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.circle.fill")
                    .foregroundStyle(.green)
                Text("Class Benefits")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                CleverBenefitBullet(text: "Double information on successful detection rolls", icon: "binoculars.fill")
                CleverBenefitBullet(text: "+2 to saves vs. illusions", icon: "eye.trianglebadge.exclamationmark.fill")
                CleverBenefitBullet(text: "+2 to vocation-related appraisal", icon: "chart.bar.fill")
                CleverBenefitBullet(text: "Learn one additional language", icon: "text.book.closed.fill")
                CleverBenefitBullet(text: "Can learn rituals from scrolls at even levels", icon: "scroll.fill")
            }
            .padding(.leading, 4)
        }
        .padding(.top, 8)
    }
}

struct CleverPowerCard: View {
    let title: String
    let description: String
    let isAvailable: Bool
    let examples: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 16)
                if isAvailable {
                    Image(systemName: "sparkles")
                        .foregroundColor(.green)
                        .imageScale(.large)
                } else {
                    Image(systemName: "hourglass.circle.fill")
                        .foregroundColor(.red)
                        .imageScale(.large)
                }
            }
            
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "list.bullet.circle.fill")
                    .foregroundStyle(.green)
                Text("Examples:")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(examples, id: \.self) { example in
                    HStack(alignment: .top, spacing: 4) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.green)
                            .padding(.top, 2)
                        Text(example)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.leading, 4)
            
            HStack {
                Image(systemName: isAvailable ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                    .foregroundColor(isAvailable ? .green : .red)
                Text(isAvailable ? "Power is available to use" : "Power has been used today")
                    .font(.caption)
                    .foregroundColor(isAvailable ? .green : .red)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .background(Color.green.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct KnackCard: View {
    let knack: CleverKnack
    let slotIndex: Int
    let hasUsedCombatDie: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(knack.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text("Slot \(slotIndex + 1)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(knack.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
            
            if knack == .combatExploiter {
                CombatDieStatus(hasUsedCombatDie: hasUsedCombatDie)
            }
        }
        .padding(12)
        .background(Color.green.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct CombatDieStatus: View {
    let hasUsedCombatDie: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Combat Die Status")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(hasUsedCombatDie ?
                     "⚠️ D10 damage die has been used this battle" :
                     "✓ D10 damage die is available this battle")
                    .font(.caption)
                    .foregroundColor(hasUsedCombatDie ? .red : .green)
            }
            Spacer()
            if hasUsedCombatDie {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
                    .imageScale(.large)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .imageScale(.large)
            }
        }
        .padding(.top, 4)
    }
}

struct EmptyKnacksView: View {
    var body: some View {
        Text("No knacks selected")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct CleverBenefitBullet: View {
    let text: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.green)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct CleverFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.green)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
