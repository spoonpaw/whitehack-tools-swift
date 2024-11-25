import SwiftUI
import PhosphorSwift

struct DetailArmorSection: View {
    let armor: [Armor]
    let totalDefenseValue: Int
    
    var body: some View {
        Section(header: SectionHeader(title: "Armor", icon: Ph.shield.bold)) {
            if armor.isEmpty {
                Text("No armor")
                    .foregroundColor(.secondary)
                    .italic()
                    .padding(.vertical, 8)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    // Total Defense Value
                    HStack {
                        Label("Total Defense Value: \(totalDefenseValue)", systemImage: "shield.fill")
                            .font(.headline)
                    }
                    .padding(.vertical, 4)
                    
                    // Individual Armor Items
                    ForEach(armor) { armorItem in
                        ArmorDetailRow(armor: armorItem)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}

private struct ArmorDetailRow: View {
    let armor: Armor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(armor.name)
                    .font(.headline)
                
                if armor.isMagical {
                    Text("+\(armor.magicalBonus)")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text("\(armor.cost) GP")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Label("Defense Value: \(armor.defenseValue)", systemImage: "shield.fill")
                .font(.caption)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 2)
    }
}
