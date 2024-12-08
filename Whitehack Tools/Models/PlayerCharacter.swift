import Foundation
import SwiftUICore
import PhosphorSwift

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
    
    mutating func removeKnack(at index: Int) {
        guard index < slots.count else { return }
        slots[index].knack = nil
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
    
    func isKnackUsed(at index: Int) -> Bool {
        guard index < slots.count else { return false }
        return slots[index].hasUsedCombatDie
    }
    
    mutating func setKnackUsed(at index: Int, to value: Bool) {
        guard index < slots.count else { return }
        slots[index].hasUsedCombatDie = value
    }
}

// MARK: - Fortunate Class Specific Types
struct SignatureObject: Codable {
    var name: String
}

struct Gear: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var weight: String
    var special: String
    var quantity: Int
    var isEquipped: Bool
    var isStashed: Bool
    var isMagical: Bool
    var isCursed: Bool
    var isContainer: Bool
    
    init(id: UUID = UUID(), 
         name: String = "", 
         weight: String = "Minor",
         special: String = "",
         quantity: Int = 1,
         isEquipped: Bool = false,
         isStashed: Bool = false,
         isMagical: Bool = false,
         isCursed: Bool = false,
         isContainer: Bool = false) {
        self.id = id
        self.name = name
        self.weight = weight
        self.special = special
        self.quantity = quantity
        self.isEquipped = isEquipped
        self.isStashed = isStashed
        self.isMagical = isMagical
        self.isCursed = isCursed
        self.isContainer = isContainer
    }
    
    static func == (lhs: Gear, rhs: Gear) -> Bool {
        lhs.id == rhs.id
    }
}

struct Armor: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var df: Int      // Defense Factor (for shields this is the bonus)
    var weight: Int  // Weight in slots
    var special: String
    var quantity: Int
    var isEquipped: Bool
    var isStashed: Bool
    var isMagical: Bool
    var isCursed: Bool
    var bonus: Int   // Magical bonus/penalty
    var isShield: Bool // Whether this is a shield (modifies defense) or armor (sets base defense)
    
    static func == (lhs: Armor, rhs: Armor) -> Bool {
        lhs.id == rhs.id
    }
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
    
    init(standing: String = "", hasUsedFortune: Bool = false, retainers: [Retainer] = [], signatureObject: SignatureObject = SignatureObject(name: ""), newKeyword: String = "") {
        self.standing = standing
        self.hasUsedFortune = hasUsedFortune
        self.retainers = retainers
        self.signatureObject = signatureObject
        self.newKeyword = newKeyword
    }
}

// MARK: - Types
import PhosphorSwift

enum CustomAttributeIcon: String, Codable, CaseIterable {
    case barbell      // Strength - Classic physical power
    case personSimpleRun  // Agility/Speed - Movement ability
    case heart       // Health/Vitality - Life force
    case brain       // Intelligence - Mental capacity
    case eye         // Perception - Awareness
    case crown       // Leadership - Authority
    case sword       // Combat/Attack - Offensive skill
    case shield      // Defense - Protection
    case lightning   // Speed/Reflexes - Quick action
    case flame       // Power/Energy - Raw force
    case moon        // Mystery - Arcane power
    case scroll      // Knowledge - Learning
    case magicWand   // Magic - Spellcasting
    case target      // Accuracy - Precision
    case arrowsOutCardinal  // Movement - Positioning
    case sparkle     // Special - Unique powers
    case shieldStar  // Divine - Holy power
    case skull       // Death - Dark power
    case crosshair   // Focus - Concentration
    case scales      // Balance - Equilibrium
    case spiral      // Chaos - Transformation/Change
    case infinity    // Eternal - Transcendence/Limitless
    case waves       // Flow - Adaptation/Flexibility
    case hourglass   // Time - Duration/Patience
    case drop        // Poison/Toxin - Resistance to corruption
    case wind        // Breath - Elemental resistance
    case handFist    // Petrification - Physical transformation
    case bandage     // Disease - Health/Recovery
    case star        // Celestial - Reality/cosmic power
    case atom        // Energy - Fundamental forces
    case compass     // Destiny - Fate/direction manipulation
    case clover      // Luck - Fortune/chance
    
