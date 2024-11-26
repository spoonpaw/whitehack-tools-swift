import Foundation

// MARK: - Deft Class Specific Types
struct Attunement: Codable, Identifiable {
    let id: UUID
    var name: String
    var isActive: Bool
    var type: AttunementType
    var isLost: Bool // If true, becomes a keyword giving +1 to related tasks
    
    init(id: UUID = UUID(), name: String = "", isActive: Bool = false, type: AttunementType = .item, isLost: Bool = false) {
        self.id = id
        self.name = name
        self.isActive = isActive
        self.type = type
        self.isLost = isLost
    }
}

enum AttunementType: String, Codable, CaseIterable {
    case teacher
    case item
    case vehicle
    case pet
    case place
}

struct AttunementSlot: Codable, Identifiable {
    let id: UUID
    var primaryAttunement: Attunement
    var secondaryAttunement: Attunement
    var tertiaryAttunement: Attunement
    var quaternaryAttunement: Attunement
    var hasTertiaryAttunement: Bool
    var hasQuaternaryAttunement: Bool
    var hasUsedDailyPower: Bool
    
    init(id: UUID = UUID(), 
         primaryAttunement: Attunement = Attunement(), 
         secondaryAttunement: Attunement = Attunement(), 
         tertiaryAttunement: Attunement = Attunement(),
         quaternaryAttunement: Attunement = Attunement(),
         hasTertiaryAttunement: Bool = false,
         hasQuaternaryAttunement: Bool = false,
         hasUsedDailyPower: Bool = false) {
        self.id = id
        self.primaryAttunement = primaryAttunement
        self.secondaryAttunement = secondaryAttunement
        self.tertiaryAttunement = tertiaryAttunement
        self.quaternaryAttunement = quaternaryAttunement
        self.hasTertiaryAttunement = hasTertiaryAttunement
        self.hasQuaternaryAttunement = hasQuaternaryAttunement
        self.hasUsedDailyPower = hasUsedDailyPower
    }
}

// MARK: - Strong Class Specific Types
enum StrongCombatOption: Int, Codable, CaseIterable, Identifiable {
    case protectAlly = 0
    case forceMovement
    case climbOpponents
    case specialAttacks
    case grantAdvantage
    case encourageFrighten
    case dualAttack
    case parryWait
    
    var id: Int { rawValue }
    
    var name: String {
        switch self {
        case .protectAlly: return "Protect Adjacent Ally"
        case .forceMovement: return "Force Movement"
        case .climbOpponents: return "Climb Big Opponents"
        case .specialAttacks: return "Special Attack Effects"
        case .grantAdvantage: return "Grant Double Advantage"
        case .encourageFrighten: return "Encourage/Frighten"
        case .dualAttack: return "Melee + Ranged Attack"
        case .parryWait: return "Parry and Wait"
        }
    }
    
    var description: String {
        switch self {
        case .protectAlly:
            return "Full round action: Protect an adjacent character by redirecting all attacks targeting them to yourself until your next turn. Each enemy gets a save against this effect."
            
        case .forceMovement:
            return "After a successful attack, you may forgo damage to force the opponent to move up to 10 feet from their current position. In melee, you may take their previous position as a free move. Target gets a save to resist. Note: This movement may trigger free attacks from other characters."
            
        case .climbOpponents:
            return "When fighting opponents larger than your species (e.g., a human vs a halfling), spend one action to climb them with an agility roll. If successful, gain double combat advantage (+4 to attack and damage) next round and subsequent rounds while holding on. Additional agility rolls may be required but don't cost actions."
            
        case .specialAttacks:
            return "On a successful attack, you may forgo normal damage to instead cause one of these effects: reduce enemy initiative by 2, reduce their movement by 10, or deal 2 points of ongoing damage per round. Must describe how the effect is achieved. Target may save to end movement/damage effects after 1+ rounds."
            
        case .grantAdvantage:
            return "Once per battle, grant an ally double combat advantage on a single attack (can be used immediately or saved for later in the fight). Requires a small verbal action like a tactical command or suggestion."
            
        case .encourageFrighten:
            return "With a small verbal action, either encourage allies or frighten enemies in a 15-foot radius. Encouragement: allies gain +1 to attack and saving throws. Frighten: enemies suffer -1 to attack and saving throws."
            
        case .dualAttack:
            return "By giving up your movement for the round, make both a melee and a ranged attack. Requires appropriate one-handed weapons (e.g., sword and throwing knife). Both attacks must use suitable one-handed weapons."
            
        case .parryWait:
            return "Instead of attacking, parry to gain +2 defense this round and double combat advantage against the parried enemy next round. Parrying two rounds in a row grants triple advantage. If you take damage while parrying, you must save or lose the effect."
        }
    }
}

