import SwiftUI
import PhosphorSwift

struct DetailHeaderSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section {
            VStack(spacing: 8) {
                Text(character.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack(spacing: 16) {
                    StatPill(label: "Level", value: "\(character.level)")
                    StatPill(label: "Class", value: character.characterClass.rawValue)
                    StatPill(label: "XP", value: "\(character.experience)")
                }
                
                // Progress Bars
                VStack(spacing: 12) {
                    VStack(spacing: 4) {
                        let healthPercentage = Double(character.currentHP) / Double(character.maxHP)
                        let healthColor = Color(
                            hue: max(0, min(0.33 * healthPercentage, 0.33)), // Green (0.33) to Red (0.0)
                            saturation: 1.0,
                            brightness: 0.8
                        )
                        
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
            .padding(.vertical, 8)
        }
    }
}
