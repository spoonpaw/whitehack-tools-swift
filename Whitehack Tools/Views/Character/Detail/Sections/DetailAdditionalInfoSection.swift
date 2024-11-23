import SwiftUI
import PhosphorSwift

struct DetailAdditionalInfoSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section(header: SectionHeader(title: "Additional Information", icon: Ph.info.bold)) {
            HStack(spacing: 16) {
                StatCard(label: "Experience", value: "\(character.experience) XP", icon: Ph.star.bold)
                StatCard(label: "Corruption", value: "\(character.corruption)", icon: Ph.warning.bold)
            }
            .padding(.vertical, 8)
        }
    }
}
