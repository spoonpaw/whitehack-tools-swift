import SwiftUI
import PhosphorSwift

struct DetailBraveQuirksSection: View {
    let characterClass: CharacterClass
    let level: Int
    let braveQuirkOptions: BraveQuirkOptions
    let comebackDice: Int
    let hasUsedSayNo: Bool
    @Environment(\.colorScheme) var colorScheme
    
    private var availableSlots: Int {
        AdvancementTables.shared.stats(for: characterClass, at: level).slots
    }
    
    var body: some View {
        if characterClass == .brave {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    // Class Overview Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                            Text("Class Overview")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        // Description Card
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Any character may show courage, but the ability to stand fast in the face of despair defines the Brave and makes up for their lack of skills and prowess. They are underdogs and unlikely heroes: failed apprentices, gardeners dreaming of dragons and elves, wannabe bards, peasants taking up arms against an oppressive ruler, or something similar.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        // Attributes & Features Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.blue)
                                Text("Class Traits")
                                    .font(.headline)
                            }
                            
                            Text("Brave character may raise or lower attributes at even levels. They can use any weapon, but armor heavier than cloth incurs a 2 attribute penalty on all task rolls. The Brave also get two rolls for hp at levels 1–3 (marked with asterisks in the table), and the player picks the best roll. Finally, they emit a distinct aura: very perceptive people and creatures will always sense their courageous quality.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Class Features Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Class Features")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        // Quirks Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.yellow)
                                Text("Quirks")
                                    .font(.headline)
                                Spacer()
                                Text("\(braveQuirkOptions.activeQuirks.count)/\(availableSlots)")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.secondary.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            Text("Brave characters' slots can each hold a special quirk. There are eight quirks to permanently choose from as the character levels.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            if braveQuirkOptions.activeQuirks.isEmpty {
                                Text("No quirks selected")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.vertical, 8)
                            } else {
                                ForEach(0..<availableSlots, id: \.self) { slotIndex in
                                    if let quirk = braveQuirkOptions.getQuirk(at: slotIndex) {
                                        QuirkCard(quirk: quirk, slotIndex: slotIndex, protectedAlly: braveQuirkOptions.getProtectedAlly(at: slotIndex))
                                    }
                                }
                            }
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.yellow.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        // Comeback Dice Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "dice.fill")
                                    .foregroundColor(.green)
                                Text("Comeback Dice")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(comebackDice)d6")
                                    .font(.title2)
                                    .foregroundColor(comebackDice > 0 ? .green : .secondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(comebackDice > 0 ? Color.green.opacity(0.1) : Color.secondary.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            Text("Every time a brave character loses an auction or fails at a task roll or a save (not attacks), she gains a \"comeback die\"—a d6. This die can be added to any attribute, to sv or to av, or to supplant a damage die, in a later situation when rolling for something else. If more than one comeback die is used, only the best one counts, and if a roll fails despite comeback dice, those dice are lost and the roll generates no new ones.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                BraveFeatureBullet(text: "Losing an auction")
                                BraveFeatureBullet(text: "Failing a task roll")
                                BraveFeatureBullet(text: "Failing a save (not attacks)")
                            }
                            .padding(.leading, 4)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        // Say No Power Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "hand.raised.fill")
                                    .foregroundColor(.red)
                                Text("Say No Power")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                HStack(spacing: 12) {
                                    Image(systemName: hasUsedSayNo ? "xmark.circle.fill" : "checkmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(hasUsedSayNo ? .red : .green)
                                    
                                    VStack(alignment: .leading) {
                                        Text(hasUsedSayNo ? "Power Used" : "Power Available")
                                            .font(.subheadline)
                                            .foregroundColor(hasUsedSayNo ? .red : .green)
                                        Text(hasUsedSayNo ? "Resets next session" : "Ready to defy fate")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(hasUsedSayNo ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            Text("Brave characters also have the power to say \"no,\" denying an enemy a successful attack, miraculous effect or fear effect directed at them. This power may be used once per session, and effectually turns a Referee roll into a failure or nullifies a power of one of her monsters. The player must explain how it is plausible in the situation, and what her character does to avoid or resist the enemy.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.red.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    if hasArmorPenalty {
                        ArmorPenaltyWarning()
                    }
                }
                .padding(.vertical, 8)
            } header: {
                Label {
                    Text("The Brave")
                        .font(.headline)
                } icon: {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    private var hasArmorPenalty: Bool {
        // TODO: Add armor check logic when equipment system is implemented
        return false
    }
}

// MARK: - Helper Views
private struct QuirkCard: View {
    let quirk: BraveQuirk
    let slotIndex: Int
    let protectedAlly: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(quirk.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Slot \(slotIndex + 1)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "sparkles")
                    .foregroundColor(.yellow)
            }
            
            Text(quirk.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)
            
            if quirk == .protectAlly && !protectedAlly.isEmpty {
                HStack {
                    Image(systemName: "shield.fill")
                        .foregroundColor(.blue)
                    Text("Protected Ally: \(protectedAlly)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding(.top, 4)
            }
        }
        .padding(12)
        .background(colorScheme == .dark ? Color(.systemGray6) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color(.systemGray4).opacity(0.3), radius: 6, x: 0, y: 2)
    }
}

private struct BraveFeatureBullet: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "circle.fill")
                .font(.system(size: 6))
                .foregroundColor(.secondary)
                .padding(.top, 6)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

private struct ArmorPenaltyWarning: View {
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text("Wearing armor heavier than cloth: -2 penalty to all task rolls")
                .font(.caption)
                .foregroundColor(.red)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.red.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
