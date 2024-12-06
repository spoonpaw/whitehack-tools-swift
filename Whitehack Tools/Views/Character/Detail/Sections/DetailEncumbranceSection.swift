import SwiftUI
import PhosphorSwift

struct DetailEncumbranceSection: View {
    let character: PlayerCharacter
    
    private let columnWidth: CGFloat = 65
    private let spacing: CGFloat = 12
    private let cornerRadius: CGFloat = 12
    
    private var usedSlots: Double {
        var total: Double = 0
        
        print("🎒 [ENCUMBRANCE] Starting encumbrance calculation...")
        
        // Add non-stashed gear slots
        for gear in character.gear where !gear.isStashed {
            let slotCount: Double
            switch gear.weight.lowercased() {
            case "no size": 
                slotCount = 0.01 // Will be counted in groups of 100
                print("🎒 [ENCUMBRANCE] No size item: \(gear.name) x\(gear.quantity) = \(slotCount * Double(gear.quantity)) slots")
            case "minor": 
                slotCount = 0.5
                print("🎒 [ENCUMBRANCE] Minor item: \(gear.name) x\(gear.quantity) = \(slotCount * Double(gear.quantity)) slots")
            case "regular": 
                slotCount = 1.0
                print("🎒 [ENCUMBRANCE] Regular item: \(gear.name) x\(gear.quantity) = \(slotCount * Double(gear.quantity)) slots")
            case "heavy": 
                slotCount = 2.0
                print("🎒 [ENCUMBRANCE] Heavy item: \(gear.name) x\(gear.quantity) = \(slotCount * Double(gear.quantity)) slots")
            default: 
                slotCount = 1.0
                print("🎒 [ENCUMBRANCE] Unknown weight item: \(gear.name) x\(gear.quantity) = \(slotCount * Double(gear.quantity)) slots")
            }
            total += slotCount * Double(gear.quantity)
        }
        
        // Add non-stashed armor slots
        for armor in character.armor where !armor.isStashed {
            let slots = Double(armor.weight * armor.quantity)
            print("🎒 [ENCUMBRANCE] Armor: \(armor.name) x\(armor.quantity) = \(slots) slots")
            total += slots
        }
        
        // Add non-stashed weapon slots
        for weapon in character.weapons where !weapon.isStashed {
            let slotCount: Double
            switch weapon.weight.lowercased() {
            case "no size": 
                slotCount = 0.01
                print("🎒 [ENCUMBRANCE] No size weapon: \(weapon.name) x\(weapon.quantity) = \(slotCount * Double(weapon.quantity)) slots")
            case "minor": 
                slotCount = 0.5
                print("🎒 [ENCUMBRANCE] Minor weapon: \(weapon.name) x\(weapon.quantity) = \(slotCount * Double(weapon.quantity)) slots")
            case "regular": 
                slotCount = 1.0
                print("🎒 [ENCUMBRANCE] Regular weapon: \(weapon.name) x\(weapon.quantity) = \(slotCount * Double(weapon.quantity)) slots")
            case "heavy": 
                slotCount = 2.0
                print("🎒 [ENCUMBRANCE] Heavy weapon: \(weapon.name) x\(weapon.quantity) = \(slotCount * Double(weapon.quantity)) slots")
            default: 
                slotCount = 1.0
                print("🎒 [ENCUMBRANCE] Unknown weight weapon: \(weapon.name) x\(weapon.quantity) = \(slotCount * Double(weapon.quantity)) slots")
            }
            total += slotCount * Double(weapon.quantity)
        }
        
        // Add coins (100 coins = 1 slot)
        let coinSlots = Double(character.coinsOnHand) / 100.0
        print("🎒 [ENCUMBRANCE] Coins: \(character.coinsOnHand) coins = \(coinSlots) slots")
        total += coinSlots
        
        print("🎒 [ENCUMBRANCE] Total used slots: \(total)")
        return total
    }
    
    private var maxSlots: Double {
        let hasContainer = character.gear.contains(where: { $0.isContainer && $0.isEquipped })
        let max = hasContainer ? 15.0 : 10.0
        print("🎒 [ENCUMBRANCE] Max slots: \(max) (Container: \(hasContainer))")
        return max
    }
    
    private var excessSlots: Double {
        let excess = max(0, usedSlots - maxSlots)
        print("🎒 [ENCUMBRANCE] Excess slots: \(excess)")
        return excess
    }
    
    private var burdenLevel: BurdenLevel {
        let drops = min(3, Int((excessSlots + 1) / 2))
        switch drops {
        case 0: return .normal
        case 1: return .heavy
        case 2: return .severe
        default: return .massive
        }
    }
    
    private var movementPenalty: Int {
        return 5 * Int((excessSlots + 1) / 2)
    }
    
    private var isSmaller: Bool {
        character.movement == 25
    }
    
