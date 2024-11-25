import SwiftUI
import PhosphorSwift

struct DetailWeaponsSection: View {
    let weapons: [Weapon]
    
    var body: some View {
        Section(header: SectionHeader(title: "Weapons", icon: Ph.sword.bold)) {
            if weapons.isEmpty {
                Text("No weapons")
                    .foregroundColor(.secondary)
                    .italic()
                    .padding(.vertical, 8)
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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(weapon.name)
                    .font(.headline)
                
                if weapon.isMagical {
                    Text("+\(weapon.magicalBonus)")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text("\(weapon.cost) GP")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 12) {
                Label(weapon.damage, systemImage: "burst.fill")
                    .font(.caption)
                
                Label(weapon.weight.rawValue, systemImage: "scalemass.fill")
                    .font(.caption)
                
                if !weapon.rateOfFire.isEmpty {
                    Label(weapon.rateOfFire, systemImage: "timer")
                        .font(.caption)
                }
            }
            
            if !weapon.special.isEmpty {
                Text(weapon.special)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 2)
    }
}
