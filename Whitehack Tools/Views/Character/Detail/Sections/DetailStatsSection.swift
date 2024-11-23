import SwiftUI
import PhosphorSwift

struct DetailStatsSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section(header: SectionHeader(title: "Attributes", icon: Ph.user.bold)) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                AttributeCard(label: "Strength", value: "\(character.strength)")
                AttributeCard(label: "Agility", value: "\(character.agility)")
                AttributeCard(label: "Toughness", value: "\(character.toughness)")
                AttributeCard(label: "Intelligence", value: "\(character.intelligence)")
                AttributeCard(label: "Willpower", value: "\(character.willpower)")
                AttributeCard(label: "Charisma", value: "\(character.charisma)")
            }
            .padding(.vertical, 8)
        }
    }
}
