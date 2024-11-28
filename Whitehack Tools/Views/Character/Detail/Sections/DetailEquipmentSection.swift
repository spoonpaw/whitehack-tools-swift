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
                    Ph.coins.bold
                        .frame(width: 16, height: 16)
                        .foregroundColor(.yellow)
                    Text("\(character.coins) GP")
                        .fontWeight(.medium)
                }
                
                // Gear Items
                if !character.gear.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Gear (\(character.gear.count) items)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        ForEach(character.gear) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                // Name and Properties Row
                                HStack {
                                    Text(item.name)
                                        .fontWeight(.medium)
                                    Spacer()
                                    if item.isEquipped {
                                        Text("Equipped")
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.green.opacity(0.2))
                                            .cornerRadius(4)
                                    }
                                    if item.isStashed {
                                        Text("Stashed")
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(4)
                                    }
                                }
                                
                                // Weight and Quantity
                                HStack {
                                    Label {
                                        Text(item.weight)
                                    } icon: {
                                        Ph.scales.bold
                                            .foregroundColor(.blue)
                                    }
                                    Spacer()
                                    if item.quantity > 1 {
                                        Label {
                                            Text("x\(item.quantity)")
                                        } icon: {
                                            Ph.stack.bold
                                                .foregroundColor(.orange)
                                        }
                                    }
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                
                                // Special Properties
                                if !item.special.isEmpty {
                                    Text(item.special)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                // Magical/Cursed Indicators
                                if item.isMagical || item.isCursed {
                                    HStack(spacing: 8) {
                                        if item.isMagical {
                                            Label {
                                                Text("Magical")
                                            } icon: {
                                                Ph.sparkle.bold
                                                    .foregroundColor(.purple)
                                            }
                                        }
                                        if item.isCursed {
                                            Label {
                                                Text("Cursed")
                                            } icon: {
                                                Ph.skull.bold
                                                    .foregroundColor(.red)
                                            }
                                        }
                                    }
                                    .font(.caption)
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                    }
                }
                
                // Inventory
                if !character.inventory.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Inventory (\(character.inventory.count) items)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        ForEach(character.inventory, id: \.self) { item in
                            HStack {
                                Ph.circle.fill
                                    .frame(width: 6, height: 6)
                                    .foregroundColor(.secondary)
                                Text(item)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}
