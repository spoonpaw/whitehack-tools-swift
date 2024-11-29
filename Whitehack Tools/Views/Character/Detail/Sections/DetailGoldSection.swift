import SwiftUI
import PhosphorSwift

struct DetailGoldSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section(header: SectionHeader(title: "Gold", icon: Ph.coins.bold)) {
            VStack(spacing: 16) {
                // On Hand and Stashed
                HStack(spacing: 24) {
                    // On Hand
                    VStack(alignment: .leading, spacing: 4) {
                        Label {
                            Text("On Hand")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        } icon: {
                            IconFrame(icon: Ph.wallet.bold, color: .yellow)
                                .scaleEffect(0.8)
                        }
                        Text("\(character.coinsOnHand) GP")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Stashed
                    VStack(alignment: .leading, spacing: 4) {
                        Label {
                            Text("Stashed")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        } icon: {
                            IconFrame(icon: Ph.vault.bold, color: .yellow)
                                .scaleEffect(0.8)
                        }
                        Text("\(character.stashedCoins) GP")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 4)
                
                Divider()
                
                // Total
                HStack {
                    Label {
                        Text("Total Gold")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    } icon: {
                        IconFrame(icon: Ph.coins.bold, color: .yellow)
                            .scaleEffect(0.8)
                    }
                    Spacer()
                    Text("\(character.coinsOnHand + character.stashedCoins) GP")
                        .font(.title3)
                        .fontWeight(.medium)
                }
                .padding(.vertical, 4)
            }
            .padding(.vertical, 4)
        }
    }
}
