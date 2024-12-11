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
            SectionHeader(title: "Armor", icon: Ph.shieldStar.bold)
            
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
                
                if armor.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "shield.slash")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        
                        Text("No Armor")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Add armor in edit mode")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                } else {
                    Text(armorDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
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
