//
//  AdvancementTables.swift
//  Whitehack Tools
//
//  Created by System Admin on 11/22/24.
//

import Foundation

// MARK: - Character Stats Structure
struct CharacterStats {
    let hitDice: String
    let attackValue: Int
    let savingValue: Int
    let slots: Int
    let groups: Int
    let raises: String  // Changed to String to handle "-" for level 1
}

// MARK: - Advancement Table Data
class AdvancementTables {
    // MARK: - Singleton
    static let shared = AdvancementTables()
    
    private init() {}  // Ensure singleton pattern
    
    // MARK: - Level-Based Stat Progressions
    private let statProgressions: [CharacterClass: [Int: CharacterStats]] = [
        .deft: [
            1: CharacterStats(hitDice: "1", attackValue: 10, savingValue: 7, slots: 1, groups: 2, raises: "-"),
            2: CharacterStats(hitDice: "2", attackValue: 11, savingValue: 8, slots: 1, groups: 2, raises: "1"),
            3: CharacterStats(hitDice: "2+1", attackValue: 11, savingValue: 9, slots: 1, groups: 3, raises: "1"),
            4: CharacterStats(hitDice: "3", attackValue: 12, savingValue: 10, slots: 2, groups: 3, raises: "2"),
            5: CharacterStats(hitDice: "3+1", attackValue: 12, savingValue: 11, slots: 2, groups: 4, raises: "2"),
            6: CharacterStats(hitDice: "4", attackValue: 13, savingValue: 12, slots: 2, groups: 4, raises: "3"),
            7: CharacterStats(hitDice: "4+1", attackValue: 13, savingValue: 13, slots: 3, groups: 5, raises: "3"),
            8: CharacterStats(hitDice: "5", attackValue: 14, savingValue: 14, slots: 3, groups: 5, raises: "4"),
            9: CharacterStats(hitDice: "5+1", attackValue: 14, savingValue: 15, slots: 3, groups: 6, raises: "4"),
            10: CharacterStats(hitDice: "6", attackValue: 15, savingValue: 16, slots: 4, groups: 6, raises: "5")
        ],
        .strong: [
            1: CharacterStats(hitDice: "1+2", attackValue: 11, savingValue: 5, slots: 1, groups: 2, raises: "-"),
            2: CharacterStats(hitDice: "2", attackValue: 11, savingValue: 6, slots: 1, groups: 2, raises: "1"),
            3: CharacterStats(hitDice: "3", attackValue: 12, savingValue: 7, slots: 1, groups: 2, raises: "1"),
            4: CharacterStats(hitDice: "4", attackValue: 13, savingValue: 8, slots: 2, groups: 3, raises: "2"),
            5: CharacterStats(hitDice: "5", attackValue: 13, savingValue: 9, slots: 2, groups: 3, raises: "2"),
            6: CharacterStats(hitDice: "6", attackValue: 14, savingValue: 10, slots: 2, groups: 3, raises: "3"),
            7: CharacterStats(hitDice: "7", attackValue: 14, savingValue: 11, slots: 3, groups: 4, raises: "3"),
            8: CharacterStats(hitDice: "8", attackValue: 15, savingValue: 12, slots: 3, groups: 4, raises: "4"),
            9: CharacterStats(hitDice: "9", attackValue: 15, savingValue: 13, slots: 3, groups: 4, raises: "4"),
            10: CharacterStats(hitDice: "10", attackValue: 16, savingValue: 14, slots: 4, groups: 5, raises: "5")
        ],
        .wise: [
            1: CharacterStats(hitDice: "1", attackValue: 10, savingValue: 6, slots: 1, groups: 2, raises: "-"),
            2: CharacterStats(hitDice: "1+1", attackValue: 10, savingValue: 7, slots: 1, groups: 2, raises: "1"),
            3: CharacterStats(hitDice: "2", attackValue: 11, savingValue: 8, slots: 2, groups: 2, raises: "1"),
            4: CharacterStats(hitDice: "2+1", attackValue: 11, savingValue: 9, slots: 2, groups: 3, raises: "2"),
            5: CharacterStats(hitDice: "3", attackValue: 12, savingValue: 10, slots: 2, groups: 3, raises: "2"),
            6: CharacterStats(hitDice: "3+1", attackValue: 12, savingValue: 11, slots: 3, groups: 3, raises: "3"),
            7: CharacterStats(hitDice: "4", attackValue: 13, savingValue: 12, slots: 3, groups: 4, raises: "3"),
            8: CharacterStats(hitDice: "4+1", attackValue: 13, savingValue: 13, slots: 3, groups: 4, raises: "4"),
            9: CharacterStats(hitDice: "5", attackValue: 14, savingValue: 14, slots: 4, groups: 4, raises: "4"),
            10: CharacterStats(hitDice: "5+1", attackValue: 14, savingValue: 15, slots: 4, groups: 5, raises: "5")
        ],
        .brave: [
            1: CharacterStats(hitDice: "1*", attackValue: 10, savingValue: 9, slots: 1, groups: 2, raises: "-"),
            2: CharacterStats(hitDice: "2*", attackValue: 10, savingValue: 10, slots: 1, groups: 2, raises: "1"),
            3: CharacterStats(hitDice: "3*", attackValue: 10, savingValue: 11, slots: 1, groups: 2, raises: "1"),
            4: CharacterStats(hitDice: "4", attackValue: 11, savingValue: 12, slots: 2, groups: 2, raises: "2"),
            5: CharacterStats(hitDice: "5", attackValue: 11, savingValue: 13, slots: 2, groups: 3, raises: "2"),
            6: CharacterStats(hitDice: "6", attackValue: 11, savingValue: 14, slots: 2, groups: 3, raises: "3"),
            7: CharacterStats(hitDice: "7", attackValue: 12, savingValue: 15, slots: 3, groups: 3, raises: "3"),
            8: CharacterStats(hitDice: "8", attackValue: 12, savingValue: 16, slots: 3, groups: 3, raises: "4"),
            9: CharacterStats(hitDice: "9", attackValue: 12, savingValue: 17, slots: 3, groups: 4, raises: "4"),
            10: CharacterStats(hitDice: "10", attackValue: 13, savingValue: 18, slots: 4, groups: 4, raises: "5")
        ],
        .clever: [
            1: CharacterStats(hitDice: "1", attackValue: 10, savingValue: 8, slots: 1, groups: 2, raises: "-"),
            2: CharacterStats(hitDice: "2", attackValue: 11, savingValue: 9, slots: 1, groups: 2, raises: "1"),
            3: CharacterStats(hitDice: "2+1", attackValue: 11, savingValue: 10, slots: 1, groups: 2, raises: "1"),
            4: CharacterStats(hitDice: "3", attackValue: 11, savingValue: 11, slots: 2, groups: 3, raises: "2"),
            5: CharacterStats(hitDice: "3+1", attackValue: 12, savingValue: 12, slots: 2, groups: 3, raises: "2"),
            6: CharacterStats(hitDice: "4", attackValue: 12, savingValue: 13, slots: 2, groups: 3, raises: "3"),
            7: CharacterStats(hitDice: "4+1", attackValue: 13, savingValue: 14, slots: 3, groups: 4, raises: "3"),
            8: CharacterStats(hitDice: "5", attackValue: 13, savingValue: 15, slots: 3, groups: 4, raises: "4"),
            9: CharacterStats(hitDice: "5+1", attackValue: 13, savingValue: 16, slots: 3, groups: 4, raises: "4"),
            10: CharacterStats(hitDice: "6", attackValue: 14, savingValue: 17, slots: 4, groups: 5, raises: "5")
        ],
        .fortunate: [
            1: CharacterStats(hitDice: "1", attackValue: 10, savingValue: 6, slots: 1, groups: 2, raises: "-"),
            2: CharacterStats(hitDice: "2", attackValue: 10, savingValue: 7, slots: 1, groups: 2, raises: "1"),
            3: CharacterStats(hitDice: "2+1", attackValue: 11, savingValue: 8, slots: 1, groups: 3, raises: "1"),
            4: CharacterStats(hitDice: "3", attackValue: 11, savingValue: 9, slots: 2, groups: 3, raises: "2"),
            5: CharacterStats(hitDice: "3+1", attackValue: 12, savingValue: 10, slots: 2, groups: 4, raises: "2"),
            6: CharacterStats(hitDice: "4", attackValue: 12, savingValue: 11, slots: 2, groups: 4, raises: "3"),
            7: CharacterStats(hitDice: "4+1", attackValue: 13, savingValue: 12, slots: 3, groups: 5, raises: "3"),
            8: CharacterStats(hitDice: "5", attackValue: 13, savingValue: 13, slots: 3, groups: 5, raises: "4"),
            9: CharacterStats(hitDice: "5+1", attackValue: 14, savingValue: 14, slots: 3, groups: 6, raises: "4"),
            10: CharacterStats(hitDice: "6", attackValue: 14, savingValue: 15, slots: 4, groups: 6, raises: "5")
        ]
    ]
    
