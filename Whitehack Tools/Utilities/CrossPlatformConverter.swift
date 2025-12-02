import Foundation

/**
 * Cross-Platform Import Normalizer
 *
 * Normalizes character data from ANY source (Swift, Kotlin, or mixed)
 * into the format expected by the Swift app.
 *
 * Philosophy: Don't assume input format. Accept what's there, map variations,
 * fill defaults for missing fields. Be defensive and flexible.
 */
struct CrossPlatformConverter {
    
    // MARK: - Detection (for logging purposes)
    
    /// Detect if JSON data appears to be from Kotlin (Android) app
    static func isKotlinFormat(_ json: Any) -> Bool {
        guard let character = extractFirstCharacter(json) else { return false }
        
        // Kotlin indicators
        let hasSpecies = character["species"] != nil && character["speciesGroup"] == nil
        let hasVocation = character["vocation"] != nil && character["vocationGroup"] == nil
        let hasUseDefaultAttributes = character["useDefaultAttributes"] != nil
        
        // Swift indicators
        let hasSpeciesGroup = character["speciesGroup"] != nil
        let hasVocationGroup = character["vocationGroup"] != nil
        let hasAttackValue = character["_attackValue"] != nil
        
        let isKotlin = (hasSpecies || hasVocation || hasUseDefaultAttributes) &&
                       !hasSpeciesGroup && !hasVocationGroup && !hasAttackValue
        
        print("🔍 Format detection: species=\(hasSpecies), vocation=\(hasVocation), " +
              "useDefaultAttributes=\(hasUseDefaultAttributes), affiliations=\(character["affiliations"] != nil), " +
              "_attackValue=\(hasAttackValue) -> isKotlin=\(isKotlin)")
        
        return isKotlin
    }
    
    private static func extractFirstCharacter(_ json: Any) -> [String: Any]? {
        if let array = json as? [[String: Any]] {
            return array.first
        } else if let character = json as? [String: Any] {
            return character
        }
        return nil
    }
    
    // MARK: - Normalization (Main Entry Point)
    
    /// Normalize JSON from any source to Swift format
    static func normalize(_ json: Any) -> Any {
        if let array = json as? [[String: Any]] {
            return array.map { normalizeCharacter($0) }
        } else if let character = json as? [String: Any] {
            return normalizeCharacter(character)
        }
        return json
    }
    
    /// Alias for backward compatibility
    static func convertFromKotlin(_ json: Any) -> Any {
        return normalize(json)
    }
    