struct StrongCombatOptions: Codable {
    private var slots: [StrongCombatOption?]
    
    init() {
        self.slots = Array(repeating: nil, count: 10) // Max level is 10
    }
    
    mutating func setOption(_ option: StrongCombatOption?, at slot: Int) {
        guard slot >= 0 && slot < slots.count else { return }
        slots[slot] = option
    }
    
    func getOption(at slot: Int) -> StrongCombatOption? {
        guard slot >= 0 && slot < slots.count else { return nil }
        return slots[slot]
    }
    
    func isActive(_ option: StrongCombatOption) -> Bool {
        slots.contains(option)
    }
    
    func isSlotFilled(at index: Int) -> Bool {
        guard index >= 0 && index < slots.count else { return false }
        return slots[index] != nil
    }
    
    var activeOptions: [StrongCombatOption] {
        slots.compactMap { $0 }
    }
    
    var count: Int {
        slots.compactMap { $0 }.count
    }
}

// MARK: - Conflict Loot Types
enum ConflictLootType: String, Codable, CaseIterable {
    case special
    case substance
    case supernatural
}

struct ConflictLoot: Codable {
    var keyword: String
    var type: ConflictLootType
    var usesRemaining: Int
    
    init(keyword: String = "", type: ConflictLootType = .special, usesRemaining: Int = 1) {
        self.keyword = keyword
        self.type = type
        self.usesRemaining = usesRemaining
    }
}

// MARK: - Wise Class Specific Types
struct WiseMiracle: Codable, Identifiable {
    let id: UUID
    var name: String
    var isActive: Bool
    var isAdditional: Bool  // Track whether this is an additional miracle
    
    init(id: UUID = UUID(), name: String = "", isActive: Bool = false, isAdditional: Bool = false) {
        self.id = id
        self.name = name
        self.isActive = isActive
        self.isAdditional = isAdditional
    }
}

struct WiseMiracleSlot: Codable, Identifiable {
    let id: UUID
    var baseMiracles: [WiseMiracle] // Array of base miracles in this slot
    var additionalMiracles: [WiseMiracle] // Array of additional miracles
    var isMagicItem: Bool // If true, this slot holds a magic item instead of miracles
    var magicItemName: String // Name of the magic item if isMagicItem is true
    var additionalMiracleCount: Int // Number of additional miracles (0-2 for first slot)
    
    init(id: UUID = UUID(), baseMiracles: [WiseMiracle] = [], additionalMiracles: [WiseMiracle] = [], isMagicItem: Bool = false, magicItemName: String = "", additionalMiracleCount: Int = 0) {
        self.id = id
        self.baseMiracles = baseMiracles
        self.additionalMiracles = additionalMiracles
        self.isMagicItem = isMagicItem
        self.magicItemName = magicItemName
        self.additionalMiracleCount = additionalMiracleCount
    }
}

// MARK: - Brave Class Specific Types
enum BraveQuirk: Int, Codable, CaseIterable, Identifiable {
    case doubleStrainRolls = 0
    case improvedHealing
    case protectAlly
    case resistCurses
    case drawAttention
    case fulfillRequirements
    case divineInvocation
    case improvisedWeapons
    
    var id: Int { rawValue }
    
    var name: String {
        switch self {
        case .doubleStrainRolls: return "Double Strain Rolls"
        case .improvedHealing: return "Improved Healing"
        case .protectAlly: return "Protect Ally"
        case .resistCurses: return "Resist Curses"
        case .drawAttention: return "Draw Attention"
        case .fulfillRequirements: return "Fulfill Requirements"
        case .divineInvocation: return "Divine Invocation"
        case .improvisedWeapons: return "Improvised Weapons"
        }
    }
    