    private var movementColumn: Int {
        isSmaller ? 2 : 1  // 1 for Human (30), 2 for Smaller (25)
    }
    
    private var movementRates: [String] {
        let base = character.movement
        return [
            "\(base) ft/r",
            "\(base - 5) ft/r",
            "\(base - 10) ft/r",
            "\(base - 15) ft/r"
        ]
    }
    
    private var crawlRates: [String] {
        return [
            "120 ft",
            "100 ft",
            "80 ft",
            "60 ft"
        ]
    }
    
    var body: some View {
        Section(header: SectionHeader(title: "Encumbrance", icon: Ph.barbell.bold)) {
            VStack(spacing: 16) {
                // Slots Overview
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        IconFrame(icon: Ph.stack.bold, color: .blue)
                        Text("Slots Overview")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    
                    VStack(spacing: 16) {
                        HStack(alignment: .center, spacing: 16) {
                            // Used Slots
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Used")
                                    .font(.system(.subheadline))
                                    .foregroundColor(.secondary)
                                Text(String(format: "%.1f", usedSlots))
                                    .font(.system(.title2, design: .rounded).weight(.medium))
                                    .foregroundColor(.primary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Available Slots
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Available")
                                    .font(.system(.subheadline))
                                    .foregroundColor(.secondary)
                                Text(String(format: "%.1f", max(0, maxSlots - usedSlots)))
                                    .font(.system(.title2, design: .rounded).weight(.medium))
                                    .foregroundColor(.primary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if excessSlots > 0 {
                            Divider()
                            
                            // Excess Slots (only shown when over limit)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Excess")
                                    .font(.system(.subheadline))
                                    .foregroundColor(.secondary)
                                HStack(alignment: .firstTextBaseline, spacing: 4) {
                                    Text(String(format: "%.1f", excessSlots))
                                        .font(.system(.title2, design: .rounded).weight(.medium))
                                        .foregroundColor(.red)
                                    Text("slots over limit")
                                        .font(.system(.caption))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(12)
                #if os(iOS)
                .background(Color(uiColor: .secondarySystemBackground))
                #else
                .background(Color(nsColor: .controlBackgroundColor))
                #endif
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                
                // Current Burden Status
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        IconFrame(icon: Image(systemName: burdenLevel.iconName), color: burdenLevel.color)
                        Text("Current Burden")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(burdenLevel.title)
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(burdenLevel.color)
                        
                        Text(burdenLevel.description)
                            .font(.system(.subheadline))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(burdenLevel.color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                
                // Movement Rates
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        IconFrame(icon: Ph.personSimpleRun.bold, color: .green)
                        Text("Movement Rates")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    
                    Text("Base rates for different burden levels.")
                        .font(.system(.caption))
                        .foregroundColor(.secondary)
                    Text("Crawl rate is ft per 10 minutes.")
                        .font(.system(.caption))
                        .foregroundColor(.secondary)
                    
                    // Main movement rates table
                    VStack(spacing: 2) {
                        tableHeaderRow
                        
                        Divider()
                            .padding(.vertical, 4)
                        
                        ForEach(BurdenLevel.allCases, id: \.self) { burden in
                            HStack(spacing: spacing) {
                                // Circle column
                                Circle()
                                    .fill(burden == burdenLevel ? burden.color : Color.clear)
                                    .frame(width: 6, height: 6)
                                    .frame(width: 16, alignment: .center)
                                
                                // Burden name
                                Text(burden.title)
                                    .frame(width: columnWidth - 6, alignment: .leading)
                                
                                Text(movementRates[burden.index])
                                    .frame(width: columnWidth, alignment: .leading)
                                    .foregroundColor(burden == burdenLevel ? burdenLevel.color : .secondary)
                                    .font(.system(.subheadline, design: .default).weight(burden == burdenLevel ? .bold : .regular))
                                
                                Text(crawlRates[burden.index])
                                    .frame(width: columnWidth, alignment: .leading)
                                    .foregroundColor(burden == burdenLevel ? burdenLevel.color : .secondary)
                                    .font(.system(.subheadline, design: .default).weight(burden == burdenLevel ? .bold : .regular))
                            }
                            .font(.system(.subheadline))
                            .padding(.vertical, 4)
                        }
                    }
                }
                .padding(12)
                #if os(iOS)
                .background(Color(uiColor: .secondarySystemBackground))
                #else
                .background(Color(nsColor: .controlBackgroundColor))
                #endif
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                
                // Movement Options
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        IconFrame(icon: Ph.arrowsOutCardinal.bold, color: burdenLevel.color)
                        Text("Movement Options")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    
                    Text("Movement rates per round (r)")
                        .font(.system(.caption))
                        .foregroundColor(.secondary)
                    Text("For use in combat and tactical situations")
                        .font(.system(.caption))
                        .foregroundColor(.secondary)
                    
                    let baseRate = movementRates[burdenLevel.index].replacingOccurrences(of: " ft/r", with: "")
                    if let base = Int(baseRate) {
                        VStack(spacing: 2) {
                            // Header
                            HStack(spacing: spacing) {
                                Text("Movement Type")
                                    .frame(width: columnWidth + 30, alignment: .leading)
                                Text("Speed")
                                    .frame(width: columnWidth, alignment: .leading)
                            }
                            .font(.system(.subheadline))
                            .foregroundColor(.secondary)
                            
                            Divider()
                                .padding(.vertical, 4)
                            
                            // Careful
                            HStack(spacing: spacing) {
                                Text("Careful")
                                    .frame(width: columnWidth + 30, alignment: .leading)
                                Text("\(base - 10) ft/r")
                                    .frame(width: columnWidth, alignment: .leading)
                            }
                            
                            // Normal
                            HStack(spacing: spacing) {
                                Text("Normal")
                                    .frame(width: columnWidth + 30, alignment: .leading)
                                Text("\(base) ft/r")
                                    .frame(width: columnWidth, alignment: .leading)
                            }
                            .foregroundColor(burdenLevel.color)
                            .font(.system(.subheadline, design: .default).weight(.bold))
                            
                            // Running
                            HStack(spacing: spacing) {
                                Text("Running")
                                    .frame(width: columnWidth + 30, alignment: .leading)
                                Text("\(base * 2) ft/r")
                                    .frame(width: columnWidth, alignment: .leading)
                            }
                        }
                        .font(.system(.subheadline))
                    }
                }
                .padding(12)
                #if os(iOS)
                .background(Color(uiColor: .secondarySystemBackground))
                #else
                .background(Color(nsColor: .controlBackgroundColor))
                #endif
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                
                // Burden Status
                if excessSlots > 0 {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            IconFrame(icon: Ph.warning.bold, color: .orange)
                            Text("Burden Status")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        let drops = min(3, Int((excessSlots + 1) / 2))
                        let dropsText = drops == 3 ? "maximum of 3" : "\(drops)"
                        Text("Your character is carrying \(String(format: "%.1f", excessSlots)) slots over their limit, dropping \(dropsText) burden categor\(drops == 1 ? "y" : "ies") from Normal.")
                            .font(.system(.subheadline))
                        
                        Text("Straining & Boosted Movement")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.top, 4)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Make a Strength roll to move as if your burden was one category lighter for the current time unit (round, 10 min, hour, or 6 hours).")
                                .font(.system(.caption))
                                .foregroundColor(.secondary)
                            
                            Text("Success: Move at the lighter burden rate for the time unit")
                                .font(.system(.caption))
                                .foregroundColor(.green)
                            
                            Text("Failure: Cannot move in the next time unit")
                                .font(.system(.caption))
                                .foregroundColor(.red)
                            
                            Text("Note: If a boosted time unit covers a smaller unit (e.g., 6 hours → round), a new roll is required to maintain the boost.")
                                .font(.system(.caption))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(12)
                    #if os(iOS)
                    .background(Color(uiColor: .secondarySystemBackground))
                    #else
                    .background(Color(nsColor: .controlBackgroundColor))
                    #endif
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private var tableHeaderRow: some View {
        HStack(spacing: spacing) {
            // Empty space for circle
            Text("")
                .frame(width: 16, alignment: .leading)
            Text("Burden")
                .frame(width: columnWidth - 6, alignment: .leading)
            Text("Move")
                .frame(width: columnWidth, alignment: .leading)
            Text("Crawl")
                .frame(width: columnWidth, alignment: .leading)
        }
        .font(.system(.subheadline))
        .foregroundColor(.secondary)
    }
    
    private func slotInfoView(title: String, value: String, isHighlighted: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(.subheadline))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(.title2, design: .rounded).weight(.medium))
                .foregroundColor(isHighlighted ? .red : .primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Supporting Types
enum BurdenLevel: CaseIterable {
    case normal, heavy, severe, massive
    
    var title: String {
        switch self {
        case .normal: return "Normal"
        case .heavy: return "Heavy"
        case .severe: return "Severe"
        case .massive: return "Massive"
        }
    }
    
    var description: String {
        switch self {
        case .normal: return "Moving freely"
        case .heavy: return "Slightly encumbered"
        case .severe: return "Heavily encumbered"
        case .massive: return "Severely encumbered"
        }
    }
    
    var color: Color {
        switch self {
        case .normal: return .green
        case .heavy: return .yellow
        case .severe: return .orange
        case .massive: return .red
        }
    }
    
    var iconName: String {
        switch self {
        case .normal: return "figure.walk"
        case .heavy: return "figure.walk.motion"
        case .severe: return "figure.walk.arrival"
        case .massive: return "figure.walk.departure"
        }
    }
    
    var index: Int {
        switch self {
        case .normal: return 0
        case .heavy: return 1
        case .severe: return 2
        case .massive: return 3
        }
    }
}
