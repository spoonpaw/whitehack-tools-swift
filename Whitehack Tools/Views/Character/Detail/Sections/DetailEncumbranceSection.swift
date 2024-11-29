import SwiftUI
import PhosphorSwift

struct DetailEncumbranceSection: View {
    let character: PlayerCharacter
    
    private struct SlotCalculation {
        let name: String
        let weight: String
        let quantity: Int
        let slots: Double
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
            
            VStack(alignment: .leading, spacing: 4) {
                // Header row
                HStack {
                    Text("Item")
                        .frame(width: 120, alignment: .leading)
                    Text("Weight")
                        .frame(width: 70, alignment: .leading)
                    Text("Qty")
                        .frame(width: 40, alignment: .trailing)
                    Text("Slots")
                        .frame(width: 40, alignment: .trailing)
                }
                .font(.caption)
                .foregroundColor(.gray)
                
                if slots.calculations.isEmpty {
                    Text("No carried items")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                } else {
                    // Item rows (non-stashed items only)
                    ForEach(slots.calculations, id: \.name) { calc in
                        HStack {
                            Text(calc.name)
                                .lineLimit(1)
                                .frame(width: 120, alignment: .leading)
                            Text(calc.weight)
                                .frame(width: 70, alignment: .leading)
                            Text("\(calc.quantity)")
                                .frame(width: 40, alignment: .trailing)
                            Text(String(format: "%.1f", calc.slots))
                                .frame(width: 40, alignment: .trailing)
                        }
                        .font(.caption)
                    }
                    
                    // Total row (carried items only)
                    HStack {
                        Text("Total")
                            .bold()
                            .frame(width: 120, alignment: .leading)
                        Spacer()
                        Text("\(slots.total)")
                            .bold()
                            .frame(width: 40, alignment: .trailing)
                    }
                    .font(.subheadline)
                    .padding(.top, 4)
                    .foregroundColor(isOverEncumbered ? .red : nil)
                }
            }
            .padding(.vertical, 8)
        }
    }
}
