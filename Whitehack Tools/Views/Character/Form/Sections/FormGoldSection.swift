import SwiftUI
import PhosphorSwift

struct FormGoldSection: View {
    @Binding var coinsOnHand: Int
    @Binding var stashedCoins: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Gold on Hand
            VStack(alignment: .leading, spacing: 12) {
                Text("Gold on Hand")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Label {
                    TextField("Amount", value: $coinsOnHand, format: .number)
                        .textFieldStyle(.roundedBorder)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif
                } icon: {
                    IconFrame(icon: Ph.wallet.bold, color: .yellow)
                }
            }
            
            // Stashed Gold
            VStack(alignment: .leading, spacing: 12) {
                Text("Stashed Gold")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Label {
                    TextField("Amount", value: $stashedCoins, format: .number)
                        .textFieldStyle(.roundedBorder)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif
                } icon: {
                    IconFrame(icon: Ph.vault.bold, color: .yellow)
                }
            }
            
            // Total Gold (read-only)
            VStack(alignment: .leading, spacing: 12) {
                Text("Total Gold")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Label {
                    Text("\(coinsOnHand + stashedCoins) GP")
                        .foregroundColor(.secondary)
                } icon: {
                    IconFrame(icon: Ph.coins.bold, color: .yellow)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
