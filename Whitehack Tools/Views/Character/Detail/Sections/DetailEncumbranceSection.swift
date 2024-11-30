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
            String(format: "%.2f", slots)
        }
    }
    
    private func calculateSlots() -> (total: Double, calculations: [SlotCalculation]) {
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
        let coinSlots = Double(character.coinsOnHand) / 100.0
        if coinSlots > 0 {
            total += coinSlots
            calculations.append(SlotCalculation(name: "Coins", weight: "no size", quantity: character.coinsOnHand, slots: coinSlots))
        }
        
        return (total, calculations)
    }
    
    private func calculateMovementRates(baseMovement: Int, totalSlots: Double) -> (normal: Int, careful: Int, run: Int, crawl: Int, maxSlots: Double, excessSlots: Double, categoriesDrop: Int) {
        let hasContainer = character.gear.contains(where: { $0.isContainer && $0.isEquipped })
        let maxSlots = hasContainer ? 15.0 : 10.0
        let excessSlots = max(0, totalSlots - maxSlots)
        let categoriesDrop = Int(ceil(excessSlots / 2.0))
        let normalMove = max(baseMovement - (5 * categoriesDrop), 5)
        
        return (
            normal: normalMove,
            careful: normalMove / 2,
            run: normalMove * 2,
            crawl: normalMove * 4,
            maxSlots: maxSlots,
            excessSlots: excessSlots,
            categoriesDrop: categoriesDrop
        )
    }
    
    private var isOverEncumbered: Bool {
        calculateSlots().total > Double(character.maxEncumbrance)
    }
    
    var body: some View {
        Section(header: SectionHeader(title: "Encumbrance", icon: Ph.scales.bold)) {
            let slots = calculateSlots()
            let movement = calculateMovementRates(baseMovement: character.movement, totalSlots: slots.total)
            
            VStack(spacing: 16) {
                // Encumbrance Summary
                VStack(alignment: .leading, spacing: 16) {
                    Text("ENCUMBRANCE STATUS")
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // Container Status
                        HStack {
                            Label {
                                Text(character.gear.contains(where: { $0.isContainer && $0.isEquipped }) ? 
                                     "Container Equipped (+5 slots)" : "No Container")
                            } icon: {
                                IconFrame(icon: Ph.package.bold, color: .blue)
                            }
                            .foregroundColor(.blue)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // Slot Summary
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Maximum Slots:")
                                    .frame(width: 120, alignment: .leading)
                                Text("\(String(format: "%.2f", movement.maxSlots))")
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                            HStack {
                                Text("Current Slots:")
                                    .frame(width: 120, alignment: .leading)
                                Text("\(String(format: "%.2f", slots.total))")
                                    .foregroundColor(slots.total > movement.maxSlots ? .red : .blue)
                                Spacer()
                            }
                            if movement.excessSlots > 0 {
                                HStack {
                                    Text("Excess Slots:")
                                        .frame(width: 120, alignment: .leading)
                                    Text("\(String(format: "%.2f", movement.excessSlots))")
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        if movement.categoriesDrop > 0 {
                            HStack {
                                Label {
                                    Text("Movement Penalty: -\(movement.categoriesDrop) categories")
                                } icon: {
                                    IconFrame(icon: Ph.warning.bold, color: .red)
                                }
                                .foregroundColor(.red)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical, 12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                
                // Movement Summary
                VStack(alignment: .leading, spacing: 16) {
                    Text("MOVEMENT RATES")
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // Base Movement
                        HStack {
                            Text("Base Movement:")
                                .frame(width: 120, alignment: .leading)
                            Text("\(character.movement) ft")
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // Movement Categories
                        VStack(alignment: .leading, spacing: 8) {
                            // Header
                            HStack {
                                Text("TYPE")
                                    .frame(width: 80, alignment: .leading)
                                Text("RATE")
                                    .frame(width: 80, alignment: .leading)
                                Text("NOTES")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                            }
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .textCase(.uppercase)
                            .padding(.horizontal)
                            
                            Divider()
                                .padding(.horizontal)
                            
                            // Movement Types
                            ForEach([
                                (type: "Normal", rate: movement.normal, note: "Base rate"),
                                (type: "Careful", rate: movement.careful, note: "Half speed"),
                                (type: "Run", rate: movement.run, note: "Double speed"),
                                (type: "Crawl", rate: movement.crawl, note: "Per 10 minutes")
                            ], id: \.type) { moveType in
                                HStack {
                                    Text(moveType.type)
                                        .frame(width: 80, alignment: .leading)
                                    Text("\(moveType.rate) ft")
                                        .frame(width: 80, alignment: .leading)
                                        .foregroundColor(.primary)
                                    Text(moveType.note)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical, 12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                
                // Detailed Explanation
                VStack(alignment: .leading, spacing: 16) {
                    let slots = calculateSlots()
                    let movement = calculateMovementRates(baseMovement: character.movement, totalSlots: slots.total)
                    let excessSlots = max(0, slots.total - movement.maxSlots)
                    
                    let burdenCategory = { () -> (name: String, icon: String, color: Color) in
                        switch movement.categoriesDrop {
                            case 0: return ("Normal", "figure.walk", .green)
                            case 1: return ("Heavy", "figure.walk.motion", .yellow)
                            case 2: return ("Severe", "figure.walk.arrival", .orange)
                            default: return ("Massive", "figure.walk.departure", .red)
                        }
                    }()
                    
                    // Burden Category Header
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: burdenCategory.icon)
                            .font(.title)
                            .foregroundColor(burdenCategory.color)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("BURDEN STATUS")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(burdenCategory.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(burdenCategory.color)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // Capacity Info
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "backpack")
                                .foregroundColor(.secondary)
                            Text("""
                                Carrying \(String(format: "%.2f", slots.total)) slots\
                                \(character.gear.contains(where: { $0.isContainer && $0.isEquipped }) ? 
                                " / 15 (with container)" : 
                                " / 10 (no container)")
                                """)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        
                        if slots.total > movement.maxSlots {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "arrow.up.forward")
                                    .foregroundColor(burdenCategory.color)
                                Text("\(String(format: "%.2f", excessSlots)) slots over (\(Int(excessSlots)) completed uneven)")
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Movement Rates
                        VStack(alignment: .leading, spacing: 8) {
                            Text("MOVEMENT RATES")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.horizontal)
                            
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "timer")
                                    .foregroundColor(.secondary)
                                Text("Combat Round (10 seconds):")
                                    .fontWeight(.medium)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal)
                            
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.clear)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("• \(movement.normal) ft with action")
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text("• \(movement.careful) ft careful")
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text("• \(movement.run) ft running")
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal)
                            
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "map")
                                    .foregroundColor(.secondary)
                                Text("Exploration (10 minutes):")
                                    .fontWeight(.medium)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal)
                            .padding(.top, 4)
                            
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.clear)
                                Text("• \(movement.crawl) ft while mapping/searching")
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Straining Option
                        if movement.categoriesDrop > 0 {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("STRAINING OPTION")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                                    .padding(.horizontal)
                                
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "bolt.fill")
                                        .foregroundColor(.yellow)
                                    Text("Strength roll to move as \(movement.categoriesDrop == 1 ? "Normal" : movement.categoriesDrop == 2 ? "Heavy" : "Severe")")
                                        .fontWeight(.medium)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Spacer(minLength: 0)
                                }
                                .padding(.horizontal)
                                
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.clear)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("• \(movement.normal + 5) ft in combat")
                                            .fixedSize(horizontal: false, vertical: true)
                                        Text("• \(movement.run + 10) ft running")
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    Spacer(minLength: 0)
                                }
                                .padding(.horizontal)
                                
                                if movement.categoriesDrop >= 3 {
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.red)
                                        Text("Massive burden may require Strength check to move at all")
                                            .foregroundColor(.red)
                                            .fixedSize(horizontal: false, vertical: true)
                                        Spacer(minLength: 0)
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 4)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            }
            .padding(.vertical, 8)
        }
    }
}
