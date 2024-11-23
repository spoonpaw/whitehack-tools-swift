import SwiftUI
import PhosphorSwift

struct DetailCombatSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section(header: SectionHeader(title: "Combat Stats", icon: Ph.shield.bold)) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                StatCard(label: "Attack", value: "\(character.attackValue)", icon: Ph.sword.bold)
                StatCard(label: "Defense", value: "\(character.defenseValue)", icon: Ph.shield.bold)
                StatCard(label: "Movement", value: "\(character.movement) ft", icon: Ph.personSimpleRun.bold)
                StatCard(label: "Save", value: "\(character.saveValue)\(character.saveColor.isEmpty ? "" : " (\(character.saveColor))")", icon: Ph.diceFive.bold)
            }
            .padding(.vertical, 8)
        }
    }
}
