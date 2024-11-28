import Foundation

struct GearData {
    struct GearItem: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let weight: String
        let special: String
    }
    
    static let gear: [GearItem] = [
        GearItem(name: "Arrow", weight: "No size", special: ""),
        GearItem(name: "Bandage", weight: "No size", special: ""),
        GearItem(name: "Blessed/Cursed water", weight: "Minor", special: ""),
        GearItem(name: "Bolt", weight: "No size", special: ""),
        GearItem(name: "Boot", weight: "Minor", special: ""),
        GearItem(name: "Bottle (wine or beer)", weight: "Minor", special: ""),
        GearItem(name: "Carpeting tool", weight: "Minor", special: ""),
        GearItem(name: "Checker (game)", weight: "No size", special: ""),
        GearItem(name: "Climbing gear", weight: "Regular", special: ""),
        GearItem(name: "Cloth (standard)", weight: "Minor", special: ""),
        GearItem(name: "Cloth (fine)", weight: "Minor", special: ""),
        GearItem(name: "Compass", weight: "No size", special: ""),
        GearItem(name: "Cult token (fine)", weight: "No size", special: ""),
        GearItem(name: "Cult token (simple)", weight: "No size", special: ""),
        GearItem(name: "Dice (bone)", weight: "No size", special: ""),
        GearItem(name: "Dog", weight: "Heavy", special: ""),
        GearItem(name: "Flatboat", weight: "Heavy", special: ""),
        GearItem(name: "Grapnel", weight: "Regular", special: ""),
        GearItem(name: "Hatchet", weight: "Minor", special: ""),
        GearItem(name: "Knapsack", weight: "Minor", special: ""),
        GearItem(name: "Lab (portable)", weight: "Heavy", special: ""),
        GearItem(name: "Lamp", weight: "Minor", special: ""),
        GearItem(name: "Lamp oil", weight: "Minor", special: ""),
        GearItem(name: "Lockpick", weight: "No size", special: ""),
        GearItem(name: "Makeup", weight: "No size", special: ""),
        GearItem(name: "Map (regular area)", weight: "No size", special: ""),
        GearItem(name: "Match", weight: "No size", special: ""),
        GearItem(name: "Mirror (glass)", weight: "Minor", special: ""),
        GearItem(name: "Parchment tube", weight: "Minor", special: ""),
        GearItem(name: "Perfume", weight: "Minor", special: ""),
        GearItem(name: "Prybar", weight: "Minor", special: ""),
        GearItem(name: "Quiver", weight: "Minor", special: ""),
        GearItem(name: "Ration (day)", weight: "Minor", special: ""),
        GearItem(name: "Rope, elven", weight: "Minor", special: ""),
        GearItem(name: "Rope, regular", weight: "Regular", special: ""),
        GearItem(name: "Sack", weight: "Minor", special: ""),
        GearItem(name: "Scroll (blank)", weight: "No size", special: ""),
        GearItem(name: "Shevvak", weight: "Regular", special: ""),
        GearItem(name: "Skiing gear", weight: "Regular", special: ""),
        GearItem(name: "Sled", weight: "Heavy", special: ""),
        GearItem(name: "Sleeping bag", weight: "Regular", special: ""),
        GearItem(name: "Snare", weight: "Minor", special: ""),
        GearItem(name: "Snow Monkey", weight: "Heavy", special: ""),
        GearItem(name: "Spell book (blank)", weight: "Regular", special: ""),
        GearItem(name: "Stick (long)", weight: "Regular", special: ""),
        GearItem(name: "Tent", weight: "Heavy", special: ""),
        GearItem(name: "Tinderbox", weight: "Minor", special: ""),
        GearItem(name: "Torch", weight: "Minor", special: ""),
        GearItem(name: "Warm coat", weight: "Regular", special: ""),
        GearItem(name: "Water container", weight: "Minor", special: ""),
        GearItem(name: "Zoruk (battle)", weight: "Heavy", special: ""),
        GearItem(name: "Zoruk (riding)", weight: "Heavy", special: "")
    ]
}
