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
        VStack(spacing: 16) {
            // Gold on Hand
            VStack(spacing: 8) {
                Text("Gold on Hand")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Label {
                    NumericTextField(text: $coinsOnHandString, field: .goldOnHand, minValue: 0, maxValue: 999999999, focusedField: $focusedField)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 120)
                        .multilineTextAlignment(.center)
                        .focused($focusedField, equals: .goldOnHand)
                        .onChange(of: focusedField) { newValue in
                            print("🔥 FOCUS CHANGED - current coins: \(coinsOnHand), string: '\(coinsOnHandString)'")
                            if newValue != .goldOnHand {  // Field lost focus
                                if coinsOnHandString.isEmpty {
                                    print("🔥 SETTING EMPTY TO 0")
                                    coinsOnHandString = "0"
                                    coinsOnHand = 0
                                } else if let value = Int(coinsOnHandString) {
                                    // Remove leading zeroes when losing focus
                                    coinsOnHandString = String(value)
                                }
                            }
                        }
                        .onChange(of: coinsOnHandString) { newValue in
                            print("🔥 STRING CHANGED TO: '\(newValue)'")
                            if let value = Int(newValue) {
                                print("🔥 PARSED INT: \(value)")
                                coinsOnHand = max(0, min(999999999, value))
                                print("🔥 SET COINS TO: \(coinsOnHand)")
                            }
                        }
                } icon: {
                    IconFrame(icon: Ph.wallet.bold, color: .yellow)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(.background)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            
            // Stashed Gold
            VStack(spacing: 8) {
                Text("Stashed Gold")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Label {
                    NumericTextField(text: $stashedCoinsString, field: .goldStashed, minValue: 0, maxValue: 999999999, focusedField: $focusedField)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 120)
                        .multilineTextAlignment(.center)
                        .focused($focusedField, equals: .goldStashed)
                        .onChange(of: focusedField) { newValue in
                            print("🔥 FOCUS CHANGED - current stashed: \(stashedCoins), string: '\(stashedCoinsString)'")
                            if newValue != .goldStashed {  // Field lost focus
                                if stashedCoinsString.isEmpty {
                                    print("🔥 SETTING EMPTY TO 0")
                                    stashedCoinsString = "0"
                                    stashedCoins = 0
                                } else if let value = Int(stashedCoinsString) {
                                    // Remove leading zeroes when losing focus
                                    stashedCoinsString = String(value)
                                }
                            }
                        }
                        .onChange(of: stashedCoinsString) { newValue in
                            print("🔥 STRING CHANGED TO: '\(newValue)'")
                            if let value = Int(newValue) {
                                print("🔥 PARSED INT: \(value)")
                                stashedCoins = max(0, min(999999999, value))
                                print("🔥 SET STASHED TO: \(stashedCoins)")
                            }
                        }
                } icon: {
                    IconFrame(icon: Ph.vault.bold, color: .yellow)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(.background)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            
            // Total Gold
            VStack(spacing: 8) {
                Text("Total Gold")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Label {
                    Text("\(coinsOnHand + stashedCoins) GP")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 120)
                        .multilineTextAlignment(.center)
                } icon: {
                    IconFrame(icon: Ph.coins.bold, color: .yellow)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(.background)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
