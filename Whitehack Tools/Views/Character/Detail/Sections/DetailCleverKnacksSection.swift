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
                // Daily Power Status
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Unorthodox Solution")
                                .font(.headline)
                            Text("Daily +6 bonus for non-combat problem solving")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if cleverKnackOptions.hasUsedUnorthodoxBonus {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                                .imageScale(.large)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                        }
                    }
                    
                    Text(cleverKnackOptions.hasUsedUnorthodoxBonus ? 
                         "⚠️ Power has been used today" :
                         "✓ Power is available to use")
                        .font(.caption)
                        .foregroundColor(cleverKnackOptions.hasUsedUnorthodoxBonus ? .red : .green)
                }
                
                // Knack Slots
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Knacks")
                            .font(.headline)
                        Spacer()
                        Text("\(cleverKnackOptions.activeKnacks.count)/\(availableSlots)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if cleverKnackOptions.activeKnacks.isEmpty {
                        Text("No knacks selected")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 8)
                    } else {
                        ForEach(0..<availableSlots, id: \.self) { slotIndex in
                            if let knack = cleverKnackOptions.getKnack(at: slotIndex) {
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
                                        .padding(.top, 4)
                                    
                                    if knack == .combatExploiter {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Combat Die Status")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                Text(cleverKnackOptions.slots[slotIndex].hasUsedCombatDie ?
                                                     "⚠️ D10 damage die has been used this battle" :
                                                     "✓ D10 damage die is available this battle")
                                                    .font(.caption)
                                                    .foregroundColor(cleverKnackOptions.slots[slotIndex].hasUsedCombatDie ? .red : .green)
                                            }
                                            Spacer()
                                            if cleverKnackOptions.slots[slotIndex].hasUsedCombatDie {
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
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
            } header: {
                Label("Clever Features", systemImage: "lightbulb.fill")
            } footer: {
                Text("The Clever get +2 to saves vs. illusions and vocation-related appraisal attempts. They get -2 AV with heavy weapons.")
            }
        }
    }
}
