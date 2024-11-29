import Foundation

struct GearData {
    struct GearItem: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let weight: String
        let special: String
        let isContainer: Bool
    }
    
    static let gear: [GearItem] = [
        GearItem(name: "Arrow", weight: "No size", special: "", isContainer: false),
        GearItem(name: "Bandage", weight: "No size", special: "", isContainer: false),
        GearItem(name: "Blessed/Cursed water", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Bolt", weight: "No size", special: "", isContainer: false),
        GearItem(name: "Boot", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Bottle (wine or beer)", weight: "Minor", special: "", isContainer: true),
        GearItem(name: "Carpeting tool", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Checker (game)", weight: "No size", special: "", isContainer: false),
        GearItem(name: "Climbing gear", weight: "Regular", special: "", isContainer: false),
        GearItem(name: "Cloth (standard)", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Cloth (fine)", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Compass", weight: "No size", special: "", isContainer: false),
        GearItem(name: "Cult token (fine)", weight: "No size", special: "", isContainer: false),
        GearItem(name: "Cult token (simple)", weight: "No size", special: "", isContainer: false),
        GearItem(name: "Dice (bone)", weight: "No size", special: "", isContainer: false),
        GearItem(name: "Dog", weight: "Heavy", special: "", isContainer: false),
        GearItem(name: "Flatboat", weight: "Heavy", special: "", isContainer: false),
        GearItem(name: "Grapnel", weight: "Regular", special: "", isContainer: false),
        GearItem(name: "Hatchet", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Knapsack", weight: "Minor", special: "", isContainer: true),
        GearItem(name: "Lab (portable)", weight: "Heavy", special: "", isContainer: false),
        GearItem(name: "Lamp", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Lamp oil", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Lockpick", weight: "No size", special: "", isContainer: false),
        GearItem(name: "Makeup", weight: "No size", special: "", isContainer: false),
        GearItem(name: "Map (regular area)", weight: "No size", special: "", isContainer: false),
        GearItem(name: "Match", weight: "No size", special: "", isContainer: false),
        GearItem(name: "Mirror (glass)", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Parchment tube", weight: "Minor", special: "", isContainer: true),
        GearItem(name: "Perfume", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Prybar", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Quiver", weight: "Minor", special: "", isContainer: true),
        GearItem(name: "Ration (day)", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Rope, elven", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Rope, regular", weight: "Regular", special: "", isContainer: false),
        GearItem(name: "Sack", weight: "Minor", special: "", isContainer: true),
        GearItem(name: "Scroll (blank)", weight: "No size", special: "", isContainer: false),
        GearItem(name: "Shevvak", weight: "Regular", special: "", isContainer: false),
        GearItem(name: "Skiing gear", weight: "Regular", special: "", isContainer: false),
        GearItem(name: "Sled", weight: "Heavy", special: "", isContainer: false),
        GearItem(name: "Sleeping bag", weight: "Regular", special: "", isContainer: false),
        GearItem(name: "Snare", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Snow Monkey", weight: "Heavy", special: "", isContainer: false),
        GearItem(name: "Spell book (blank)", weight: "Regular", special: "", isContainer: false),
        GearItem(name: "Stick (long)", weight: "Regular", special: "", isContainer: false),
        GearItem(name: "Tent", weight: "Heavy", special: "", isContainer: false),
        GearItem(name: "Tinderbox", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Torch", weight: "Minor", special: "", isContainer: false),
        GearItem(name: "Warm coat", weight: "Regular", special: "", isContainer: false),
        GearItem(name: "Water container", weight: "Minor", special: "", isContainer: true),
        GearItem(name: "Zoruk (battle)", weight: "Heavy", special: "", isContainer: false),
        GearItem(name: "Zoruk (riding)", weight: "Heavy", special: "", isContainer: false)
    ]
}
