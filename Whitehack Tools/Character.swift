import Foundation

struct Character: Identifiable, Codable {
    let id: UUID
    var name: String
    var characterClass: String
    var level: Int
    var hitPoints: Int
    var notes: String
    
    init(id: UUID = UUID(), name: String = "", characterClass: String = "", level: Int = 1, hitPoints: Int = 0, notes: String = "") {
        self.id = id
        self.name = name
        self.characterClass = characterClass
        self.level = level
        self.hitPoints = hitPoints
        self.notes = notes
    }
}
