import SwiftUI
import PhosphorSwift

struct DetailGoldSection: View {
    let character: PlayerCharacter
    
    private var backgroundColor: Color {
        #if os(iOS)
        Color(.systemBackground)
        #else
        Color(nsColor: .windowBackgroundColor)
        #endif
    }
    
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Gold", icon: Ph.coins.bold)
            
            VStack(spacing: 16) {
                // On Hand and Stashed
                HStack(spacing: 16) {
                    // On Hand
                    VStack(alignment: .leading, spacing: 4) {
                        Label {
                            Text("On Hand")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        } icon: {
                            IconFrame(icon: Ph.wallet.bold, color: Color.yellow.opacity(0.8))
                                .scaleEffect(0.8)
                        }
                        Text("\(character.coinsOnHand) GP")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    #if os(iOS)
                    .background(Color(UIColor.secondarySystemBackground))
                    #else
                    .background(Color(NSColor.controlBackgroundColor))
                    #endif
                    .cornerRadius(8)
                    
                    // Stashed
                    VStack(alignment: .leading, spacing: 4) {
                        Label {
                            Text("Stashed")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        } icon: {
                            IconFrame(icon: Ph.vault.bold, color: Color.yellow.opacity(0.8))
                                .scaleEffect(0.8)
                        }
                        Text("\(character.stashedCoins) GP")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    #if os(iOS)
                    .background(Color(UIColor.secondarySystemBackground))
                    #else
                    .background(Color(NSColor.controlBackgroundColor))
                    #endif
                    .cornerRadius(8)
                }
                
                // Total
                HStack {
                    Label {
                        Text("Total Gold")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    } icon: {
                        IconFrame(icon: Ph.coins.bold, color: Color.yellow.opacity(0.8))
                            .scaleEffect(0.8)
                    }
                    Spacer()
                    Text("\(character.coinsOnHand + character.stashedCoins) GP")
                        .font(.title3)
                        .fontWeight(.medium)
                }
                .padding()
                #if os(iOS)
                .background(Color(UIColor.secondarySystemBackground))
                #else
                .background(Color(NSColor.controlBackgroundColor))
                #endif
                .cornerRadius(8)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(12)
            .shadow(radius: 4)
        }
        .padding(.horizontal)
    }
}
