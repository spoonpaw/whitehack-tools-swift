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
                    ClassInfoCard()
                    CombatBenefitsCard()
                    SpecialAbilitiesCard(character: character)
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
    (title: "Special Conflict", text: "Note special or culturally important conflicts. Gain +2 for one round to df/av/sv/hp/attribute/damage/healing/mv/initiative if related to the conflict memory.", icon: "star.circle.fill", color: Color.yellow),
    (title: "Substance", text: "Extract rare substances from enemies with suitable keywords (poison, acid, etc.). May count toward encumbrance.", icon: "flask.fill", color: Color.green),
    (title: "Supernatural", text: "Gain non-violent supernatural ability by delivering killing blow to creature", icon: "wand.and.stars", color: Color.purple)
]

private let specialAbilities = [
    (level: 1, name: "Protect Ally", desc: "Protect adjacent ally, redirecting attacks to self (save allowed)", icon: "shield.lefthalf.filled", color: Color.blue),
    (level: 2, name: "Push Opponent", desc: "Push opponent within 10ft after hit, optionally take their space (save negates)", icon: "person.fill.turn.right", color: Color.orange),
    (level: 3, name: "Climb Opponent", desc: "Climb big opponents for +4 AV/damage, requires agility check", icon: "figure.climbing", color: Color.green),
    (level: 4, name: "Trade Damage", desc: "Trade damage for initiative/movement/ongoing damage effects", icon: "arrow.triangle.2.circlepath", color: Color.purple),
    (level: 5, name: "Grant Combat Advantage", desc: "Grant ally double combat advantage once per battle", icon: "person.2.fill", color: Color.yellow),
    (level: 6, name: "Boost Allies", desc: "Boost allies' or debuff enemies' AV/SV in 15ft radius", icon: "speaker.wave.3.fill", color: Color.red),
    (level: 7, name: "Melee and Ranged Attack", desc: "Make both melee and ranged attack by forgoing movement", icon: "arrow.left.and.right.circle.fill", color: Color.orange),
    (level: 8, name: "Parry", desc: "Parry for defense bonus and subsequent combat advantage", icon: "shield.righthalf.filled", color: Color.blue)
]

private let combatBenefits = [
    (text: "Two free attacks per round (others get one)", icon: "figure.fencing", color: Color.red),
    (text: "Flow attacks when reducing enemy to 0 HP (raises + 1 per round)", icon: "arrow.triangle.branch", color: Color.orange),
    (text: "Can use all special combat options", icon: "shield.righthalf.filled", color: Color.purple),
    (text: "+4 save vs. special melee attacks", icon: "person.crop.circle.badge.exclamationmark", color: Color.blue),
    (text: "+1 save vs. poison and death", icon: "cross.vial.fill", color: Color.green)
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
                .imageScale(.large)
        }
    }
}

// MARK: - Cards
private struct ClassInfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Ph.barbell.bold
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.red)
                Text("Class Overview")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Text("Masters of combat who rely on physical prowess and martial skill. Whether as warriors, guards, knights, bounty hunters, or barbarians, they excel in battle and can turn the tide of combat.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.red.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

private struct CombatBenefitsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "shield.lefthalf.filled")
                    .foregroundColor(.red)
                    .imageScale(.large)
                Text("Combat Benefits")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(combatBenefits, id: \.text) { benefit in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: benefit.icon)
                            .foregroundColor(benefit.color)
                            .imageScale(.large)
                            .frame(width: 24, alignment: .center)
                        
                        Text(benefit.text)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

private struct SpecialAbilitiesCard: View {
    let character: PlayerCharacter
    
