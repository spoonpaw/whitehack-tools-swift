import SwiftUI
import PhosphorSwift

struct DetailStrongCombatSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        if character.characterClass == .strong {
            Section {
                // Combat Options
                VStack(alignment: .leading, spacing: 12) {
                    Label("Combat Options", systemImage: "shield.lefthalf.filled")
                        .font(.headline)
                    
                    ForEach(0..<character.availableCombatOptions.count, id: \.self) { index in
                        if let option = character.strongCombatOptions.getOption(at: index) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Slot \(index + 1): \(option.name)")
                                    .font(.subheadline)
                                Text(option.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .padding(.vertical, 4)
                
                // Conflict Loot
                VStack(alignment: .leading, spacing: 12) {
                    Label("Current Conflict Loot", systemImage: "trophy.fill")
                        .font(.headline)
                    
                    if let loot = character.currentConflictLoot {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(loot.keyword)
                                    .font(.subheadline)
                                Spacer()
                                Text("\(loot.usesRemaining) uses")
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(loot.type.rawValue.capitalized)
                                .font(.caption)
                                .foregroundColor(typeColor(for: loot.type))
                        }
                        .padding(.vertical, 4)
                    } else {
                        Text("No conflict loot held")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            } header: {
                Label("Strong Combat Features", systemImage: "shield.fill")
            }
        }
    }
    
    private func typeColor(for type: ConflictLootType) -> Color {
        switch type {
        case .special:
            return .blue
        case .substance:
            return .green
        case .supernatural:
            return .purple
        }
    }
}
