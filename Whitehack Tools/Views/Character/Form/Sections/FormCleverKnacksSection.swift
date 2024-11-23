import SwiftUI

struct FormCleverKnacksSection: View {
    let characterClass: CharacterClass
    let level: Int
    @Binding var cleverKnackOptions: CleverKnackOptions
    @Environment(\.colorScheme) var colorScheme
    
    private var availableSlots: Int {
        guard characterClass == .clever else { return 0 }
        let stats = AdvancementTables.shared.stats(for: characterClass, at: level)
        return stats.slots
    }
    
    var body: some View {
        if characterClass == .clever {
            Section {
                // Daily Power
                Toggle(isOn: $cleverKnackOptions.hasUsedUnorthodoxBonus) {
                    VStack(alignment: .leading) {
                        Text("Unorthodox Solution")
                            .font(.headline)
                        Text("Daily +6 bonus for non-combat problem solving")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .tint(.red)
                
                if cleverKnackOptions.hasUsedUnorthodoxBonus {
                    Text("⚠️ Power has been used today")
                        .foregroundColor(.red)
                        .font(.caption)
                } else {
                    Text("✓ Power is available to use")
                        .foregroundColor(.green)
                        .font(.caption)
                }
                
                // Knack Slots
                ForEach(0..<availableSlots, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Knack Slot \(index + 1)")
                                .font(.headline)
                            Spacer()
                        }
                        
                        Picker("Select Knack", selection: Binding(
                            get: { cleverKnackOptions.getKnack(at: index) },
                            set: { cleverKnackOptions.setKnack($0, at: index) }
                        )) {
                            Text("None").tag(nil as CleverKnack?)
                            ForEach(CleverKnack.allCases) { knack in
                                Text(knack.name).tag(knack as CleverKnack?)
                            }
                        }
                        
                        if let knack = cleverKnackOptions.getKnack(at: index) {
                            Text(knack.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            if knack == .combatExploiter {
                                Toggle("Combat Die Usage", isOn: Binding(
                                    get: { cleverKnackOptions.slots[index].hasUsedCombatDie },
                                    set: { newValue in
                                        var updatedOptions = cleverKnackOptions
                                        updatedOptions.setHasUsedCombatDie(newValue, at: index)
                                        self.cleverKnackOptions = updatedOptions
                                    }
                                ))
                                .tint(.red)
                                
                                if cleverKnackOptions.slots[index].hasUsedCombatDie {
                                    Text("⚠️ D10 damage die has been used this battle")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                } else {
                                    Text("✓ D10 damage die is available this battle")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                }
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
