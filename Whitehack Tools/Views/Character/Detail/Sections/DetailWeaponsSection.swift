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
            // Name
            HStack {
                Label {
                    Text(weapon.name)
                        .font(.headline)
                } icon: {
                    IconFrame(icon: Ph.sword.bold)
                }
                
                Spacer()
                
                // Equipped Status
                Label {
                    Text(weapon.isEquipped ? "Equipped" : "Not Equipped")
                        .font(.caption)
                } icon: {
                    IconFrame(icon: Ph.bagSimple.bold, color: weapon.isEquipped ? .green : .gray)
                }
                .foregroundStyle(weapon.isEquipped ? .green : .gray)
            }
            
            Divider()
            
            // Combat Stats
            VStack(alignment: .leading, spacing: 4) {
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