    var iconView: AnyView {
        switch self {
        case .barbell: return AnyView(Ph.barbell.bold)
        case .personSimpleRun: return AnyView(Ph.personSimpleRun.bold)
        case .heart: return AnyView(Ph.heart.bold)
        case .brain: return AnyView(Ph.brain.bold)
        case .eye: return AnyView(Ph.eye.bold)
        case .crown: return AnyView(Ph.crown.bold)
        case .sword: return AnyView(Ph.sword.bold)
        case .shield: return AnyView(Ph.shield.bold)
        case .lightning: return AnyView(Ph.lightning.bold)
        case .flame: return AnyView(Ph.flame.bold)
        case .moon: return AnyView(Ph.moon.bold)
        case .scroll: return AnyView(Ph.scroll.bold)
        case .magicWand: return AnyView(Ph.magicWand.bold)
        case .target: return AnyView(Ph.target.bold)
        case .arrowsOutCardinal: return AnyView(Ph.arrowsOutCardinal.bold)
        case .sparkle: return AnyView(Ph.sparkle.bold)
        case .shieldStar: return AnyView(Ph.shieldStar.bold)
        case .skull: return AnyView(Ph.skull.bold)
        case .crosshair: return AnyView(Ph.crosshair.bold)
        case .scales: return AnyView(Ph.scales.bold)
        case .spiral: return AnyView(Ph.spiral.bold)
        case .infinity: return AnyView(Ph.infinity.bold)
        case .waves: return AnyView(Ph.waves.bold)
        case .hourglass: return AnyView(Ph.hourglass.bold)
        case .drop: return AnyView(Ph.drop.bold)
        case .wind: return AnyView(Ph.wind.bold)
        case .handFist: return AnyView(Ph.handFist.bold)
        case .bandage: return AnyView(Ph.bandaids.bold)
        case .star: return AnyView(Ph.star.bold)
        case .atom: return AnyView(Ph.atom.bold)
        case .compass: return AnyView(Ph.compass.bold)
        case .clover: return AnyView(Ph.clover.bold)
        }
    }
    
    var icon: Image {
        switch self {
        case .barbell: return Image(systemName: "barbell")
        case .personSimpleRun: return Image(systemName: "person.run")
        case .heart: return Image(systemName: "heart.fill")
        case .brain: return Image(systemName: "brain.head.profile")
        case .eye: return Image(systemName: "eye.fill")
        case .crown: return Image(systemName: "crown.fill")
        case .sword: return Image(systemName: "sword")
        case .shield: return Image(systemName: "shield.fill")
        case .lightning: return Image(systemName: "bolt.fill")
        case .flame: return Image(systemName: "flame.fill")
        case .moon: return Image(systemName: "moon.fill")
        case .scroll: return Image(systemName: "scroll.fill")
        case .magicWand: return Image(systemName: "sparkles.rectangle.stack")
        case .target: return Image(systemName: "target")
        case .arrowsOutCardinal: return Image(systemName: "arrow.up.left.and.arrow.down.right")
        case .sparkle: return Image(systemName: "sparkles")
        case .shieldStar: return Image(systemName: "shield.star.fill")
        case .skull: return Image(systemName: "cross.circle.fill")
        case .crosshair: return Image(systemName: "crosshair")
        case .scales: return Image(systemName: "scales")
        case .spiral: return Image(systemName: "spiral")
        case .infinity: return Image(systemName: "infinity")
        case .waves: return Image(systemName: "waveform.path.ecg.rectangle")
        case .hourglass: return Image(systemName: "hourglass")
        case .drop: return Image(systemName: "drop.fill")
        case .wind: return Image(systemName: "wind")
        case .handFist: return Image(systemName: "hand.fist")
        case .bandage: return Image(systemName: "bandage.fill")
        case .star: return Image(systemName: "star")
        case .atom: return Image(systemName: "atom")
        case .compass: return Image(systemName: "compass")
        case .clover: return Image(systemName: "clover")
        }
    }
    
    var displayName: String {
        self.rawValue.capitalized
    }
}

struct CustomAttribute: Codable, Identifiable {
    let id: UUID
    var name: String
    var value: Int
    var icon: CustomAttributeIcon
    
    init(id: UUID = UUID(), name: String = "", value: Int = 10, icon: CustomAttributeIcon = .sword) {
        self.id = id
        self.name = name
        self.value = value
        self.icon = icon
    }
}