    /// Normalize a single character to Swift format
    private static func normalizeCharacter(_ input: [String: Any]) -> [String: Any] {
        print("🔄 Normalizing character: \(input["name"] ?? "Unknown")")
        
        var output: [String: Any] = [:]
        
        // MARK: - Identity Fields
        output["id"] = input["id"] ?? UUID().uuidString
        output["name"] = input["name"] ?? ""
        output["playerName"] = input["playerName"] ?? ""
        output["characterClass"] = input["characterClass"] ?? "Deft"
        output["level"] = input["level"] ?? 1
        
        // MARK: - Group Fields (accept either naming convention)
        output["speciesGroup"] = input["speciesGroup"] ?? input["species"] ?? ""
        output["vocationGroup"] = input["vocationGroup"] ?? input["vocation"] ?? ""
        output["affiliationGroups"] = input["affiliationGroups"] ?? input["affiliations"] ?? [String]()
        
        // MARK: - Attributes
        output["strength"] = input["strength"] ?? 10
        output["agility"] = input["agility"] ?? 10
        output["toughness"] = input["toughness"] ?? 10
        output["intelligence"] = input["intelligence"] ?? 10
        output["willpower"] = input["willpower"] ?? 10
        output["charisma"] = input["charisma"] ?? 10
        
        // Custom attributes - accept either boolean naming
        if let useCustom = input["useCustomAttributes"] as? Bool {
            output["useCustomAttributes"] = useCustom
        } else if let useDefault = input["useDefaultAttributes"] as? Bool {
            output["useCustomAttributes"] = !useDefault
        } else {
            output["useCustomAttributes"] = false
        }
        
        output["customAttributes"] = normalizeCustomAttributes(input["customAttributes"])
        output["attributeGroupPairs"] = normalizeAttributeGroupPairs(input["attributeGroupPairs"])
        
        // MARK: - Combat Stats
        output["currentHP"] = input["currentHP"] ?? 1
        output["maxHP"] = input["maxHP"] ?? 1
        output["movement"] = input["movement"] ?? 30
        output["_attackValue"] = input["_attackValue"] ?? 10
        output["_saveValue"] = input["_saveValue"] ?? 7
        
        // MARK: - Other Fields
        output["saveColor"] = input["saveColor"] ?? ""
        output["languages"] = input["languages"] ?? [String]()
        output["coinsOnHand"] = input["coinsOnHand"] ?? 0
        output["stashedCoins"] = input["stashedCoins"] ?? 0
        output["experience"] = input["experience"] ?? 0
        output["notes"] = input["notes"] ?? ""
        output["maxEncumbrance"] = input["maxEncumbrance"] ?? 15
        output["inventory"] = input["inventory"] ?? [String]()
        output["corruption"] = input["corruption"] ?? 0
        output["comebackDice"] = input["comebackDice"] ?? 0
        output["hasUsedSayNo"] = input["hasUsedSayNo"] ?? false
        
        // MARK: - Equipment
        output["weapons"] = normalizeWeapons(input["weapons"])
        output["armor"] = normalizeArmor(input["armor"])
        output["gear"] = normalizeGear(input["gear"])
        
        // MARK: - Class Options
        output["attunementSlots"] = normalizeAttunementSlots(input["attunementSlots"])
        output["wiseMiracleSlots"] = normalizeWiseMiracleSlots(input["wiseMiracleSlots"])
        output["strongCombatOptions"] = normalizeStrongCombatOptions(input["strongCombatOptions"])
        output["currentConflictLoot"] = normalizeConflictLoot(input["currentConflictLoot"])
        output["braveQuirkOptions"] = normalizeBraveQuirkOptions(input["braveQuirkOptions"])
        output["cleverKnackOptions"] = normalizeCleverKnackOptions(input["cleverKnackOptions"])
        output["fortunateOptions"] = normalizeFortunateOptions(input["fortunateOptions"])
        
        return output
    }
    
    // MARK: - Custom Attributes
    
    private static func normalizeCustomAttributes(_ value: Any?) -> [[String: Any]] {
        guard let attrs = value as? [[String: Any]] else { return [] }
        return attrs.map { attr in
            [
                "id": attr["id"] ?? UUID().uuidString,
                "name": attr["name"] ?? "",
                "value": attr["value"] ?? 10,
                "icon": attr["icon"] ?? "barbell"
            ]
        }
    }
    
    private static func normalizeAttributeGroupPairs(_ value: Any?) -> [[String: Any]] {
        guard let pairs = value as? [[String: Any]] else { return [] }
        return pairs.map { pair in
            [
                "id": pair["id"] ?? UUID().uuidString,
                "attribute": pair["attribute"] ?? "",
                "group": pair["group"] ?? ""
            ]
        }
    }
    
    // MARK: - Equipment Normalization
    
    private static func normalizeWeapons(_ value: Any?) -> [[String: Any]] {
        guard let weapons = value as? [[String: Any]] else { return [] }
        return weapons.map { weapon -> [String: Any] in
            var w: [String: Any] = [:]
            w["id"] = weapon["id"] ?? UUID().uuidString
            w["name"] = weapon["name"] ?? ""
            w["damage"] = weapon["damage"] ?? ""
            w["weight"] = weapon["weight"] ?? "Regular"
            w["range"] = weapon["range"] ?? ""
            w["rateOfFire"] = weapon["rateOfFire"] ?? ""
            w["special"] = weapon["special"] ?? ""
            w["isEquipped"] = weapon["isEquipped"] ?? false
            w["isStashed"] = weapon["isStashed"] ?? false
            w["isMagical"] = weapon["isMagical"] ?? false
            w["isCursed"] = weapon["isCursed"] ?? false
            w["bonus"] = weapon["bonus"] ?? 0
            w["quantity"] = weapon["quantity"] ?? 1
            return w
        }
    }
    
