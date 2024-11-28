import Foundation

struct ArmorData {
    struct ArmorItem: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let df: Int
        let weight: Int
        let special: String
        let isShield: Bool
    }
    
    // Weight categories in pounds
    static let WEIGHT_MINOR = 1
    static let WEIGHT_LIGHT = 2
    static let WEIGHT_HEAVY = 4
    
    static let armors: [ArmorItem] = [
        ArmorItem(name: "Shields", df: 1, weight: WEIGHT_MINOR, special: "", isShield: true),
        ArmorItem(name: "Cloth", df: 1, weight: WEIGHT_MINOR, special: "", isShield: false),
        ArmorItem(name: "Leather", df: 2, weight: WEIGHT_MINOR, special: "", isShield: false),
        ArmorItem(name: "Hard leather", df: 3, weight: WEIGHT_LIGHT, special: "", isShield: false),
        ArmorItem(name: "Chainmail", df: 4, weight: WEIGHT_HEAVY, special: "", isShield: false),
        ArmorItem(name: "Splint mail", df: 5, weight: WEIGHT_HEAVY, special: "", isShield: false),
        ArmorItem(name: "Full plate", df: 6, weight: WEIGHT_HEAVY, special: "", isShield: false)
    ]
    
    static func getWeight(_ df: Int) -> Int {
        switch df {
        case 1, 2:
            return WEIGHT_MINOR
        case 3:
            return WEIGHT_LIGHT
        case 4, 5, 6:
            return WEIGHT_HEAVY
        default:
            return WEIGHT_MINOR
        }
    }
}