// MARK: - Weapon Types
struct Weapon: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var damage: String
    var weight: String
    var range: String
    var rateOfFire: String
    var special: String
    var isEquipped: Bool
    var isStashed: Bool
    var isMagical: Bool
    var isCursed: Bool
    var bonus: Int
    var quantity: Int
    
    init(id: UUID = UUID(), name: String = "", damage: String = "", weight: String = "", range: String = "", rateOfFire: String = "-", special: String = "", isEquipped: Bool = false, isStashed: Bool = false, isMagical: Bool = false, isCursed: Bool = false, bonus: Int = 0, quantity: Int = 1) {
        self.id = id
        self.name = name
        self.damage = damage
        self.weight = weight
        self.range = range
        self.rateOfFire = rateOfFire
        self.special = special
        self.isEquipped = isEquipped
        self.isStashed = isStashed
        self.isMagical = isMagical
        self.isCursed = isCursed
        self.bonus = bonus
        self.quantity = quantity
    }
    
    static func fromData(_ data: [String: String]) -> Weapon {
        Weapon(
            id: UUID(),
            name: data["name"] ?? "",
            damage: data["damage"] ?? "",
            weight: data["weight"] ?? "",
            range: data["range"] ?? "",
            rateOfFire: data["rateOfFire"] ?? "-",
            special: data["special"] ?? "",
            isEquipped: data["isEquipped"]?.lowercased() == "true",
            isStashed: data["isStashed"]?.lowercased() == "true",
            isMagical: data["isMagical"]?.lowercased() == "true",
            isCursed: data["isCursed"]?.lowercased() == "true",
            bonus: Int(data["bonus"] ?? "0") ?? 0,
            quantity: Int(data["quantity"] ?? "1") ?? 1
        )
    }
}

// MARK: - Player Character
class PlayerCharacter: Identifiable, Codable {
    // MARK: - Properties
    let id: UUID
    var name: String
    var playerName: String
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
    
    // Attributes Configuration
    var useCustomAttributes: Bool
    var customAttributes: [CustomAttribute]
    
