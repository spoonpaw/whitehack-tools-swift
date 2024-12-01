import SwiftUI
import PhosphorSwift

struct DetailCombatSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section(header: SectionHeader(title: "Combat Stats", icon: Ph.shield.bold)) {
            VStack(spacing: 16) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    StatCard(label: "Attack", value: "\(character.attackValue)", icon: Ph.sword.bold)
                    StatCard(label: "Defense", value: "\(character.defenseValue)", icon: Ph.shield.bold)
                    StatCard(label: "Movement", value: "\(character.movement) ft", icon: Ph.personSimpleRun.bold)
                    StatCard(label: "Initiative", value: character.initiativeBonus > 0 ? "+\(character.initiativeBonus)" : "0", icon: Ph.lightning.bold)
                }
                
                SaveColorCard(value: character.saveValue, colorName: character.saveColor)
            }
            .padding(.vertical, 8)
        }
    }
}

private struct SaveColorCard: View {
    let value: Int
    let colorName: String
    
    private var color: Color {
        switch colorName.lowercased() {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                IconFrame(icon: Ph.palette.bold, color: color)
                Text("Save Color")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            HStack {
                Text("Save Value: \(value)")
                    .font(.subheadline)
                
                Spacer()
                
                Circle()
                    .fill(color)
                    .frame(width: 24, height: 24)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
