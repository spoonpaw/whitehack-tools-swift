import SwiftUI
import PhosphorSwift

// MARK: - Main View
struct DetailStrongCombatSection: View {
    let character: PlayerCharacter
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if character.characterClass == .strong {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    AttributeBonusesCard(character: character)
                    ConflictLootingCard(character: character)
                    FlowAttacksCard(character: character)
                }
                .padding(.vertical)
            } header: {
                StrongSectionHeader()
            }
        } else {
            EmptyView()
        }
    }
}

// MARK: - Static Data
private let lootingOptions = [
    (title: "Special Conflict", text: "Note special or culturally important conflicts. Gain +2 for one round to df/av/sv/hp/attribute/damage/healing/mv/initiative if related to the conflict memory.", icon: "star.fill", color: Color.yellow),
    (title: "Substance", text: "Extract rare substances from enemies with suitable keywords (poison, acid, etc.). May count toward encumbrance.", icon: "flask.fill", color: Color.green),
    (title: "Supernatural", text: "Gain non-violent supernatural ability by delivering killing blow to creature", icon: "sparkles", color: Color.purple)
]

private let specialAbilities = [
    (level: 1, name: "Protect Ally", desc: "Protect adjacent ally, redirecting attacks to self (save allowed)", icon: "shield.lefthalf.filled", color: Color.blue),
    (level: 2, name: "Push Opponent", desc: "Push opponent within 10ft after hit, optionally take their space (save negates)", icon: "arrow.up.and.down.and.arrow.left.and.right", color: Color.orange),
    (level: 3, name: "Climb Opponent", desc: "Climb big opponents for +4 AV/damage, requires agility check", icon: "figure.climbing", color: Color.green),
    (level: 4, name: "Trade Damage", desc: "Trade damage for initiative/movement/ongoing damage effects", icon: "arrow.triangle.2.circlepath", color: Color.purple),
    (level: 5, name: "Grant Combat Advantage", desc: "Grant ally double combat advantage once per battle", icon: "person.2.fill", color: Color.yellow),
    (level: 6, name: "Boost Allies", desc: "Boost allies' or debuff enemies' AV/SV in 15ft radius", icon: "speaker.wave.3.fill", color: Color.red),
    (level: 7, name: "Melee and Ranged Attack", desc: "Make both melee and ranged attack by forgoing movement", icon: "arrow.left.and.right", color: Color.orange),
    (level: 8, name: "Parry", desc: "Parry for defense bonus and subsequent combat advantage", icon: "shield.righthalf.filled", color: Color.blue)
]

private let combatBenefits = [
    (text: "Two free attacks per round (others get one)", icon: "figure.fencing", color: Color.red),
    (text: "Flow attacks when reducing enemy to 0 HP (raises + 1 per round)", icon: "arrow.triangle.branch", color: Color.orange),
    (text: "Can use all special combat options", icon: "shield.righthalf.filled", color: Color.purple),
    (text: "+4 save vs. special melee attacks", icon: "person.crop.circle.badge.exclamationmark", color: Color.blue),
    (text: "+1 save vs. poison and death", icon: "cross.vial", color: Color.green)
]

private let attributeBonuses = [
    (attribute: "Strength", bonus: "+1 AV, +1 damage", color: Color(red: 1.0, green: 0.647, blue: 0.0)), // Orange
    (attribute: "Toughness", bonus: "+2 HP", color: Color(red: 1.0, green: 0.0, blue: 0.0)) // Red
]

// MARK: - Section Header
private struct StrongSectionHeader: View {
    var body: some View {
        Label {
            Text("The Strong")
                .font(.headline)
                .foregroundColor(.primary)
        } icon: {
            Image(systemName: "shield.fill")
                .foregroundColor(.red)
        }
    }
}

// MARK: - Cards
private struct ClassInfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Masters of combat who rely on physical prowess and martial skill. Whether as warriors, guards, knights, bounty hunters, or barbarians, they excel in battle and can turn the tide of combat.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.red.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

private struct CombatBenefitsCard: View {
    var body: some View {
        CardContainer(title: "Combat Benefits", icon: "shield.lefthalf.filled") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Combat Benefits")
                    .font(.subheadline)
                    .foregroundColor(.red)
                
                ForEach(combatBenefits, id: \.text) { benefit in
                    CombatBenefitRow(
                        text: benefit.text,
                        icon: benefit.icon,
                        color: benefit.color
                    )
                }
            }
        }
    }
}

private struct ConflictLootingCard: View {
    let character: PlayerCharacter
    