    // Default Attributes (used when useCustomAttributes is false)
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
        return stats.attunementSlots
    }
    
    // Strong Class Specific Properties
    var currentConflictLoot: ConflictLoot?
    var strongCombatOptions: StrongCombatOptions
    
    // Wise Class Specific Properties
    var wiseMiracleSlots: [WiseMiracleSlot]
    
    // Brave Class Specific Properties
    var braveQuirkOptions: BraveQuirkOptions
    var cleverKnackOptions: CleverKnackOptions
    
    // Fortunate Class Specific Properties
    var fortunateOptions: FortunateOptions
    
    // Other
    var languages: [String]
    var notes: String
    var experience: Int
    var corruption: Int
    var inventory: [String]
    var maxEncumbrance: Int
    var coinsOnHand: Int
    var stashedCoins: Int
    var gear: [Gear]  // New gear array
    
    // Computed Properties
    var currentEncumbrance: Int {
        var total = 0
        // Add encumbrance from gear
        for item in gear {
            if !item.isStashed {
                switch item.weight.lowercased() {
                case "no size": total += item.quantity
                case "minor": total += item.quantity * 2
                case "regular": total += item.quantity * 10
                case "heavy": total += item.quantity * 20
                default: break
                }
            }
        }
        return total
    }
    
    var comebackDice: Int {
        let stats = AdvancementTables.shared.stats(for: characterClass, at: level)
        return stats.comebackDice
    }
    
    var hasUsedSayNo: Bool
    
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
    
    // Equipment Tracking
    var weapons: [Weapon]
    var armor: [Armor]
    
    var totalDefenseValue: Int {
        let baseDF = armor.reduce(0) { total, armor in
            total + armor.df
        }
        return baseDF
    }
    
    var initiativeBonus: Int {
        if agility >= 16 {
            return 2
        } else if agility >= 13 {
            return 1
        }
        return 0
    }
    
    // MARK: - ID Regeneration Extension
    func copyWithNewIDs() -> PlayerCharacter {
        // Create a copy of the character with a new ID
        let newCharacter = PlayerCharacter(
            id: UUID(),
            name: name,
            playerName: playerName,
            characterClass: characterClass,
            level: level,
            useCustomAttributes: useCustomAttributes,
            customAttributes: customAttributes.map { attribute in
                CustomAttribute(
                    id: UUID(),
                    name: attribute.name,
                    value: attribute.value,
                    icon: attribute.icon
                )
            },
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
            attributeGroupPairs: attributeGroupPairs.map { pair in
                AttributeGroupPair(
                    id: UUID(),
                    attribute: pair.attribute,
                    group: pair.group
                )
            },
            attunementSlots: attunementSlots.map { slot in
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
            },
            currentConflictLoot: currentConflictLoot,
            strongCombatOptions: strongCombatOptions,
            wiseMiracleSlots: wiseMiracleSlots.map { slot in
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
            },
            braveQuirkOptions: braveQuirkOptions,
            cleverKnackOptions: cleverKnackOptions,
            fortunateOptions: FortunateOptions(
                standing: fortunateOptions.standing,
                hasUsedFortune: fortunateOptions.hasUsedFortune,
                retainers: fortunateOptions.retainers.map { retainer in
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
                },
                signatureObject: SignatureObject(name: fortunateOptions.signatureObject.name),
                newKeyword: fortunateOptions.newKeyword
            ),
            comebackDice: comebackDice,
            hasUsedSayNo: hasUsedSayNo,
            languages: languages,
            notes: notes,
            experience: experience,
            corruption: corruption,
            inventory: inventory,
            maxEncumbrance: maxEncumbrance,
            coinsOnHand: coinsOnHand,
            stashedCoins: stashedCoins,
            gear: gear.map { gear in
                Gear(
                    id: UUID(),
                    name: gear.name,
                    weight: gear.weight,
                    special: gear.special,
                    quantity: gear.quantity,
                    isEquipped: gear.isEquipped,
                    isStashed: gear.isStashed,
                    isMagical: gear.isMagical,
                    isCursed: gear.isCursed,
                    isContainer: gear.isContainer
                )
            },
            weapons: weapons.map { weapon in
                Weapon(
                    id: UUID(),
                    name: weapon.name,
                    damage: weapon.damage,
                    weight: weapon.weight,
                    range: weapon.range,
                    rateOfFire: weapon.rateOfFire,
                    special: weapon.special,
                    isEquipped: weapon.isEquipped,
                    isStashed: weapon.isStashed,
                    isMagical: weapon.isMagical,
                    isCursed: weapon.isCursed,
                    bonus: weapon.bonus,
                    quantity: weapon.quantity
                )
            },
            armor: armor.map { armor in
                Armor(
                    id: UUID(),
                    name: armor.name,
                    df: armor.df,
                    weight: armor.weight,
                    special: armor.special,
                    quantity: armor.quantity,
                    isEquipped: armor.isEquipped,
                    isStashed: armor.isStashed,
                    isMagical: armor.isMagical,
                    isCursed: armor.isCursed,
                    bonus: armor.bonus,
                    isShield: armor.isShield
                )
            }
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
        
        return newCharacter
    }
    
    // MARK: - Initializer
    init(
        id: UUID = UUID(),
        name: String = "",
        playerName: String = "",
        characterClass: CharacterClass = .deft,
        level: Int = 1,
        useCustomAttributes: Bool = false,
        customAttributes: [CustomAttribute] = [],
        strength: Int = 10,
        agility: Int = 10,
        toughness: Int = 10,
        intelligence: Int = 10,
        willpower: Int = 10,
        charisma: Int = 10,
        currentHP: Int = 1,
        maxHP: Int = 1,
        _attackValue: Int = 10,
        defenseValue: Int = 0,
        movement: Int = 30,
        _saveValue: Int = 7,
        saveColor: String = "",
        speciesGroup: String? = nil,
        vocationGroup: String? = nil,
        affiliationGroups: [String] = [],
        attributeGroupPairs: [AttributeGroupPair] = [],
        attunementSlots: [AttunementSlot] = [],
        currentConflictLoot: ConflictLoot? = nil,
        strongCombatOptions: StrongCombatOptions = StrongCombatOptions(),
        wiseMiracleSlots: [WiseMiracleSlot] = [],
        braveQuirkOptions: BraveQuirkOptions = BraveQuirkOptions(),
        cleverKnackOptions: CleverKnackOptions = CleverKnackOptions(),
        fortunateOptions: FortunateOptions = FortunateOptions(),
        comebackDice: Int = 0,
        hasUsedSayNo: Bool = false,
        languages: [String] = ["Common"],
        notes: String = "",
        experience: Int = 0,
        corruption: Int = 0,
        inventory: [String] = [],
        maxEncumbrance: Int = 15,
        coinsOnHand: Int = 0,
        stashedCoins: Int = 0,
        gear: [Gear] = [],
        weapons: [Weapon] = [],
        armor: [Armor] = []
    ) {
        self.id = id
        self.name = name
        self.playerName = playerName
        self.characterClass = characterClass
        self.level = level
        self.useCustomAttributes = useCustomAttributes
        self.customAttributes = customAttributes
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
        self.maxEncumbrance = maxEncumbrance
        self.coinsOnHand = coinsOnHand
        self.stashedCoins = stashedCoins
        self.gear = gear
        self.weapons = weapons
        self.armor = armor
    }
}
