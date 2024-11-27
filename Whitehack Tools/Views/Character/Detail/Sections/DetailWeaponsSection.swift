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
            // Name and Status
            HStack {
                Text(weapon.name)
                    .font(.headline)
                Spacer()
            }
            
            Divider()
            
            // Combat Stats
            VStack(alignment: .leading, spacing: 4) {
                // Stashed/On Person Status
                Label {
                    Text(weapon.isStashed ? "Stashed" : "On Person")
                        .font(.subheadline)
                } icon: {
                    if weapon.isStashed {
                        IconFrame(icon: Ph.warehouse.bold, color: .orange)
                    } else {
                        IconFrame(icon: Ph.user.bold, color: .gray)
                    }
                }
                .foregroundStyle(weapon.isStashed ? .orange : .gray)
                
                // Equipped Status (only if not stashed)
                if !weapon.isStashed {
                    Label {
                        Text(weapon.isEquipped ? "Equipped" : "Unequipped")
                            .font(.subheadline)
                    } icon: {
                        IconFrame(icon: Ph.bagSimple.bold, color: weapon.isEquipped ? .green : .gray)
                    }
                    .foregroundStyle(weapon.isEquipped ? .green : .gray)
                }
                
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
                    Text("Weight: \(weapon.weight)")
                } icon: {
                    IconFrame(icon: Ph.scales.bold, color: .blue)
                }
                .foregroundStyle(.blue)
                
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
}
