import SwiftUI

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
                // Class Description
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .foregroundStyle(.green)
                        Text("The Clever")
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                    
                    Text("Investigators, scientists, engineers, and pioneers who solve problems through unconventional methods. Masters of lateral thinking who turn curiosity and craftiness into powerful advantages.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .foregroundStyle(.green)
                            .imageScale(.large)
                        Text("You excel at information gathering, getting two pieces of information on successful detection rolls. Your unorthodox approaches and technical expertise make you invaluable in non-combat situations.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 4)
                }
                
                // Daily Power Status
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                            .foregroundStyle(.green)
                        Text("Unorthodox Solution")
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                    
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "lightbulb.circle.fill")
                            .foregroundStyle(.green)
                            .imageScale(.large)
                        Text("Your unique perspective lets you approach problems from unexpected angles. This might involve unusual tools, strange methods, or creative applications of everyday items.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 4)
                    
                    CleverPowerCard(
                        title: "Daily Power",
                        description: "Gain +6 to any non-combat problem-solving attempt using an unconventional method",
                        isAvailable: !cleverKnackOptions.hasUsedUnorthodoxBonus,
                        examples: [
                            "Using mirrors to redirect magical effects",
                            "Repurposing common items in creative ways",
                            "Finding unexpected solutions to traditional problems"
                        ]
                    )
                }
                .padding(.top, 8)
                
                // Knack Slots
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "gearshape.2.fill")
                            .foregroundStyle(.green)
                        Text("Special Knacks")
                            .font(.headline)
                        Spacer()
                        Text("\(cleverKnackOptions.activeKnacks.count)/\(availableSlots)")
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
                    
                    if cleverKnackOptions.activeKnacks.isEmpty {
                        EmptyKnacksView()
                    } else {
                        ForEach(0..<availableSlots, id: \.self) { slotIndex in
                            if let knack = cleverKnackOptions.getKnack(at: slotIndex) {
                                KnackCard(
                                    knack: knack,
                                    slotIndex: slotIndex,
                                    hasUsedCombatDie: cleverKnackOptions.slots[slotIndex].hasUsedCombatDie
                                )
                            }
                        }
                    }
                }
                .padding(.top, 8)
                
                // Additional Benefits
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
                
            } header: {
                Label("Clever Features", systemImage: "lightbulb.fill")
                    .foregroundStyle(.green)
            } footer: {
                Text("At even levels, you may choose between raising attributes or gaining an additional language/learning a ritual from a scroll.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
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
