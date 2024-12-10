import SwiftUI
import PhosphorSwift

struct DetailEquipmentSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Equipment", icon: Ph.bagSimple.bold)
            
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
                    .padding()
                    .groupCardStyle()
                } else {
                    ForEach(character.gear) { gearItem in
                        GearDetailRow(gear: gearItem)
                            .padding()
                            .groupCardStyle()
                    }
                }
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
                    IconFrame(icon: Ph.package.bold, color: .blue)
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
                    IconFrame(icon: gear.isEquipped ? Ph.checkCircle.bold : Ph.circle.bold,
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
                
                Spacer()
                
                // Container Status
                if gear.isContainer {
                    Label {
                        Text("Container")
                            .foregroundColor(.blue)
                    } icon: {
                        IconFrame(icon: Ph.package.bold, color: .blue)
                    }
                    .font(.callout)
                }
            }
            
            if gear.isMagical || gear.isCursed || !gear.special.isEmpty {
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
                    
                    // Cursed Status
                    if gear.isCursed {
                        Label {
                            Text("Cursed")
                                .foregroundColor(.red)
                        } icon: {
                            IconFrame(icon: Ph.skull.bold, color: .red)
                        }
                        .font(.callout)
                    }
                    
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
        }
        .padding()
        #if os(iOS)
        .background(Color(uiColor: .systemBackground))
        #else
        .background(Color(nsColor: .windowBackgroundColor))
        #endif
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}