    var description: String {
        switch self {
        case .doubleStrainRolls:
            return "Always make double positive strain rolls to move faster when encumbered."
        case .improvedHealing:
            return "Require no treatment to heal beyond 1 HP from negative value. Can use comeback dice for damage shrugged off on successful save."
        case .protectAlly:
            return "Choose a party member at session start. When protecting them, use one free comeback die for the roll."
        case .resistCurses:
            return "+4 saving throw vs. cursed objects and may use comeback dice to reduce cursed HP costs."
        case .drawAttention:
            return "Enemies choose to attack someone other than you first at the start of battle (if possible). Can be inverted when desired."
        case .fulfillRequirements:
            return "Once per session, your courage fulfills user requirements that an item, place, or passage may have in the form of class or groups."
        case .divineInvocation:
            return "Once per session, use a god's name to halt, scare, convince, bless, or curse your level number of listeners (none higher level than you, +1 for holy symbol/affiliation). Each target may save to avoid."
        case .improvisedWeapons:
            return "Improvised weapons do at least 1d6 damage, and actual weapons ignore target resistances (but not immunities)."
        }
    }
}

struct BraveQuirkSlot: Codable, Identifiable {
    let id: UUID
    var quirk: BraveQuirk?
    var protectedAllyName: String // Only used if quirk is .protectAlly
    
    init(id: UUID = UUID(), quirk: BraveQuirk? = nil, protectedAllyName: String = "") {
        self.id = id
        self.quirk = quirk
        self.protectedAllyName = protectedAllyName
    }
}

struct BraveQuirkOptions: Codable {
    private var slots: [BraveQuirkSlot]
    
    init() {
        self.slots = Array(repeating: BraveQuirkSlot(), count: 10) // Max level is 10
    }
    
    mutating func setQuirk(_ quirk: BraveQuirk?, at slot: Int) {
        guard slot >= 0 && slot < slots.count else { return }
        slots[slot].quirk = quirk
    }
    
    func getQuirk(at slot: Int) -> BraveQuirk? {
        guard slot >= 0 && slot < slots.count else { return nil }
        return slots[slot].quirk
    }
    
    func isActive(_ quirk: BraveQuirk) -> Bool {
        slots.contains { $0.quirk == quirk }
    }
    
    func isSlotFilled(at index: Int) -> Bool {
        guard index >= 0 && index < slots.count else { return false }
        return slots[index].quirk != nil
    }
    
    var activeQuirks: [BraveQuirk] {
        slots.compactMap { $0.quirk }
    }
    
    var count: Int {
        slots.compactMap { $0.quirk }.count
    }
    
    // Special handling for the Protect Ally quirk
    mutating func setProtectedAlly(_ name: String, at slot: Int) {
        guard slot >= 0 && slot < slots.count else { return }
        slots[slot].protectedAllyName = name
    }
    
    func getProtectedAlly(at slot: Int) -> String {
        guard slot >= 0 && slot < slots.count else { return "" }
        return slots[slot].protectedAllyName
    }
}

// MARK: - Clever Class Specific Types
enum CleverKnack: Int, Codable, CaseIterable, Identifiable {
    case combatExploiter = 0
    case efficientCrafter
    case weakenedSaves
    case navigationMaster
    case convincingNegotiator
    case escapeArtist
    case substanceExpert
    case machineMaster
    case trackingExpert
    
    var id: Int { rawValue }
    
    var name: String {
        switch self {
        case .combatExploiter: return "Combat Exploiter"
        case .efficientCrafter: return "Efficient Crafter"
        case .weakenedSaves: return "Weakened Saves"
        case .navigationMaster: return "Navigation Master"
        case .convincingNegotiator: return "Convincing Negotiator"
        case .escapeArtist: return "Escape Artist"
        case .substanceExpert: return "Substance Expert"
        case .machineMaster: return "Machine Master"
        case .trackingExpert: return "Tracking Expert"
        }
    }
    
