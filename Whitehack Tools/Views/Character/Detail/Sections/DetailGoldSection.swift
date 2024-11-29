import SwiftUI
import PhosphorSwift

struct DetailGoldSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section(header: SectionHeader(title: "Gold", icon: Ph.coins.bold)) {
            HStack {
                Label {
                    Text("\(character.coins) GP")
                        .fontWeight(.medium)
                } icon: {
                    IconFrame(icon: Ph.coins.bold, color: .yellow)
                }
            }
            .padding(.vertical, 8)
        }
    }
}
