import SwiftUI
import PhosphorSwift

struct DetailArmorSection: View {
    let armor: [Armor]
    let totalDefenseValue: Int
    
    private var armorDefenseValue: Int {
        armor.reduce(into: 0) { total, armor in
            total += armor.df
        }
    }
    
    private var armorDescription: String {
        if armor.isEmpty {
            return "No armor equipped"
        } else {
            return armor.map { "\($0.name) (\($0.df))" }.joined(separator: ", ")
        }
    }
    
    private var backgroundColor: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemGroupedBackground)
        #else
        return Color(nsColor: .windowBackgroundColor)
        #endif
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Ph.shieldStar.bold
                    .frame(width: 20, height: 20)
                Text("Armor")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Defense Value")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(totalDefenseValue)")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                
                if !armor.isEmpty {
                    Text(armorDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .cornerRadius(12)
        }
    }
}
