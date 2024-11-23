import Foundation

class PlayerCharacter: Identifiable, Codable {
    // MARK: - Properties
    let id: UUID
    var name: String
    var characterClass: CharacterClass
    var level: Int {
        didSet {
            // Ensure level is always between 1 and 10
            if level < 1 {
                level = 1
            } else if level > 10 {
                level = 10
            }
        }
    }
    
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
    private(set) var _attackValue: Int // Stored property for backward compatibility
    var attackValue: Int { // Computed property
        get {
            let stats = AdvancementTables.shared.stats(for: characterClass, at: level)
            return stats.attackValue
        }
        set {
            _attackValue = newValue // For backward compatibility
        }
    }
    var defenseValue: Int
    var movement: Int
    private(set) var _saveValue: Int // Stored property for backward compatibility
    var saveValue: Int { // Computed property
        get {
            let stats = AdvancementTables.shared.stats(for: characterClass, at: level)
            return stats.savingValue
        }
        set {
            _saveValue = newValue // For backward compatibility
        }
    }
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
    
    // Computed XP properties
    var xpForNextLevel: Int {
        // If at max level, return 0
        guard level < 10 else { return 0 }
        return AdvancementTables.shared.xpRequirement(for: characterClass, at: level + 1)
    }
    
    var xpProgress: Double {
        guard xpForNextLevel > 0 else { return 1.0 } // At max level
        
        // Get XP required for current level
        let currentLevelXP = level > 1 ? AdvancementTables.shared.xpRequirement(for: characterClass, at: level) : 0
        
        // Calculate progress between current level and next level
        let progressXP = Double(experience - currentLevelXP)
        let neededXP = Double(xpForNextLevel - currentLevelXP)
        return min(progressXP / neededXP, 1.0)
    }
    
    var canLevelUp: Bool {
        guard level < 10 else { return false }
        return experience >= xpForNextLevel
    }
    
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
         _attackValue: Int = 10, // Initialize with default value for backward compatibility
         defenseValue: Int = 0,
         movement: Int = 30,
         _saveValue: Int = 7, // Initialize with default value for backward compatibility
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
        self._attackValue = _attackValue
        self.defenseValue = defenseValue
        self.movement = movement
        self._saveValue = _saveValue
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
