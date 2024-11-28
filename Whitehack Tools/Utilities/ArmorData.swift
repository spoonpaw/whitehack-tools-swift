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
    
    static let armors: [ArmorItem] = [
        ArmorItem(name: "Shield", df: 1, weight: 1, special: "", isShield: true),
        ArmorItem(name: "Cloth", df: 1, weight: 1, special: "", isShield: false),
        ArmorItem(name: "Leather", df: 2, weight: 2, special: "", isShield: false),
        ArmorItem(name: "Hard leather", df: 3, weight: 3, special: "", isShield: false),
        ArmorItem(name: "Chainmail", df: 4, weight: 4, special: "", isShield: false),
        ArmorItem(name: "Splint mail", df: 5, weight: 5, special: "", isShield: false),
        ArmorItem(name: "Full plate", df: 6, weight: 6, special: "", isShield: false)
    ]
}