    var description: String {
        switch self {
        case .combatExploiter:
            return "Base bonus for combat advantage is +3 instead of +2, and once per battle may switch d6 for d10 as damage die"
        case .efficientCrafter:
            return "+4 to crafting, mending, or assembly. Takes half the time and can skip one non-essential part"
        case .weakenedSaves:
            return "Targets of special attacks get -3 to their saves"
        case .navigationMaster:
            return "Can always figure out location roughly. Never gets lost"
        case .convincingNegotiator:
            return "+2 to task rolls and saves in conviction attempts, including trade"
        case .escapeArtist:
            return "+4 to any task roll related to escaping confinement or bypassing barriers"
        case .substanceExpert:
            return "+4 to substance identification and saves, +1 to quantified effects in character's favor"
        case .machineMaster:
            return "+4 to task rolls with or concerning machines"
        case .trackingExpert:
            return "+4 to tracking and covering own tracks"
        }
    }
}

struct CleverKnackSlot: Codable, Identifiable {
    let id: UUID
    var knack: CleverKnack?
    var hasUsedCombatDie: Bool // Only used if knack is .combatExploiter
    
    init(id: UUID = UUID(), knack: CleverKnack? = nil, hasUsedCombatDie: Bool = false) {
        self.id = id
        self.knack = knack
        self.hasUsedCombatDie = hasUsedCombatDie
    }
}

struct CleverKnackOptions: Codable {
    private(set) var slots: [CleverKnackSlot]
    var hasUsedUnorthodoxBonus: Bool
    
    init() {
        self.slots = []
        self.hasUsedUnorthodoxBonus = false
    }
    
    var activeKnacks: [CleverKnack] {
        slots.compactMap { $0.knack }
    }
    
    mutating func setKnack(_ knack: CleverKnack?, at index: Int) {
        while slots.count <= index {
            slots.append(CleverKnackSlot())
        }
        slots[index].knack = knack
    }
    
    func getKnack(at index: Int) -> CleverKnack? {
        guard index < slots.count else { return nil }
        return slots[index].knack
    }
    
    mutating func resetDailyPowers() {
        hasUsedUnorthodoxBonus = false
        for i in 0..<slots.count {
            slots[i].hasUsedCombatDie = false
        }
    }
    
    mutating func setHasUsedCombatDie(_ value: Bool, at index: Int) {
        guard index < slots.count else { return }
        slots[index].hasUsedCombatDie = value
    }
}

// MARK: - Fortunate Class Specific Types
struct SignatureObject: Codable {
    var name: String
}

struct Retainer: Codable, Identifiable {
    let id: UUID
    var name: String
    var type: String
    var hitDice: Int
    var defenseFactor: Int
    var movement: Int
    var keywords: [String]
    var attitude: String
    var notes: String
    var currentHP: Int
    var maxHP: Int
    
    init(id: UUID = UUID(), name: String = "", type: String = "", hitDice: Int = 1, defenseFactor: Int = 0, movement: Int = 30, keywords: [String] = [], attitude: String = "", notes: String = "", currentHP: Int = 1, maxHP: Int = 1) {
        self.id = id
        self.name = name
        self.type = type
        self.hitDice = hitDice
        self.defenseFactor = defenseFactor
        self.movement = movement
        self.keywords = keywords
        self.attitude = attitude
        self.notes = notes
        self.currentHP = currentHP
        self.maxHP = maxHP
    }
}

struct FortunateOptions: Codable {
    var standing: String  // The defining standing (e.g., "Reincarnated Master")
    var hasUsedFortune: Bool  // Once per game session fortune usage
    var retainers: [Retainer]
    var signatureObject: SignatureObject
    var newKeyword: String  // For temporary storage during keyword input
    
    init() {
        self.standing = ""
        self.hasUsedFortune = false
        self.retainers = []
        self.signatureObject = SignatureObject(name: "")
        self.newKeyword = ""
    }
}

// MARK: - Weapon Types
struct Weapon: Codable, Identifiable {
    var id: String { name }  // Using name as id since weapons are unique by name
    var name: String
    var damage: String
    var weight: String
    var rateOfFire: String
    var special: String
    