    private var availableSlots: Int {
        AdvancementTables.shared.stats(for: character.characterClass, at: character.level).slots
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "bolt.shield.fill")
                    .foregroundColor(.orange)
                    .imageScale(.large)
                Text("Selected Special Abilities")
                    .font(.headline)
            }
            
            if character.strongCombatOptions.activeOptions.isEmpty {
                Text("No abilities selected")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.leading, 4)
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(character.strongCombatOptions.activeOptions.enumerated()), id: \.element) { index, option in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: specialAbilities[option.rawValue].icon)
                                    .foregroundColor(specialAbilities[option.rawValue].color)
                                    .imageScale(.large)
                                
                                Text("Slot \(index + 1): \(option.name)")
                                    .font(.subheadline.bold())
                                    .foregroundColor(specialAbilities[option.rawValue].color)
                            }
                            
                            Text(option.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.leading, 32)
                        }
                        .padding(12)
                        .background(specialAbilities[option.rawValue].color.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            
            if let currentLoot = character.currentConflictLoot {
                Divider()
                    .padding(.vertical, 8)
                
                HStack {
                    Image(systemName: "bag.fill.badge.plus")
                        .foregroundColor(.yellow)
                        .imageScale(.large)
                    Text("Active Conflict Loot")
                        .font(.headline)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: currentLoot.type == .substance ? "flask.fill" : 
                                       currentLoot.type == .special ? "star.circle.fill" : "wand.and.stars")
                            .foregroundColor(currentLoot.type == .substance ? .green :
                                           currentLoot.type == .special ? .yellow : .purple)
                            .imageScale(.large)
                        
                        Text(currentLoot.type.rawValue.capitalized)
                            .font(.subheadline.bold())
                            .foregroundColor(currentLoot.type == .substance ? .green :
                                           currentLoot.type == .special ? .yellow : .purple)
                    }
                    
                    if !currentLoot.keyword.isEmpty {
                        Text("Keyword: \(currentLoot.keyword)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.leading, 32)
                    }
                    
                    Text("\(currentLoot.usesRemaining) use\(currentLoot.usesRemaining != 1 ? "s" : "") remaining")
                        .font(.subheadline)
                        .foregroundColor(currentLoot.usesRemaining > 0 ? .blue : .red)
                        .padding(.leading, 32)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(currentLoot.type == .substance ? .green : 
                                currentLoot.type == .special ? .yellow : .purple).opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

private struct ConflictLootingCard: View {
    let character: PlayerCharacter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "bag.fill.badge.plus")
                    .foregroundColor(.yellow)
                    .imageScale(.large)
                Text("Conflict Looting")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(lootingOptions, id: \.title) { option in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: option.icon)
                                .foregroundColor(option.color)
                                .imageScale(.large)
                            
                            Text(option.title)
                                .font(.subheadline.bold())
                                .foregroundColor(option.color)
                        }
                        
                        Text(option.text)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.leading, 32)
                    }
                    .padding(12)
                    .background(option.color.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

private struct FlowAttacksCard: View {
    let character: PlayerCharacter
    
    private var maxFlowAttacks: Int {
        let stats = AdvancementTables.shared.stats(for: character.characterClass, at: character.level)
        // At level 1, raises is "-", so return 1 (just the base flow attack)
        if stats.raises == "-" {
            return 1
        }
        return Int(stats.raises)! + 1 // Flow attacks = raises + 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "arrow.triangle.branch")
                    .foregroundColor(.orange)
                    .imageScale(.large)
                Text("Flow Attacks")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Maximum Flow Attacks per Round: \(maxFlowAttacks)")
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                
                Text("When you reduce an enemy to 0 HP, you can make an additional attack against an adjacent enemy (melee) or an enemy adjacent to the prior target (ranged).")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(Color.orange.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.red)
                    .imageScale(.large)
                Text("Attribute Bonuses")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 16) {
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
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

private struct ClassFeaturesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "shield.lefthalf.filled")
                    .foregroundColor(.red)
                    .imageScale(.large)
                Text("Class Features")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Combat Prowess")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("• Two free attacks per round (others get one)")
                    Text("• Flow attacks when reducing enemy to 0 HP")
                    Text("• Can make flow attacks against enemies adjacent to you (melee) or the prior target (ranged)")
                    Text("• Maximum flow attacks per round = raises + 1")
                }
                .font(.subheadline)
                
                Text("Combat Options")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.top, 4)
                
                Text("Can use any special combat option and permanently fill slots with options from the Strong ability list. Unless noted, effects last one round and can be activated any number of times.")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

private struct SelectedCombatOptionsCard: View {
    let character: PlayerCharacter
    
    private var availableSlots: Int {
        AdvancementTables.shared.stats(for: character.characterClass, at: character.level).slots
    }
    
    private var selectedOptions: [StrongCombatOption] {
        character.availableCombatOptions.filter { character.strongCombatOptions.isActive($0) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "square.stack.3d.up.fill")
                    .foregroundColor(.red)
                    .imageScale(.large)
                Text("Selected Combat Options")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("\(selectedOptions.count)/\(availableSlots) Slots Used")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if selectedOptions.isEmpty {
                    Text("No combat options selected")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
                } else {
                    ForEach(selectedOptions) { option in
                        HStack(spacing: 12) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 6))
                                .foregroundColor(.secondary)
                            Text(option.name)
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
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
                .foregroundStyle(color)
            
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
