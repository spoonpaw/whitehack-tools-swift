import SwiftUI
import PhosphorSwift

struct DetailEquipmentSection: View {
    let character: PlayerCharacter
    
    private var isOverEncumbered: Bool {
        character.currentEncumbrance > character.maxEncumbrance
    }
    
    var body: some View {
        Section(header: SectionHeader(title: "Equipment", icon: Ph.briefcase.bold)) {
            VStack(alignment: .leading, spacing: 16) {
                // Encumbrance Bar
                VStack(alignment: .leading, spacing: 4) {
                    ProgressBar(
                        value: Double(character.currentEncumbrance),
                        maxValue: Double(character.maxEncumbrance),
                        label: "Encumbrance",
                        foregroundColor: isOverEncumbered ? .red : .blue,
                        showPercentage: true,
                        isComplete: isOverEncumbered,
                        completionMessage: isOverEncumbered ? "Over encumbered!" : nil
                    )
                }
                
                // Coins
                HStack {
                    Label {
                        Text("\(character.coins) GP")
                            .fontWeight(.medium)
                    } icon: {
                        IconFrame(icon: Ph.coins.bold, color: .yellow)
                    }
                }
                
                // Gear Items
                if character.gear.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "shippingbox.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        
                        Text("No Equipment")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Add equipment in edit mode")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(character.gear) { item in
                            GearDetailRow(gear: item)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}

private struct GearDetailRow: View {
    let gear: Gear
    
    private func getWeightDisplayText(_ weight: String) -> String {
        switch weight {
        case "No size": return "No size (100/slot)"
        case "Minor": return "Minor (2/slot)"
        case "Regular": return "Regular (1 slot)"
        case "Heavy": return "Heavy (2 slots)"
        default: return weight
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name and Quantity
            HStack {
                Label {
                    Text(gear.name)
                        .font(.headline)
                } icon: {
                    IconFrame(icon: Ph.package.bold, color: .blue)
                }
                
                Spacer()
                
                if gear.quantity > 1 {
                    Text("×\(gear.quantity)")
                        .foregroundColor(.secondary)
                        .font(.callout)
                }
            }
            
            // Status Section
            HStack {
                // Equipped Status
                Label {
                    Text(gear.isEquipped ? "Equipped" : "Unequipped")
                        .foregroundColor(gear.isEquipped ? .green : .secondary)
                } icon: {
                    IconFrame(icon: gear.isEquipped ? Ph.bagSimple.bold : Ph.bag.bold,
                            color: gear.isEquipped ? .green : .gray)
                }
                
                Spacer()
                
                // Location Status
                Label {
                    Text(gear.isStashed ? "Stashed" : "On Person")
                        .font(.subheadline)
                } icon: {
                    IconFrame(icon: gear.isStashed ? Ph.warehouse.bold : Ph.user.bold, color: gear.isStashed ? .orange : .secondary)
                }
                .foregroundColor(gear.isStashed ? .orange : .secondary)
            }
            .font(.callout)
            
            // Weight and Slots
            HStack {
                Label {
                    Text(getWeightDisplayText(gear.weight))
                } icon: {
                    IconFrame(icon: Ph.scales.bold, color: .blue)
                }
                .foregroundColor(.secondary)
                .font(.callout)
            }
            
            if !gear.special.isEmpty {
                Divider()
                
                // Special Properties
                VStack(alignment: .leading, spacing: 4) {
                    Label {
                        Text(gear.special)
                            .foregroundColor(.secondary)
                            .font(.callout)
                    } icon: {
                        IconFrame(icon: Ph.textT.bold, color: .purple)
                    }
                }
            }
            
            if gear.isMagical || gear.isCursed {
                Divider()
                
                // Magical/Cursed Status
                VStack(alignment: .leading, spacing: 4) {
                    if gear.isMagical {
                        Label {
                            Text("Magical")
                                .foregroundColor(.purple)
                        } icon: {
                            IconFrame(icon: Ph.sparkle.bold, color: .purple)
                        }
                    }
                    
                    if gear.isCursed {
                        Label {
                            Text("Cursed")
                                .foregroundColor(.red)
                        } icon: {
                            IconFrame(icon: Ph.skull.bold, color: .red)
                        }
                    }
                }
                .font(.callout)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