    init(name: String = "", damage: String = "", weight: String = "", rateOfFire: String = "", special: String = "") {
        self.name = name
        self.damage = damage
        self.weight = weight
        self.rateOfFire = rateOfFire
        self.special = special
    }
    
    static func fromData(_ data: [String: String]) -> Weapon {
        Weapon(
            name: data["name"] ?? "",
            damage: data["damage"] ?? "",
            weight: data["weight"] ?? "",
            rateOfFire: data["rateOfFire"] ?? "",
            special: data["special"] ?? ""
        )
    }
}

// MARK: - Armor Types
struct Armor: Codable, Identifiable {
    let id: UUID
    var name: String
    var defenseValue: Int
    var cost: Int
    var isMagical: Bool
    var magicalBonus: Int
}

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
    
    // Deft Class Specific Properties
    var attunementSlots: [AttunementSlot]
    
    // Strong Class Specific Properties
    var currentConflictLoot: ConflictLoot?
    var strongCombatOptions: StrongCombatOptions
    
    // Wise Class Specific Properties
    var wiseMiracleSlots: [WiseMiracleSlot]
    
    // Brave Class Specific Properties
    var braveQuirkOptions: BraveQuirkOptions
    var comebackDice: Int
    var hasUsedSayNo: Bool
    
    // Clever Class Specific Properties
    var cleverKnackOptions: CleverKnackOptions
    
    // Fortunate Class Specific Properties
    var fortunateOptions: FortunateOptions
    
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
    var weapons: [Weapon]
    var armor: [Armor]
    
    var totalDefenseValue: Int {
        let baseDF = armor.reduce(0) { total, armor in
            total + armor.defenseValue + (armor.isMagical ? armor.magicalBonus : 0)
        }
        return baseDF
    }
    
    // MARK: - Deft Attunement Methods
    
    /// Tracks if the daily attunement power has been used
    var hasUsedAttunementToday: Bool = false
    
    /// Switches the active state between primary and secondary attunements in a slot
    /// - Parameter slotIndex: The index of the slot to switch
    /// - Returns: True if the switch was successful, false if the slot doesn't exist
    func switchAttunements(inSlot slotIndex: Int) -> Bool {
        guard slotIndex < attunementSlots.count else { return false }
        
        // Swap active states
        attunementSlots[slotIndex].primaryAttunement.isActive.toggle()
        attunementSlots[slotIndex].secondaryAttunement.isActive.toggle()
        
        return true
    }
    
    /// Get the number of available attunement slots based on character level
    var availableAttunementSlots: Int {
        let stats = AdvancementTables.shared.stats(for: characterClass, at: level)
        return stats.slots
    }
    
    /// Checks if the character can use attunements (based on armor restrictions)
    var canUseAttunements: Bool {
        // TODO: Add armor check logic when equipment system is implemented
        return true
    }
    
    // MARK: - Strong Combat Methods

    /// Tracks if the character has any flow attacks remaining
    var remainingFlowAttacks: Int {
        guard characterClass == .strong else { return 0 }
        return level + 1 // raises + 1
    }

    /// Available combat options based on level
    var availableCombatOptions: [StrongCombatOption] {
        StrongCombatOption.allCases.filter { $0.rawValue <= level }
    }

    // MARK: - Brave Class Specific Methods
    var availableQuirkSlots: Int {
        guard characterClass == .brave else { return 0 }
        let stats = AdvancementTables.shared.stats(for: characterClass, at: level)
        return stats.slots
    }

    var hasArmorPenalty: Bool {
        // TODO: Add armor check logic when equipment system is implemented
        // Returns true if wearing armor heavier than cloth
        return false
    }

    var attributePenalty: Int {
        guard characterClass == .brave && hasArmorPenalty else { return 0 }
        return 2
    }
    
    // MARK: - Initializer
    init(
        id: UUID = UUID(),
        name: String = "",
        characterClass: CharacterClass = .deft,
        level: Int = 1,
        strength: Int = 10,
        agility: Int = 10,
        toughness: Int = 10,
        intelligence: Int = 10,
        willpower: Int = 10,
        charisma: Int = 10,
        currentHP: Int = 1,
        maxHP: Int = 1,
        _attackValue: Int = 10, // Initialize with default value for backward compatibility
        defenseValue: Int = 0,
        movement: Int = 30,
        _saveValue: Int = 7, // Initialize with default value for backward compatibility
        saveColor: String = "",
        speciesGroup: String? = nil,
        vocationGroup: String? = nil,
        affiliationGroups: [String] = [],
        attributeGroupPairs: [AttributeGroupPair] = [], // Initialize as empty
        attunementSlots: [AttunementSlot] = [], // Initialize as empty
        currentConflictLoot: ConflictLoot? = nil,
        strongCombatOptions: StrongCombatOptions = StrongCombatOptions(), // Initialize as empty
        wiseMiracleSlots: [WiseMiracleSlot] = [], // Initialize as empty
        braveQuirkOptions: BraveQuirkOptions = BraveQuirkOptions(), // Initialize as empty
        cleverKnackOptions: CleverKnackOptions = CleverKnackOptions(), // Initialize as empty
        fortunateOptions: FortunateOptions = FortunateOptions(), // Initialize as empty
        comebackDice: Int = 0,
        hasUsedSayNo: Bool = false,
        languages: [String] = ["Common"],
        notes: String = "",
        experience: Int = 0,
        corruption: Int = 0,
        inventory: [String] = [],
        currentEncumbrance: Int = 0,
        maxEncumbrance: Int = 15,
        coins: Int = 0,
        weapons: [Weapon] = [],
        armor: [Armor] = [],
        hasUsedAttunementToday: Bool = false) {
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
        self.attunementSlots = attunementSlots
        self.currentConflictLoot = currentConflictLoot
        self.strongCombatOptions = strongCombatOptions
        self.wiseMiracleSlots = wiseMiracleSlots
        self.braveQuirkOptions = braveQuirkOptions
        self.cleverKnackOptions = cleverKnackOptions
        self.fortunateOptions = fortunateOptions
        self.comebackDice = comebackDice
        self.hasUsedSayNo = hasUsedSayNo
        self.languages = languages
        self.notes = notes
        self.experience = experience
        self.corruption = corruption
        self.inventory = inventory
        self.currentEncumbrance = currentEncumbrance
        self.maxEncumbrance = maxEncumbrance
        self.coins = coins
        self.weapons = weapons
        self.armor = armor
        self.hasUsedAttunementToday = hasUsedAttunementToday
    }
}