    private static func normalizeArmor(_ value: Any?) -> [[String: Any]] {
        guard let armors = value as? [[String: Any]] else { return [] }
        return armors.map { armor -> [String: Any] in
            var a: [String: Any] = [:]
            a["id"] = armor["id"] ?? UUID().uuidString
            a["name"] = armor["name"] ?? ""
            a["df"] = armor["df"] ?? 0
            a["weight"] = armor["weight"] ?? 0
            a["special"] = armor["special"] ?? ""
            a["quantity"] = armor["quantity"] ?? 1
            a["isEquipped"] = armor["isEquipped"] ?? false
            a["isStashed"] = armor["isStashed"] ?? false
            a["isMagical"] = armor["isMagical"] ?? false
            a["isCursed"] = armor["isCursed"] ?? false
            a["bonus"] = armor["bonus"] ?? 0
            a["isShield"] = armor["isShield"] ?? false
            return a
        }
    }
    
    private static func normalizeGear(_ value: Any?) -> [[String: Any]] {
        guard let gears = value as? [[String: Any]] else { return [] }
        return gears.map { gear -> [String: Any] in
            var g: [String: Any] = [:]
            g["id"] = gear["id"] ?? UUID().uuidString
            g["name"] = gear["name"] ?? ""
            g["weight"] = gear["weight"] ?? "Regular"
            g["special"] = gear["special"] ?? ""
            g["quantity"] = gear["quantity"] ?? 1
            g["isEquipped"] = gear["isEquipped"] ?? false
            g["isStashed"] = gear["isStashed"] ?? false
            g["isMagical"] = gear["isMagical"] ?? false
            g["isCursed"] = gear["isCursed"] ?? false
            g["isContainer"] = gear["isContainer"] ?? false
            return g
        }
    }
    
    // MARK: - Attunement Slots
    
    private static func normalizeAttunementSlots(_ value: Any?) -> [[String: Any]] {
        guard let slots = value as? [[String: Any]], !slots.isEmpty else {
            return [createDefaultAttunementSlot()]
        }
        
        return slots.map { slot in
            var normalized: [String: Any] = [:]
            normalized["id"] = slot["id"] ?? UUID().uuidString
            normalized["primaryAttunement"] = normalizeAttunement(slot["primaryAttunement"])
            normalized["secondaryAttunement"] = normalizeAttunement(slot["secondaryAttunement"])
            normalized["tertiaryAttunement"] = normalizeAttunement(slot["tertiaryAttunement"])
            normalized["quaternaryAttunement"] = normalizeAttunement(slot["quaternaryAttunement"])
            normalized["hasTertiaryAttunement"] = slot["hasTertiaryAttunement"] ?? false
            normalized["hasQuaternaryAttunement"] = slot["hasQuaternaryAttunement"] ?? false
            normalized["hasUsedDailyPower"] = slot["hasUsedDailyPower"] ?? false
            return normalized
        }
    }
    
    private static func normalizeAttunement(_ value: Any?) -> [String: Any] {
        guard let att = value as? [String: Any] else {
            return createDefaultAttunement()
        }
        
        var normalized: [String: Any] = [:]
        normalized["id"] = att["id"] ?? UUID().uuidString
        normalized["name"] = att["name"] ?? ""
        normalized["isActive"] = att["isActive"] ?? false
        normalized["isLost"] = att["isLost"] ?? false
        
        // Accept type in any casing, normalize to lowercase
        if let typeStr = att["type"] as? String {
            normalized["type"] = typeStr.lowercased()
        } else {
            normalized["type"] = "item"
        }
        
        return normalized
    }
    
    private static func createDefaultAttunementSlot() -> [String: Any] {
        [
            "id": UUID().uuidString,
            "primaryAttunement": createDefaultAttunement(),
            "secondaryAttunement": createDefaultAttunement(),
            "tertiaryAttunement": createDefaultAttunement(),
            "quaternaryAttunement": createDefaultAttunement(),
            "hasTertiaryAttunement": false,
            "hasQuaternaryAttunement": false,
            "hasUsedDailyPower": false
        ]
    }
    
