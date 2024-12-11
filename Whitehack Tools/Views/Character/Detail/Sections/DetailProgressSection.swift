import SwiftUI
import PhosphorSwift

struct DetailProgressSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 4) {
                let healthPercentage = Double(character.currentHP) / Double(character.maxHP)
                let healthColor: Color = {
                    if character.currentHP <= -10 {
                        return .red.opacity(0.8)  // Death state
                    } else if character.currentHP <= -2 {
                        return .red  // Critical state
                    } else if character.currentHP <= -1 {
                        return .red.opacity(0.9)  // Near death
                    } else if character.currentHP == 0 {
                        return .orange  // Unconscious
                    } else if character.currentHP < character.maxHP / 4 {
                        return .orange.opacity(0.8)  // Severely wounded
                    } else if character.currentHP < character.maxHP / 2 {
                        return .yellow  // Wounded
                    } else if character.currentHP == character.maxHP {
                        return .green  // Full health
                    } else {
                        return Color(
                            hue: max(0.1, min(0.33 * healthPercentage, 0.33)), // Yellow-green to Green
                            saturation: 0.8,
                            brightness: 0.8
                        )
                    }
                }()
                
                ProgressBar(
                    value: Double(character.currentHP),
                    maxValue: Double(character.maxHP),
                    label: "Health (\(character.currentHP)/\(character.maxHP))",
                    foregroundColor: healthColor,
                    showPercentage: false,
                    isComplete: false,
                    completionMessage: ""
                )
                
                // HP Status based on mechanical rules
                if character.currentHP <= -10 {
                    Text("Instant death.")
                        .font(.caption)
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                } else if character.currentHP <= -2 {
                    VStack(spacing: 2) {
                        Text("Knocked out until healed to positive HP.")
                        Text("Injured.")
                        Text("Save or die in d6 rounds.")
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                } else if character.currentHP <= -1 {
                    VStack(spacing: 2) {
                        Text("Knocked out until healed to positive HP.")
                        Text("Injured.")
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                } else if character.currentHP == 0 {
                    Text("Knocked out until healed to positive HP.")
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else if character.currentHP < character.maxHP / 2 {
                    Text("Wounded")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            if character.level < 10 {
                ProgressBar(
                    value: Double(character.experience - (character.level > 1 ? AdvancementTables.shared.xpRequirement(for: character.characterClass, at: character.level) : 0)),
                    maxValue: Double(character.xpForNextLevel - (character.level > 1 ? AdvancementTables.shared.xpRequirement(for: character.characterClass, at: character.level) : 0)),
                    label: "XP to Level \(character.level + 1)",
                    foregroundColor: .blue,
                    showPercentage: true,
                    isComplete: character.experience >= character.xpForNextLevel,
                    completionMessage: "Ready to advance to Level \(character.level + 1)!"
                )
            }
        }
        .padding(.vertical, 8)
    }
}
