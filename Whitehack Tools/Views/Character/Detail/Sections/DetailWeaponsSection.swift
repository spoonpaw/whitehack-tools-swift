import SwiftUI
import PhosphorSwift

struct DetailWeaponsSection: View {
    let weapons: [Weapon]
    
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Weapons", icon: Ph.sword.bold)
            
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
                .groupCardStyle()
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(weapons) { weapon in
                        WeaponDetailRow(weapon: weapon)
                            .padding()
                            .groupCardStyle()
                            .shadow(radius: 2)
                    }
                }
                .padding()
                .groupCardStyle()
                .shadow(radius: 4)
            }
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
                Label {
                    Text(weapon.name)
                        .font(.title3)
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
                Text("Weight:")
                    .foregroundColor(.secondary)
                    .font(.callout)
                Label {
                    Text(getWeightDisplayText(weapon.weight))
                } icon: {
                    IconFrame(icon: Ph.scales.bold, color: .blue)
                }
                .foregroundColor(.secondary)
                .font(.callout)
            }
            
            // Combat Stats
            VStack(alignment: .leading, spacing: 4) {
                // Magical Status
                if weapon.isMagical {
                    HStack {
                        Text("Status:")
                            .foregroundColor(.secondary)
                        Label {
                            Text("Magical")
                                .font(.subheadline)
                        } icon: {
                            IconFrame(icon: Ph.sparkle.bold, color: .purple)
                        }
                        .foregroundStyle(.purple)
                    }
                }
                
                // Cursed Status
                if weapon.isCursed {
                    HStack {
                        Text("Status:")
                            .foregroundColor(.secondary)
                        Label {
                            Text("Cursed")
                                .font(.subheadline)
                        } icon: {
                            IconFrame(icon: Ph.skull.bold, color: .red)
                        }
                        .foregroundStyle(.red)
                    }
                }
                
                // Bonus/Penalty
                if weapon.bonus != 0 {
                    HStack {
                        Text("Modifier:")
                            .foregroundColor(.secondary)
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
                }
                
                HStack {
                    Text("Damage:")
                        .foregroundColor(.secondary)
                    Label {
                        Text(weapon.damage)
                    } icon: {
                        IconFrame(icon: Ph.target.bold, color: .red)
                    }
                    .foregroundStyle(.red)
                }
                
                HStack {
                    Text("Range:")
                        .foregroundColor(.secondary)
                    Label {
                        Text(weapon.range)
                    } icon: {
                        IconFrame(icon: Ph.arrowsOutSimple.bold, color: .purple)
                    }
                    .foregroundStyle(.purple)
                }
                
                HStack {
                    Text("Rate of Fire:")
                        .foregroundColor(.secondary)
                    Label {
                        Text(weapon.rateOfFire)
                    } icon: {
                        IconFrame(icon: Ph.timer.bold, color: .green)
                    }
                    .foregroundStyle(.green)
                }
            }
            .font(.subheadline)
            
            // Special Properties
            if !weapon.special.isEmpty {
                HStack {
                    Text("Special:")
                        .foregroundColor(.secondary)
                    Label {
                        Text(weapon.special)
                            .italic()
                    } icon: {
                        IconFrame(icon: Ph.star.bold, color: .purple)
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
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
