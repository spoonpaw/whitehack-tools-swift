import SwiftUI
import PhosphorSwift

struct DetailGoldSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section {
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
                        Text("\(character.coinsOnHand)gp")
                            .font(.title2.monospacedDigit())
                            .foregroundColor(.primary)
                    }
                    
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
                        Text("\(character.stashedCoins)gp")
                            .font(.title2.monospacedDigit())
                            .foregroundColor(.primary)
                    }
                }
                
                // Total
                VStack(alignment: .leading, spacing: 4) {
                    Label {
                        Text("Total")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    } icon: {
                        IconFrame(icon: Ph.coins.bold, color: .yellow)
                            .scaleEffect(0.8)
                    }
                    Text("\(character.coinsOnHand + character.stashedCoins)gp")
                        .font(.title2.monospacedDigit())
                        .foregroundColor(.primary)
                }
            }
            .padding(.vertical, 8)
        } header: {
            HStack(spacing: 8) {
                Ph.coins.bold
                    .frame(width: 20, height: 20)
                Text("Gold")
                    .font(.headline)
            }
        }
    }
}
