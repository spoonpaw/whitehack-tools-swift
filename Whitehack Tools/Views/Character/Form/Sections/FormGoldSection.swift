import SwiftUI
import PhosphorSwift

struct FormGoldSection: View {
    @Binding var coins: Int
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                // Gold Amount
                VStack(alignment: .leading, spacing: 12) {
                    Text("Gold Pieces")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Label {
                        TextField("Amount", value: $coins, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                    } icon: {
                        IconFrame(icon: Ph.coins.bold, color: .yellow)
                    }
                }
            }
            .padding(.vertical, 8)
        } header: {
            Label("Gold", systemImage: "centsign.circle.fill")
        }
    }
}