    private static func createDefaultAttunement() -> [String: Any] {
        [
            "id": UUID().uuidString,
            "name": "",
            "isActive": false,
            "type": "item",
            "isLost": false
        ]
    }
    
    // MARK: - Wise Miracle Slots
    
    private static func normalizeWiseMiracleSlots(_ value: Any?) -> [[String: Any]] {
        guard let slots = value as? [[String: Any]], !slots.isEmpty else {
            return [createDefaultWiseMiracleSlot()]
        }
        
        return slots.map { slot in
            var normalized: [String: Any] = [:]
            normalized["id"] = slot["id"] ?? UUID().uuidString
            
            // Accept either field name
            normalized["isMagicItem"] = slot["isMagicItem"] ?? slot["isMagicItemSlot"] ?? false
            normalized["magicItemName"] = slot["magicItemName"] ?? ""
            normalized["additionalMiracleCount"] = slot["additionalMiracleCount"] ?? 0
            
            normalized["baseMiracles"] = normalizeMiracles(slot["baseMiracles"], isAdditional: false)
            normalized["additionalMiracles"] = normalizeMiracles(slot["additionalMiracles"], isAdditional: true)
            
            return normalized
        }
    }
    
    private static func normalizeMiracles(_ value: Any?, isAdditional: Bool) -> [[String: Any]] {
        guard let miracles = value as? [[String: Any]] else { return [] }
        return miracles.map { miracle in
            [
                "id": miracle["id"] ?? UUID().uuidString,
                "name": miracle["name"] ?? "",
                "isActive": miracle["isActive"] ?? false,
                "isAdditional": miracle["isAdditional"] ?? isAdditional
            ]
        }
    }
    
    private static func createDefaultWiseMiracleSlot() -> [String: Any] {
        [
            "id": UUID().uuidString,
            "isMagicItem": false,
            "magicItemName": "",
            "baseMiracles": [[String: Any]](),
            "additionalMiracles": [[String: Any]](),
            "additionalMiracleCount": 0
        ]
    }
    
    // MARK: - Strong Combat Options
    
    private static func normalizeStrongCombatOptions(_ value: Any?) -> [String: Any] {
        guard let options = value as? [String: Any] else {
            return ["slots": [Any?](repeating: nil, count: 10)]
        }
        
        if let slots = options["slots"] as? [Any?] {
            // Convert strings to integers (Kotlin exports combat options as strings)
            let normalizedSlots: [Any?] = slots.map { slot -> Any? in
                if slot == nil || slot is NSNull {
                    return nil
                }
                if let intVal = slot as? Int {
                    return intVal
                }
                if let strVal = slot as? String, let intVal = Int(strVal) {
                    return intVal
                }
                return slot
            }
            return ["slots": normalizedSlots]
        }
        
        return ["slots": [Any?](repeating: nil, count: 10)]
    }
    
    // MARK: - Conflict Loot
    
    private static func normalizeConflictLoot(_ value: Any?) -> Any? {
        if value == nil || value is NSNull {
            return nil
        }
        
        guard let loot = value as? [String: Any] else { return nil }
        
        var normalized: [String: Any] = [:]
        normalized["keyword"] = loot["keyword"] ?? ""
        normalized["usesRemaining"] = loot["usesRemaining"] ?? 0
        
        // Accept type in any casing, normalize to lowercase
        if let typeStr = loot["type"] as? String {
            normalized["type"] = typeStr.lowercased()
        } else {
            normalized["type"] = "object"
        }
        
        return normalized
    }
    
    // MARK: - Brave Quirk Options
    
    private static func normalizeBraveQuirkOptions(_ value: Any?) -> [String: Any] {
        guard let options = value as? [String: Any],
              let slots = options["slots"] as? [[String: Any]] else {
            return ["slots": createDefaultBraveQuirkSlots()]
        }
        
        let normalizedSlots = slots.map { slot -> [String: Any] in
            var s: [String: Any] = [:]
            s["id"] = slot["id"] ?? UUID().uuidString
            s["quirk"] = slot["quirk"]  // Can be nil
            s["protectedAllyName"] = slot["protectedAllyName"] ?? ""
            return s
        }
        
        // Ensure we have 10 slots
        var paddedSlots = normalizedSlots
        while paddedSlots.count < 10 {
            paddedSlots.append([
                "id": UUID().uuidString,
                "protectedAllyName": ""
            ])
        }
        
        return ["slots": paddedSlots]
    }
    
