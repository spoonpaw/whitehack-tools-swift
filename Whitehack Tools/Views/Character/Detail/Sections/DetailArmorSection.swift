import SwiftUI
import PhosphorSwift

struct DetailArmorSection: View {
    let armor: [Armor]
    let totalDefenseValue: Int
    
    private var armorDefenseValue: Int {
        // Each armor piece contributes its defense value once, regardless of quantity
        armor.reduce(into: 0) { total, armor in
            total += armor.df // Not multiplying by quantity
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Armor", icon: Ph.shieldStar.bold)
            
            VStack(alignment: .leading, spacing: 16) {
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
                    .padding(.horizontal)
                } else {
                    ForEach(armor) { armor in
                        ArmorDetailRow(armor: armor)
                            .padding()
                            #if os(iOS)
                            .background(Color(UIColor.secondarySystemBackground))
                            #else
                            .background(Color(NSColor.controlBackgroundColor))
                            #endif
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

private struct ArmorDetailRow: View {
    let armor: Armor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name, Quantity and Defense Value
            HStack {
                HStack(spacing: 4) {
                    IconFrame(icon: Ph.shieldChevron.bold, color: .blue)
                    Text(armor.name)
                        .font(.title3)
                }
                
                if armor.quantity > 1 {
                    Text("×\(armor.quantity)")
                        .foregroundColor(.secondary)
                        .font(.callout)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    IconFrame(icon: Ph.shield.bold, color: .green)
                    Text("DF \(armor.df)")
                        .font(.headline)
                        .foregroundColor(.green)
                }
            }
            
            // Status Section
            HStack {
                // Equipped Status
                HStack(spacing: 4) {
                    IconFrame(icon: armor.isEquipped ? Ph.shieldCheckered.bold : Ph.shield.bold,
                            color: armor.isEquipped ? .green : .gray)
                    Text(armor.isEquipped ? "Equipped" : "Unequipped")
                        .foregroundColor(armor.isEquipped ? .green : .secondary)
                }
                
                Spacer()
                
                // Location Status
                HStack(spacing: 4) {
                    IconFrame(icon: armor.isStashed ? Ph.warehouse.bold : Ph.user.bold,
                            color: armor.isStashed ? .orange : .gray)
                    Text(armor.isStashed ? "Stashed" : "On Person")
                        .foregroundColor(armor.isStashed ? .orange : .secondary)
                }
            }
            .font(.callout)
            
            // Weight and Slots
            HStack(spacing: 4) {
                IconFrame(icon: Ph.scales.bold, color: .blue)
                Text("Weight:")
                    .foregroundColor(.secondary)
                    .font(.callout)
                Text("\(armor.weight) slot\(armor.weight == 1 ? "" : "s")")
                    .foregroundColor(.secondary)
                    .font(.callout)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // Magical Status
                if armor.isMagical {
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
                if armor.isCursed {
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
                if armor.bonus != 0 {
                    HStack(spacing: 4) {
                        IconFrame(icon: Ph.plusMinus.bold, color: .purple)
                        Text("Modifier:")
                            .foregroundColor(.secondary)
                        HStack(spacing: 4) {
                            Text(armor.bonus >= 0 ? "Bonus" : "Penalty")
                            Text("\(abs(armor.bonus))")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.purple)
                    }
                }
                
                // Shield Status
                if armor.isShield {
                    HStack(spacing: 4) {
                        IconFrame(icon: Ph.shield.bold, color: .blue)
                        Text("Type:")
                            .foregroundColor(.secondary)
                        Text("Shield")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }
                }
            }
            .font(.subheadline)
            
            // Special Properties
            if !armor.special.isEmpty {
                HStack(spacing: 4) {
                    IconFrame(icon: Ph.star.bold, color: .purple)
                    Text("Special:")
                        .foregroundColor(.secondary)
                    Text(armor.special)
                        .italic()
                        .foregroundStyle(.purple)
                }
                .font(.subheadline)
            }
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

#Preview {
    DetailArmorSection(
        armor: [
            Armor(id: UUID(), name: "Plate Mail", df: 4, weight: 2, special: "Noisy", quantity: 1, isEquipped: true, isStashed: false, isMagical: true, isCursed: false, bonus: 0, isShield: false),
            Armor(id: UUID(), name: "Shield", df: 1, weight: 1, special: "", quantity: 1, isEquipped: true, isStashed: false, isMagical: false, isCursed: false, bonus: 0, isShield: true)
        ],
        totalDefenseValue: 5
    )
    .padding()
}
