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
                    // Class Overview
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Class Overview")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Text("Underdogs and unlikely heroes who turn failure into triumph. Failed apprentices, dreaming gardeners, wannabe bards, or peasants rising against oppression - the Brave are defined by their unwavering courage in the face of despair, making up for their lack of conventional skills with remarkable resilience.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        Text("Very perceptive beings will sense your courageous aura. While you can use any weapon, wearing armor heavier than cloth imposes a -2 penalty to all task rolls.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 4)
                    }
                    
                    Divider()
                        .background(Color.purple.opacity(0.3))
                    
                    // Class Features
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Class Features")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        // Quirk Slots Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Label("Quirks", systemImage: "sparkles")
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
                            
                            Text("Quirks are unique abilities that define your character's heroic nature. You gain additional quirk slots as you level up.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 4)
                            
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
                        
                        Divider()
                            .background(Color.purple.opacity(0.3))
                        
                        // Comeback Dice Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Label("Comeback Dice", systemImage: "dice.fill")
                                    .font(.headline)
                                Spacer()
                                Text("\(comebackDice)d6")
                                    .font(.title2)
                                    .foregroundColor(comebackDice > 0 ? .green : .secondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(comebackDice > 0 ? Color.green.opacity(0.1) : Color.secondary.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            Text("Your resilience turns setbacks into opportunities:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                BraveFeatureBullet(text: "Losing an auction")
                                BraveFeatureBullet(text: "Failing a task roll")
                                BraveFeatureBullet(text: "Failing a save (not attacks)")
                            }
                            .padding(.leading, 4)
                            
                            Text("Use comeback dice to enhance attributes, saving throws, attack values, or replace damage dice. When using multiple dice, only the highest counts. Failed rolls with comeback dice don't generate new ones.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
                        }
                        
                        Divider()
                            .background(Color.purple.opacity(0.3))
                        
                        // Say No Power Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Label("Say No Power", systemImage: "hand.raised.fill")
                                    .font(.headline)
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
                            
                            Text("Once per session, you can deny an enemy's successful attack, miraculous effect, or fear effect directed at you. This power turns a Referee's roll into a failure or nullifies a monster's power. You must explain how your character plausibly avoids or resists the effect.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 4)
                        }
                    }
                }
                .padding(.vertical, 8)
                
                if hasArmorPenalty {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("Wearing armor heavier than cloth: -2 penalty to all task rolls")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .padding(.vertical, 8)
                }
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

struct QuirkCard: View {
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

struct BraveFeatureBullet: View {
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
