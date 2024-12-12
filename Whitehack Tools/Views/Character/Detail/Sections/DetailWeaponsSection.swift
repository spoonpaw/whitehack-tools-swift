import SwiftUI
import PhosphorSwift

struct DetailWeaponsSection: View {
    let weapons: [Weapon]
    
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Weapons", icon: Ph.sword.bold)
            
            VStack(alignment: .leading, spacing: 16) {
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
                    .padding(.horizontal)
                } else {
                    ForEach(weapons) { weapon in
                        WeaponDetailRow(weapon: weapon)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                    }
                }
            }
            .padding()
            .groupCardStyle()
            .shadow(radius: 4)
        }
        .padding(.horizontal)
    }
}

private struct WeaponDetailRow: View {
    let weapon: Weapon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name and Quantity
            HStack {
                HStack(spacing: 4) {
                    IconFrame(icon: Ph.sword.bold, color: .blue)
                    Text(weapon.name)
                        .font(.title3)
                }
                
                Spacer()
                
                Text("×\(weapon.quantity)")
                    .foregroundColor(.secondary)
                    .font(.callout)
            }
            
            // Status Section
            HStack {
                // Equipped Status
                HStack(spacing: 4) {
                    IconFrame(icon: weapon.isEquipped ? Ph.shieldCheckered.bold : Ph.shield.bold,
                            color: weapon.isEquipped ? .green : .gray)
                    Text(weapon.isEquipped ? "Equipped" : "Unequipped")
                        .foregroundColor(weapon.isEquipped ? .green : .secondary)
                }
                
                Spacer()
                
                // Location Status
                HStack(spacing: 4) {
                    IconFrame(icon: weapon.isStashed ? Ph.warehouse.bold : Ph.user.bold,
                            color: weapon.isStashed ? .orange : .gray)
                    Text(weapon.isStashed ? "Stashed" : "On Person")
                        .foregroundColor(weapon.isStashed ? .orange : .secondary)
                }
            }
            .font(.callout)
            
            // Weight and Slots
            HStack(spacing: 4) {
                IconFrame(icon: Ph.scales.bold, color: .blue)
                Text("Weight:")
                    .foregroundColor(.secondary)
                    .font(.callout)
                Text(getWeightDisplayText(weapon.weight))
                    .foregroundColor(.secondary)
                    .font(.callout)
            }
            
            // Combat Stats
            VStack(alignment: .leading, spacing: 4) {
                // Magical Status
                if weapon.isMagical {
                    HStack(spacing: 4) {
                        IconFrame(icon: Ph.sparkle.bold, color: .purple)
                        Text("Status:")
                            .foregroundColor(.secondary)
                        Text("Magical")
                            .font(.subheadline)
                            .foregroundStyle(.purple)
                    }
                }
                
                // Cursed Status
                if weapon.isCursed {
                    HStack(spacing: 4) {
                        IconFrame(icon: Ph.skull.bold, color: .red)
                        Text("Status:")
                            .foregroundColor(.secondary)
                        Text("Cursed")
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    }
                }
                
                // Bonus/Penalty
                if weapon.bonus != 0 {
                    HStack(spacing: 4) {
                        IconFrame(icon: Ph.plusMinus.bold, color: .purple)
                        Text("Modifier:")
                            .foregroundColor(.secondary)
                        HStack(spacing: 4) {
                            Text(weapon.bonus >= 0 ? "Bonus" : "Penalty")
                            Text("\(abs(weapon.bonus))")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.purple)
                    }
                }
                
                HStack(spacing: 4) {
                    IconFrame(icon: Ph.target.bold, color: .red)
                    Text("Damage:")
                        .foregroundColor(.secondary)
                    Text(weapon.damage)
                        .foregroundStyle(.red)
                }
                
                HStack(spacing: 4) {
                    IconFrame(icon: Ph.arrowsOutSimple.bold, color: .purple)
                    Text("Range:")
                        .foregroundColor(.secondary)
                    Text(weapon.range)
                        .foregroundStyle(.purple)
                }
                
                HStack(spacing: 4) {
                    IconFrame(icon: Ph.timer.bold, color: .green)
                    Text("Rate of Fire:")
                        .foregroundColor(.secondary)
                    Text(weapon.rateOfFire)
                        .foregroundStyle(.green)
                }
            }
            .font(.subheadline)
            
            // Special Properties
            if !weapon.special.isEmpty {
                HStack(spacing: 4) {
                    IconFrame(icon: Ph.star.bold, color: .purple)
                    Text("Special:")
                        .foregroundColor(.secondary)
                    Text(weapon.special)
                        .italic()
                        .foregroundStyle(.purple)
                }
                .font(.subheadline)
            }
        }
        .padding()
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

private extension View {
    func groupCardStyle() -> some View {
        self
            #if os(iOS)
            .background(Color(uiColor: .systemBackground))
            #else
            .background(Color(nsColor: .windowBackgroundColor))
            #endif
            .cornerRadius(12)
    }
}