    // MARK: - XP Requirements
    private let xpRequirements: [CharacterClass: [Int: Int]] = [
        .deft: [
            2: 1450, 3: 2900, 4: 5800, 5: 11600,
            6: 23200, 7: 46400, 8: 92800, 9: 185600, 10: 371200
        ],
        .strong: [
            2: 1900, 3: 3800, 4: 7600, 5: 15200,
            6: 30400, 7: 60800, 8: 121600, 9: 243200, 10: 486400
        ],
        .wise: [
            2: 2350, 3: 4700, 4: 9400, 5: 18800,
            6: 37600, 7: 75200, 8: 150400, 9: 300800, 10: 601600
        ],
        .brave: [
            2: 1225, 3: 2450, 4: 4900, 5: 9800,
            6: 19600, 7: 39200, 8: 78400, 9: 156800, 10: 313600
        ],
        .clever: [
            2: 1350, 3: 2700, 4: 5400, 5: 10800,
            6: 21600, 7: 43200, 8: 86400, 9: 172800, 10: 345600
        ],
        .fortunate: [
            2: 1450, 3: 2900, 4: 5800, 5: 11600,
            6: 23200, 7: 46400, 8: 92800, 9: 185600, 10: 371200
        ]
    ]
    
    // MARK: - Public Methods
    
    /// Get all stats for a character class at a specific level
    func stats(for characterClass: CharacterClass, at level: Int) -> CharacterStats {
        // Ensure level is between 1 and 10
        let validLevel = max(1, min(10, level))
        
        // Return stats for the valid level, defaulting to level 1 if something goes wrong
        return statProgressions[characterClass]?[validLevel] ?? statProgressions[characterClass]?[1] ?? CharacterStats(hitDice: "1", attackValue: 10, savingValue: 7, slots: 1, groups: 2, raises: "-")
    }
    
    /// Get XP required for next level
    func xpRequirement(for characterClass: CharacterClass, at targetLevel: Int) -> Int {
        let clampedLevel = min(max(targetLevel, 2), 10)
        return xpRequirements[characterClass]?[clampedLevel] ?? 0
    }
    
    /// Calculate current level based on XP
    func level(for characterClass: CharacterClass, withXP xp: Int) -> Int {
        guard xp > 0 else { return 1 }
        
        let requirements = xpRequirements[characterClass] ?? [:]
        
        // Find the highest level where the XP requirement is less than or equal to the character's XP
        for level in (2...10).reversed() {
            if let requirement = requirements[level], xp >= requirement {
                return level
            }
        }
        
        return 1
    }
}
