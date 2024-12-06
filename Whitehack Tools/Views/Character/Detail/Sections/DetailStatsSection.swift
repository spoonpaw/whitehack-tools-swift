import SwiftUI
import PhosphorSwift

struct DetailStatsSection: View {
    let character: PlayerCharacter
    
    private var backgroundColor: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemGroupedBackground)
        #else
        return Color(nsColor: .windowBackgroundColor)
        #endif
    }
    
    private func getAttributeDescription(_ value: Int) -> String {
        if value >= 16 {
            return "Exceptional (+2)"
        } else if value >= 13 {
            return "Above Average (+1)"
        } else if value >= 8 {
            return "Average"
        } else if value >= 6 {
            return "Below Average (-1)"
        } else {
            return "Poor (-2)"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Ph.chartBar.bold
                    .frame(width: 20, height: 20)
                Text("Attributes")
                    .font(.headline)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                StatCard(
                    label: "Strength",
                    value: "\(character.strength)",
                    icon: Ph.barbell.bold,
                    description: getAttributeDescription(character.strength)
                )
                
                StatCard(
                    label: "Agility",
                    value: "\(character.agility)",
                    icon: Ph.personSimpleRun.bold,
                    description: getAttributeDescription(character.agility)
                )
                
                StatCard(
                    label: "Toughness",
                    value: "\(character.toughness)",
                    icon: Ph.heart.bold,
                    description: getAttributeDescription(character.toughness)
                )
                
                StatCard(
                    label: "Intelligence",
                    value: "\(character.intelligence)",
                    icon: Ph.brain.bold,
                    description: getAttributeDescription(character.intelligence)
                )
                
                StatCard(
                    label: "Willpower",
                    value: "\(character.willpower)",
                    icon: Ph.eye.bold,
                    description: getAttributeDescription(character.willpower)
                )
                
                StatCard(
                    label: "Charisma",
                    value: "\(character.charisma)",
                    icon: Ph.star.bold,
                    description: getAttributeDescription(character.charisma)
                )
            }
        }
    }
}

struct StatCard: View {
    let label: String
    let value: String
    let icon: Image
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                icon
                    .frame(width: 20, height: 20)
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(value)
                    .font(.title2)
                    .fontWeight(.medium)
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}
