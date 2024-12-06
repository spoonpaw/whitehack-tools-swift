import SwiftUI
import PhosphorSwift

struct DetailHeaderSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section(header: SectionHeader(title: "Basic Info", icon: Ph.identificationCard.bold)) {
            VStack(spacing: 8) {
                Text(character.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                if !character.playerName.isEmpty {
                    Text("Player: \(character.playerName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
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
                        } else if character.currentHP <= 0 {
                            Text("Unconscious and dying.")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    if character.level < 10 {
                        let xpProgress = character.xpProgress
                        let currentLevelXP = character.level > 1 ? AdvancementTables.shared.xpRequirement(for: character.characterClass, at: character.level) : 0
                        let nextLevelXP = character.xpForNextLevel
                        let xpNeeded = nextLevelXP - currentLevelXP
                        let xpGained = character.experience - currentLevelXP
                        
                        ProgressBar(
                            value: Double(xpGained),
                            maxValue: Double(xpNeeded),
                            label: "XP to Level \(character.level + 1)",
                            foregroundColor: .blue,
                            showPercentage: true,
                            isComplete: character.canLevelUp,
                            completionMessage: "Ready to level up!"
                        )
                    }
                }
            }
            .padding()
        }
    }
}

struct StatPill: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.background)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
        )
    }
}
