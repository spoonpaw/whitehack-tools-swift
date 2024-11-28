import SwiftUI
import PhosphorSwift

struct DetailArmorSection: View {
    let armor: [Armor]
    let totalDefenseValue: Int
    
    private func getWeightDisplayText(_ weight: Int) -> String {
        return "\(weight) slot\(weight == 1 ? "" : "s")"
    }
    
    var body: some View {
        Section(header: SectionHeader(title: "Armor", icon: Ph.shield.bold)) {
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
                VStack(alignment: .leading, spacing: 12) {
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
    
    private func getWeightDisplayText(_ weight: Int) -> String {
        return "\(weight) slot\(weight == 1 ? "" : "s")"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name and Quantity
            HStack {
                Label {
                    Text(armor.name)
                        .font(.headline)
                } icon: {
                    IconFrame(icon: armor.isShield ? Ph.shieldCheck.bold : Ph.shield.bold, 
                            color: armor.isShield ? .blue : .purple)
                }
                
                Spacer()
                
                Text("×\(armor.quantity)")
                    .foregroundColor(.secondary)
                    .font(.callout)
            }
            
            // Status Section
            HStack {
                // Equipped Status
                Label {
                    Text(armor.isEquipped ? "Equipped" : "Unequipped")
                        .foregroundColor(armor.isEquipped ? .green : .secondary)
                } icon: {
                    IconFrame(icon: armor.isEquipped ? Ph.shieldCheckered.bold : Ph.shield.bold,
                            color: armor.isEquipped ? .green : .gray)
                }
                
                Spacer()
                
                // Location Status
                Label {
                    Text(armor.isStashed ? "Stashed" : "On Person")
                        .foregroundColor(armor.isStashed ? .orange : .secondary)
                } icon: {
                    IconFrame(icon: armor.isStashed ? Ph.warehouse.bold : Ph.user.bold,
                            color: armor.isStashed ? .orange : .gray)
                }
            }
            .font(.callout)
            
            // Weight
            HStack {
                Label {
                    Text(getWeightDisplayText(armor.weight))
                } icon: {
                    IconFrame(icon: Ph.scales.bold, color: .blue)
                }
                .foregroundColor(.secondary)
                .font(.callout)
            }
            
            Divider()
            
            // Armor Stats
            VStack(alignment: .leading, spacing: 4) {
                // Magical Status
                if armor.isMagical {
                    Label {
                        Text("Magical")
                            .foregroundColor(.purple)
                    } icon: {
                        IconFrame(icon: Ph.sparkle.bold, color: .purple)
                    }
                    .font(.callout)
                }
                
                // Cursed Status
                if armor.isCursed {
                    Label {
                        Text("Cursed")
                            .foregroundColor(.red)
                    } icon: {
                        IconFrame(icon: Ph.skull.bold, color: .red)
                    }
                    .font(.callout)
                }
                
                // Defense Value
                Label {
                    Text("Defense: \(armor.isShield ? "+\(armor.df)" : "\(armor.df)")")
                        .foregroundColor(.blue)
                } icon: {
                    IconFrame(icon: Ph.shieldChevron.bold, color: .blue)
                }
                .font(.callout)
                
                // Bonus/Penalty
                if armor.bonus != 0 {
                    Label {
                        Text("\(armor.bonus >= 0 ? "+" : "-")\(abs(armor.bonus))")
                            .foregroundColor(armor.bonus >= 0 ? .green : .red)
                    } icon: {
                        IconFrame(icon: armor.bonus >= 0 ? Ph.plus.bold : Ph.minus.bold,
                                color: armor.bonus >= 0 ? .green : .red)
                    }
                    .font(.callout)
                }
                
                // Special Properties
                if !armor.special.isEmpty {
                    Label {
                        Text(armor.special)
                            .foregroundColor(.yellow)
                    } icon: {
                        IconFrame(icon: Ph.star.bold, color: .yellow)
                    }
                    .font(.callout)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}