// MARK: - ID Regeneration Extension
extension PlayerCharacter {
    /// Creates a copy of the character with new UUIDs while maintaining relationships
    func copyWithNewIDs() -> PlayerCharacter {
        // Create a copy of the character with a new ID
        let newCharacter = PlayerCharacter(
            id: UUID(),
            name: name,
            characterClass: characterClass,
            level: level,
            strength: strength,
            agility: agility,
            toughness: toughness,
            intelligence: intelligence,
            willpower: willpower,
            charisma: charisma,
            currentHP: currentHP,
            maxHP: maxHP,
            _attackValue: _attackValue,
            defenseValue: defenseValue,
            movement: movement,
            _saveValue: _saveValue,
            saveColor: saveColor,
            speciesGroup: speciesGroup,
            vocationGroup: vocationGroup,
            affiliationGroups: affiliationGroups,
            corruption: corruption,
            inventory: inventory,
            currentEncumbrance: currentEncumbrance,
            maxEncumbrance: maxEncumbrance,
            coins: coins
        )
        
        // Copy attribute group pairs with new IDs
        newCharacter.attributeGroupPairs = attributeGroupPairs.map { pair in
            AttributeGroupPair(
                id: UUID(),
                attribute: pair.attribute,
                group: pair.group
            )
        }
        
        // Copy attunement slots with new IDs
        newCharacter.attunementSlots = attunementSlots.map { slot in
            AttunementSlot(
                id: UUID(),
                primaryAttunement: Attunement(
                    id: UUID(),
                    name: slot.primaryAttunement.name,
                    isActive: slot.primaryAttunement.isActive,
                    type: slot.primaryAttunement.type,
                    isLost: slot.primaryAttunement.isLost
                ),
                secondaryAttunement: Attunement(
                    id: UUID(),
                    name: slot.secondaryAttunement.name,
                    isActive: slot.secondaryAttunement.isActive,
                    type: slot.secondaryAttunement.type,
                    isLost: slot.secondaryAttunement.isLost
                ),
                tertiaryAttunement: Attunement(
                    id: UUID(),
                    name: slot.tertiaryAttunement.name,
                    isActive: slot.tertiaryAttunement.isActive,
                    type: slot.tertiaryAttunement.type,
                    isLost: slot.tertiaryAttunement.isLost
                ),
                quaternaryAttunement: Attunement(
                    id: UUID(),
                    name: slot.quaternaryAttunement.name,
                    isActive: slot.quaternaryAttunement.isActive,
                    type: slot.quaternaryAttunement.type,
                    isLost: slot.quaternaryAttunement.isLost
                ),
                hasTertiaryAttunement: slot.hasTertiaryAttunement,
                hasQuaternaryAttunement: slot.hasQuaternaryAttunement,
                hasUsedDailyPower: slot.hasUsedDailyPower
            )
        }
        
        // Copy wise miracle slots with new IDs
        newCharacter.wiseMiracleSlots = wiseMiracleSlots.map { slot in
            WiseMiracleSlot(
                id: UUID(),
                baseMiracles: slot.baseMiracles.map { miracle in
                    WiseMiracle(
                        id: UUID(),
                        name: miracle.name,
                        isActive: miracle.isActive,
                        isAdditional: miracle.isAdditional
                    )
                },
                additionalMiracles: slot.additionalMiracles.map { miracle in
                    WiseMiracle(
                        id: UUID(),
                        name: miracle.name,
                        isActive: miracle.isActive,
                        isAdditional: miracle.isAdditional
                    )
                },
                isMagicItem: slot.isMagicItem,
                magicItemName: slot.magicItemName,
                additionalMiracleCount: slot.additionalMiracleCount
            )
        }
        
        // Copy brave quirk options
        var newBraveQuirkOptions = BraveQuirkOptions()
        for i in 0..<10 {
            if let quirk = braveQuirkOptions.getQuirk(at: i) {
                newBraveQuirkOptions.setQuirk(quirk, at: i)
                newBraveQuirkOptions.setProtectedAlly(braveQuirkOptions.getProtectedAlly(at: i), at: i)
            }
        }
        newCharacter.braveQuirkOptions = newBraveQuirkOptions
        
        // Copy clever knack options
        var newCleverKnackOptions = CleverKnackOptions()
        newCleverKnackOptions.hasUsedUnorthodoxBonus = cleverKnackOptions.hasUsedUnorthodoxBonus
        for i in 0..<cleverKnackOptions.slots.count {
            if let knack = cleverKnackOptions.getKnack(at: i) {
                newCleverKnackOptions.setKnack(knack, at: i)
            }
        }
        newCharacter.cleverKnackOptions = newCleverKnackOptions
        
        // Copy fortunate options
        var newFortunateOptions = FortunateOptions()
        newFortunateOptions.standing = fortunateOptions.standing
        newFortunateOptions.hasUsedFortune = fortunateOptions.hasUsedFortune
        newFortunateOptions.signatureObject = fortunateOptions.signatureObject
        newFortunateOptions.newKeyword = fortunateOptions.newKeyword
        newFortunateOptions.retainers = fortunateOptions.retainers.map { retainer in
            Retainer(
                id: UUID(),
                name: retainer.name,
                type: retainer.type,
                hitDice: retainer.hitDice,
                defenseFactor: retainer.defenseFactor,
                movement: retainer.movement,
                keywords: retainer.keywords,
                attitude: retainer.attitude,
                notes: retainer.notes,
                currentHP: retainer.currentHP,
                maxHP: retainer.maxHP
            )
        }
        newCharacter.fortunateOptions = newFortunateOptions
        
        // Copy other properties
        newCharacter.languages = languages
        newCharacter.notes = notes
        newCharacter.experience = experience
        newCharacter.hasUsedAttunementToday = hasUsedAttunementToday
        newCharacter.hasUsedSayNo = hasUsedSayNo
        newCharacter.comebackDice = comebackDice
        
        return newCharacter
    }
}
