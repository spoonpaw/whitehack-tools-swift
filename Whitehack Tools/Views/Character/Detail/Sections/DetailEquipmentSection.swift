import SwiftUI
import PhosphorSwift

struct DetailEquipmentSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section(header: SectionHeader(title: "Equipment", icon: Ph.briefcase.bold)) {
            VStack(alignment: .leading, spacing: 16) {
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
                        ForEach(character.gear) { gearItem in
                            GearDetailRow(gear: gearItem)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
}

private struct GearDetailRow: View {
    let gear: Gear
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name and Quantity
            HStack {
                Label {
                    Text(gear.name)
                        .font(.headline)
                } icon: {
                    IconFrame(icon: Ph.bagSimple.bold, color: .blue)
                }
                
                Spacer()
                
                Text("×\(gear.quantity)")
                    .foregroundColor(.secondary)
                    .font(.callout)
            }
            
            // Status Section
            HStack {
                // Equipped Status
                Label {
                    Text(gear.isEquipped ? "Equipped" : "Unequipped")
                        .foregroundColor(gear.isEquipped ? .green : .secondary)
                } icon: {
                    IconFrame(icon: gear.isEquipped ? Ph.bagSimple.bold : Ph.bagSimple.bold,
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
                    Text(FormEquipmentSection.getWeightDisplayText(gear.weight))
                } icon: {
                    IconFrame(icon: Ph.scales.bold, color: .blue)
                }
                .foregroundColor(.secondary)
                .font(.callout)
            }
            
            Divider()
            
            // Special Properties Section
            VStack(alignment: .leading, spacing: 4) {
                // Magical Status
                if gear.isMagical {
                    Label {
                        Text("Magical")
                            .foregroundColor(.purple)
                    } icon: {
                        IconFrame(icon: Ph.sparkle.bold, color: .purple)
                    }
                    .font(.callout)
                }
                
                // Cursed and Container Status
                HStack(spacing: 8) {
                    if gear.isCursed {
                        IconFrame(icon: Ph.skull.bold, color: .red)
                    }
                    if gear.isContainer {
                        IconFrame(icon: Ph.package.bold, color: .blue)
                    }
                }
                .font(.callout)
                
                // Special Properties
                if !gear.special.isEmpty {
                    Label {
                        Text(gear.special)
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
