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
                    // Total Defense Value
                    HStack {
                        Label {
                            Text("Total Defense Value: \(totalDefenseValue)")
                                .font(.headline)
                        } icon: {
                            IconFrame(icon: Ph.shieldCheckered.bold, color: .blue)
                        }
                    }
                    .padding(.vertical, 4)
                    
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
                    IconFrame(icon: armor.isShield ? Ph.shieldCheck.bold : Ph.shield.bold, color: .blue)
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
                // Defense Factor
                Label {
                    Text(armor.isShield ? "+\(armor.df)" : "Defense: \(armor.df)")
                        .font(.subheadline)
                } icon: {
                    IconFrame(icon: Ph.shieldCheck.bold, color: .blue)
                }
                
                // Magical Status
                if armor.isMagical {
                    Label {
                        Text("Magical")
                            .font(.subheadline)
                    } icon: {
                        IconFrame(icon: Ph.sparkle.bold, color: .purple)
                    }
                    .foregroundStyle(.purple)
                }
                
                // Cursed Status
                if armor.isCursed {
                    Label {
                        Text("Cursed")
                            .font(.subheadline)
                    } icon: {
                        IconFrame(icon: Ph.skull.bold, color: .red)
                    }
                    .foregroundStyle(.red)
                }
                
                // Bonus/Penalty
                if armor.bonus != 0 {
                    Label {
                        HStack(spacing: 4) {
                            Text(armor.bonus >= 0 ? "Bonus" : "Penalty")
                            Text("\(abs(armor.bonus))")
                        }
                        .font(.subheadline)
                    } icon: {
                        IconFrame(icon: Ph.plusMinus.bold, color: .purple)
                    }
                    .foregroundStyle(.purple)
                }
                
                // Special Properties
                if !armor.special.isEmpty {
                    Label {
                        Text(armor.special)
                            .font(.subheadline)
                    } icon: {
                        IconFrame(icon: Ph.star.bold, color: .yellow)
                    }
                    .foregroundStyle(.yellow)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
