import SwiftUI
import PhosphorSwift

struct DetailWeaponsSection: View {
    let weapons: [Weapon]
    
    var body: some View {
        Section(header: SectionHeader(title: "Weapons", icon: Ph.sword.bold)) {
            if weapons.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "shield.slash")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    
                    Text("No Weapons")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Add weapons in edit mode")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .italic()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(weapons) { weapon in
                        WeaponDetailRow(weapon: weapon)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}

private struct WeaponDetailRow: View {
    let weapon: Weapon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name and Quantity
            HStack {
                Label {
                    Text(weapon.name)
                        .font(.headline)
                } icon: {
                    IconFrame(icon: Ph.sword.bold, color: .blue)
                }
                
                Spacer()
                
                Text("×\(weapon.quantity)")
                    .foregroundColor(.secondary)
                    .font(.callout)
            }
            
            // Status Section
            HStack {
                // Equipped Status
                Label {
                    Text(weapon.isEquipped ? "Equipped" : "Unequipped")
                        .foregroundColor(weapon.isEquipped ? .green : .secondary)
                } icon: {
                    IconFrame(icon: weapon.isEquipped ? Ph.shieldCheckered.bold : Ph.shield.bold,
                            color: weapon.isEquipped ? .green : .gray)
                }
                
                Spacer()
                
                // Location Status
                Label {
                    Text(weapon.isStashed ? "Stashed" : "On Person")
                        .foregroundColor(weapon.isStashed ? .orange : .secondary)
                } icon: {
                    IconFrame(icon: weapon.isStashed ? Ph.warehouse.bold : Ph.user.bold,
                            color: weapon.isStashed ? .orange : .gray)
                }
            }
            .font(.callout)
            
            // Weight and Slots
            HStack {
                Label {
                    Text(getWeightDisplayText(weapon.weight))
                } icon: {
                    IconFrame(icon: Ph.scales.bold, color: .blue)
                }
                .foregroundColor(.secondary)
                .font(.callout)
            }
            
            Divider()
            
            // Combat Stats
            VStack(alignment: .leading, spacing: 4) {
                // Magical Status
                if weapon.isMagical {
                    Label {
                        Text("Magical")
                            .font(.subheadline)
                    } icon: {
                        IconFrame(icon: Ph.sparkle.bold, color: .purple)
                    }
                    .foregroundStyle(.purple)
                }
                
                // Cursed Status
                if weapon.isCursed {
                    Label {
                        Text("Cursed")
                            .font(.subheadline)
                    } icon: {
                        IconFrame(icon: Ph.skull.bold, color: .red)
                    }
                    .foregroundStyle(.red)
                }
                
                // Bonus/Penalty
                if weapon.bonus != 0 {
                    Label {
                        HStack(spacing: 4) {
                            Text(weapon.bonus >= 0 ? "Bonus" : "Penalty")
                            Text("\(abs(weapon.bonus))")
                        }
                        .font(.subheadline)
                    } icon: {
                        IconFrame(icon: Ph.plusMinus.bold, color: .purple)
                    }
                    .foregroundStyle(.purple)
                }
                
                Label {
                    Text("Damage: \(weapon.damage)")
                } icon: {
                    IconFrame(icon: Ph.target.bold, color: .red)
                }
                .foregroundStyle(.red)
                
                Label {
                    Text("Range: \(weapon.range)")
                } icon: {
                    IconFrame(icon: Ph.arrowsOutSimple.bold, color: .purple)
                }
                .foregroundStyle(.purple)
                
                Label {
                    Text("Rate of Fire: \(weapon.rateOfFire)")
                } icon: {
                    IconFrame(icon: Ph.timer.bold, color: .green)
                }
                .foregroundStyle(.green)
            }
            .font(.subheadline)
            
            // Special Properties
            if !weapon.special.isEmpty {
                Label {
                    Text(weapon.special)
                        .italic()
                } icon: {
                    IconFrame(icon: Ph.star.bold, color: .purple)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
    
    private func getWeightDisplayText(_ weight: String) -> String {
        switch weight {
        case "No size": return "No size (100/slot)"
        case "Minor": return "Minor (2/slot)"
        case "Regular": return "Regular (1 slot)"
        case "Heavy": return "Heavy (2 slots)"
        default: return weight
        }
    }
}