    var body: some View {
        CardContainer(title: "Conflict Looting", icon: "bag.fill") {
            VStack(alignment: .leading, spacing: 12) {
                if let loot = character.currentConflictLoot {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: loot.type == .substance ? "flask.fill" : 
                                       loot.type == .special ? "star.fill" : "sparkles")
                            .font(.title2)
                            .foregroundColor(loot.type == .substance ? .green :
                                           loot.type == .special ? .yellow : .purple)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(loot.type.rawValue.capitalized)
                                .font(.headline)
                            if !loot.keyword.isEmpty {
                                Text("Keyword: \(loot.keyword)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Text("\(loot.usesRemaining) use\(loot.usesRemaining != 1 ? "s" : "") remaining")
                                .font(.caption)
                                .foregroundColor(loot.usesRemaining > 0 ? .blue : .red)
                        }
                    }
                    .padding(.vertical, 8)
                } else {
                    Text("No conflict loot currently held")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                    .padding(.vertical, 4)
                
                Text("Looting Types")
                    .font(.subheadline)
                    .foregroundColor(.red)
                
                ForEach(lootingOptions, id: \.title) { loot in
                    LootOptionCard(title: loot.title, text: loot.text, icon: loot.icon, color: loot.color)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Looting Rules")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    
                    Text("• Can only hold one loot instance at a time")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("• Each instance is usable \(character.level) times (equal to character level)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("• Can exchange loot after new conflicts (unused substances spoil)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("• Substances may count toward encumbrance")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(Color.red.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

private struct SpecialAbilitiesCard: View {
    let character: PlayerCharacter
    
    private var availableSlots: Int {
        AdvancementTables.shared.stats(for: character.characterClass, at: character.level).slots
    }
    
    var body: some View {
        CardContainer(title: "Special Abilities", icon: "bolt.shield.fill") {
            VStack(alignment: .leading, spacing: 12) {
                if character.strongCombatOptions.activeOptions.isEmpty {
                    Text("No abilities selected yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    if availableSlots > 0 {
                        Text("You have \(availableSlots) ability slot\(availableSlots > 1 ? "s" : "") available")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                } else {
                    ForEach(character.strongCombatOptions.activeOptions, id: \.self) { ability in
                        AbilityCard(
                            level: ability.rawValue + 1,
                            name: ability.name,
                            desc: ability.description,
                            icon: ability.rawValue == 0 ? "shield.lefthalf.filled" :
                                  ability.rawValue == 1 ? "arrow.up.and.down.and.arrow.left.and.right" :
                                  ability.rawValue == 2 ? "figure.climbing" :
                                  ability.rawValue == 3 ? "arrow.triangle.2.circlepath" :
                                  ability.rawValue == 4 ? "person.2.fill" :
                                  ability.rawValue == 5 ? "speaker.wave.3.fill" :
                                  ability.rawValue == 6 ? "arrow.left.and.right" : "shield.righthalf.filled",
                            color: ability.rawValue == 0 ? .blue :
                                   ability.rawValue == 1 ? .orange :
                                   ability.rawValue == 2 ? .green :
                                   ability.rawValue == 3 ? .purple :
                                   ability.rawValue == 4 ? .yellow :
                                   ability.rawValue == 5 ? .red :
                                   ability.rawValue == 6 ? .orange : .blue,
                            isUnlocked: true
                        )
                    }
                    
                    let remainingSlots = availableSlots - character.strongCombatOptions.count
                    if remainingSlots > 0 {
                        Text("You have \(remainingSlots) more ability slot\(remainingSlots > 1 ? "s" : "") available")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.top, 4)
                    }
                }
            }
        }
    }
}

private struct AttributeBonusesCard: View {
    let character: PlayerCharacter
    
    private var strengthBonus: String {
        "AV +1, Damage +1"
    }
    
    private var toughnessBonus: String {
        "HP +2"
    }
    
    var body: some View {
        CardContainer(title: "Attribute Bonuses", icon: "chart.bar.fill") {
            VStack(alignment: .leading, spacing: 12) {
                AttributeBonusRow(
                    attribute: "Strength (\(character.strength))",
                    bonus: strengthBonus,
                    icon: Ph.barbell,
                    color: Color(red: 1.0, green: 0.647, blue: 0.0) // Orange
                )
                AttributeBonusRow(
                    attribute: "Toughness (\(character.toughness))",
                    bonus: toughnessBonus,
                    icon: Ph.heart,
                    color: Color(red: 1.0, green: 0.0, blue: 0.0) // Red
                )
            }
        }
    }
}

private struct FlowAttacksCard: View {
    let character: PlayerCharacter
    
    var body: some View {
        CardContainer(title: "Flow Attacks", icon: "arrow.triangle.branch") {
            VStack(alignment: .leading, spacing: 12) {
                Text("When you reduce an enemy to 0 HP, you may:")
                    .font(.subheadline)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "figure.fencing")
                            .foregroundColor(.orange)
                        Text("Attack another enemy adjacent to you (melee)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                            .foregroundColor(.orange)
                        Text("Attack another enemy adjacent to prior target (ranged)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.leading, 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Flow Attack Rules")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    
                    Text("• Requires a separate attack roll")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("• Must have a ready weapon")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("• Limited to raises + 1 flow attacks per round")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(Color.red.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

// MARK: - Helper Views
private struct CardContainer<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.red)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.red.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
    }
}

private struct AbilityCard: View {
    let level: Int
    let name: String
    let desc: String
    let icon: String
    let color: Color
    let isUnlocked: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(desc)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

private struct CombatBenefitRow: View {
    let text: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .imageScale(.small)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }
}

private struct LootOptionCard: View {
    let title: String
    let text: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Spacer()
            }
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct AttributeBonusRow: View {
    let attribute: String
    let bonus: String
    let icon: Ph
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            icon
                .bold
                .frame(width: 20, height: 20)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(attribute)
                    .font(.headline)
                Text(bonus)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
