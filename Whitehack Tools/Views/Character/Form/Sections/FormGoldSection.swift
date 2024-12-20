import SwiftUI
import PhosphorSwift

struct FormGoldSection: View {
    @Binding var coinsOnHand: Int
    @Binding var stashedCoins: Int
    
    @State private var coinsOnHandString: String
    @State private var stashedCoinsString: String
    @FocusState private var focusedField: CharacterFormView.Field?
    
    init(coinsOnHand: Binding<Int>, stashedCoins: Binding<Int>) {
        self._coinsOnHand = coinsOnHand
        self._stashedCoins = stashedCoins
        self._coinsOnHandString = State(initialValue: "\(coinsOnHand.wrappedValue)")
        self._stashedCoinsString = State(initialValue: "\(stashedCoins.wrappedValue)")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Gold on Hand
            VStack(alignment: .leading, spacing: 12) {
                Text("Gold on Hand")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Label {
                    NumericTextField(text: $coinsOnHandString, field: .goldOnHand, minValue: 0, maxValue: 999999999, focusedField: $focusedField)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: coinsOnHandString) { newValue in
                            if let value = Int(newValue) {
                                coinsOnHand = max(0, min(999999999, value))
                            }
                            coinsOnHandString = "\(coinsOnHand)"
                        }
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
                    NumericTextField(text: $stashedCoinsString, field: .goldStashed, minValue: 0, maxValue: 999999999, focusedField: $focusedField)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: stashedCoinsString) { newValue in
                            if let value = Int(newValue) {
                                stashedCoins = max(0, min(999999999, value))
                            }
                            stashedCoinsString = "\(stashedCoins)"
                        }
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
