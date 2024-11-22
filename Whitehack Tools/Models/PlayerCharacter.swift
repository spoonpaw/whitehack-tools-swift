import Foundation

class PlayerCharacter: Identifiable, Codable {
    // MARK: - Properties
    let id: UUID
    var name: String
    var characterClass: CharacterClass
    var level: Int
    
    // Attributes
    var strength: Int
    var agility: Int
    var toughness: Int
    var intelligence: Int
    var willpower: Int
    var charisma: Int
    
    // Combat Stats
    var currentHP: Int
    var maxHP: Int
    var attackValue: Int
    var defenseValue: Int
    var movement: Int
    var saveValue: Int
    var saveColor: String
    
    // Groups
    var speciesGroup: String? // "Human" or custom
    var vocationGroup: String? // Custom
    var affiliationGroups: [String]
    
    // New Property for Attribute-Group Pairs
    var attributeGroupPairs: [AttributeGroupPair]
    
    // Other
    var languages: [String]
    var notes: String
    var experience: Int
    var corruption: Int
    
    // Equipment Tracking
    var inventory: [String]
    var currentEncumbrance: Int
    var maxEncumbrance: Int
    var coins: Int
    
    // MARK: - Initializer
    init(id: UUID = UUID(),
         name: String = "",
         characterClass: CharacterClass = .deft,
         level: Int = 1,
         strength: Int = 10,
         agility: Int = 10,
         toughness: Int = 10,
         intelligence: Int = 10,
         willpower: Int = 10,
         charisma: Int = 10,
         currentHP: Int = 0,
         maxHP: Int = 0,
         attackValue: Int = 10,
         defenseValue: Int = 0,
         movement: Int = 30,
         saveValue: Int = 7,
         saveColor: String = "",
         speciesGroup: String? = nil,
         vocationGroup: String? = nil,
         affiliationGroups: [String] = [],
         attributeGroupPairs: [AttributeGroupPair] = [], // Initialize as empty
         languages: [String] = ["Common"],
         notes: String = "",
         experience: Int = 0,
         corruption: Int = 0,
         inventory: [String] = [],
         currentEncumbrance: Int = 0,
         maxEncumbrance: Int = 15,
         coins: Int = 0) {
        self.id = id
        self.name = name
        self.characterClass = characterClass
        self.level = level
        self.strength = strength
        self.agility = agility
        self.toughness = toughness
        self.intelligence = intelligence
        self.willpower = willpower
        self.charisma = charisma
        self.currentHP = currentHP
        self.maxHP = maxHP
        self.attackValue = attackValue
        self.defenseValue = defenseValue
        self.movement = movement
        self.saveValue = saveValue
        self.saveColor = saveColor
        self.speciesGroup = speciesGroup
        self.vocationGroup = vocationGroup
        self.affiliationGroups = affiliationGroups
        self.attributeGroupPairs = attributeGroupPairs
        self.languages = languages
        self.notes = notes
        self.experience = experience
        self.corruption = corruption
        self.inventory = inventory
        self.currentEncumbrance = currentEncumbrance
        self.maxEncumbrance = maxEncumbrance
        self.coins = coins
    }
}
