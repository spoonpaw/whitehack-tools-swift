import SwiftUI
import PhosphorSwift

struct DetailAdditionalInfoSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section(header: SectionHeader(title: "Additional Information", icon: Ph.info.bold)) {
            VStack(spacing: 8) {
                HStack(spacing: 16) {
                    StatCard(label: "Experience", value: "\(character.experience) XP", icon: Ph.star.bold)
                    StatCard(label: "Corruption", value: "\(character.corruption)", icon: Ph.warning.bold)
                }
                
                if character.level < 10 {
                    HStack(spacing: 16) {
                        StatCard(label: "Next Level", value: "\(character.xpForNextLevel) XP", icon: Ph.arrowCircleUp.bold)
                        StatCard(label: "Remaining", value: "\(character.xpForNextLevel - character.experience) XP", icon: Ph.hourglassSimple.bold)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}
