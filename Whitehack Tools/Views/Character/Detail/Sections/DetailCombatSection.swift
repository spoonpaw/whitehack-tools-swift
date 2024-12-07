import SwiftUI
import PhosphorSwift

struct DetailCombatSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section(header: SectionHeader(title: "Combat Stats", icon: Ph.boxingGlove.bold)) {
            VStack(spacing: 16) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    StatCard(label: "Attack", value: "\(character.attackValue)", icon: AnyView(Ph.sword.bold))
                    StatCard(label: "Defense", value: "\(character.defenseValue)", icon: AnyView(Ph.shield.bold))
                    StatCard(label: "Movement", value: "\(character.movement) ft", icon: AnyView(Ph.personSimpleRun.bold))
                    StatCard(label: "Initiative", value: character.initiativeBonus > 0 ? "+\(character.initiativeBonus)" : "0", icon: AnyView(Ph.lightning.bold))
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                IconFrame(icon: Ph.shieldStar.bold, color: .purple)
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Save Value: \(value)")
                    .font(.subheadline)
                
                Text("Color: \"\(colorName)\"")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        #if os(iOS)
        .background(Color(uiColor: .secondarySystemBackground))
        #else
        .background(Color(nsColor: .controlBackgroundColor))
        #endif
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