    private static func createDefaultBraveQuirkSlots() -> [[String: Any]] {
        (0..<10).map { _ in
            [
                "id": UUID().uuidString,
                "protectedAllyName": ""
            ] as [String: Any]
        }
    }
    
    // MARK: - Clever Knack Options
    
    private static func normalizeCleverKnackOptions(_ value: Any?) -> [String: Any] {
        guard let options = value as? [String: Any] else {
            return [
                "slots": createDefaultCleverKnackSlots(),
                "hasUsedUnorthodoxBonus": false
            ]
        }
        
        var normalized: [String: Any] = [:]
        normalized["hasUsedUnorthodoxBonus"] = options["hasUsedUnorthodoxBonus"] ?? false
        
        if let slots = options["slots"] as? [[String: Any]] {
            let normalizedSlots = slots.map { slot -> [String: Any] in
                var s: [String: Any] = [:]
                s["id"] = slot["id"] ?? UUID().uuidString
                s["knack"] = slot["knack"]  // Can be nil
                s["hasUsedCombatDie"] = slot["hasUsedCombatDie"] ?? false
                return s
            }
            
            // Ensure we have 10 slots
            var paddedSlots = normalizedSlots
            while paddedSlots.count < 10 {
                paddedSlots.append([
                    "id": UUID().uuidString,
                    "hasUsedCombatDie": false
                ])
            }
            
            normalized["slots"] = paddedSlots
        } else {
            normalized["slots"] = createDefaultCleverKnackSlots()
        }
        
        return normalized
    }
    
    private static func createDefaultCleverKnackSlots() -> [[String: Any]] {
        (0..<10).map { _ in
            [
                "id": UUID().uuidString,
                "hasUsedCombatDie": false
            ] as [String: Any]
        }
    }
    
    // MARK: - Fortunate Options
    
    private static func normalizeFortunateOptions(_ value: Any?) -> [String: Any] {
        guard let options = value as? [String: Any] else {
            return [
                "newKeyword": "",
                "standing": "",
                "hasUsedFortune": false,
                "retainers": [[String: Any]](),
                "signatureObject": ["name": ""]
            ]
        }
        
        var normalized: [String: Any] = [:]
        normalized["newKeyword"] = options["newKeyword"] ?? ""
        normalized["standing"] = options["standing"] ?? ""
        normalized["hasUsedFortune"] = options["hasUsedFortune"] ?? false
        
        // Normalize signature object
        if let sigObj = options["signatureObject"] as? [String: Any] {
            normalized["signatureObject"] = ["name": sigObj["name"] ?? ""]
        } else {
            normalized["signatureObject"] = ["name": ""]
        }
        
        // Normalize retainers
        if let retainers = options["retainers"] as? [[String: Any]] {
            normalized["retainers"] = retainers.map { retainer -> [String: Any] in
                var r: [String: Any] = [:]
                r["id"] = retainer["id"] ?? UUID().uuidString
                r["name"] = retainer["name"] ?? ""
                r["type"] = retainer["type"] ?? ""
                r["hitDice"] = retainer["hitDice"] ?? 1
                // Accept either field name
                r["defenseFactor"] = retainer["defenseFactor"] ?? retainer["defense"] ?? 0
                r["movement"] = retainer["movement"] ?? 30
                r["keywords"] = retainer["keywords"] ?? [String]()
                r["attitude"] = retainer["attitude"] ?? ""
                r["notes"] = retainer["notes"] ?? ""
                r["currentHP"] = retainer["currentHP"] ?? 1
                r["maxHP"] = retainer["maxHP"] ?? 1
                return r
            }
        } else {
            normalized["retainers"] = [[String: Any]]()
        }
        
        return normalized
    }
    
    // MARK: - Data Conversion Helper
    
    /// Convert normalized dictionary back to Data for decoding
    static func convertToData(_ json: Any) throws -> Data {
        return try JSONSerialization.data(withJSONObject: json, options: [])
    }
}
