import SwiftUI
import PhosphorSwift

struct DetailEncumbranceSection: View {
    let character: PlayerCharacter
    
    private struct SlotCalculation: Identifiable {
        let id = UUID()
        let name: String
        let weight: String
        let quantity: Int
        let slots: Double
        
        var formattedSlots: String {
            slots.truncatingRemainder(dividingBy: 1) == 0 ? 
                String(format: "%.0f", slots) : 
                String(format: "%.1f", slots)
        }
    }
    
    private func calculateSlots() -> (total: Int, calculations: [SlotCalculation]) {
        var total: Double = 0
        var calculations: [SlotCalculation] = []
        
        // Add non-stashed gear slots
        for gear in character.gear where !gear.isStashed {
            let slotCount: Double
            switch gear.weight.lowercased() {
            case "no size": slotCount = 0.01 // Will be counted in groups of 100
            case "minor": slotCount = 0.5
            case "regular": slotCount = 1.0
            case "heavy": slotCount = 2.0
            default: slotCount = 1.0
            }
            let totalSlots = slotCount * Double(gear.quantity)
            total += totalSlots
            calculations.append(SlotCalculation(name: gear.name, weight: gear.weight, quantity: gear.quantity, slots: totalSlots))
        }
        
        // Add non-stashed armor slots (direct slot count)
        for armor in character.armor where !armor.isStashed {
            let totalSlots = Double(armor.weight * armor.quantity)
            total += totalSlots
            calculations.append(SlotCalculation(name: armor.name, weight: "\(armor.weight)", quantity: armor.quantity, slots: totalSlots))
        }
        
        // Add non-stashed weapon slots
        for weapon in character.weapons where !weapon.isStashed {
            let slotCount: Double
            switch weapon.weight.lowercased() {
            case "no size": slotCount = 0.01 // Will be counted in groups of 100
            case "minor": slotCount = 0.5
            case "regular": slotCount = 1.0
            case "heavy": slotCount = 2.0
            default: slotCount = 1.0
            }
            let totalSlots = slotCount * Double(weapon.quantity)
            total += totalSlots
            calculations.append(SlotCalculation(name: weapon.name, weight: weapon.weight, quantity: weapon.quantity, slots: totalSlots))
        }
        
        // Add coins (100 coins = 1 slot)
        let coinSlots = Double(character.coins) / 100.0
        if coinSlots > 0 {
            total += coinSlots
            calculations.append(SlotCalculation(name: "Coins", weight: "no size", quantity: character.coins, slots: coinSlots))
        }
        
        return (Int(ceil(total)), calculations)
    }
    
    private var isOverEncumbered: Bool {
        calculateSlots().total > character.maxEncumbrance
    }
    
    var body: some View {
        Section(header: SectionHeader(title: "Encumbrance", icon: Ph.scales.bold)) {
            let slots = calculateSlots()
            
            VStack(spacing: 12) {
                if slots.calculations.isEmpty {
                    HStack {
                        IconFrame(icon: Ph.bagSimple.bold, color: .gray)
                        Text("No carried items")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                } else {
                    // Categories
                    HStack(spacing: 0) {
                        Text("ITEM")
                            .frame(width: 140, alignment: .leading)
                        Text("WEIGHT")
                            .frame(width: 70, alignment: .leading)
                        Text("QTY")
                            .frame(width: 40, alignment: .trailing)
                        Text("SLOTS")
                            .frame(width: 50, alignment: .trailing)
                    }
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)
                    
                    // Divider
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 1)
                    
                    // Items
                    VStack(spacing: 8) {
                        ForEach(slots.calculations) { calc in
                            HStack(spacing: 0) {
                                Text(calc.name)
                                    .lineLimit(1)
                                    .frame(width: 140, alignment: .leading)
                                Text(calc.weight)
                                    .frame(width: 70, alignment: .leading)
                                Text("\(calc.quantity)")
                                    .frame(width: 40, alignment: .trailing)
                                    .foregroundColor(.gray)
                                Text(calc.formattedSlots)
                                    .frame(width: 50, alignment: .trailing)
                                    .foregroundColor(.blue)
                            }
                            .font(.callout)
                        }
                    }
                    
                    // Divider
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 1)
                        .padding(.top, 4)
                    
                    // Total
                    HStack(spacing: 0) {
                        Text("TOTAL SLOTS")
                            .font(.caption)
                            .textCase(.uppercase)
                            .foregroundColor(.gray)
                            .frame(width: 140, alignment: .leading)
                        Spacer()
                        Text("\(slots.total)")
                            .font(.title3.bold())
                            .foregroundColor(isOverEncumbered ? .red : .primary)
                            .frame(width: 50, alignment: .trailing)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}
