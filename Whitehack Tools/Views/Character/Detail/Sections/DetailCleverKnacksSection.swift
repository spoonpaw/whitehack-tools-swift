import SwiftUI
import PhosphorSwift

struct DetailCleverKnacksSection: View {
    let characterClass: CharacterClass
    let level: Int
    let cleverKnackOptions: CleverKnackOptions
    @Environment(\.colorScheme) var colorScheme
    
    private var availableSlots: Int {
        AdvancementTables.shared.stats(for: characterClass, at: level).slots
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "The Clever", icon: Image(systemName: "brain.head.profile"))
            
            if characterClass == .clever {
                GroupBox {
                    VStack(alignment: .leading, spacing: 16) {
                        ClassOverviewCard()
                        Divider()
                        UnorthodoxSolutionCard(hasUsedUnorthodoxBonus: cleverKnackOptions.hasUsedUnorthodoxBonus)
                        Divider()
                        InformationGatheringCard()
                        Divider()
                        SpecialKnacksCard(
                            activeKnacks: cleverKnackOptions.activeKnacks,
                            slots: cleverKnackOptions.slots,
                            availableSlots: availableSlots
                        )
                        Divider()
                        AdvancementOptionsCard()
                        Divider()
                        CombatAndSavingThrowsCard()
                    }
                    .padding(12)
                }
                .groupBoxStyle(DetailCardGroupBoxStyle())
            }
        }
    }
}

// MARK: - Group Box Style
private struct DetailCardGroupBoxStyle: GroupBoxStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            configuration.content
        }
        .frame(maxWidth: .infinity)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1.5)
        )
        .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 2)
    }
}

// MARK: - Cards
private struct ClassOverviewCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.green)
                Text("Class Overview")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            DetailCleverFeatureRow(
                icon: "lightbulb.fill",
                color: .green,
                title: "Analytical Minds",
                description: "Clever characters think in different ways. They may not always have a high intelligence score, but they are curious, crafty, and unafraid of failure."
            )
            
            DetailCleverFeatureRow(
                icon: "person.fill.questionmark",
                color: .green,
                title: "Diverse Backgrounds",
                description: "Investigators, scientists, engineers, pioneers, and explorers who approach problems with unique perspectives."
            )
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.green.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct DetailCleverFeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
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
                    .foregroundColor(.yellow)
                Text("Unorthodox Solution")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            DetailCleverFeatureRow(
                icon: "sparkles",
                color: .yellow,
                title: "Daily Power",
                description: "Once per day, gain a +6 bonus for an unorthodox attempt to solve a non-combat related problem."
            )
            
            DetailCleverFeatureRow(
                icon: "exclamationmark.triangle",
                color: .yellow,
                title: "Drawbacks",
                description: "Negative modifiers may apply to account for bizarre methods or serious drawbacks."
            )
            
            HStack {
                Image(systemName: hasUsedUnorthodoxBonus ? "hourglass.circle.fill" : "checkmark.circle.fill")
                    .foregroundColor(hasUsedUnorthodoxBonus ? .red : .green)
                Text(hasUsedUnorthodoxBonus ? "Daily power has been used" : "Daily power is available")
                    .font(.caption)
                    .foregroundColor(hasUsedUnorthodoxBonus ? .red : .green)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Information Gathering Card
private struct InformationGatheringCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass.circle.fill")
                    .foregroundColor(.blue)
                Text("Information Gathering")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            DetailCleverFeatureRow(
                icon: "doc.text.magnifyingglass",
                color: .blue,
                title: "Enhanced Detection",
                description: "All successful or critical rolls for clues and information gathering are treated as a pair."
            )
            
            DetailCleverFeatureRow(
                icon: "questionmark.circle",
                color: .blue,
                title: "Player Questions",
                description: "Get additional information based on player questions, proportionate to roll quality."
            )
            
            DetailCleverFeatureRow(
                icon: "list.bullet",
                color: .blue,
                title: "Requirements",
                description: "Additional information must be within bounds of the situation and not surpass the regular success."
            )
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Advancement Options Card
private struct AdvancementOptionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "arrow.up.forward.circle.fill")
                    .foregroundColor(.orange)
                Text("Advancement Options")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            DetailCleverFeatureRow(
                icon: "text.book.closed",
                color: .orange,
                title: "Extra Language",
                description: "Start with an additional language from the beginning."
            )
            
            DetailCleverFeatureRow(
                icon: "arrow.up.right",
                color: .orange,
                title: "Even Level Choice",
                description: "At even levels, choose between a raise, an additional language, or learning a ritual from a scroll."
            )
            
            DetailCleverFeatureRow(
                icon: "scroll",
                color: .orange,
                title: "Ritual Learning",
                description: "Can learn rituals from scrolls in known languages. Takes one week to study, costs (Scroll Cost + 1) × 2 HP to cast."
            )
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Combat and Saving Throws Card
private struct CombatAndSavingThrowsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "shield.fill")
                    .foregroundColor(.red)
                Text("Combat & Saving Throws")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            DetailCleverFeatureRow(
                icon: "shield.lefthalf.filled",
                color: .red,
                title: "Armor Use",
                description: "Can use any type of armor without penalty."
            )
            
            DetailCleverFeatureRow(
                icon: "eye.trianglebadge.exclamationmark",
                color: .red,
                title: "Illusion Defense",
                description: "+2 bonus to saving throws against illusions."
            )
            
            DetailCleverFeatureRow(
                icon: "star",
                color: .red,
                title: "Appraisal Bonus",
                description: "+2 to vocation-related appraisal checks."
            )
            
            DetailCleverFeatureRow(
                icon: "bolt",
                color: .red,
                title: "Heavy Weapons",
                description: "2 AV when using heavy weapons."
            )
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Special Knacks Card
private struct SpecialKnacksCard: View {
    let activeKnacks: [CleverKnack]
    let slots: [CleverKnackSlot]
    let availableSlots: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "gearshape.2.fill")
                    .foregroundColor(.purple)
                Text("Special Knacks")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text("\(activeKnacks.count)/\(availableSlots)")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            DetailCleverFeatureRow(
                icon: "brain",
                color: .purple,
                title: "Specialized Techniques",
                description: "Your analytical mind develops specialized techniques as you advance. Each knack represents mastery over a particular domain of clever thinking."
            )
            
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
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.purple.opacity(0.1))
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

private struct EmptyKnackCard: View {
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

private struct KnackCard: View {
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

private struct CombatDieStatus: View {
    let hasUsedCombatDie: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Combat Die Status")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(hasUsedCombatDie ?
                     "⚠️ D10 damage die has been used this battle" :
                     "✓ D10 damage die is available this battle")
                    .font(.caption)
                    .foregroundColor(hasUsedCombatDie ? .red : .green)
                    .fixedSize(horizontal: false, vertical: true)
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

private struct EmptyKnacksView: View {
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

private struct CleverBenefitBullet: View {
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
